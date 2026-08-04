import '../../domain/entities/note.dart';
import '../../domain/repositories/note_repository.dart';
import '../../domain/ai/embedding_engine.dart';

class HybridSearchResult {
  const HybridSearchResult({
    required this.note,
    required this.rrfScore,
  });

  final Note note;
  final double rrfScore;
}

class HybridRetriever {
  const HybridRetriever({
    required NoteRepository repository,
    required EmbeddingEngine embeddingEngine,
  })  : _repository = repository,
        _embeddingEngine = embeddingEngine;

  final NoteRepository _repository;
  final EmbeddingEngine _embeddingEngine;

  /// Executes Reciprocal Rank Fusion (RRF) combining BM25/Tokenized SQL text search and Cosine Similarity vector search.
  Future<List<HybridSearchResult>> retrieve(String query, {int limit = 10, int rrfK = 60}) async {
    final cleanQuery = query.trim();
    if (cleanQuery.isEmpty) return [];

    // 1. Tokenized Keyword Text Search
    final tokens = _extractSearchTokens(cleanQuery);
    final textResultsMap = <String, Note>{};
    final tokenScores = <String, int>{};

    // Full query search
    final fullQueryResults = await _repository.textSearch(cleanQuery);
    for (final note in fullQueryResults) {
      textResultsMap[note.id] = note;
      tokenScores[note.id] = (tokenScores[note.id] ?? 0) + 5;
    }

    // Per-token search
    for (final token in tokens) {
      final tokenResults = await _repository.textSearch(token);
      for (final note in tokenResults) {
        textResultsMap[note.id] = note;
        tokenScores[note.id] = (tokenScores[note.id] ?? 0) + 1;
      }
    }

    final textResults = textResultsMap.values.toList()
      ..sort((a, b) => (tokenScores[b.id] ?? 0).compareTo(tokenScores[a.id] ?? 0));

    // 2. Semantic Vector Search
    List<Note> vectorResults = [];
    if (_embeddingEngine.isReady) {
      final queryVector = await _embeddingEngine.embed(cleanQuery);
      if (queryVector != null) {
        vectorResults = await _repository.semanticSearch(queryVector, limit: limit * 2);
      }
    }

    // 3. Reciprocal Rank Fusion (RRF)
    final rrfScores = <String, double>{};
    final noteMap = <String, Note>{};

    for (int i = 0; i < textResults.length; i++) {
      final note = textResults[i];
      noteMap[note.id] = note;
      final rank = i + 1;
      rrfScores[note.id] = (rrfScores[note.id] ?? 0.0) + (1.0 / (rrfK + rank));
    }

    for (int i = 0; i < vectorResults.length; i++) {
      final note = vectorResults[i];
      noteMap[note.id] = note;
      final rank = i + 1;
      rrfScores[note.id] = (rrfScores[note.id] ?? 0.0) + (1.0 / (rrfK + rank));
    }

    final sortedEntries = rrfScores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedEntries
        .take(limit)
        .map((entry) => HybridSearchResult(
              note: noteMap[entry.key]!,
              rrfScore: entry.value,
            ))
        .toList();
  }

  List<String> _extractSearchTokens(String query) {
    const stopWords = {
      'what', 'did', 'do', 'does', 'how', 'why', 'when', 'where', 'who', 'which',
      'i', 'me', 'my', 'you', 'your', 'we', 'our', 'is', 'are', 'was', 'were', 'be',
      'been', 'being', 'have', 'has', 'had', 'the', 'a', 'an', 'and', 'or', 'but',
      'in', 'on', 'at', 'to', 'for', 'with', 'about', 'against', 'between', 'into',
      'through', 'during', 'before', 'after', 'above', 'below', 'from', 'up', 'down',
      'out', 'off', 'over', 'under', 'again', 'further', 'then', 'once', 'here',
      'there', 'all', 'any', 'both', 'each', 'few', 'more', 'most', 'other', 'some',
      'such', 'no', 'nor', 'not', 'only', 'own', 'same', 'so', 'than', 'too', 'very',
      'can', 'will', 'just', 'should', 'now', 'write', 'wrote', 'tell', 'show', 'find'
    };

    final rawWords = query.toLowerCase().split(RegExp(r'[\s_,\.\?\!]+'));
    return rawWords.where((w) => w.length > 2 && !stopWords.contains(w)).toList();
  }
}
