import 'package:drift/drift.dart';
import 'notes_table.dart';

/// Stores the 384-float embedding vector for each note as a BLOB.
/// One-to-one with [NotesTable] — only exists after AI processing.
class EmbeddingsTable extends Table {
  @override
  String get tableName => 'embeddings';

  /// FK → notes.id
  TextColumn get noteId =>
      text().references(NotesTable, #id, onDelete: KeyAction.cascade)();

  /// Raw IEEE 754 little-endian floats: 384 × 4 bytes = 1536 bytes.
  BlobColumn get vector => blob()();

  @override
  Set<Column> get primaryKey => {noteId};
}
