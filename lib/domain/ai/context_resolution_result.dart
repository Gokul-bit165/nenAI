/// The discrete decision made by the Context Resolution Engine.
enum ResolutionOutcome {
  /// High confidence with sufficient margin: automatically attach memory to target context.
  autoAttach,

  /// High confidence across multiple non-conflicting valid parent contexts (DAG attachment).
  multiAttach,

  /// Competing candidate contexts with low margin: user disambiguation required.
  ambiguous,

  /// Memory represents a new episode, project, or topic that should be initialized as a new context.
  newContext,

  /// Incomplete or dangling references with low confidence: kept unassigned without guessing.
  unresolved,

  /// Trivial, transient, or scratchpad content not requiring contextual graph binding.
  ignore;

  static ResolutionOutcome fromString(String val) {
    return ResolutionOutcome.values.firstWhere(
      (e) => e.name.toLowerCase() == val.toLowerCase().trim(),
      orElse: () => ResolutionOutcome.unresolved,
    );
  }
}

/// Transparent multi-signal breakdown of candidate context scoring.
class CandidateScoreBreakdown {
  const CandidateScoreBreakdown({
    required this.candidateId,
    required this.candidateName,
    required this.contextPath,
    required this.finalScore,
    required this.signals,
    this.evidenceSnippet,
  });

  final String candidateId;
  final String candidateName;
  final String contextPath;
  final double finalScore;

  /// Transparent mapping of individual reasoning signals:
  /// e.g. semantic, lexical, entity, graph, temporal, recency, contextContinuity, explicitMention, previousReference
  final Map<String, double> signals;

  final String? evidenceSnippet;

  Map<String, dynamic> toJson() => {
        'candidate': candidateName,
        'candidateId': candidateId,
        'contextPath': contextPath,
        'finalScore': double.parse(finalScore.toStringAsFixed(2)),
        'signals': signals.map((k, v) => MapEntry(k, double.parse(v.toStringAsFixed(2)))),
        if (evidenceSnippet != null) 'evidenceSnippet': evidenceSnippet,
      };

  @override
  String toString() =>
      'CandidateScoreBreakdown($candidateName: ${finalScore.toStringAsFixed(2)}, signals: $signals)';
}

/// Comprehensive outcome returned by the Context Resolution Engine.
class ContextResolutionResult {
  const ContextResolutionResult({
    required this.outcome,
    this.targetContextId,
    this.targetContextName,
    this.targetContextPath,
    this.additionalTargetContextIds = const [],
    this.confidence = 0.0,
    this.candidateBreakdowns = const [],
    this.ambiguousCandidates = const [],
    this.suggestedNewContextName,
    this.suggestedNewContextType,
    required this.reasoningSummary,
    this.unresolvedReferences = const [],
  });

  final ResolutionOutcome outcome;

  /// Primary target context ID when outcome is autoAttach or multiAttach
  final String? targetContextId;

  /// Primary target context display name
  final String? targetContextName;

  /// Primary target context hierarchical ancestral path
  final String? targetContextPath;

  /// Additional target context IDs when outcome is multiAttach
  final List<String> additionalTargetContextIds;

  /// Resolution confidence score in [0.0, 1.0]
  final double confidence;

  /// Ranked candidate evaluations with transparent signal breakdowns
  final List<CandidateScoreBreakdown> candidateBreakdowns;

  /// Competing candidate contexts when outcome is ambiguous
  final List<CandidateScoreBreakdown> ambiguousCandidates;

  /// Suggested name for new context node when outcome is newContext
  final String? suggestedNewContextName;

  /// Suggested semantic type for new context (e.g. 'project', 'episode', 'topic')
  final String? suggestedNewContextType;

  /// Concise human-readable explanation of why this resolution was chosen
  final String reasoningSummary;

  /// List of raw reference strings that remain unresolved
  final List<String> unresolvedReferences;

  bool get isAutoAttached => outcome == ResolutionOutcome.autoAttach;
  bool get isMultiAttached => outcome == ResolutionOutcome.multiAttach;
  bool get isAmbiguous => outcome == ResolutionOutcome.ambiguous;
  bool get isNewContext => outcome == ResolutionOutcome.newContext;
  bool get isUnresolved => outcome == ResolutionOutcome.unresolved;
  bool get isIgnored => outcome == ResolutionOutcome.ignore;

  @override
  String toString() =>
      'ContextResolutionResult(outcome: ${outcome.name}, target: $targetContextName, conf: ${confidence.toStringAsFixed(2)})';
}
