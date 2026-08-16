import 'package:get_it/get_it.dart';
import 'data/local/database/app_database.dart';
import 'data/local/vector/vector_store.dart';
import 'data/repositories/note_repository_impl.dart';
import 'domain/repositories/note_repository.dart';
import 'domain/repositories/context_repository.dart';
import 'data/repositories/context_repository_impl.dart';
import 'domain/repositories/evidence_repository.dart';
import 'data/repositories/evidence_repository_impl.dart';
import 'domain/repositories/resolution_repository.dart';
import 'data/repositories/resolution_repository_impl.dart';
import 'domain/ai/evidence_evaluator.dart';
import 'domain/ai/note_intelligence_engine.dart';
import 'domain/ai/embedding_engine.dart';
import 'ai/groq/groq_intelligence_engine.dart';
import 'ai/onnx/onnx_embedding_engine.dart';

import 'ai/agents/understanding_agent.dart';
import 'ai/agents/entity_resolver.dart';
import 'ai/agents/memory_reasoner.dart';
import 'ai/agents/memory_router.dart';
import 'ai/agents/query_understanding_agent.dart';
import 'ai/agents/context_resolution_agent.dart';
import 'ai/agents/memory_recall_agent.dart';
import 'ai/memory/memory_linker.dart';
import 'ai/memory/retrieval_planner.dart';
import 'ai/memory/memory_context_builder.dart';
import 'ai/memory/hybrid_retriever.dart';
import 'ai/memory/context_candidate_retriever.dart';
import 'ai/memory/reference_resolver.dart';
import 'ai/memory/context_evolution_engine.dart';
import 'ai/memory/context_timeline_service.dart';
import 'ai/memory/memory_correction_service.dart';
import 'ai/memory/relationship_evidence_builder.dart';
import 'ai/memory/temporal_memory_retriever.dart';
import 'ai/chat/chat_service.dart';

import 'background/note_processing_isolate.dart';
import 'background/clustering_manager.dart';
import 'ai/services/memory_capture_service.dart';
import 'ai/memory/kg_query_engine.dart';
import 'ai/services/minimal_memory_understanding_service.dart';

import 'domain/usecases/create_note.dart';
import 'domain/usecases/update_note.dart';
import 'domain/usecases/get_notes.dart';
import 'domain/usecases/search_notes.dart';
import 'domain/usecases/get_clusters.dart';
import 'domain/usecases/rename_cluster.dart';

import 'core/services/alarm_service.dart';
import 'core/services/calendar_service.dart';
import 'mcp/tool_registry.dart';
import 'mcp/tool_executor.dart';
import 'mcp/tools/memory_tools.dart';
import 'mcp/tools/alarm_tool.dart';
import 'mcp/tools/calendar_tool.dart';

final GetIt getIt = GetIt.instance;

