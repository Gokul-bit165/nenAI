import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/embeddings_table.dart';

part 'embeddings_dao.g.dart';

@DriftAccessor(tables: [EmbeddingsTable])
class EmbeddingsDao extends DatabaseAccessor<AppDatabase>
    with _$EmbeddingsDaoMixin {
  EmbeddingsDao(super.db);

  Future<EmbeddingsTableData?> getByNoteId(String noteId) =>
      (select(embeddingsTable)
            ..where((t) => t.noteId.equals(noteId)))
          .getSingleOrNull();

  /// Returns all stored embedding rows (used for cosine similarity scan).
  Future<List<EmbeddingsTableData>> getAll() =>
      select(embeddingsTable).get();

  Future<void> upsert(EmbeddingsTableCompanion companion) =>
      into(embeddingsTable).insertOnConflictUpdate(companion);

  Future<void> deleteByNoteId(String noteId) =>
      (delete(embeddingsTable)..where((t) => t.noteId.equals(noteId))).go();
}
