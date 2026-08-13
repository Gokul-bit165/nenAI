import 'package:drift/drift.dart';

/// Drift join table connecting notes/memories with contextual nodes.
class MemoryContextsTable extends Table {
  @override
  String get tableName => 'memory_contexts';

  TextColumn get memoryId => text()();
  TextColumn get contextId => text()();
  
  /// Role of the memory in this context: 'contained_in', 'mentions', 'produced_by', 'evidence_for'
  TextColumn get role => text().withDefault(const Constant('contained_in'))();
  
  /// Confidence score between 0.0 and 1.0
  RealColumn get confidence => real().withDefault(const Constant(1.0))();

  /// Provenance: Extracted reasoning or snippet supporting the link
  TextColumn get evidence => text().nullable()();

  IntColumn get createdAt => integer()();

  @override
  Set<Column> get primaryKey => {memoryId, contextId};
}
