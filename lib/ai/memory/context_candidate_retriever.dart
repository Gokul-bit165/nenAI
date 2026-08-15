import 'dart:math' as math;
import '../../data/local/database/app_database.dart';
import '../../domain/ai/context_candidate.dart';
import '../../domain/repositories/context_repository.dart';
import '../../core/utils/vector_math.dart';
import 'relationship_evidence_builder.dart';

/// Context Candidate Retriever: Retrieves and scores existing hierarchical contexts
/// for incoming notes using multi-signal retrieval without LLM database scans.
class ContextCandidateRetriever {
  ContextCandidateRetriever({
    required this.db,
    required this.contextRepository,
  });

  final AppDatabase db;
  final ContextRepository contextRepository;

  /// Retrieves Top-K candidate contexts for a given incoming note.
  Future<List<ContextCandidate>> retrieveCandidates(
    CandidateRetrievalQuery query,
  ) async {
    final allNodes = await db.contexts.getAllNodes();
    if (allNodes.isEmpty) return const [];

    final candidates = <ContextCandidate>[];

    final queryText = query.noteText.toLowerCase();
    final analysis = query.analysisResult;
    final queryKeywords = (analysis?.keywords ?? []).map((k) => k.toLowerCase()).toSet();
    final queryTopics = (analysis?.topics ?? []).map((t) => t.toLowerCase()).toSet();
    final queryActionSubjects = (analysis?.actions ?? [])
        .map((a) => a.subject.toLowerCase().trim())
        .where((s) => s.isNotEmpty && s != 'this' && s != 'it')
        .toSet();

    final queryEntityNames = (analysis?.entities ?? [])
        .map((e) => e.name.toLowerCase().trim())
        .toSet();

    for (final node in allNodes) {
      final candidate = await _evaluateContextNode(
        node: node,
        query: query,
        queryText: queryText,
        queryKeywords: queryKeywords,
        queryTopics: queryTopics,
        queryActionSubjects: queryActionSubjects,
        queryEntityNames: queryEntityNames,
      );

      if (candidate != null && candidate.totalScore > 0.05) {
        candidates.add(candidate);
      }
    }

    // Sort descending by deterministic totalScore
    candidates.sort((a, b) => b.totalScore.compareTo(a.totalScore));

    return candidates.take(query.topK).toList();
  }

