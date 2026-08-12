import '../../domain/ai/embedding_engine.dart';
import '../../domain/repositories/note_repository.dart';
import '../../data/local/vector/vector_store.dart';
import '../../domain/ai/note_analysis_result.dart';
import '../../core/constants/app_constants.dart';

class MemoryLinker {
  MemoryLinker({
    required NoteRepository repository,
    required VectorStore vectorStore,
    required EmbeddingEngine embeddingEngine,
  })  : _repository = repository,
        _vectorStore = vectorStore,
        _embeddingEngine = embeddingEngine;

  final NoteRepository _repository;
  final VectorStore _vectorStore;
  final EmbeddingEngine _embeddingEngine;

  /// Generates embedding and conditionally links high-confidence related memories.
  Future<List<String>> linkMemory({
    required String noteId,
    required String rawContent,
    required NoteAnalysisResult analysis,
  }) async {
    if (!_embeddingEngine.isReady) return [];

    // Combine raw content with structured essence
    final structuredRepresentation = StringBuffer(rawContent);
    if (analysis.summary.isNotEmpty) {
      structuredRepresentation.writeln('\nSummary: ${analysis.summary}');
    }
    if (analysis.entities.isNotEmpty) {
      structuredRepresentation.writeln('Entities: ${analysis.entities.map((e) => e.name).join(', ')}');
    }

    final vector = await _embeddingEngine.embed(structuredRepresentation.toString());
    if (vector == null) return [];

    // Save vector in vector store
    await _repository.saveEmbedding(noteId, vector);

    // Retrieve top KNN candidates
    final candidates = await _vectorStore.knn(
      vector,
      limit: AppConstants.maxRelatedNotes + 1,
    );

    final linkedIds = <String>[];
    for (final candidate in candidates) {
      if (candidate.noteId == noteId) continue;

      // Smart verification: only link if similarity is high (>= 0.75)
      if (candidate.similarity >= 0.75) {
        linkedIds.add(candidate.noteId);
      }
    }

    return linkedIds;
  }
}
