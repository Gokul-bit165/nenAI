import 'package:get_it/get_it.dart';
import 'data/local/database/app_database.dart';
import 'data/local/vector/vector_store.dart';
import 'data/repositories/note_repository_impl.dart';
import 'domain/repositories/note_repository.dart';
import 'domain/ai/note_intelligence_engine.dart';
import 'domain/ai/embedding_engine.dart';
import 'ai/litert/flutter_gemma_intelligence_engine.dart';
import 'ai/onnx/onnx_embedding_engine.dart';
import 'ai/stub/stub_intelligence_engine.dart';

import 'ai/agents/understanding_agent.dart';
import 'ai/agents/entity_resolver.dart';
import 'ai/agents/memory_reasoner.dart';
import 'ai/agents/memory_router.dart';
import 'ai/agents/query_understanding_agent.dart';
import 'ai/memory/memory_linker.dart';
import 'ai/memory/retrieval_planner.dart';
import 'ai/memory/memory_context_builder.dart';
import 'ai/memory/hybrid_retriever.dart';
import 'ai/chat/chat_service.dart';

import 'background/note_processing_isolate.dart';
import 'background/clustering_manager.dart';

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

  // AI Engine: Local Gemma 3 1B on-device -> Offline Extractive Engine fallback
  final gemmaEngine = FlutterGemmaIntelligenceEngine();
  await gemmaEngine.init();
  if (gemmaEngine.isReady) {
    getIt.registerSingleton<NoteIntelligenceEngine>(gemmaEngine);
  } else {
    getIt.registerSingleton<NoteIntelligenceEngine>(StubIntelligenceEngine());
  }

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

  final memoryRouter = MemoryRouter(db);
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

  final contextBuilder = MemoryContextBuilder(
    entitiesDao: db.entities,
    relationshipsDao: db.relationships,
    tasksDao: db.tasks,
  );
  getIt.registerSingleton<MemoryContextBuilder>(contextBuilder);

  final queryAgent = QueryUnderstandingAgent(retrievalPlanner);
  getIt.registerSingleton<QueryUnderstandingAgent>(queryAgent);

  // 3-Way Hybrid Retriever
  final hybridRetriever = HybridRetriever(
    repository: repository,
    embeddingEngine: onnxEngine,
    entitiesDao: db.entities,
    relationshipsDao: db.relationships,
    retrievalPlanner: retrievalPlanner,
  );
  getIt.registerSingleton<HybridRetriever>(hybridRetriever);

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

  // Chat Service
  getIt.registerSingleton<ChatService>(
    ChatService(
      hybridRetriever: hybridRetriever,
      contextBuilder: contextBuilder,
      queryAgent: queryAgent,
      toolRegistry: toolRegistry,
      toolExecutor: toolExecutor,
      intelligenceEngine: getIt<NoteIntelligenceEngine>(),
    ),
  );

  // Background Isolate Processor (V2 Write Flow)
  getIt.registerSingleton<NoteProcessingIsolate>(
    NoteProcessingIsolate(
      repository: repository,
      understandingAgent: understandingAgent,
      entityResolver: entityResolver,
      memoryReasoner: memoryReasoner,
      memoryRouter: memoryRouter,
      memoryLinker: memoryLinker,
      clusteringManager: clusteringManager,
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
