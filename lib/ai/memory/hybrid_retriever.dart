import '../../domain/entities/note.dart';
import '../../domain/repositories/note_repository.dart';
import '../../domain/repositories/context_repository.dart';
import '../../domain/ai/embedding_engine.dart';
import '../../data/local/database/app_database.dart';
import '../../data/local/database/daos/entities_dao.dart';
import '../../data/local/database/daos/relationships_dao.dart';
import '../../data/local/database/daos/tasks_dao.dart';
import 'retrieval_planner.dart';
import 'reference_resolver.dart';
import 'context_timeline_service.dart';

/// Rich search result containing note content, RRF ranking, knowledge graph triples,
/// context path hierarchy, associated tasks, and full source provenance.
class HybridSearchResult {
  const HybridSearchResult({
    required this.note,
    required this.rrfScore,
    this.graphTriples = const [],
    this.contextPath,
    this.contextId,
    this.contextName,
    this.tasks = const [],
    this.sourceNoteIds = const [],
  });

  final Note note;
  final double rrfScore;
  final List<String> graphTriples;
  final String? contextPath;
  final String? contextId;
  final String? contextName;
  final List<TasksTableData> tasks;
  final List<String> sourceNoteIds;
}

/// Context-Aware Hybrid Retriever: Executes multi-signal reciprocal rank fusion combining
/// Full-Text Search (FTS), Semantic Vectors, Knowledge Graph, Context Hierarchy, Reference Resolution,
/// Task State, and Temporal Recency.
class HybridRetriever {
  const HybridRetriever({
    required NoteRepository repository,
    required EmbeddingEngine embeddingEngine,
    required EntitiesDao entitiesDao,
    required RelationshipsDao relationshipsDao,
    required RetrievalPlanner retrievalPlanner,
    ContextRepository? contextRepository,
    TasksDao? tasksDao,
    ReferenceResolver? referenceResolver,
    ContextTimelineService? contextTimelineService,
  })  : _repository = repository,
        _embeddingEngine = embeddingEngine,
        _entitiesDao = entitiesDao,
        _relationshipsDao = relationshipsDao,
        _retrievalPlanner = retrievalPlanner,
        _contextRepository = contextRepository,
        _tasksDao = tasksDao,
        _referenceResolver = referenceResolver,
        _contextTimelineService = contextTimelineService;

  final NoteRepository _repository;
  final EmbeddingEngine _embeddingEngine;
  final EntitiesDao _entitiesDao;
  final RelationshipsDao _relationshipsDao;
  final RetrievalPlanner _retrievalPlanner;
  final ContextRepository? _contextRepository;
  final TasksDao? _tasksDao;
  final ReferenceResolver? _referenceResolver;
  final ContextTimelineService? _contextTimelineService;

