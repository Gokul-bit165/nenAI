import 'package:drift/drift.dart';

/// Drift table definition for directed edges between context nodes in the DAG.
class ContextEdgesTable extends Table {
  @override
  String get tableName => 'context_edges';

  TextColumn get id => text()();
  
  /// Parent / Source context node ID
  TextColumn get sourceContextId => text()();
  
  /// Child / Target context node ID
  TextColumn get targetContextId => text()();
  
  /// Semantic relation type: 'part_of', 'sub_topic', 'activity_of', 'outcome_of', 'relates_to'
  TextColumn get relationType => text()();
  
  /// Confidence score between 0.0 and 1.0
  RealColumn get confidence => real().withDefault(const Constant(1.0))();
  
  /// Provenance: Memory/note ID that originated this relationship
  TextColumn get originatingMemoryId => text().nullable()();
  
  /// Provenance: Snippet or reasoning evidence for this link
  TextColumn get evidence => text().nullable()();

  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
