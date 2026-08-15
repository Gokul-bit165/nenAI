import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:nenai/data/local/database/app_database.dart';
import 'package:nenai/data/local/vector/vector_store.dart';
import 'package:nenai/data/repositories/context_repository_impl.dart';
import 'package:nenai/data/repositories/evidence_repository_impl.dart';
import 'package:nenai/data/repositories/note_repository_impl.dart';
import 'package:nenai/data/repositories/resolution_repository_impl.dart';
import 'package:nenai/domain/entities/context_node.dart';
import 'package:nenai/domain/entities/note.dart';
import 'package:nenai/domain/ai/embedding_engine.dart';
import 'package:nenai/ai/agents/understanding_agent.dart';
import 'package:nenai/ai/agents/entity_resolver.dart';
import 'package:nenai/ai/agents/context_resolution_agent.dart';
import 'package:nenai/ai/agents/memory_reasoner.dart';
import 'package:nenai/ai/agents/memory_router.dart';
import 'package:nenai/ai/memory/context_candidate_retriever.dart';
import 'package:nenai/ai/memory/reference_resolver.dart';
import 'package:nenai/ai/memory/context_evolution_engine.dart';
import 'package:nenai/ai/memory/memory_linker.dart';
import 'package:nenai/background/clustering_manager.dart';
import 'package:nenai/background/note_processing_isolate.dart';
import 'package:nenai/ai/stub/stub_intelligence_engine.dart';

class MockStubEmbeddingEngine implements EmbeddingEngine {
  @override
  bool get isReady => true;

  @override
  Future<List<double>?> embed(String text) async {
    return List<double>.filled(384, 0.15);
  }

  @override
  Future<void> dispose() async {}
}

