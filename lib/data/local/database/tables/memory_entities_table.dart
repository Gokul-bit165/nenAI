import 'package:drift/drift.dart';

/// Drift join table connecting notes/memories with referenced entities.
class MemoryEntitiesTable extends Table {
  @override
  String get tableName => 'memory_entities';

  TextColumn get memoryId => text()();
  TextColumn get entityId => text()();
  
  /// Role of the entity in this memory (e.g. 'subject', 'mentioned', 'creator')
  TextColumn get role => text().withDefault(const Constant('mentioned'))();

  @override
  Set<Column> get primaryKey => {memoryId, entityId};
}