  /// Executes Context-Aware Hybrid Retrieval.
  Future<List<HybridSearchResult>> retrieve(
    String query, {
    int limit = 10,
    int rrfK = 60,
    String? explicitContextId,
  }) async {
    final cleanQuery = query.trim();
    if (cleanQuery.isEmpty) return [];

    final queryLower = cleanQuery.toLowerCase();

    // ── 1. Query Understanding & Target Entity Identification ─────────────────
    final plan = await _retrievalPlanner.plan(cleanQuery);

    // ── 2. Context Hierarchy Identification & Scoping ─────────────────────────
    final targetScopedContextIds = <String>{};
    final conflictingContextIds = <String>{};
    String? matchedContextPath;
    String? matchedContextName;

    if (_contextRepository != null) {
      final allNodes = await _contextRepository.getAllNodes();

      // Check if query mentions any explicit project / episode
      final matchingProjects = allNodes.where((n) {
        final nodeNameLower = n.name.toLowerCase();
        return (n.type.name == 'project' || n.type.name == 'episode') &&
            (queryLower.contains(nodeNameLower) || (explicitContextId != null && n.id == explicitContextId));
      }).toList();

      if (matchingProjects.isNotEmpty) {
        for (final proj in matchingProjects) {
          targetScopedContextIds.add(proj.id);
          matchedContextName ??= proj.name;

          final subtree = await _contextRepository.getSubtree(proj.id);
          if (subtree != null) {
            for (final childNode in subtree.allNodes) {
              targetScopedContextIds.add(childNode.id);
            }
          }

          final ancestors = await _contextRepository.getAncestors(proj.id);
          final pathNodes = [...ancestors.reversed.map((a) => a.name), proj.name];
          matchedContextPath = pathNodes.join(' └── ');
        }

        // All non-matching projects and their subtrees are conflicting
        final nonMatchingProjects = allNodes.where((n) =>
            (n.type.name == 'project' || n.type.name == 'episode') &&
            !matchingProjects.any((m) => m.id == n.id));

        for (final nonProj in nonMatchingProjects) {
          conflictingContextIds.add(nonProj.id);
          final subtree = await _contextRepository.getSubtree(nonProj.id);
          if (subtree != null) {
            for (final childNode in subtree.allNodes) {
              conflictingContextIds.add(childNode.id);
            }
          }
        }
      } else {
        // Match generic context nodes directly if no project matched
        for (final node in allNodes) {
          final nodeNameLower = node.name.toLowerCase();
          if (queryLower.contains(nodeNameLower) || (explicitContextId != null && node.id == explicitContextId)) {
            targetScopedContextIds.add(node.id);
            matchedContextName ??= node.name;

            final subtree = await _contextRepository.getSubtree(node.id);
            if (subtree != null) {
              for (final childNode in subtree.allNodes) {
                targetScopedContextIds.add(childNode.id);
              }
            }
          }
        }
      }
    }

    // ── 3. FTS Keyword & Tokenized SQL Search ─────────────────────────────────
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

    // ── 4. Semantic Vector Search ─────────────────────────────────────────────
    List<Note> vectorResults = [];
    if (_embeddingEngine.isReady) {
      final queryVector = await _embeddingEngine.embed(cleanQuery);
      if (queryVector != null) {
        vectorResults = await _repository.semanticSearch(queryVector, limit: limit * 2);
      }
    }

    // ── 5. Knowledge Graph Traversal ──────────────────────────────────────────
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

    // ── 6. Context Hierarchy Memory Collection ────────────────────────────────
    final contextResultsMap = <String, Note>{};
    if (_contextRepository != null && targetScopedContextIds.isNotEmpty) {
      for (final ctxId in targetScopedContextIds) {
        final memoryIds = await _contextRepository.getMemoriesForContext(ctxId);
        for (final mId in memoryIds) {
          if (!contextResultsMap.containsKey(mId)) {
            final note = await _repository.getNoteById(mId);
            if (note != null) {
              contextResultsMap[mId] = note;
            }
          }
        }
      }
    }
    final contextResults = contextResultsMap.values.toList();

    // ── 7. Multi-Signal Reciprocal Rank Fusion (RRF) ─────────────────────────
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
    applyRRF(kgResults, 1.5);
    applyRRF(contextResults, 2.0); // High boost for notes inside the target context subtree

    // ── 8. Context Scoping & Penalty Filter ────────────────────────────────────
    // If target context is explicitly specified/identified, filter out or penalize disjoint conflicting contexts
    if (targetScopedContextIds.isNotEmpty && _contextRepository != null) {
      for (final noteId in rrfScores.keys.toList()) {
        final memoryContexts = await _contextRepository.getContextsForMemory(noteId);
        final hasTargetContext = memoryContexts.any((c) => targetScopedContextIds.contains(c.id));
        final hasConflictingContext = memoryContexts.any((c) => conflictingContextIds.contains(c.id));

        if (!hasTargetContext && hasConflictingContext) {
          // Penalize or suppress unrelated context notes (e.g. FC notes when querying ReadSmart AI)
          rrfScores[noteId] = (rrfScores[noteId] ?? 0.0) * 0.15;
        } else if (hasTargetContext) {
          // Extra boost for direct context hit
          rrfScores[noteId] = (rrfScores[noteId] ?? 0.0) * 1.5;
        }
      }
    }

    // ── 9. Temporal Recency Weighting ─────────────────────────────────────────
    final now = DateTime.now();
    for (final entry in noteMap.entries) {
      final noteDate = entry.value.createdAt;
      final diffHours = now.difference(noteDate).inHours.abs();
      final recencyMultiplier = diffHours <= 24 ? 1.20 : (diffHours <= 72 ? 1.10 : 1.0);
      rrfScores[entry.key] = (rrfScores[entry.key] ?? 0.0) * recencyMultiplier;
    }

    final sortedEntries = rrfScores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // ── 10. Enrich with Tasks, Path & Provenance ──────────────────────────────
    final searchResults = <HybridSearchResult>[];
    for (final entry in sortedEntries.take(limit)) {
      final note = noteMap[entry.key]!;
      final tasks = _tasksDao != null ? await _tasksDao.getByMemoryId(note.id) : <TasksTableData>[];

      String? noteContextPath = matchedContextPath;
      String? noteContextName = matchedContextName;
      String? noteContextId;

      if (_contextRepository != null) {
        final memContexts = await _contextRepository.getContextsForMemory(note.id);
        if (memContexts.isNotEmpty) {
          final ctx = memContexts.first;
          noteContextId = ctx.id;
          noteContextName = ctx.name;
          final ancestors = await _contextRepository.getAncestors(ctx.id);
          final pathNodes = [...ancestors.reversed.map((a) => a.name), ctx.name];
          noteContextPath = pathNodes.join(' └── ');
        }
      }

      searchResults.add(
        HybridSearchResult(
          note: note,
          rrfScore: entry.value,
          graphTriples: memoryGraphTriples[note.id] ?? const [],
          contextPath: noteContextPath,
          contextId: noteContextId,
          contextName: noteContextName,
          tasks: tasks,
          sourceNoteIds: [note.id],
        ),
      );
    }

    return searchResults;
  }
}