void main() {
  late AppDatabase db;
  late VectorStore vectorStore;
  late NoteRepositoryImpl noteRepository;
  late ContextRepositoryImpl contextRepository;
  late EvidenceRepositoryImpl evidenceRepository;
  late ResolutionRepositoryImpl resolutionRepository;
  late UnderstandingAgent understandingAgent;
  late EntityResolver entityResolver;
  late ContextCandidateRetriever contextCandidateRetriever;
  late ReferenceResolver referenceResolver;
  late ContextResolutionAgent contextResolutionAgent;
  late MemoryReasoner memoryReasoner;
  late MemoryRouter memoryRouter;
  late MemoryLinker memoryLinker;
  late ClusteringManager clusteringManager;
  late ContextEvolutionEngine contextEvolutionEngine;
  late NoteProcessingIsolate pipeline;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    vectorStore = VectorStore(db);
    noteRepository = NoteRepositoryImpl(db, vectorStore);
    contextRepository = ContextRepositoryImpl(db);
    evidenceRepository = EvidenceRepositoryImpl(db);
    resolutionRepository = ResolutionRepositoryImpl(
      db: db,
      contextRepository: contextRepository,
      evidenceRepository: evidenceRepository,
    );

    understandingAgent = UnderstandingAgent(StubIntelligenceEngine());
    entityResolver = EntityResolver(db.entities);
    contextCandidateRetriever = ContextCandidateRetriever(
      db: db,
      contextRepository: contextRepository,
    );
    referenceResolver = ReferenceResolver(
      db: db,
      contextRepository: contextRepository,
    );
    contextResolutionAgent = const ContextResolutionAgent();
    memoryReasoner = MemoryReasoner(db.relationships);
    memoryRouter = MemoryRouter(
      db: db,
      contextRepository: contextRepository,
      evidenceRepository: evidenceRepository,
      resolutionRepository: resolutionRepository,
    );
    memoryLinker = MemoryLinker(
      repository: noteRepository,
      vectorStore: vectorStore,
      embeddingEngine: MockStubEmbeddingEngine(),
    );
    clusteringManager = ClusteringManager(noteRepository);

    contextEvolutionEngine = ContextEvolutionEngine(
      contextRepository: contextRepository,
      evidenceRepository: evidenceRepository,
    );

    pipeline = NoteProcessingIsolate(
      repository: noteRepository,
      understandingAgent: understandingAgent,
      entityResolver: entityResolver,
      contextCandidateRetriever: contextCandidateRetriever,
      referenceResolver: referenceResolver,
      contextResolutionAgent: contextResolutionAgent,
      memoryReasoner: memoryReasoner,
      memoryRouter: memoryRouter,
      memoryLinker: memoryLinker,
      clusteringManager: clusteringManager,
    );
  });

  tearDown(() async {
    await db.close();
  });

  group('Phase 9: Dynamic Memory Evolution Tests', () {
    test('1. Sequential 4-Note Deep Context Evolution (Dean Meeting -> ReadSmart AI -> Deployment -> Testing -> API failure)', () async {
      final now = DateTime.now();

      // ── Step 1: Note 1 - "Dean meeting about ReadSmart AI and FC."
      const note1Id = 'note-seq-1';
      const note1Text = 'Dean meeting about ReadSmart AI and FC.';
      await noteRepository.createNote(
        Note(
          id: note1Id,
          content: note1Text,
          createdAt: now.subtract(const Duration(hours: 4)),
          updatedAt: now.subtract(const Duration(hours: 4)),
        ),
      );

      // Create root meeting context & children
      await contextRepository.upsertNode(ContextNode(
        id: 'ctx-dean-seq',
        name: 'Dean Meeting',
        type: ContextNodeType.episode,
        originatingMemoryId: note1Id,
        createdAt: now.subtract(const Duration(hours: 4)),
        updatedAt: now.subtract(const Duration(hours: 4)),
      ));
      await contextRepository.upsertNode(ContextNode(
        id: 'ctx-rs-seq',
        name: 'ReadSmart AI',
        type: ContextNodeType.project,
        originatingMemoryId: note1Id,
        createdAt: now.subtract(const Duration(hours: 4)),
        updatedAt: now.subtract(const Duration(hours: 4)),
      ));
      await contextRepository.upsertNode(ContextNode(
        id: 'ctx-fc-seq',
        name: 'FC',
        type: ContextNodeType.project,
        originatingMemoryId: note1Id,
        createdAt: now.subtract(const Duration(hours: 4)),
        updatedAt: now.subtract(const Duration(hours: 4)),
      ));
      await contextRepository.upsertEdge(ContextEdge(
        id: 'e-dean-rs',
        sourceContextId: 'ctx-dean-seq',
        targetContextId: 'ctx-rs-seq',
        relationType: 'project',
        createdAt: now.subtract(const Duration(hours: 4)),
        updatedAt: now.subtract(const Duration(hours: 4)),
      ));
      await contextRepository.upsertEdge(ContextEdge(
        id: 'e-dean-fc',
        sourceContextId: 'ctx-dean-seq',
        targetContextId: 'ctx-fc-seq',
        relationType: 'project',
        createdAt: now.subtract(const Duration(hours: 4)),
        updatedAt: now.subtract(const Duration(hours: 4)),
      ));
      await contextRepository.linkMemory(MemoryContextLink(
        memoryId: note1Id,
        contextId: 'ctx-dean-seq',
        createdAt: now.subtract(const Duration(hours: 4)),
      ));
      await contextRepository.linkMemory(MemoryContextLink(
        memoryId: note1Id,
        contextId: 'ctx-rs-seq',
        createdAt: now.subtract(const Duration(hours: 4)),
      ));

      // ── Step 2: Note 2 - "ReadSmart AI deployment completed."
      const note2Id = 'note-seq-2';
      const note2Text = 'ReadSmart AI deployment completed.';
      await noteRepository.createNote(
        Note(
          id: note2Id,
          content: note2Text,
          createdAt: now.subtract(const Duration(hours: 3)),
          updatedAt: now.subtract(const Duration(hours: 3)),
        ),
      );
      await pipeline.processNote(note2Id);

      // Verify Deployment activity context exists under ReadSmart AI
      final rsChildEdges = await contextRepository.getChildEdges('ctx-rs-seq');
      expect(rsChildEdges.any((e) => e.relationType == 'activity'), isTrue);

      final deployEdge = rsChildEdges.firstWhere((e) => e.relationType == 'activity');
      final deployNode = await contextRepository.getNodeById(deployEdge.targetContextId);
      expect(deployNode, isNotNull);
      expect(deployNode!.name, 'Deployment');

      // ── Step 3: Note 3 - "I want to test this."
      const note3Id = 'note-seq-3';
      const note3Text = 'I finished the deployment and now I want to test this.';
      await noteRepository.createNote(
        Note(
          id: note3Id,
          content: note3Text,
          createdAt: now.subtract(const Duration(hours: 2)),
          updatedAt: now.subtract(const Duration(hours: 2)),
        ),
      );
      await pipeline.processNote(note3Id);

      // Verify Testing activity context exists under Deployment
      final deployChildEdges = await contextRepository.getChildEdges(deployNode.id);
      expect(deployChildEdges.any((e) => e.relationType == 'activity'), isTrue);

      final testEdge = deployChildEdges.firstWhere((e) => e.relationType == 'activity');
      final testNode = await contextRepository.getNodeById(testEdge.targetContextId);
      expect(testNode, isNotNull);
      expect(testNode!.name, 'Testing');

      // ── Step 4: Note 4 - "Testing failed because API returned 500."
      const note4Id = 'note-seq-4';
      const note4Text = 'Testing failed because API returned 500 error.';
      await noteRepository.createNote(
        Note(
          id: note4Id,
          content: note4Text,
          createdAt: now.subtract(const Duration(hours: 1)),
          updatedAt: now.subtract(const Duration(hours: 1)),
        ),
      );
      await pipeline.processNote(note4Id);

      // Verify API failure issue context exists under Testing
      final testChildEdges = await contextRepository.getChildEdges(testNode.id);
      expect(testChildEdges.any((e) => e.relationType == 'issue_investigation'), isTrue);

      final issueEdge = testChildEdges.firstWhere((e) => e.relationType == 'issue_investigation');
      final issueNode = await contextRepository.getNodeById(issueEdge.targetContextId);
      expect(issueNode, isNotNull);
      expect(issueNode!.name, 'API failure');

      // ── Verify Ancestral Provenance Path (Deep DAG) ────────────
      final issueAncestors = await contextRepository.getAncestors(issueNode.id);
      final ancestorNames = issueAncestors.map((a) => a.name).toList();

      expect(ancestorNames, containsAll(['Testing', 'Deployment', 'ReadSmart AI', 'Dean Meeting']));
    });

    test('2. Context Merging preserves all historical note links, edges, and provenance', () async {
      final now = DateTime.now();

      // Node A: "RS Project" with note-A
      await contextRepository.upsertNode(ContextNode(
        id: 'ctx-rs-alias',
        name: 'RS Project',
        type: ContextNodeType.project,
        createdAt: now.subtract(const Duration(days: 5)),
        updatedAt: now.subtract(const Duration(days: 5)),
      ));
      await contextRepository.linkMemory(MemoryContextLink(
        memoryId: 'note-historical-a',
        contextId: 'ctx-rs-alias',
        createdAt: now.subtract(const Duration(days: 5)),
      ));

      // Node B: "ReadSmart AI" with note-B
      await contextRepository.upsertNode(ContextNode(
        id: 'ctx-rs-canonical',
        name: 'ReadSmart AI',
        type: ContextNodeType.project,
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ));
      await contextRepository.linkMemory(MemoryContextLink(
        memoryId: 'note-historical-b',
        contextId: 'ctx-rs-canonical',
        createdAt: now.subtract(const Duration(days: 1)),
      ));

      // Child edge under RS Project
      await contextRepository.upsertEdge(ContextEdge(
        id: 'edge-sub',
        sourceContextId: 'ctx-rs-alias',
        targetContextId: 'ctx-staging-task',
        relationType: 'activity',
        createdAt: now.subtract(const Duration(days: 5)),
        updatedAt: now.subtract(const Duration(days: 5)),
      ));

      // Execute Merge: RS Project -> ReadSmart AI
      await contextEvolutionEngine.mergeContexts(
        sourceContextId: 'ctx-rs-alias',
        targetContextId: 'ctx-rs-canonical',
      );

      // Verify source node is removed
      final oldNode = await contextRepository.getNodeById('ctx-rs-alias');
      expect(oldNode, isNull);

      // Verify all historical memories now link to canonical ReadSmart AI
      final canonicalMemories = await contextRepository.getMemoriesForContext('ctx-rs-canonical');
      expect(canonicalMemories, containsAll(['note-historical-a', 'note-historical-b']));

      // Verify child edge was reparented to canonical ReadSmart AI
      final canonicalChildren = await contextRepository.getChildEdges('ctx-rs-canonical');
      expect(canonicalChildren.any((e) => e.targetContextId == 'ctx-staging-task'), isTrue);

      // Verify evidence provenance audit trail was recorded
      final evidenceList = await evidenceRepository.getByContextId('ctx-rs-canonical');
      expect(evidenceList.any((e) => e.relationType == 'merged_context'), isTrue);
    });

    test('3. Context Splitting spawns dedicated child sub-nodes and preserves parent', () async {
      final now = DateTime.now();

      await contextRepository.upsertNode(ContextNode(
        id: 'ctx-general-eng',
        name: 'Engineering Work',
        type: ContextNodeType.topic,
        createdAt: now,
        updatedAt: now,
      ));

      final splitChildren = await contextEvolutionEngine.splitContext(
        contextId: 'ctx-general-eng',
        newChildNames: ['Frontend Development', 'Backend Optimization'],
        childType: 'activity',
      );

      expect(splitChildren.length, 2);
      expect(splitChildren.map((c) => c.name), containsAll(['Frontend Development', 'Backend Optimization']));

      final childEdges = await contextRepository.getChildEdges('ctx-general-eng');
      expect(childEdges.length, 2);
      expect(childEdges.every((e) => e.relationType == 'split_child'), isTrue);
    });

    test('4. Stale context reactivation updates timestamps without data loss', () async {
      final oldDate = DateTime.now().subtract(const Duration(days: 45));

      await contextRepository.upsertNode(ContextNode(
        id: 'ctx-dormant',
        name: 'Dormant Project',
        type: ContextNodeType.project,
        createdAt: oldDate,
        updatedAt: oldDate,
      ));

      await contextEvolutionEngine.reactivateContextIfStale(contextId: 'ctx-dormant');

      final updatedNode = await contextRepository.getNodeById('ctx-dormant');
      expect(updatedNode, isNotNull);
      expect(updatedNode!.updatedAt.isAfter(oldDate), isTrue);
    });
  });
}
