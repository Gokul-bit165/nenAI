import 'package:drift/drift.dart';

/// Drift table definition for Knowledge Graph relationships/triples.
class RelationshipsTable extends Table {
  @override
  String get tableName => 'relationships';

  TextColumn get id => text()();
  
  /// Foreign key to source entity (e.g. Arun)
  TextColumn get sourceEntityId => text()();
  
  /// Predicate/relationship label (e.g. 'suggested', 'works_on', 'helps_with', 'used_in')
  TextColumn get relation => text()();
  
  /// Foreign key to target entity (e.g. Gemma 3 1B)
  TextColumn get targetEntityId => text()();
  
  /// Foreign key to note/memory ID where this fact was stated
  TextColumn get sourceMemoryId => text()();

  /// Confidence score (0.0 to 1.0)
  RealColumn get confidence => real().withDefault(const Constant(1.0))();

  /// How this relationship was established: 'extracted' (from note text),
  /// 'inferred' (cross-note graph traversal), or 'user_confirmed'.
  TextColumn get inferenceType => text().withDefault(const Constant('extracted'))();

  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
