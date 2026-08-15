import 'package:drift/drift.dart';

/// Drift table definition for storing explainable memory evidence records.
class MemoryEvidenceTable extends Table {
  @override
  String get tableName => 'memory_evidence';

  TextColumn get id => text()();
  TextColumn get sourceMemoryId => text()();
  TextColumn get sourceTextSnippet => text().withDefault(const Constant(''))();
  TextColumn get targetContextId => text()();
  TextColumn get targetContextName => text().withDefault(const Constant(''))();
  TextColumn get relationType => text().withDefault(const Constant('relates_to'))();
  
  /// Confidence score between 0.0 and 1.0 (ranking signal)
  RealColumn get confidence => real().withDefault(const Constant(1.0))();

  /// 'explicit' | 'strongInference' | 'weakInference' | 'ambiguousInference'
  TextColumn get inferenceType => text().withDefault(const Constant('weakInference'))();

  /// JSON-encoded array of EvidenceSignal objects
  TextColumn get signalsJson => text().withDefault(const Constant('[]'))();

  /// Concise human-readable explanation
  TextColumn get explanation => text().withDefault(const Constant(''))();

  IntColumn get createdAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
