import 'package:drift/drift.dart';

/// Drift table definition for resolved Knowledge Graph entities.
class EntitiesTable extends Table {
  @override
  String get tableName => 'entities';

  TextColumn get id => text()();
  TextColumn get name => text()();
  
  /// Entity type: 'person', 'project', 'technology', 'organization', 'concept', 'location'
  TextColumn get type => text()();
  
  /// Normalized lowercase representation for fast deterministic matching
  TextColumn get canonicalName => text()();

  /// Comma-separated or JSON list of known aliases/alternative spellings
  TextColumn get aliasesJson => text().withDefault(const Constant('[]'))();

  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
