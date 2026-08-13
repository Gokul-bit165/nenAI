/// Types of user memory corrections and feedback actions.
enum CorrectionType {
  moveContext,
  excludeContext,
  mergeContexts,
  splitContext,
  renameContext,
  correctEntity,
  removeRelationship,
}

/// A structured request payload describing a user correction.
class MemoryCorrectionRequest {
  const MemoryCorrectionRequest({
    required this.type,
    this.memoryId,
    this.sourceContextId,
    this.targetContextId,
    this.targetContextName,
    this.entityId,
    this.newName,
    this.newType,
    this.relationshipId,
    this.childNames = const [],
    this.reason,
  });

  final CorrectionType type;
  final String? memoryId;
  final String? sourceContextId;
  final String? targetContextId;
  final String? targetContextName;
  final String? entityId;
  final String? newName;
  final String? newType;
  final String? relationshipId;
  final List<String> childNames;
  final String? reason;
}

/// The result of executing a memory correction.
class MemoryCorrectionResult {
  const MemoryCorrectionResult({
    required this.success,
    required this.message,
    this.auditEvidenceId,
    this.affectedMemoryIds = const [],
    this.affectedContextIds = const [],
  });

  final bool success;
  final String message;
  final String? auditEvidenceId;
  final List<String> affectedMemoryIds;
  final List<String> affectedContextIds;
}
