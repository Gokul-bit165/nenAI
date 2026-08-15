/// Authority / origin of a memory context binding.
enum ResolutionSource {
  automatic,
  userConfirmed,
  userRejected,
  manual;

  static ResolutionSource fromString(String val) {
    return ResolutionSource.values.firstWhere(
      (e) => e.name.toLowerCase() == val.toLowerCase().trim() ||
          e.name == val,
      orElse: () => ResolutionSource.manual,
    );
  }
}

/// Candidate context option presented to the user on the Clarification UI.
class ResolutionCandidateOption {
  const ResolutionCandidateOption({
    required this.contextId,
    required this.contextName,
    required this.contextPath,
    required this.confidence,
    required this.evidenceSummary,
  });

  final String contextId;
  final String contextName;
  final String contextPath;
  final double confidence;

  /// Concise human-readable reason (e.g. "ReadSmart AI has recent notes about deployment and testing.")
  final String evidenceSummary;

  Map<String, dynamic> toJson() => {
        'contextId': contextId,
        'contextName': contextName,
        'contextPath': contextPath,
        'confidence': confidence,
        'evidenceSummary': evidenceSummary,
      };

  factory ResolutionCandidateOption.fromJson(Map<String, dynamic> json) =>
      ResolutionCandidateOption(
        contextId: json['contextId'] as String,
        contextName: json['contextName'] as String,
        contextPath: json['contextPath'] as String? ?? json['contextName'] as String,
        confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
        evidenceSummary: json['evidenceSummary'] as String? ?? '',
      );

  @override
  String toString() =>
      'ResolutionCandidateOption($contextName, ${(confidence * 100).toStringAsFixed(0)}%)';
}

/// Domain entity representing an ambiguous memory awaiting human confirmation.
class PendingResolution {
  const PendingResolution({
    required this.id,
    required this.memoryId,
    required this.noteTextSnippet,
    required this.candidates,
    this.status = 'pending',
    this.selectedContextId,
    this.resolutionSource,
    required this.createdAt,
    this.resolvedAt,
  });

  final String id;
  final String memoryId;
  final String noteTextSnippet;
  final List<ResolutionCandidateOption> candidates;

  /// 'pending', 'resolved', 'dismissed'
  final String status;

  final String? selectedContextId;
  final ResolutionSource? resolutionSource;
  final DateTime createdAt;
  final DateTime? resolvedAt;

  bool get isPending => status == 'pending';
  bool get isResolved => status == 'resolved';

  PendingResolution copyWith({
    String? id,
    String? memoryId,
    String? noteTextSnippet,
    List<ResolutionCandidateOption>? candidates,
    String? status,
    String? selectedContextId,
    ResolutionSource? resolutionSource,
    DateTime? createdAt,
    DateTime? resolvedAt,
  }) {
    return PendingResolution(
      id: id ?? this.id,
      memoryId: memoryId ?? this.memoryId,
      noteTextSnippet: noteTextSnippet ?? this.noteTextSnippet,
      candidates: candidates ?? this.candidates,
      status: status ?? this.status,
      selectedContextId: selectedContextId ?? this.selectedContextId,
      resolutionSource: resolutionSource ?? this.resolutionSource,
      createdAt: createdAt ?? this.createdAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
    );
  }

  @override
  String toString() =>
      'PendingResolution(id: $id, memory: $memoryId, status: $status, candidates: ${candidates.length})';
}

/// User's explicit choice when resolving an ambiguous memory.
class ResolutionChoice {
  const ResolutionChoice.single(this.contextId)
      : isBoth = false,
        isNewContext = false,
        isNone = false,
        newContextName = null,
        newContextType = null;

  const ResolutionChoice.both()
      : contextId = null,
        isBoth = true,
        isNewContext = false,
        isNone = false,
        newContextName = null,
        newContextType = null;

  const ResolutionChoice.newContext({
    required this.newContextName,
    this.newContextType = 'project',
  })  : contextId = null,
        isBoth = false,
        isNewContext = true,
        isNone = false;

  const ResolutionChoice.none()
      : contextId = null,
        isBoth = false,
        isNewContext = false,
        isNone = true,
        newContextName = null,
        newContextType = null;

  final String? contextId;
  final bool isBoth;
  final bool isNewContext;
  final bool isNone;
  final String? newContextName;
  final String? newContextType;

  bool get isSingle => contextId != null && !isBoth && !isNewContext && !isNone;
}
