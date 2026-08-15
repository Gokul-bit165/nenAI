import '../entities/note.dart';
import '../entities/cluster.dart';

/// The single source of truth for all note and cluster data.
/// Implemented by [NoteRepositoryImpl] in the data layer.
abstract class NoteRepository {
  // ── Notes ─────────────────────────────────────────────────────────────────

  /// Reactively emits the full list of notes, newest first.
  Stream<List<Note>> watchAllNotes();

  /// Fetches all notes.
  Future<List<Note>> getAllNotes();

  /// Reactively emits notes belonging to a specific cluster.
  Stream<List<Note>> watchNotesByCluster(String clusterId);

  /// Fetches a single note by ID. Returns null if not found.
  Future<Note?> getNoteById(String id);

  /// Persists a new note. The note is written immediately; AI enrichment
  /// is enqueued asynchronously (see [NoteProcessingWorker]).
  Future<void> createNote(Note note);

  /// Updates an existing note's content and timestamps.
  Future<void> updateNote(Note note);

  /// Deletes a note and its associated embedding and related-note links.
  Future<void> deleteNote(String id);

  /// Writes back AI-enriched fields (summary, keywords, clusterId,
  /// relatedNoteIds, status) after background processing completes.
  Future<void> updateNoteAiFields({
    required String noteId,
    required String summary,
    required List<String> keywords,
    required String? clusterId,
    required List<String> relatedNoteIds,
    required String status,
  });

  /// Stores a note's embedding vector.
  Future<void> saveEmbedding(String noteId, List<double> vector);

  /// Returns all stored embeddings as a map of noteId → vector.
  Future<Map<String, List<double>>> getAllEmbeddings();

  // ── Search ────────────────────────────────────────────────────────────────

  /// Semantic KNN search: returns notes whose embeddings are most similar to
  /// [queryVector], ranked by cosine similarity.
  Future<List<Note>> semanticSearch(List<double> queryVector, {int limit = 20});

  /// Full-text keyword search fallback (used when embeddings are unavailable).
  Future<List<Note>> textSearch(String query);

  // ── Clusters ──────────────────────────────────────────────────────────────

  /// Reactively emits all clusters with live note counts.
  Stream<List<Cluster>> watchAllClusters();

  /// Fetches a cluster by ID.
  Future<Cluster?> getClusterById(String id);

  /// Creates or replaces a cluster.
  Future<void> upsertCluster(Cluster cluster);

  /// Renames a cluster without changing anything else.
  Future<void> renameCluster(String clusterId, String newName);

  /// Moves a note from its current cluster to [newClusterId].
  Future<void> moveNoteToCluster(String noteId, String newClusterId);
}
