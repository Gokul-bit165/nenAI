import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/notes_table.dart';

part 'notes_dao.g.dart';

@DriftAccessor(tables: [NotesTable])
class NotesDao extends DatabaseAccessor<AppDatabase> with _$NotesDaoMixin {
  NotesDao(super.db);

  // ── Reactive queries ───────────────────────────────────────────────────────

  Stream<List<NotesTableData>> watchAll() =>
      (select(notesTable)
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .watch();

  Stream<List<NotesTableData>> watchByCluster(String clusterId) =>
      (select(notesTable)
            ..where((t) => t.clusterId.equals(clusterId))
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .watch();

  // ── One-shot queries ───────────────────────────────────────────────────────

  Future<NotesTableData?> getById(String id) =>
      (select(notesTable)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<NotesTableData>> getByIds(List<String> ids) =>
      (select(notesTable)..where((t) => t.id.isIn(ids))).get();

  /// Plain FTS-style search — falls back from semantic when model unavailable.
  Future<List<NotesTableData>> search(String query) {
    final q = '%${query.toLowerCase()}%';
    return (select(notesTable)
          ..where(
            (t) => t.content.lower().like(q) | t.summary.lower().like(q),
          )
          ..limit(20))
        .get();
  }

  /// All notes with status = 'pending' (retry queue on app launch).
  Future<List<NotesTableData>> getPending() =>
      (select(notesTable)
            ..where((t) => t.processingStatus.equals('pending')))
          .get();

  // ── Writes ─────────────────────────────────────────────────────────────────

  Future<void> insertNote(NotesTableCompanion companion) =>
      into(notesTable).insert(companion);

  Future<void> updateNote(NotesTableCompanion companion) =>
      (update(notesTable)
            ..where((t) => t.id.equals(companion.id.value)))
          .write(companion);

  Future<void> updateAiFields({
    required String noteId,
    required String summary,
    required String keywordsJson,
    String? clusterId,
    required String relatedNoteIdsJson,
    required String processingStatus,
  }) =>
      (update(notesTable)..where((t) => t.id.equals(noteId))).write(
        NotesTableCompanion(
          summary: Value(summary),
          keywordsJson: Value(keywordsJson),
          clusterId: Value(clusterId),
          relatedNoteIdsJson: Value(relatedNoteIdsJson),
          processingStatus: Value(processingStatus),
          updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
        ),
      );

  Future<void> updateStatus(String noteId, String status) =>
      (update(notesTable)..where((t) => t.id.equals(noteId))).write(
        NotesTableCompanion(processingStatus: Value(status)),
      );

  Future<void> deleteNote(String id) =>
      (delete(notesTable)..where((t) => t.id.equals(id))).go();
}
