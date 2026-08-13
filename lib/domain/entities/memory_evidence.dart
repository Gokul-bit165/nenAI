/// Classification of memory relationship inference strength.
enum InferenceType {
  /// Directly and explicitly stated in the source note text.
  explicit,

  /// High multi-signal confidence with a clear distinct winner.
  strongInference,

  /// Low-to-moderate confidence without sufficient grounding.
  weakInference,

  /// Multiple competing candidate contexts with similarly close scores.
  ambiguousInference;

  static InferenceType fromString(String val) {
    return InferenceType.values.firstWhere(
      (e) => e.name.toLowerCase() == val.toLowerCase().trim(),
      orElse: () => InferenceType.weakInference,
    );
  }
}

/// Category of reasoning signal used in confidence calculation.
enum SignalType {
  explicitMention,
  vectorSimilarity,
  entityCoOccurrence,
  temporalRecency,
  keywordActionOverlap,
  graphNeighborhood,
  contextContinuity,
  custom;

  static SignalType fromString(String val) {
    return SignalType.values.firstWhere(
      (e) => e.name.toLowerCase() == val.toLowerCase().trim(),
      orElse: () => SignalType.custom,
    );
  }
}

/// Atomic structured signal contributing to an inferred relationship.
class EvidenceSignal {
  const EvidenceSignal({
    required this.signalType,
    required this.weight,
    required this.score,
    required this.description,
    this.sourceMemoryId,
    this.metadata = const {},
  });

  final SignalType signalType;

  /// Signal importance weight in the evaluation model (e.g. 0.0 to 1.0)
  final double weight;

  /// Raw signal score in [0.0, 1.0]
  final double score;

  /// Human-readable explanation of this specific signal
  final String description;

  /// ID of the memory that supplied this signal evidence
  final String? sourceMemoryId;

  /// Additional structured context data
  final Map<String, dynamic> metadata;

  /// Effective confidence contribution: weight * score
  double get contribution => weight * score;

  Map<String, dynamic> toJson() => {
        'signalType': signalType.name,
        'weight': weight,
        'score': score,
        'description': description,
        if (sourceMemoryId != null) 'sourceMemoryId': sourceMemoryId,
        if (metadata.isNotEmpty) 'metadata': metadata,
      };

  factory EvidenceSignal.fromJson(Map<String, dynamic> json) => EvidenceSignal(
        signalType: SignalType.fromString(json['signalType'] as String? ?? 'custom'),
        weight: (json['weight'] as num?)?.toDouble() ?? 0.0,
        score: (json['score'] as num?)?.toDouble() ?? 0.0,
        description: json['description'] as String? ?? '',
        sourceMemoryId: json['sourceMemoryId'] as String?,
        metadata: (json['metadata'] as Map<String, dynamic>?) ?? const {},
      );

  @override
  String toString() =>
      'EvidenceSignal(${signalType.name}, weight: $weight, score: $score, desc: "$description")';
}

/// Domain entity representing a complete explainable evidence record for an inferred link.
class MemoryEvidence {
  const MemoryEvidence({
    required this.id,
    required this.sourceMemoryId,
    required this.sourceTextSnippet,
    required this.targetContextId,
    required this.targetContextName,
    required this.relationType,
    required this.confidence,
    required this.inferenceType,
    required this.signals,
    required this.explanation,
    required this.createdAt,
  });

  final String id;
  final String sourceMemoryId;
  final String sourceTextSnippet;
  final String targetContextId;
  final String targetContextName;
  final String relationType;

  /// Confidence score in [0.0, 1.0] (treated as a ranking signal, not absolute truth)
  final double confidence;

  final InferenceType inferenceType;
  final List<EvidenceSignal> signals;

  /// Concise human-readable explanation
  final String explanation;

  final DateTime createdAt;

  MemoryEvidence copyWith({
    String? id,
    String? sourceMemoryId,
    String? sourceTextSnippet,
    String? targetContextId,
    String? targetContextName,
    String? relationType,
    double? confidence,
    InferenceType? inferenceType,
    List<EvidenceSignal>? signals,
    String? explanation,
    DateTime? createdAt,
  }) {
    return MemoryEvidence(
      id: id ?? this.id,
      sourceMemoryId: sourceMemoryId ?? this.sourceMemoryId,
      sourceTextSnippet: sourceTextSnippet ?? this.sourceTextSnippet,
      targetContextId: targetContextId ?? this.targetContextId,
      targetContextName: targetContextName ?? this.targetContextName,
      relationType: relationType ?? this.relationType,
      confidence: confidence ?? this.confidence,
      inferenceType: inferenceType ?? this.inferenceType,
      signals: signals ?? this.signals,
      explanation: explanation ?? this.explanation,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'sourceMemoryId': sourceMemoryId,
        'sourceTextSnippet': sourceTextSnippet,
        'targetContextId': targetContextId,
        'targetContextName': targetContextName,
        'relationType': relationType,
        'confidence': confidence,
        'inferenceType': inferenceType.name,
        'signals': signals.map((s) => s.toJson()).toList(),
        'explanation': explanation,
        'createdAt': createdAt.toIso8601String(),
      };

  factory MemoryEvidence.fromJson(Map<String, dynamic> json) => MemoryEvidence(
        id: json['id'] as String,
        sourceMemoryId: json['sourceMemoryId'] as String,
        sourceTextSnippet: json['sourceTextSnippet'] as String? ?? '',
        targetContextId: json['targetContextId'] as String,
        targetContextName: json['targetContextName'] as String? ?? '',
        relationType: json['relationType'] as String? ?? 'relates_to',
        confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
        inferenceType: InferenceType.fromString(json['inferenceType'] as String? ?? 'weakInference'),
        signals: ((json['signals'] as List<dynamic>?) ?? [])
            .whereType<Map<String, dynamic>>()
            .map((s) => EvidenceSignal.fromJson(s))
            .toList(),
        explanation: json['explanation'] as String? ?? '',
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'] as String)
            : DateTime.now(),
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is MemoryEvidence && other.id == id);

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'MemoryEvidence($sourceMemoryId -> $targetContextName ($inferenceType), conf: $confidence)';
}

/// Evaluated candidate context with associated evidence and confidence breakdown.
class CandidateEvidence {
  const CandidateEvidence({
    required this.contextId,
    required this.contextName,
    required this.relationType,
    required this.confidence,
    required this.inferenceType,
    required this.signals,
    required this.explanation,
  });

  final String contextId;
  final String contextName;
  final String relationType;
  final double confidence;
  final InferenceType inferenceType;
  final List<EvidenceSignal> signals;
  final String explanation;

  @override
  String toString() =>
      'CandidateEvidence($contextName: ${confidence.toStringAsFixed(2)}, type: ${inferenceType.name})';
}

/// Comprehensive outcome of evaluating all potential contextual candidates for a source note.
class EvidenceEvaluationResult {
  const EvidenceEvaluationResult({
    required this.sourceMemoryId,
    required this.sourceTextSnippet,
    this.topCandidate,
    required this.allCandidates,
    required this.isAmbiguous,
    this.ambiguousCandidates = const [],
  });

  final String sourceMemoryId;
  final String sourceTextSnippet;
  final CandidateEvidence? topCandidate;
  final List<CandidateEvidence> allCandidates;
  final bool isAmbiguous;
  final List<CandidateEvidence> ambiguousCandidates;

  @override
  String toString() =>
      'EvidenceEvaluationResult(candidates: ${allCandidates.length}, top: ${topCandidate?.contextName}, isAmbiguous: $isAmbiguous)';
}
