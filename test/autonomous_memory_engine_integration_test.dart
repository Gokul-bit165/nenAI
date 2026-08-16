import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:get_it/get_it.dart';
import 'package:nenai/data/local/database/app_database.dart';
import 'package:nenai/data/local/vector/vector_store.dart';
import 'package:nenai/data/repositories/context_repository_impl.dart';
import 'package:nenai/data/repositories/evidence_repository_impl.dart';
import 'package:nenai/data/repositories/note_repository_impl.dart';
import 'package:nenai/data/repositories/resolution_repository_impl.dart';
import 'package:nenai/domain/entities/note.dart';
import 'package:nenai/domain/entities/context_node.dart';
import 'package:nenai/domain/ai/embedding_engine.dart';
import 'package:nenai/domain/ai/note_intelligence_engine.dart';
import 'package:nenai/domain/ai/note_analysis_result.dart';
import 'package:nenai/ai/stub/stub_intelligence_engine.dart';
import 'package:nenai/ai/agents/understanding_agent.dart';
import 'package:nenai/ai/agents/entity_resolver.dart';
import 'package:nenai/ai/agents/context_resolution_agent.dart';
import 'package:nenai/ai/agents/memory_reasoner.dart';
import 'package:nenai/ai/agents/memory_router.dart';
import 'package:nenai/ai/agents/query_understanding_agent.dart';
import 'package:nenai/ai/agents/memory_recall_agent.dart';
import 'package:nenai/ai/memory/context_candidate_retriever.dart';
import 'package:nenai/ai/memory/reference_resolver.dart';
import 'package:nenai/ai/memory/memory_linker.dart';
import 'package:nenai/ai/memory/context_evolution_engine.dart';
import 'package:nenai/ai/memory/context_timeline_service.dart';
import 'package:nenai/ai/memory/hybrid_retriever.dart';
import 'package:nenai/ai/memory/memory_context_builder.dart';
import 'package:nenai/ai/memory/retrieval_planner.dart';
import 'package:nenai/ai/memory/memory_correction_service.dart';
import 'package:nenai/ai/memory/temporal_memory_retriever.dart';
import 'package:nenai/ai/chat/chat_service.dart';
import 'package:nenai/background/note_processing_isolate.dart';
import 'package:nenai/background/clustering_manager.dart';
import 'package:nenai/mcp/tool_registry.dart';
import 'package:nenai/mcp/tool_executor.dart';

class StubMockEmbeddingEngine implements EmbeddingEngine {
  @override
  bool get isReady => true;

  @override
  Future<List<double>?> embed(String text) async {
    return List<double>.filled(384, 0.1);
  }

  @override
  Future<void> dispose() async {}
}

class StubMockIntelligenceEngine implements NoteIntelligenceEngine {
  @override
  bool get isReady => true;

  @override
  void cancel() {}

  @override
  Future<String?> chat(String userMessage, {List<String>? contextMemories}) async {
    return 'Grounded response for: $userMessage';
  }