  Future<ContextCandidate?> _evaluateContextNode({
    required ContextNodesTableData node,
    required CandidateRetrievalQuery query,
    required String queryText,
    required Set<String> queryKeywords,
    required Set<String> queryTopics,
    required Set<String> queryActionSubjects,
    required Set<String> queryEntityNames,
  }) async {
    // 1. Ancestors & Context Path
    final ancestors = await contextRepository.getAncestors(node.id);
    final pathNodeNames = <String>[
      ...ancestors.reversed.map((a) => a.name),
      node.name,
    ];
    final contextPath = pathNodeNames.join(' └── ');

    // 2. Related Memories
    final memoryIds = await db.contexts.getMemoriesForContext(node.id);

    // 3. Related Notes & Timestamps
    DateTime? lastActiveTime = DateTime.fromMillisecondsSinceEpoch(node.updatedAt);
    final noteSummaries = <String>[];

    for (final mId in memoryIds) {
      final note = await db.notes.getById(mId);
      if (note != null) {
        final noteDate = DateTime.fromMillisecondsSinceEpoch(note.updatedAt);
        if (lastActiveTime == null || noteDate.isAfter(lastActiveTime)) {
          lastActiveTime = noteDate;
        }
        if (note.summary != null) {
          noteSummaries.add(note.summary!);
        }
      }
    }

    // 4. Related Evidence
    final evidenceRecords = await db.evidence.getByContextId(node.id);
    final recentEvidence = evidenceRecords.take(3).map((e) => e.explanation).toList();

    // ── Signal 1: Lexical & Action Relevance ─────────────────────────────────
    final matchedSignals = <String>[];
    double lexicalRelevance = 0.0;
    final nodeNameLower = node.name.toLowerCase();

    // Exact name match in text
    if (queryText.contains(nodeNameLower)) {
      lexicalRelevance += 0.50;
      matchedSignals.add('Explicit mention of "${node.name}" in text');
    }

    // Action subjects match (e.g. action "deployment" matches node "Deployment")
    for (final actionSub in queryActionSubjects) {
      if (nodeNameLower.contains(actionSub) || actionSub.contains(nodeNameLower)) {
        lexicalRelevance += 0.40;
        matchedSignals.add('Action subject "$actionSub" matches context "${node.name}"');
      }
    }

    // Topics & Keywords match
    int topicMatches = 0;
    for (final top in queryTopics) {
      if (nodeNameLower.contains(top) || pathNodeNames.any((p) => p.toLowerCase().contains(top))) {
        topicMatches++;
      }
    }
    if (topicMatches > 0) {
      lexicalRelevance += math.min(0.30, topicMatches * 0.15);
      matchedSignals.add('Topic matches in context path');
    }

    lexicalRelevance = lexicalRelevance.clamp(0.0, 1.0);

    // ── Signal 2: Graph & Entity Relevance ───────────────────────────────────
    double graphRelevance = 0.0;
    final relatedEntities = <String>[];

    // Direct entity match for context node
    if (queryEntityNames.contains(nodeNameLower) || queryEntityNames.any((e) => nodeNameLower == e)) {
      graphRelevance += 0.80;
      matchedSignals.add('Exact entity match for context node "${node.name}"');
    } else if (queryEntityNames.any((e) => nodeNameLower.contains(e) || e.contains(nodeNameLower))) {
      graphRelevance += 0.50;
      matchedSignals.add('Entity match for context node "${node.name}"');
    }

    for (final mId in memoryIds) {
      final entities = await db.entities.getEntitiesForMemory(mId);
      for (final e in entities) {
        relatedEntities.add(e.name);
        if (queryEntityNames.contains(e.name.toLowerCase())) {
          graphRelevance += 0.35;
          matchedSignals.add('Entity "${e.name}" co-occurs in knowledge graph');
        }
      }
    }

    // Check ancestor name matches
    for (final anc in ancestors) {
      if (queryText.contains(anc.name.toLowerCase())) {
        graphRelevance += 0.30;
        matchedSignals.add('Ancestor context "${anc.name}" mentioned in text');
      }
    }

    graphRelevance = graphRelevance.clamp(0.0, 1.0);

    // ── Signal 3: Temporal Proximity ─────────────────────────────────────────
    double temporalRelevance = 0.0;
    if (lastActiveTime != null) {
      final diffHours = query.noteTimestamp.difference(lastActiveTime).inHours.abs();
      if (diffHours <= 2) {
        temporalRelevance = 0.95;
        matchedSignals.add('Active session (< 2 hrs ago)');
      } else if (diffHours <= 24) {
        temporalRelevance = 0.80;
        matchedSignals.add('Recent activity (< 24 hrs ago)');
      } else if (diffHours <= 72) {
        temporalRelevance = 0.50;
      } else {
        // Exponential decay for older contexts
        temporalRelevance = math.max(0.0, math.exp(-diffHours / 168.0));
      }
    }

    // ── Signal 4: Semantic Vector Similarity ─────────────────────────────────
    double semanticSimilarity = 0.0;
    if (query.embedding != null && query.embedding!.isNotEmpty) {
      for (final mId in memoryIds) {
        final embRecord = await db.embeddings.getByNoteId(mId);
        if (embRecord != null) {
          final targetVector = VectorMath.bytesToFloatList(embRecord.vector);
          final sim = VectorMath.cosineSimilarity(
            query.embedding!,
            targetVector,
          );
          if (sim > semanticSimilarity) {
            semanticSimilarity = sim;
          }
        }
      }
      if (semanticSimilarity > 0.65) {
        matchedSignals.add('High vector embedding similarity (${semanticSimilarity.toStringAsFixed(2)})');
      }
    } else {
      // Fallback lexical overlap if no embedding vector is passed
      semanticSimilarity = lexicalRelevance * 0.8;
    }

    semanticSimilarity = semanticSimilarity.clamp(0.0, 1.0);

    // ── Signal 6: User-Confirmed Prior Corrections & Negative Preferences ───
    bool isUserExcluded = false;
    bool isUserConfirmed = false;

    for (final ev in evidenceRecords) {
      if (ev.relationType == 'user_excluded') {
        if (ev.sourceTextSnippet.isNotEmpty && queryText.contains(ev.sourceTextSnippet.toLowerCase())) {
          isUserExcluded = true;
          break;
        }
      } else if (ev.relationType == 'user_relocated' || ev.relationType == 'user_confirmed') {
        if (ev.sourceTextSnippet.isNotEmpty && queryText.contains(ev.sourceTextSnippet.toLowerCase())) {
          isUserConfirmed = true;
        }
      }
    }

    if (isUserExcluded) {
      return null; // Suppress candidate completely if user previously declared unrelated
    }

    // ── Composite Deterministic Ranking ──────────────────────────────────────
    double totalScore = (0.35 * semanticSimilarity) +
        (0.25 * graphRelevance) +
        (0.20 * temporalRelevance) +
        (0.20 * lexicalRelevance);

    // Explicit boost if direct node or parent match
    if (queryText.contains(nodeNameLower)) {
      totalScore = math.min(1.0, totalScore + 0.15);
    }

    if (isUserConfirmed) {
      totalScore = math.min(1.0, totalScore + 0.30);
      matchedSignals.add('User-confirmed preference for this context lineage');
    }

    totalScore = totalScore.clamp(0.0, 1.0);

    // ── Signal 7: Entity Evidence Boost ──────────────────────────────────────
    // If the incoming note has pre-computed entity evidences, boost this candidate
    // when those entities are known to appear in its context lineage.
    double evidenceBoost = 0.0;
    final evidences = query.entityEvidences.whereType<EntityEvidence>().toList();
    for (final ev in evidences) {
      // Check if this entity's linked memory IDs overlap with this context's notes
      final overlap = ev.linkedMemoryIds.any((mid) => memoryIds.contains(mid));
      if (overlap) {
        evidenceBoost += ev.matchConfidence * 0.40;
        matchedSignals.add(
          'KG entity "${ev.entityName}" confirmed in context lineage (conf: ${ev.matchConfidence.toStringAsFixed(2)})',
        );
      }
      // Also boost if entity name matches any node in the context path
      final entityNameLower = ev.entityName.toLowerCase();
      if (pathNodeNames.any((p) => p.toLowerCase().contains(entityNameLower))) {
        evidenceBoost += ev.matchConfidence * 0.25;
        matchedSignals.add('KG entity "${ev.entityName}" matches context path node');
      }
    }
    if (evidenceBoost > 0) {
      totalScore = math.min(1.0, totalScore + evidenceBoost);
    }

    totalScore = totalScore.clamp(0.0, 1.0);

    return ContextCandidate(
      contextId: node.id,
      contextName: node.name,
      contextType: node.type,
      contextPath: contextPath,
      pathNodes: pathNodeNames,
      relatedEntities: relatedEntities.toSet().toList(),
      relatedNoteIds: memoryIds,
      recentEvidence: recentEvidence,
      semanticSimilarity: semanticSimilarity,
      graphRelevance: graphRelevance,
      temporalRelevance: temporalRelevance,
      lexicalRelevance: lexicalRelevance,
      totalScore: totalScore,
      matchedSignals: matchedSignals,
    );
  }
}
