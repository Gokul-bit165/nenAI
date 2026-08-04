import '../../../core/constants/app_constants.dart';
import '../../../core/utils/vector_math.dart';
import '../database/app_database.dart';

/// Wraps embedding storage and KNN retrieval.
class VectorStore {
  VectorStore(this._db);
  final AppDatabase _db;

  /// Saves or replaces the embedding vector for [noteId].
  Future<void> save(String noteId, List<double> vector) async {
    final bytes = VectorMath.floatListToBytes(vector);
    await _db.embeddings.upsert(
      EmbeddingsTableCompanion.insert(
        noteId: noteId,
        vector: bytes,
      ),
    );
  }

  /// Returns all stored embeddings as a map of noteId → float vector.
  Future<Map<String, List<double>>> loadAll() async {
    final rows = await _db.embeddings.getAll();
    return {
      for (final row in rows)
        row.noteId: VectorMath.bytesToFloatList(row.vector),
    };
  }

  /// Finds the [limit] nearest neighbours to [queryVector] by cosine similarity.
  /// Returns a list of (noteId, similarity) pairs, sorted descending.
  Future<List<({String noteId, double similarity})>> knn(
    List<double> queryVector, {
    int limit = AppConstants.maxRelatedNotes,
  }) async {
    final all = await loadAll();
    final scored = all.entries
        .map(
          (e) => (
            noteId: e.key,
            similarity: VectorMath.cosineSimilarity(queryVector, e.value),
          ),
        )
        .toList()
      ..sort((a, b) => b.similarity.compareTo(a.similarity));
    return scored.take(limit).toList();
  }

  /// Returns the centroid of all vectors belonging to [noteIds].
  Future<List<double>?> centroidOf(List<String> noteIds) async {
    if (noteIds.isEmpty) return null;
    final all = await loadAll();
    final vecs = noteIds
        .where(all.containsKey)
        .map((id) => all[id]!)
        .toList();
    if (vecs.isEmpty) return null;
    return VectorMath.centroid(vecs);
  }
}
