import 'package:drift/drift.dart';

/// Drift table definition for actionable tasks extracted from memories.
class TasksTable extends Table {
  @override
  String get tableName => 'tasks';

  TextColumn get id => text()();
  
  /// Foreign key to the note/memory from which this task was extracted
  TextColumn get memoryId => text()();
  
  TextColumn get description => text()();
  
  /// Raw or parsed due date string (e.g. 'tomorrow', '2026-08-13T09:00:00')
  TextColumn get dueDate => text().nullable()();

  /// Parsed epoch millis if successfully parsed by DateTimeParser
  IntColumn get dueTimestamp => integer().nullable()();

  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();

  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
