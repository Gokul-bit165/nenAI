/// Clean domain representation of a Knowledge Graph Entity.
class KnowledgeEntity {
  const KnowledgeEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.canonicalName,
    this.aliases = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  
  /// Display name e.g. "Arun", "Gemma 3 1B", "NENAI"
  final String name;
  
  /// 'person', 'project', 'technology', 'organization', 'concept', 'location'
  final String type;
  
  /// Normalized lowercase string e.g. "arun", "gemma 3 1b"
  final String canonicalName;
  
  final List<String> aliases;
  final DateTime createdAt;
  final DateTime updatedAt;

  KnowledgeEntity copyWith({
    String? id,
    String? name,
    String? type,
    String? canonicalName,
    List<String>? aliases,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return KnowledgeEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      canonicalName: canonicalName ?? this.canonicalName,
      aliases: aliases ?? this.aliases,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is KnowledgeEntity && other.id == id);

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'KnowledgeEntity(id: $id, name: $name, type: $type)';
}
