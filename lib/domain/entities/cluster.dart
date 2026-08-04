/// Clean domain entity for an auto-generated topic cluster.
class Cluster {
  const Cluster({
    required this.id,
    required this.name,
    required this.colorHex,
    required this.createdAt,
    this.noteCount = 0,
  });

  final String id;

  /// Human-readable name. Auto-generated from LLM topic; can be renamed by user.
  final String name;

  /// Hex colour string (e.g. '#7C4DFF') for the cluster chip in the UI.
  final String colorHex;

  /// Number of notes currently assigned to this cluster.
  final int noteCount;

  final DateTime createdAt;

  Cluster copyWith({
    String? id,
    String? name,
    String? colorHex,
    int? noteCount,
    DateTime? createdAt,
  }) {
    return Cluster(
      id: id ?? this.id,
      name: name ?? this.name,
      colorHex: colorHex ?? this.colorHex,
      noteCount: noteCount ?? this.noteCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Cluster && other.id == id);

  @override
  int get hashCode => id.hashCode;
}
