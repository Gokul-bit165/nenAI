import '../../domain/entities/note.dart';
import '../../domain/repositories/note_repository.dart';
import '../../domain/ai/embedding_engine.dart';
import '../../data/local/database/daos/entities_dao.dart';
import '../../data/local/database/daos/relationships_dao.dart';
import 'retrieval_planner.dart';

class HybridSearchResult {
  const HybridSearchResult({
    required this.note,
    required this.rrfScore,
    this.graphTriples = const [],
  });

  final Note note;
  final double rrfScore;
  final List<String> graphTriples;
}

class HybridRetriever {
  const HybridRetriever({
    required NoteRepository repository,
    required EmbeddingEngine embeddingEngine,
    required EntitiesDao entitiesDao,
    required RelationshipsDao relationshipsDao,
    required RetrievalPlanner retrievalPlanner,
  })  : _repository = repository,
        _embeddingEngine = embeddingEngine,
        _entitiesDao = entitiesDao,
        _relationshipsDao = relationshipsDao,
        _retrievalPlanner = retrievalPlanner;

  final NoteRepository _repository;
  final EmbeddingEngine _embeddingEngine;
  final EntitiesDao _entitiesDao;
  final RelationshipsDao _relationshipsDao;
  final RetrievalPlanner _retrievalPlanner;

  /// Executes 3-Way Reciprocal Rank Fusion (FTS + Vector + Knowledge Graph).
  Future<List<HybridSearchResult>> retrieve(String query, {int limit = 10, int rrfK = 60}) async {
    final cleanQuery = query.trim();
    if (cleanQuery.isEmpty) return [];

    // Plan retrieval
    final plan = await _retrievalPlanner.plan(cleanQuery);

    // ── 1. Keyword / Tokenized SQL Text Search ───────────────────────────────
    final textResultsMap = <String, Note>{};
    final tokenScores = <String, int>{};

    final fullQueryResults = await _repository.textSearch(cleanQuery);
    for (final note in fullQueryResults) {
      textResultsMap[note.id] = note;
      tokenScores[note.id] = (tokenScores[note.id] ?? 0) + 5;
    }

    for (final token in plan.searchKeywords) {
      final tokenResults = await _repository.textSearch(token);
      for (final note in tokenResults) {
        textResultsMap[note.id] = note;
        tokenScores[note.id] = (tokenScores[note.id] ?? 0) + 1;
      }
    }

    final textResults = textResultsMap.values.toList()
      ..sort((a, b) => (tokenScores[b.id] ?? 0).compareTo(tokenScores[a.id] ?? 0));

    // ── 2. Semantic Vector Search ─────────────────────────────────────────────
    List<Note> vectorResults = [];
    if (_embeddingEngine.isReady) {
      final queryVector = await _embeddingEngine.embed(cleanQuery);
      if (queryVector != null) {
        vectorResults = await _repository.semanticSearch(queryVector, limit: limit * 2);
      }
    }

    // ── 3. Knowledge Graph Traversal ──────────────────────────────────────────
    final kgResultsMap = <String, Note>{};
    final memoryGraphTriples = <String, List<String>>{};

    for (final entity in plan.targetEntities) {
      final neighborhood = await _relationshipsDao.getNeighborhood(entity.id);
      for (final item in neighborhood) {
        final memoryId = item.relationship.sourceMemoryId;
        final tripleStr = '${item.source.name} --${item.relationship.relation}--> ${item.target.name}';
        
        memoryGraphTriples.putIfAbsent(memoryId, () => []).add(tripleStr);

        if (!kgResultsMap.containsKey(memoryId)) {
          final note = await _repository.getNoteById(memoryId);
          if (note != null) {
            kgResultsMap[memoryId] = note;
          }
        }
      }
    }
    final kgResults = kgResultsMap.values.toList();

    // ── 4. 3-Way Reciprocal Rank Fusion (RRF) ─────────────────────────────────
    final rrfScores = <String, double>{};
    final noteMap = <String, Note>{};

    void applyRRF(List<Note> list, double weight) {
      for (int i = 0; i < list.length; i++) {
        final note = list[i];
        noteMap[note.id] = note;
        final rank = i + 1;
        rrfScores[note.id] = (rrfScores[note.id] ?? 0.0) + (weight / (rrfK + rank));
      }
    }

    applyRRF(textResults, 1.0);
    applyRRF(vectorResults, 1.2);
    applyRRF(kgResults, 1.5); // High boost for direct graph matches

    final sortedEntries = rrfScores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedEntries
        .take(limit)
        .map((entry) => HybridSearchResult(
              note: noteMap[entry.key]!,
              rrfScore: entry.value,
              graphTriples: memoryGraphTriples[entry.key] ?? const [],
            ))
        .toList();
  }
}
