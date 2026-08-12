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
  createEntity,
  updateEntity,
  createRelationship,
  updateRelationship,
  createTask,
  updateTask,
  linkMemory,
  updateMemory,
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
