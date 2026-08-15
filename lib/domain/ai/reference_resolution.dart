/// Status of cross-note reference resolution.
enum ReferenceResolutionStatus {
  resolved,
  ambiguous,
  unresolved;

  bool get isResolved => this == ReferenceResolutionStatus.resolved;
  bool get isAmbiguous => this == ReferenceResolutionStatus.ambiguous;
  bool get isUnresolved => this == ReferenceResolutionStatus.unresolved;
}

/// Category of linguistic reference.
enum ReferenceCategory {
  pronoun, // he, she, they, it
  demonstrative, // this, that
  definiteNounPhrase, // the project, the deployment, the meeting
  taskReference, // previous task, that issue
  unknown;

  static ReferenceCategory fromText(String text) {
    final t = text.toLowerCase().trim();
    if (['he', 'she', 'they', 'it', 'him', 'her', 'them'].contains(t)) {
      return ReferenceCategory.pronoun;
    }
    if (['this', 'that', 'these', 'those'].contains(t)) {
      return ReferenceCategory.demonstrative;
    }
    if (t.startsWith('the ') || t.startsWith('that ')) {
      if (t.contains('task') || t.contains('issue') || t.contains('bug') || t.contains('ticket')) {
        return ReferenceCategory.taskReference;
      }
      return ReferenceCategory.definiteNounPhrase;
    }
    if (t.contains('previous task') || t.contains('prior task')) {
      return ReferenceCategory.taskReference;
    }
    return ReferenceCategory.unknown;
  }
}

/// Candidate referent entity, context, or action.
class ReferentCandidate {
  const ReferentCandidate({
    required this.referentId,
    required this.referentName,
    required this.referentType,
    required this.sourceNoteId,
    required this.confidence,
    required this.signals,
    required this.reasoning,
  });

  final String referentId;
  final String referentName;

  /// 'person', 'project', 'activity', 'topic', 'task', 'concept'
  final String referentType;

  final String sourceNoteId;
  final double confidence;
  final Map<String, double> signals;
  final String reasoning;

  Map<String, dynamic> toJson() => {
        'referentId': referentId,
        'referentName': referentName,
        'referentType': referentType,
        'sourceNoteId': sourceNoteId,
        'confidence': double.parse(confidence.toStringAsFixed(2)),
        'signals': signals.map((k, v) => MapEntry(k, double.parse(v.toStringAsFixed(2)))),
        'reasoning': reasoning,
      };

  @override
  String toString() =>
      'ReferentCandidate($referentName [$referentType], conf: ${confidence.toStringAsFixed(2)})';
}

/// Result for an individual reference (e.g. "this", "the project", "he").
class ResolvedReference {
  const ResolvedReference({
    required this.referenceText,
    required this.category,
    required this.status,
    this.targetReferent,
    this.targetReferentId,
    this.targetReferentType,
    this.confidence = 0.0,
    this.candidates = const [],
    required this.explanation,
  });

  final String referenceText;
  final ReferenceCategory category;
  final ReferenceResolutionStatus status;

  final String? targetReferent;
  final String? targetReferentId;
  final String? targetReferentType;
  final double confidence;
  final List<ReferentCandidate> candidates;
  final String explanation;

  bool get isResolved => status == ReferenceResolutionStatus.resolved;
  bool get isAmbiguous => status == ReferenceResolutionStatus.ambiguous;
  bool get isUnresolved => status == ReferenceResolutionStatus.unresolved;

  Map<String, dynamic> toJson() => {
        'referenceText': referenceText,
        'category': category.name,
        'status': status.name,
        if (targetReferent != null) 'targetReferent': targetReferent,
        if (targetReferentId != null) 'targetReferentId': targetReferentId,
        if (targetReferentType != null) 'targetReferentType': targetReferentType,
        'confidence': double.parse(confidence.toStringAsFixed(2)),
        'candidates': candidates.map((c) => c.toJson()).toList(),
        'explanation': explanation,
      };

  @override
  String toString() =>
      'ResolvedReference("$referenceText" -> ${targetReferent ?? "none"}, status: ${status.name}, conf: ${confidence.toStringAsFixed(2)})';
}

/// Full outcome container for all references in a note.
class ReferenceResolutionResult {
  const ReferenceResolutionResult({
    required this.resolvedReferences,
    required this.hasAmbiguities,
    required this.unresolvedCount,
    required this.summary,
  });

  final List<ResolvedReference> resolvedReferences;
  final bool hasAmbiguities;
  final int unresolvedCount;
  final String summary;

  ResolvedReference? getByText(String text) {
    final lower = text.toLowerCase().trim();
    return resolvedReferences.firstWhere(
      (r) => r.referenceText.toLowerCase().trim() == lower,
      orElse: () => ResolvedReference(
        referenceText: text,
        category: ReferenceCategory.fromText(text),
        status: ReferenceResolutionStatus.unresolved,
        explanation: 'Reference not found in evaluation.',
      ),
    );
  }
}
