import 'knowledge_entity.dart';

/// Clean domain representation of a Knowledge Graph relationship edge (Subject -> Predicate -> Object).
class KnowledgeRelationship {
  const KnowledgeRelationship({
    required this.id,
    required this.sourceEntityId,
    required this.relation,
    required this.targetEntityId,
    required this.sourceMemoryId,
    this.confidence = 1.0,
    required this.createdAt,
    required this.updatedAt,
    this.sourceEntity,
    this.targetEntity,
  });

  final String id;
  final String sourceEntityId;
  
  /// Predicate/relationship label e.g. "suggested", "works_on", "helps_with", "used_in"
  final String relation;
  
  final String targetEntityId;
  final String sourceMemoryId;
  final double confidence;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Optional populated graph node references
  final KnowledgeEntity? sourceEntity;
  final KnowledgeEntity? targetEntity;

  KnowledgeRelationship copyWith({
    String? id,
    String? sourceEntityId,
    String? relation,
    String? targetEntityId,
    String? sourceMemoryId,
    double? confidence,
    DateTime? createdAt,
    DateTime? updatedAt,
    KnowledgeEntity? sourceEntity,
    KnowledgeEntity? targetEntity,
  }) {
    return KnowledgeRelationship(
      id: id ?? this.id,
      sourceEntityId: sourceEntityId ?? this.sourceEntityId,
      relation: relation ?? this.relation,
      targetEntityId: targetEntityId ?? this.targetEntityId,
      sourceMemoryId: sourceMemoryId ?? this.sourceMemoryId,
      confidence: confidence ?? this.confidence,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      sourceEntity: sourceEntity ?? this.sourceEntity,
      targetEntity: targetEntity ?? this.targetEntity,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is KnowledgeRelationship && other.id == id);

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'KnowledgeRelationship($sourceEntityId --$relation--> $targetEntityId)';
}
