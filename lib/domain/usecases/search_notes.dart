import '../entities/note.dart';
import '../ai/embedding_engine.dart';
import '../repositories/note_repository.dart';

class SearchNotesUseCase {
  const SearchNotesUseCase(this._repository, this._embeddingEngine);

  final NoteRepository _repository;
  final EmbeddingEngine _embeddingEngine;

  Future<List<Note>> call(String query, {int limit = 20}) async {
    if (query.trim().isEmpty) return [];

    if (_embeddingEngine.isReady) {
      final queryVector = await _embeddingEngine.embed(query);
      if (queryVector != null) {
        return _repository.semanticSearch(queryVector, limit: limit);
      }
    }
    return _repository.textSearch(query);
  }
}
