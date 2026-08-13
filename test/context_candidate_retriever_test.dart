import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:nenai/data/local/database/app_database.dart';
import 'package:nenai/data/repositories/context_repository_impl.dart';
import 'package:nenai/ai/memory/context_candidate_retriever.dart';
import 'package:nenai/domain/entities/context_node.dart';
import 'package:nenai/domain/ai/context_candidate.dart';
import 'package:nenai/domain/ai/note_analysis_result.dart';

void main() {
  late AppDatabase db;
  late ContextRepositoryImpl contextRepository;
  late ContextCandidateRetriever retriever;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    contextRepository = ContextRepositoryImpl(db);
    retriever = ContextCandidateRetriever(
      db: db,
      contextRepository: contextRepository,
    );
  });

  tearDown(() async {
    await db.close();
  });

  group('Phase 4: Context Candidate Retrieval Tests', () {
    test('1. Candidate retrieval and context path construction (ReadSmart AI vs FC)', () async {
      final now = DateTime.now();

      // Set up hierarchy:
      // Meeting with Dean -> Project Discussion -> ReadSmart AI -> Deployment
      // FC -> Deployment
      await contextRepository.upsertNode(ContextNode(
        id: 'ctx-dean',
        name: 'Meeting with Dean',
        type: ContextNodeType.episode,
        createdAt: now.subtract(const Duration(hours: 3)),
        updatedAt: now.subtract(const Duration(hours: 3)),
      ));
      await contextRepository.upsertNode(ContextNode(
        id: 'ctx-disc',
        name: 'Project Discussion',
        type: ContextNodeType.topic,
        createdAt: now.subtract(const Duration(hours: 3)),
        updatedAt: now.subtract(const Duration(hours: 3)),
      ));
      await contextRepository.upsertNode(ContextNode(
        id: 'ctx-readsmart',
        name: 'ReadSmart AI',
        type: ContextNodeType.project,
        createdAt: now.subtract(const Duration(hours: 2)),
        updatedAt: now.subtract(const Duration(hours: 1)),
      ));
      await contextRepository.upsertNode(ContextNode(
        id: 'ctx-readsmart-deploy',
        name: 'Deployment',
        type: ContextNodeType.activity,
        createdAt: now.subtract(const Duration(hours: 1)),
        updatedAt: now.subtract(const Duration(minutes: 30)),
      ));

      await contextRepository.upsertNode(ContextNode(
        id: 'ctx-fc',
        name: 'FC',
        type: ContextNodeType.project,
        createdAt: now.subtract(const Duration(days: 5)),
        updatedAt: now.subtract(const Duration(days: 5)),
      ));
      await contextRepository.upsertNode(ContextNode(
        id: 'ctx-fc-deploy',
        name: 'FC Deployment',
        type: ContextNodeType.activity,
        createdAt: now.subtract(const Duration(days: 5)),
        updatedAt: now.subtract(const Duration(days: 5)),
      ));

      // Hierarchy Edges
      await contextRepository.upsertEdge(ContextEdge(
        id: 'e1',
        sourceContextId: 'ctx-dean',
        targetContextId: 'ctx-disc',
        relationType: 'has_topic',
        createdAt: now,
        updatedAt: now,
      ));
      await contextRepository.upsertEdge(ContextEdge(
        id: 'e2',
        sourceContextId: 'ctx-disc',
        targetContextId: 'ctx-readsmart',
        relationType: 'project',
        createdAt: now,
        updatedAt: now,
      ));
      await contextRepository.upsertEdge(ContextEdge(
        id: 'e3',
        sourceContextId: 'ctx-readsmart',
        targetContextId: 'ctx-readsmart-deploy',
        relationType: 'activity',
        createdAt: now,
        updatedAt: now,
      ));
      await contextRepository.upsertEdge(ContextEdge(
        id: 'e4',
        sourceContextId: 'ctx-fc',
        targetContextId: 'ctx-fc-deploy',
        relationType: 'activity',
        createdAt: now,
        updatedAt: now,
      ));

      // Link a recent note to ReadSmart AI Deployment
      await contextRepository.linkMemory(MemoryContextLink(
        memoryId: 'note-rs-prev',
        contextId: 'ctx-readsmart-deploy',
        role: 'activity_log',
        createdAt: now.subtract(const Duration(minutes: 45)),
      ));

      // Incoming note with unresolved reference
      const noteText = 'I finished the deployment and now I want to test this.';
      const analysis = NoteAnalysisResult(
        topic: 'Deployment Testing',
        summary: noteText,
        topics: ['deployment', 'testing'],
        actions: [
          ContextualAction(type: 'completed', subject: 'deployment'),
          ContextualAction(type: 'planned', subject: 'testing'),
        ],
        references: [
          ContextualReference(text: 'this', type: 'anaphora', resolution: null),
        ],
      );

      final query = CandidateRetrievalQuery(
        noteText: noteText,
        analysisResult: analysis,
        noteTimestamp: now,
        topK: 5,
      );

      final candidates = await retriever.retrieveCandidates(query);

      expect(candidates.isNotEmpty, isTrue);

      // Verify ReadSmart AI Deployment is retrieved with full ancestral path
      final rsDeployCandidate = candidates.firstWhere((c) => c.contextId == 'ctx-readsmart-deploy');
      expect(rsDeployCandidate.contextName, 'Deployment');
      expect(
        rsDeployCandidate.contextPath,
        'Meeting with Dean └── Project Discussion └── ReadSmart AI └── Deployment',
      );

      // Verify FC Deployment is also retrieved in candidate pool
      final fcCandidate = candidates.firstWhere((c) => c.contextId == 'ctx-fc-deploy');
      expect(fcCandidate.contextPath, 'FC └── FC Deployment');
    });

    test('2. Deterministic ranking prioritizes recent active context over stale context', () async {
      final now = DateTime.now();

      // Recent Node
      await contextRepository.upsertNode(ContextNode(
        id: 'ctx-active-deploy',
        name: 'Deployment',
        type: ContextNodeType.activity,
        createdAt: now.subtract(const Duration(hours: 1)),
        updatedAt: now.subtract(const Duration(hours: 1)),
      ));

      // Stale Node (30 days ago)
      await contextRepository.upsertNode(ContextNode(
        id: 'ctx-stale-deploy',
        name: 'Deployment',
        type: ContextNodeType.activity,
        createdAt: now.subtract(const Duration(days: 30)),
        updatedAt: now.subtract(const Duration(days: 30)),
      ));

      final query = CandidateRetrievalQuery(
        noteText: 'Finished deployment steps.',
        analysisResult: const NoteAnalysisResult(
          topic: 'Deployment',
          summary: 'Finished deployment steps.',
          actions: [ContextualAction(type: 'completed', subject: 'deployment')],
        ),
        noteTimestamp: now,
        topK: 5,
      );

      final candidates = await retriever.retrieveCandidates(query);

      expect(candidates.length, 2);
      expect(candidates.first.contextId, 'ctx-active-deploy');
      expect(candidates.first.temporalRelevance, greaterThan(candidates[1].temporalRelevance));
      expect(candidates.first.totalScore, greaterThan(candidates[1].totalScore));
    });

    test('3. No candidate scenario returns empty list when DB has no matching contexts', () async {
      final query = CandidateRetrievalQuery(
        noteText: 'Apple pie baking recipe with cinnamon.',
        analysisResult: const NoteAnalysisResult(
          topic: 'Baking Recipe',
          summary: 'Apple pie baking recipe.',
          keywords: ['apple', 'pie', 'cinnamon'],
        ),
        noteTimestamp: DateTime.now(),
        topK: 5,
      );

      final candidates = await retriever.retrieveCandidates(query);
      expect(candidates, isEmpty);
    });

    test('4. Multiple candidate contexts retrieved for ambiguous queries', () async {
      final now = DateTime.now();

      // Two projects both having an "Architecture Review" activity
      await contextRepository.upsertNode(ContextNode(id: 'ctx-alpha', name: 'Project Alpha', createdAt: now, updatedAt: now));
      await contextRepository.upsertNode(ContextNode(id: 'ctx-alpha-arch', name: 'Architecture Review', createdAt: now, updatedAt: now));
      await contextRepository.upsertEdge(ContextEdge(id: 'ea', sourceContextId: 'ctx-alpha', targetContextId: 'ctx-alpha-arch', relationType: 'activity', createdAt: now, updatedAt: now));

      await contextRepository.upsertNode(ContextNode(id: 'ctx-beta', name: 'Project Beta', createdAt: now, updatedAt: now));
      await contextRepository.upsertNode(ContextNode(id: 'ctx-beta-arch', name: 'Architecture Review', createdAt: now, updatedAt: now));
      await contextRepository.upsertEdge(ContextEdge(id: 'eb', sourceContextId: 'ctx-beta', targetContextId: 'ctx-beta-arch', relationType: 'activity', createdAt: now, updatedAt: now));

      final query = CandidateRetrievalQuery(
        noteText: 'Conducted architecture review with tech leads.',
        analysisResult: const NoteAnalysisResult(
          topic: 'Architecture Review',
          summary: 'Conducted architecture review with tech leads.',
          topics: ['architecture review'],
          actions: [ContextualAction(type: 'completed', subject: 'architecture review')],
        ),
        noteTimestamp: now,
        topK: 5,
      );

      final candidates = await retriever.retrieveCandidates(query);

      // Both Alpha and Beta architecture reviews must be returned in the candidate pool
      final matchedIds = candidates.map((c) => c.contextId).toSet();
      expect(matchedIds, containsAll(['ctx-alpha-arch', 'ctx-beta-arch']));
    });
  });
}
