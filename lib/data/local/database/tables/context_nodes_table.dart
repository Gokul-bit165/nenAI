import 'package:drift/drift.dart';

/// Drift table definition for Hierarchical Context Nodes.
class ContextNodesTable extends Table {
  @override
  String get tableName => 'context_nodes';

  TextColumn get id => text()();
  TextColumn get name => text()();
  
  /// episode, project, topic, activity, task, concept, person, organization, custom
  TextColumn get type => text().withDefault(const Constant('custom'))();
  
  TextColumn get description => text().nullable()();
  TextColumn get originatingMemoryId => text().nullable()();

  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
