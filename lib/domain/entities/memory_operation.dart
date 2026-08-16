/// Configuration parameters for Entity Resolution.
class EntityResolutionConfig {
  EntityResolutionConfig._();

  static const double autoMatchThreshold = 0.90;
  static const double ambiguousThreshold = 0.70;
}

/// Status returned by EntityResolver.
enum ResolutionStatus {
  match,
  create,
  ambiguous,
}

/// Result of resolving a named entity mention.
class ResolvedEntity {
  const ResolvedEntity({
    required this.originalMention,
    required this.entityId,
    required this.name,
    required this.type,
    required this.status,
    required this.confidence,
    this.canonicalName,
  });

  final String originalMention;
  final String entityId;
  final String name;
  final String type;
  final ResolutionStatus status;
  final double confidence;
  final String? canonicalName;

  @override
  String toString() =>
      'ResolvedEntity(mention: $originalMention, id: $entityId, name: $name, status: $status, conf: $confidence)';
}

/// Typed operations emitted by the Memory Reasoner and executed by the Memory Router.
enum OperationType {
  createContext,
  attachMemory,
  createChildContext,
  linkContext,
  updateContext,
  createRelationship,
  correctRelationship,
  createTask,
  mergeContext,
  splitContext,
  requestClarification,
  createEntity,
  updateEntity,
  linkMemory,
  noOp,
}

/// Atomic memory operation model with typed payload.
class MemoryOperation {
  const MemoryOperation({
    required this.type,
    required this.payload,
  });

  final OperationType type;
  final Map<String, dynamic> payload;

  factory MemoryOperation.createContext({
    required String id,
    required String name,
    required String type,
    String? originatingMemoryId,
  }) =>
      MemoryOperation(
        type: OperationType.createContext,
        payload: {
          'id': id,
          'name': name,
          'type': type,
          if (originatingMemoryId != null) 'originatingMemoryId': originatingMemoryId,
        },
      );

  factory MemoryOperation.attachMemory({
    required String memoryId,
    required String contextId,
    String? contextName,
    String role = 'attached',
    double confidence = 1.0,
    String? evidence,
  }) =>
      MemoryOperation(
        type: OperationType.attachMemory,
        payload: {
          'memoryId': memoryId,
          'contextId': contextId,
          if (contextName != null) 'contextName': contextName,
          'role': role,
          'confidence': confidence,
          if (evidence != null) 'evidence': evidence,
        },
      );

  factory MemoryOperation.createChildContext({
    required String id,
    required String parentContextId,
    required String childName,
    required String childType,
    String relationType = 'has_child',
    String? originatingMemoryId,
  }) =>
      MemoryOperation(
        type: OperationType.createChildContext,
        payload: {
          'id': id,
          'parentContextId': parentContextId,
          'childName': childName,
          'childType': childType,
          'relationType': relationType,
          if (originatingMemoryId != null) 'originatingMemoryId': originatingMemoryId,
        },
      );

  factory MemoryOperation.linkContext({
    required String sourceContextId,
    required String targetContextId,
    String relationType = 'relates_to',
    double confidence = 1.0,
    String? evidence,
    String? originatingMemoryId,
  }) =>
      MemoryOperation(
        type: OperationType.linkContext,
        payload: {
          'sourceContextId': sourceContextId,
          'targetContextId': targetContextId,
          'relationType': relationType,
          'confidence': confidence,
          if (evidence != null) 'evidence': evidence,
          if (originatingMemoryId != null) 'originatingMemoryId': originatingMemoryId,
        },
      );

  factory MemoryOperation.updateContext({
    required String contextId,
    String? name,
    String? type,
  }) =>
      MemoryOperation(
        type: OperationType.updateContext,
        payload: {
          'contextId': contextId,
          if (name != null) 'name': name,
          if (type != null) 'type': type,
        },
      );

  factory MemoryOperation.mergeContext({
    required String sourceContextId,
    required String targetContextId,
  }) =>
      MemoryOperation(
        type: OperationType.mergeContext,
        payload: {
          'sourceContextId': sourceContextId,
          'targetContextId': targetContextId,
        },
      );

  factory MemoryOperation.splitContext({
    required String sourceContextId,
    required List<Map<String, String>> newChildNodes,
  }) =>
      MemoryOperation(
        type: OperationType.splitContext,
        payload: {
          'sourceContextId': sourceContextId,
          'newChildNodes': newChildNodes,
        },
      );

  factory MemoryOperation.requestClarification({
    required String memoryId,
    required String noteTextSnippet,
    required List<Map<String, dynamic>> candidates,
  }) =>
      MemoryOperation(
        type: OperationType.requestClarification,
        payload: {
          'memoryId': memoryId,
          'noteTextSnippet': noteTextSnippet,
          'candidates': candidates,
        },
      );

  factory MemoryOperation.createEntity({
    required String id,
    required String name,
    required String type,
    required String canonicalName,
  }) =>
      MemoryOperation(
        type: OperationType.createEntity,
        payload: {
          'id': id,
          'name': name,
          'type': type,
          'canonicalName': canonicalName,
        },
      );

  factory MemoryOperation.createRelationship({
    required String id,
    required String sourceEntityId,
    required String relation,
    required String targetEntityId,
    required String sourceMemoryId,
    double confidence = 1.0,
    String inferenceType = 'extracted',
  }) =>
      MemoryOperation(
        type: OperationType.createRelationship,
        payload: {
          'id': id,
          'sourceEntityId': sourceEntityId,
          'relation': relation,
          'targetEntityId': targetEntityId,
          'sourceMemoryId': sourceMemoryId,
          'confidence': confidence,
          'inferenceType': inferenceType,
        },
      );

  factory MemoryOperation.correctRelationship({
    required String sourceEntityId,
    required String relation,
    required String oldTargetEntityId,
    required String newTargetEntityId,
    required String sourceMemoryId,
  }) =>
      MemoryOperation(
        type: OperationType.correctRelationship,
        payload: {
          'sourceEntityId': sourceEntityId,
          'relation': relation,
          'oldTargetEntityId': oldTargetEntityId,
          'newTargetEntityId': newTargetEntityId,
          'sourceMemoryId': sourceMemoryId,
        },
      );

  factory MemoryOperation.createTask({
    required String id,
    required String memoryId,
    required String description,
    String? dueDate,
    int? dueTimestamp,
  }) =>
      MemoryOperation(
        type: OperationType.createTask,
        payload: {
          'id': id,
          'memoryId': memoryId,
          'description': description,
          'dueDate': dueDate,
          'dueTimestamp': dueTimestamp,
        },
      );

  factory MemoryOperation.linkMemory({
    required String sourceMemoryId,
    required String targetMemoryId,
  }) =>
      MemoryOperation(
        type: OperationType.linkMemory,
        payload: {
          'sourceMemoryId': sourceMemoryId,
          'targetMemoryId': targetMemoryId,
        },
      );

  factory MemoryOperation.noOp({String reason = ''}) =>
      MemoryOperation(
        type: OperationType.noOp,
        payload: {'reason': reason},
      );

  @override
  String toString() => 'MemoryOperation(type: $type, payload: $payload)';
}