  @override
  Future<NoteAnalysisResult?> analyze(String content) async {
    return null;
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
  late EntityResolver entityResolver;
  late ContextCandidateRetriever candidateRetriever;
  late ReferenceResolver referenceResolver;
  late ContextResolutionAgent contextResolutionAgent;
  late MemoryReasoner memoryReasoner;
  late MemoryRouter memoryRouter;
  late ContextEvolutionEngine evolutionEngine;
  late HybridRetriever hybridRetriever;
  late MemoryContextBuilder contextBuilder;
  late ContextTimelineService timelineService;
  late MemoryRecallAgent recallAgent;
  late MemoryCorrectionService correctionService;
  late ChatService chatService;
  late NoteProcessingIsolate writePipeline;

  setUp(() async {
    await GetIt.I.reset();

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

    entityResolver = EntityResolver(db.entities);
    candidateRetriever = ContextCandidateRetriever(
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
    evolutionEngine = ContextEvolutionEngine(
      contextRepository: contextRepository,
      evidenceRepository: evidenceRepository,
    );

    final retrievalPlanner = RetrievalPlanner(db.entities);
    hybridRetriever = HybridRetriever(
      repository: noteRepository,
      embeddingEngine: StubMockEmbeddingEngine(),
      entitiesDao: db.entities,
      relationshipsDao: db.relationships,
      retrievalPlanner: retrievalPlanner,
      contextRepository: contextRepository,
    );

    contextBuilder = MemoryContextBuilder(
      entitiesDao: db.entities,
      relationshipsDao: db.relationships,
      tasksDao: db.tasks,
      contextRepository: contextRepository,
    );

    timelineService = ContextTimelineService(
      db: db,
      contextRepository: contextRepository,
      hybridRetriever: hybridRetriever,
    );

    recallAgent = MemoryRecallAgent(
      db: db,
      contextRepository: contextRepository,
      noteRepository: noteRepository,
      hybridRetriever: hybridRetriever,
      contextBuilder: contextBuilder,
      contextTimelineService: timelineService,
      referenceResolver: referenceResolver,
      entitiesDao: db.entities,
      relationshipsDao: db.relationships,
      tasksDao: db.tasks,
      temporalMemoryRetriever: TemporalMemoryRetriever(
        noteRepository: noteRepository,
        contextRepository: contextRepository,
        tasksDao: db.tasks,
      ),
    );

    correctionService = MemoryCorrectionService(
      db: db,
      contextRepository: contextRepository,
      evidenceRepository: evidenceRepository,
      contextEvolutionEngine: evolutionEngine,
    );

    final queryAgent = QueryUnderstandingAgent(retrievalPlanner);
    final toolRegistry = ToolRegistry();
    final toolExecutor = ToolExecutor(toolRegistry);

    chatService = ChatService(
      hybridRetriever: hybridRetriever,
      contextBuilder: contextBuilder,
      queryAgent: queryAgent,
      toolRegistry: toolRegistry,
      toolExecutor: toolExecutor,
      intelligenceEngine: StubMockIntelligenceEngine(),
      recallAgent: recallAgent,
    );

    final memoryLinker = MemoryLinker(
      repository: noteRepository,
      vectorStore: vectorStore,
      embeddingEngine: StubMockEmbeddingEngine(),
    );

    final clusteringManager = ClusteringManager(noteRepository);

    writePipeline = NoteProcessingIsolate(
      repository: noteRepository,
      understandingAgent: UnderstandingAgent(StubIntelligenceEngine()),
      entityResolver: entityResolver,
      contextCandidateRetriever: candidateRetriever,
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
    await GetIt.I.reset();
  });

  group('Phase 16: Final Autonomous Memory Engine Integration Tests', () {
    test('1. End-to-End Write Pipeline: Sequential 4-Note DAG formation and context evolution', () async {
      final t0 = DateTime(2026, 8, 10, 10, 0);
      final t1 = DateTime(2026, 8, 11, 14, 0);
      final t2 = DateTime(2026, 8, 12, 16, 0);
      final t3 = DateTime(2026, 8, 13, 11, 0);

      // Note 1: Dean meeting about ReadSmart AI and FC
      const n1Id = 'note-seq-1';
      await noteRepository.createNote(Note(
        id: n1Id,
        content: 'I had a meeting with Dean to discuss ReadSmart AI and FC projects.',
        createdAt: t0,
        updatedAt: t0,
      ));
      await writePipeline.processNote(n1Id);

      final nodesAfterN1 = await contextRepository.getAllNodes();
      expect(nodesAfterN1.any((n) => n.name.contains('ReadSmart') || n.name.contains('Dean')), isTrue);

      // Note 2: ReadSmart AI deployment completed
      const n2Id = 'note-seq-2';
      await noteRepository.createNote(Note(
        id: n2Id,
        content: 'ReadSmart AI deployment completed successfully on staging.',
        createdAt: t1,
        updatedAt: t1,
      ));
      await writePipeline.processNote(n2Id);

      // Note 3: Anaphora resolution "I want to test this"
      const n3Id = 'note-seq-3';
      await noteRepository.createNote(Note(
        id: n3Id,
        content: 'I finished the deployment and now I want to test this.',
        createdAt: t2,
        updatedAt: t2,
      ));
      await writePipeline.processNote(n3Id);

      // Note 4: Testing failure & task creation
      const n4Id = 'note-seq-4';
      await noteRepository.createNote(Note(
        id: n4Id,
        content: 'Testing failed because API returned 500 error. Need to fix auth endpoint by tomorrow.',
        createdAt: t3,
        updatedAt: t3,
      ));
      await writePipeline.processNote(n4Id);

      // Verify all notes stored and processed
      final allNotes = await noteRepository.getAllNotes();
      expect(allNotes.length, 4);

      // Verify tasks created
      final allTasks = await db.tasks.getAll();
      expect(allTasks.isNotEmpty, isTrue);

      // Verify entities in knowledge graph
      final allEntities = await db.entities.getAll();
      expect(allEntities.any((e) => e.name.toLowerCase() == 'dean'), isTrue);
    });

    test('2. End-to-End Recall Pipeline: FACT, TIMELINE, RELATION, TASK, and AMBIGUOUS Question handling', () async {
      final now = DateTime.now();

      // Seed ReadSmart AI context & notes
      await noteRepository.createNote(Note(
        id: 'n-rs-deploy',
        content: 'ReadSmart AI deployment completed on staging cluster.',
        summary: 'ReadSmart AI Deployment',
        createdAt: now,
        updatedAt: now,
      ));

      await db.entities.upsertEntity(EntitiesTableCompanion.insert(
        id: 'ent-arun',
        name: 'Arun',
        canonicalName: 'arun',
        type: 'person',
        createdAt: now.millisecondsSinceEpoch,
        updatedAt: now.millisecondsSinceEpoch,
      ));

      await db.entities.upsertEntity(EntitiesTableCompanion.insert(
        id: 'ent-grpc',
        name: 'gRPC streaming',
        canonicalName: 'grpc streaming',
        type: 'technology',
        createdAt: now.millisecondsSinceEpoch,
        updatedAt: now.millisecondsSinceEpoch,
      ));

      await db.relationships.upsertRelationship(RelationshipsTableCompanion.insert(
        id: 'rel-arun-grpc',
        sourceEntityId: 'ent-arun',
        targetEntityId: 'ent-grpc',
        relation: 'suggested',
        sourceMemoryId: 'n-rs-deploy',
        createdAt: now.millisecondsSinceEpoch,
        updatedAt: now.millisecondsSinceEpoch,
      ));

      await db.tasks.insertTask(TasksTableCompanion.insert(
        id: 'task-test-auth',
        memoryId: 'n-rs-deploy',
        description: 'Test auth endpoint with load generator',
        isCompleted: const Value(false),
        createdAt: now.millisecondsSinceEpoch,
        updatedAt: now.millisecondsSinceEpoch,
      ));

      // FACT Recall: "What did Arun suggest?"
      final factResp = await chatService.handleUserMessage('What did Arun suggest?');
      expect(factResp.replyText, contains('Arun --suggested--> gRPC streaming'));
      expect(factResp.sourceNoteIds.contains('n-rs-deploy'), isTrue);

      // TASK Recall: "What do I need to test?"
      final taskResp = await chatService.handleUserMessage('What do I need to test?');
      expect(taskResp.replyText, contains('Test auth endpoint with load generator'));

      // AMBIGUOUS Question: Multiple deployments
      await contextRepository.upsertNode(ContextNode(
        id: 'ctx-rs-deploy-test',
        name: 'ReadSmart AI Deployment',
        type: ContextNodeType.activity,
        createdAt: now,
        updatedAt: now,
      ));
      await contextRepository.upsertNode(ContextNode(
        id: 'ctx-fc-deploy-test',
        name: 'FC Deployment',
        type: ContextNodeType.activity,
        createdAt: now,
        updatedAt: now,
      ));

      await noteRepository.createNote(Note(
        id: 'n-fc-deploy',
        content: 'FC deployment completed yesterday.',
        summary: 'FC Deployment',
        createdAt: now,
        updatedAt: now,
      ));

      final ambigResp = await chatService.handleUserMessage('Which deployment did I finish?');
      expect(ambigResp.isClarification, isTrue);
      expect(ambigResp.candidateOptions.length, 2);
    });

    test('3. End-to-End User Correction Feedback Loop: Relocation, Provenance, and Deterministic Ranking Bias', () async {
      final now = DateTime.now();

      // Seed context nodes
      await contextRepository.upsertNode(ContextNode(
        id: 'ctx-fc-final',
        name: 'FC',
        type: ContextNodeType.project,
        createdAt: now,
        updatedAt: now,
      ));
      await contextRepository.upsertNode(ContextNode(
        id: 'ctx-rs-final',
        name: 'ReadSmart AI',
        type: ContextNodeType.project,
        createdAt: now,
        updatedAt: now,
      ));

      const noteId = 'note-move-final';
      const noteContent = 'Deployed new backend services';
      await noteRepository.createNote(Note(
        id: noteId,
        content: noteContent,
        createdAt: now,
        updatedAt: now,
      ));
      await contextRepository.linkMemory(MemoryContextLink(
        memoryId: noteId,
        contextId: 'ctx-fc-final',
        role: 'inferred',
        confidence: 0.60,
        createdAt: now,
      ));

      // User performs manual correction
      final moveResult = await correctionService.moveMemoryContext(
        memoryId: noteId,
        fromContextId: 'ctx-fc-final',
        toContextId: 'ctx-rs-final',
        reason: 'User relocated deployed services to ReadSmart AI',
      );

      expect(moveResult.success, isTrue);

      // Verify audit provenance preserved
      final evidenceList = await evidenceRepository.getByMemoryId(noteId);
      expect(evidenceList.any((e) => e.relationType == 'user_relocated'), isTrue);

      // Verify learned preference returns ReadSmart AI for similar query
      final preferred = await correctionService.getLearnedContextPreference(
        'Deployed new backend services',
      );
      expect(preferred, 'ctx-rs-final');
    });
  });
}