Future<void> configureDependencies() async {
  if (getIt.isRegistered<AppDatabase>()) return;

  // Services
  final calendarService = CalendarService();
  getIt.registerSingleton<CalendarService>(calendarService);

  final alarmService = AlarmService();
  await alarmService.init();
  getIt.registerSingleton<AlarmService>(alarmService);

  // Database & Vector Store
  final db = AppDatabase();
  getIt.registerSingleton<AppDatabase>(db);

  final vectorStore = VectorStore(db);
  getIt.registerSingleton<VectorStore>(vectorStore);

  // Repository
  final repository = NoteRepositoryImpl(db, vectorStore);
  getIt.registerSingleton<NoteRepository>(repository);

  final contextRepository = ContextRepositoryImpl(db);
  getIt.registerSingleton<ContextRepository>(contextRepository);

  final evidenceRepository = EvidenceRepositoryImpl(db);
  getIt.registerSingleton<EvidenceRepository>(evidenceRepository);

  final resolutionRepository = ResolutionRepositoryImpl(
    db: db,
    contextRepository: contextRepository,
    evidenceRepository: evidenceRepository,
  );
  getIt.registerSingleton<ResolutionRepository>(resolutionRepository);

  const evidenceEvaluator = EvidenceEvaluator();
  getIt.registerSingleton<EvidenceEvaluator>(evidenceEvaluator);

  // AI Engine: Groq API for Fast Testing -> On-device / Offline fallback
  final groqEngine = GroqIntelligenceEngine();
  getIt.registerSingleton<NoteIntelligenceEngine>(groqEngine);

  final onnxEngine = OnnxEmbeddingEngine();
  await onnxEngine.init();
  getIt.registerSingleton<EmbeddingEngine>(onnxEngine);

  // Agents & Memory Engine Components
  final understandingAgent = UnderstandingAgent(getIt<NoteIntelligenceEngine>());
  getIt.registerSingleton<UnderstandingAgent>(understandingAgent);

  final entityResolver = EntityResolver(db.entities);
  getIt.registerSingleton<EntityResolver>(entityResolver);

  final memoryReasoner = MemoryReasoner(db.relationships);
  getIt.registerSingleton<MemoryReasoner>(memoryReasoner);

  final memoryRouter = MemoryRouter(
    db: db,
    contextRepository: contextRepository,
    evidenceRepository: evidenceRepository,
    resolutionRepository: resolutionRepository,
  );
  getIt.registerSingleton<MemoryRouter>(memoryRouter);

  final memoryLinker = MemoryLinker(
    repository: repository,
    vectorStore: vectorStore,
    embeddingEngine: onnxEngine,
  );
  getIt.registerSingleton<MemoryLinker>(memoryLinker);

  final clusteringManager = ClusteringManager(repository);
  getIt.registerSingleton<ClusteringManager>(clusteringManager);

  final retrievalPlanner = RetrievalPlanner(db.entities);
  getIt.registerSingleton<RetrievalPlanner>(retrievalPlanner);

  // Multi-Signal Context-Aware Hybrid Retriever
  final hybridRetriever = HybridRetriever(
    repository: repository,
    embeddingEngine: onnxEngine,
    entitiesDao: db.entities,
    relationshipsDao: db.relationships,
    retrievalPlanner: retrievalPlanner,
    contextRepository: contextRepository,
    tasksDao: db.tasks,
  );
  getIt.registerSingleton<HybridRetriever>(hybridRetriever);

  final contextBuilder = MemoryContextBuilder(
    entitiesDao: db.entities,
    relationshipsDao: db.relationships,
    tasksDao: db.tasks,
    contextRepository: contextRepository,
  );
  getIt.registerSingleton<MemoryContextBuilder>(contextBuilder);

  final queryAgent = QueryUnderstandingAgent(retrievalPlanner);
  getIt.registerSingleton<QueryUnderstandingAgent>(queryAgent);

  final contextCandidateRetriever = ContextCandidateRetriever(
    db: db,
    contextRepository: contextRepository,
  );
  getIt.registerSingleton<ContextCandidateRetriever>(contextCandidateRetriever);

  const contextResolutionAgent = ContextResolutionAgent();
  getIt.registerSingleton<ContextResolutionAgent>(contextResolutionAgent);

  final referenceResolver = ReferenceResolver(
    db: db,
    contextRepository: contextRepository,
  );
  getIt.registerSingleton<ReferenceResolver>(referenceResolver);

  final contextEvolutionEngine = ContextEvolutionEngine(
    contextRepository: contextRepository,
    evidenceRepository: evidenceRepository,
  );
  getIt.registerSingleton<ContextEvolutionEngine>(contextEvolutionEngine);

  final contextTimelineService = ContextTimelineService(
    db: db,
    contextRepository: contextRepository,
    hybridRetriever: hybridRetriever,
  );
  getIt.registerSingleton<ContextTimelineService>(contextTimelineService);

  final memoryCorrectionService = MemoryCorrectionService(
    db: db,
    contextRepository: contextRepository,
    evidenceRepository: evidenceRepository,
    contextEvolutionEngine: contextEvolutionEngine,
  );
  getIt.registerSingleton<MemoryCorrectionService>(memoryCorrectionService);

  // RelationshipEvidenceBuilder — builds entity evidence bundles before context scoring
  final relationshipEvidenceBuilder = RelationshipEvidenceBuilder(
    entitiesDao: db.entities,
    relationshipsDao: db.relationships,
  );
  getIt.registerSingleton<RelationshipEvidenceBuilder>(relationshipEvidenceBuilder);

  // TemporalMemoryRetriever — answers 'Summarize today' / 'This week' queries
  final temporalMemoryRetriever = TemporalMemoryRetriever(
    noteRepository: repository,
    contextRepository: contextRepository,
    tasksDao: db.tasks,
  );
  getIt.registerSingleton<TemporalMemoryRetriever>(temporalMemoryRetriever);

  // MCP Tool System
  final toolRegistry = ToolRegistry();
  toolRegistry.registerTool(SearchMemoriesTool(hybridRetriever));
  toolRegistry.registerTool(CreateMemoryTool(repository));
  toolRegistry.registerTool(GetMemoryStatsTool(repository));
  toolRegistry.registerTool(SetAlarmTool(alarmService));
  toolRegistry.registerTool(CreateCalendarEventTool(calendarService));
  toolRegistry.registerTool(GetCalendarEventsTool(calendarService));
  getIt.registerSingleton<ToolRegistry>(toolRegistry);

  final toolExecutor = ToolExecutor(toolRegistry);
  getIt.registerSingleton<ToolExecutor>(toolExecutor);

  // KG-First Query Engine
  final kgQueryEngine = KGQueryEngine(db: db);
  getIt.registerSingleton<KGQueryEngine>(kgQueryEngine);

  // Minimal Memory Understanding Service (Synchronous stages 1-6 for Chat formation)
  final minimalMemoryUnderstandingService = MinimalMemoryUnderstandingService(
    understandingAgent: understandingAgent,
    entityResolver: entityResolver,
    contextCandidateRetriever: contextCandidateRetriever,
    contextResolutionAgent: contextResolutionAgent,
    referenceResolver: referenceResolver,
    relationshipEvidenceBuilder: relationshipEvidenceBuilder,
  );
  getIt.registerSingleton<MinimalMemoryUnderstandingService>(minimalMemoryUnderstandingService);

  final memoryRecallAgent = MemoryRecallAgent(
    db: db,
    contextRepository: contextRepository,
    noteRepository: repository,
    hybridRetriever: hybridRetriever,
    contextBuilder: contextBuilder,
    contextTimelineService: contextTimelineService,
    referenceResolver: referenceResolver,
    entitiesDao: db.entities,
    relationshipsDao: db.relationships,
    tasksDao: db.tasks,
    temporalMemoryRetriever: temporalMemoryRetriever,
    kgQueryEngine: kgQueryEngine,
  );
  getIt.registerSingleton<MemoryRecallAgent>(memoryRecallAgent);

  // Chat Service
  getIt.registerSingleton<ChatService>(
    ChatService(
      hybridRetriever: hybridRetriever,
      contextBuilder: contextBuilder,
      queryAgent: queryAgent,
      toolRegistry: toolRegistry,
      toolExecutor: toolExecutor,
      intelligenceEngine: getIt<NoteIntelligenceEngine>(),
      recallAgent: memoryRecallAgent,
      kgQueryEngine: kgQueryEngine,
      minimalUnderstandingService: minimalMemoryUnderstandingService,
    ),
  );

  // Autonomous Memory Engine Pipeline (13-Stage Pipeline + RelationshipEvidenceBuilder)
  getIt.registerSingleton<NoteProcessingIsolate>(
    NoteProcessingIsolate(
      repository: repository,
      understandingAgent: understandingAgent,
      entityResolver: entityResolver,
      contextCandidateRetriever: contextCandidateRetriever,
      referenceResolver: referenceResolver,
      contextResolutionAgent: contextResolutionAgent,
      memoryReasoner: memoryReasoner,
      memoryRouter: memoryRouter,
      memoryLinker: memoryLinker,
      clusteringManager: clusteringManager,
      relationshipEvidenceBuilder: relationshipEvidenceBuilder,
    ),
  );

  // MemoryCaptureService — unified entry point for note + chat memory analysis
  // Registered as app-level singleton so its clarificationEvents stream lives beyond
  // screen lifecycle — ChatNotifier subscribes at construction time, not screen mount.
  getIt.registerSingleton<MemoryCaptureService>(
    MemoryCaptureService(
      noteProcessingIsolate: getIt<NoteProcessingIsolate>(),
      db: db,
    ),
  );

  // Use cases
  getIt.registerFactory(() => CreateNoteUseCase(getIt<NoteRepository>()));
  getIt.registerFactory(() => UpdateNoteUseCase(getIt<NoteRepository>()));
  getIt.registerFactory(() => GetNotesUseCase(getIt<NoteRepository>()));
  getIt.registerFactory(
    () => SearchNotesUseCase(getIt<NoteRepository>(), getIt<EmbeddingEngine>()),
  );
  getIt.registerFactory(() => GetClustersUseCase(getIt<NoteRepository>()));
  getIt.registerFactory(() => RenameClusterUseCase(getIt<NoteRepository>()));
}
