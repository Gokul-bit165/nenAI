import 'package:drift/drift.dart';

/// Drift table definition for notes.
/// Maps 1-to-1 with the [Note] domain entity.
class NotesTable extends Table {
  @override
  String get tableName => 'notes';

  TextColumn get id => text()();
  TextColumn get content => text()();

  /// AI-generated 1–2 sentence summary. Null until processing completes.
  TextColumn get summary => text().nullable()();

  /// JSON-encoded list of keyword strings. Empty array '[]' by default.
  TextColumn get keywordsJson => text().withDefault(const Constant('[]'))();

  /// Foreign key to clusters table. Null until cluster is assigned.
  TextColumn get clusterId => text().nullable()();

  /// JSON-encoded list of related note IDs.
  TextColumn get relatedNoteIdsJson =>
      text().withDefault(const Constant('[]'))();

  /// One of: pending | processing | completed | failed
  TextColumn get processingStatus =>
      text().withDefault(const Constant('pending'))();

  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
