import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:workmanager/workmanager.dart';
import '../../core/constants/app_constants.dart';
import '../../domain/entities/note.dart';
import '../../domain/entities/cluster.dart';
import '../../domain/entities/processing_status.dart';
import '../../domain/repositories/note_repository.dart';
import '../local/database/app_database.dart';
import '../local/vector/vector_store.dart';

class NoteRepositoryImpl implements NoteRepository {
  NoteRepositoryImpl(this._db, this._vectorStore);

  final AppDatabase _db;
  final VectorStore _vectorStore;

  // ── Notes ─────────────────────────────────────────────────────────────────

  @override
  Stream<List<Note>> watchAllNotes() =>
      _db.notes.watchAll().map((rows) => rows.map(_rowToNote).toList());

  @override
  Stream<List<Note>> watchNotesByCluster(String clusterId) =>
      _db.notes
          .watchByCluster(clusterId)
          .map((rows) => rows.map(_rowToNote).toList());

  @override
  Future<Note?> getNoteById(String id) async {
    final row = await _db.notes.getById(id);
    return row == null ? null : _rowToNote(row);
  }

  @override
  Future<void> createNote(Note note) async {
    await _db.notes.insertNote(
      NotesTableCompanion.insert(
        id: note.id,
        content: note.content,
        summary: Value(note.summary),
        keywordsJson: Value(jsonEncode(note.keywords)),
        clusterId: Value(note.clusterId),
        relatedNoteIdsJson: Value(jsonEncode(note.relatedNoteIds)),
        processingStatus: Value(note.status.name),
        createdAt: note.createdAt.millisecondsSinceEpoch,
        updatedAt: note.updatedAt.millisecondsSinceEpoch,
      ),
    );
    await _enqueueProcessing(note.id);
  }

  @override
  Future<void> updateNote(Note note) async {
    await _db.notes.updateNote(
      NotesTableCompanion(
        id: Value(note.id),
        content: Value(note.content),
        processingStatus: Value(ProcessingStatus.pending.name),
        updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
      ),
    );
    await _enqueueProcessing(note.id);
  }

  @override
  Future<void> deleteNote(String id) => _db.notes.deleteNote(id);

  @override
  Future<void> updateNoteAiFields({
    required String noteId,
    required String summary,
    required List<String> keywords,
    required String? clusterId,
    required List<String> relatedNoteIds,
    required String status,
  }) =>
      _db.notes.updateAiFields(
        noteId: noteId,
        summary: summary,
        keywordsJson: jsonEncode(keywords),
        clusterId: clusterId,
        relatedNoteIdsJson: jsonEncode(relatedNoteIds),
        processingStatus: status,
      );

  @override
  Future<void> saveEmbedding(String noteId, List<double> vector) =>
      _vectorStore.save(noteId, vector);

  @override
  Future<Map<String, List<double>>> getAllEmbeddings() =>
      _vectorStore.loadAll();

  // ── Search ────────────────────────────────────────────────────────────────

  @override
  Future<List<Note>> semanticSearch(
    List<double> queryVector, {
    int limit = 20,
  }) async {
    final results = await _vectorStore.knn(queryVector, limit: limit);
    if (results.isEmpty) return [];
    final ids = results.map((r) => r.noteId).toList();
    final rows = await _db.notes.getByIds(ids);
    final idIndex = {for (var i = 0; i < ids.length; i++) ids[i]: i};
    rows.sort((a, b) => (idIndex[a.id] ?? 0).compareTo(idIndex[b.id] ?? 0));
    return rows.map(_rowToNote).toList();
  }

  @override
  Future<List<Note>> textSearch(String query) async {
    final rows = await _db.notes.search(query);
    return rows.map(_rowToNote).toList();
  }

  // ── Clusters ──────────────────────────────────────────────────────────────

  @override
  Stream<List<Cluster>> watchAllClusters() async* {
    await for (final clusterRows in _db.clusters.watchAll()) {
      final counts = <String, int>{};
      final allRows = await (_db.select(_db.notesTable)).get();
      for (final row in allRows) {
        if (row.clusterId != null) {
          counts[row.clusterId!] = (counts[row.clusterId!] ?? 0) + 1;
        }
      }
      yield clusterRows.map((r) => _rowToCluster(r, counts[r.id] ?? 0)).toList();
    }
  }

  @override
  Future<Cluster?> getClusterById(String id) async {
    final row = await _db.clusters.getById(id);
    return row == null ? null : _rowToCluster(row, 0);
  }

  @override
  Future<void> upsertCluster(Cluster cluster) =>
      _db.clusters.upsert(
        ClustersTableCompanion.insert(
          id: cluster.id,
          name: cluster.name,
          colorHex: cluster.colorHex,
          createdAt: cluster.createdAt.millisecondsSinceEpoch,
        ),
      );

  @override
  Future<void> renameCluster(String clusterId, String newName) =>
      _db.clusters.rename(clusterId, newName);

  @override
  Future<void> moveNoteToCluster(String noteId, String newClusterId) =>
      _db.notes.updateNote(
        NotesTableCompanion(
          id: Value(noteId),
          clusterId: Value(newClusterId),
        ),
      );

  // ── Private helpers ───────────────────────────────────────────────────────

  Note _rowToNote(NotesTableData row) => Note(
        id: row.id,
        content: row.content,
        summary: row.summary,
        keywords: List<String>.from(
          (jsonDecode(row.keywordsJson) as List<dynamic>),
        ),
        clusterId: row.clusterId,
        relatedNoteIds: List<String>.from(
          (jsonDecode(row.relatedNoteIdsJson) as List<dynamic>),
        ),
        status: ProcessingStatus.values.byName(row.processingStatus),
        createdAt: DateTime.fromMillisecondsSinceEpoch(row.createdAt),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(row.updatedAt),
      );

  Cluster _rowToCluster(ClustersTableData row, int count) => Cluster(
        id: row.id,
        name: row.name,
        colorHex: row.colorHex,
        noteCount: count,
        createdAt: DateTime.fromMillisecondsSinceEpoch(row.createdAt),
      );

  Future<void> _enqueueProcessing(String noteId) async {
    try {
      await Workmanager().registerOneOffTask(
        '${AppConstants.noteProcessingTaskName}.$noteId',
        AppConstants.noteProcessingTaskName,
        inputData: {AppConstants.noteIdInputKey: noteId},
        constraints: Constraints(networkType: NetworkType.notRequired),
        backoffPolicy: BackoffPolicy.exponential,
        backoffPolicyDelay: const Duration(seconds: 5),
      );
    } catch (_) {
      // Workmanager is Android-only or ignored in test environment
    }
  }
}
