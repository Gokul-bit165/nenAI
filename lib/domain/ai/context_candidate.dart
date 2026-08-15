import 'note_analysis_result.dart';

/// Context candidate retrieved for an incoming memory before committing to database.
class ContextCandidate {
  const ContextCandidate({
    required this.contextId,
    required this.contextName,
    this.contextType = 'custom',
    required this.contextPath,
    this.pathNodes = const [],
    this.relatedEntities = const [],
    this.relatedNoteIds = const [],
    this.recentEvidence = const [],
    this.semanticSimilarity = 0.0,
    this.graphRelevance = 0.0,
    this.temporalRelevance = 0.0,
    this.lexicalRelevance = 0.0,
    required this.totalScore,
    this.matchedSignals = const [],
  });

  /// The unique context node ID
  final String contextId;

  /// The display name of the context (e.g. "Deployment", "ReadSmart AI")
  final String contextName;

  /// Semantic type: episode, project, topic, activity, task, concept
  final String contextType;

  /// Hierarchical ancestral path (e.g. "Meeting with Dean └── Project Discussion └── ReadSmart AI")
  final String contextPath;

  /// Ordered list of node names from root ancestor to this node
  final List<String> pathNodes;

  /// Entities connected to this context or its parent hierarchy
  final List<String> relatedEntities;

  /// IDs of historical notes associated with this context
  final List<String> relatedNoteIds;

  /// Recent reasoning evidence snippets
  final List<String> recentEvidence;

  /// Cosine similarity from embedding search [0.0, 1.0]
  final double semanticSimilarity;

  /// Knowledge graph connectivity & co-occurrence score [0.0, 1.0]
  final double graphRelevance;

  /// Time-decayed recency score based on last activity [0.0, 1.0]
  final double temporalRelevance;

  /// Keyword, action, and lexical match score [0.0, 1.0]
  final double lexicalRelevance;

  /// Deterministic composite rank score [0.0, 1.0]
  final double totalScore;

  /// Short list of signal reasons that activated this candidate
  final List<String> matchedSignals;

  ContextCandidate copyWith({
    String? contextId,
    String? contextName,
    String? contextType,
    String? contextPath,
    List<String>? pathNodes,
    List<String>? relatedEntities,
    List<String>? relatedNoteIds,
    List<String>? recentEvidence,
    double? semanticSimilarity,
    double? graphRelevance,
    double? temporalRelevance,
    double? lexicalRelevance,
    double? totalScore,
    List<String>? matchedSignals,
  }) {
    return ContextCandidate(
      contextId: contextId ?? this.contextId,
      contextName: contextName ?? this.contextName,
      contextType: contextType ?? this.contextType,
      contextPath: contextPath ?? this.contextPath,
      pathNodes: pathNodes ?? this.pathNodes,
      relatedEntities: relatedEntities ?? this.relatedEntities,
      relatedNoteIds: relatedNoteIds ?? this.relatedNoteIds,
      recentEvidence: recentEvidence ?? this.recentEvidence,
      semanticSimilarity: semanticSimilarity ?? this.semanticSimilarity,
      graphRelevance: graphRelevance ?? this.graphRelevance,
      temporalRelevance: temporalRelevance ?? this.temporalRelevance,
      lexicalRelevance: lexicalRelevance ?? this.lexicalRelevance,
      totalScore: totalScore ?? this.totalScore,
      matchedSignals: matchedSignals ?? this.matchedSignals,
    );
  }

  @override
  String toString() =>
      'ContextCandidate($contextPath, score: ${totalScore.toStringAsFixed(2)}, sem: ${semanticSimilarity.toStringAsFixed(2)}, temp: ${temporalRelevance.toStringAsFixed(2)})';
}

/// Query parameters passed into [ContextCandidateRetriever].
class CandidateRetrievalQuery {
  const CandidateRetrievalQuery({
    required this.noteText,
    this.analysisResult,
    required this.noteTimestamp,
    this.embedding,
    this.topK = 5,
    this.entityEvidences = const [],
  });

  final String noteText;
  final NoteAnalysisResult? analysisResult;
  final DateTime noteTimestamp;
  final List<double>? embedding;
  final int topK;

  /// Pre-computed entity evidence bundles from [RelationshipEvidenceBuilder].
  /// Used to boost context candidates that share confirmed KG entities.
  final List<dynamic> entityEvidences;
}
