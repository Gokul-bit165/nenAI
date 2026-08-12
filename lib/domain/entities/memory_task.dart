/// Clean domain representation of an extracted Action Item / Task.
class MemoryTask {
  const MemoryTask({
    required this.id,
    required this.memoryId,
    required this.description,
    this.dueDate,
    this.dueTimestamp,
    this.isCompleted = false,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String memoryId;
  final String description;
  final String? dueDate;
  final DateTime? dueTimestamp;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  MemoryTask copyWith({
    String? id,
    String? memoryId,
    String? description,
    String? dueDate,
    DateTime? dueTimestamp,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MemoryTask(
      id: id ?? this.id,
      memoryId: memoryId ?? this.memoryId,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      dueTimestamp: dueTimestamp ?? this.dueTimestamp,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is MemoryTask && other.id == id);

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'MemoryTask(id: $id, description: $description, isCompleted: $isCompleted, due: $dueDate)';
}
