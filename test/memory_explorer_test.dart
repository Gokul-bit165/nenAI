import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/native.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:get_it/get_it.dart';
import 'package:nenai/data/local/database/app_database.dart';
import 'package:nenai/data/local/vector/vector_store.dart';
import 'package:nenai/data/repositories/context_repository_impl.dart';
import 'package:nenai/data/repositories/note_repository_impl.dart';
import 'package:nenai/domain/repositories/context_repository.dart';
import 'package:nenai/domain/repositories/note_repository.dart';
import 'package:nenai/domain/entities/context_node.dart';
import 'package:nenai/domain/entities/note.dart';
import 'package:nenai/domain/ai/embedding_engine.dart';
import 'package:nenai/ai/memory/retrieval_planner.dart';
import 'package:nenai/ai/memory/hybrid_retriever.dart';
import 'package:nenai/ai/memory/context_timeline_service.dart';
import 'package:nenai/presentation/screens/explorer/memory_explorer_screen.dart';

class MockStubEmbeddingEngine implements EmbeddingEngine {
  @override
  bool get isReady => true;

  @override
  Future<List<double>?> embed(String text) async {
    return List<double>.filled(384, 0.1);
  }

  @override
  Future<void> dispose() async {}
}

void main() {
  late AppDatabase db;
  late VectorStore vectorStore;
  late NoteRepositoryImpl noteRepository;
  late ContextRepositoryImpl contextRepository;
  late HybridRetriever hybridRetriever;
  late ContextTimelineService timelineService;

  setUp(() async {
    await GetIt.I.reset();

    db = AppDatabase.forTesting(NativeDatabase.memory());
    vectorStore = VectorStore(db);
    noteRepository = NoteRepositoryImpl(db, vectorStore);
    contextRepository = ContextRepositoryImpl(db);

    final retrievalPlanner = RetrievalPlanner(db.entities);
    hybridRetriever = HybridRetriever(
      repository: noteRepository,
      embeddingEngine: MockStubEmbeddingEngine(),
      entitiesDao: db.entities,
      relationshipsDao: db.relationships,
      retrievalPlanner: retrievalPlanner,
      contextRepository: contextRepository,
    );

    timelineService = ContextTimelineService(
      db: db,
      contextRepository: contextRepository,
      hybridRetriever: hybridRetriever,
    );

    GetIt.I.registerSingleton<AppDatabase>(db);
    GetIt.I.registerSingleton<NoteRepository>(noteRepository);
    GetIt.I.registerSingleton<ContextRepository>(contextRepository);
    GetIt.I.registerSingleton<ContextTimelineService>(timelineService);
  });

  tearDown(() async {
    await db.close();
    await GetIt.I.reset();
  });

  group('Phase 14: Memory Explorer Tests', () {
    testWidgets('1. Renders Project, Meeting, and People categories in Hierarchy View', (tester) async {
      final now = DateTime.now();

      // Insert Project Contexts
      await contextRepository.upsertNode(ContextNode(
        id: 'ctx-rs',
        name: 'ReadSmart AI',
        type: ContextNodeType.project,
        createdAt: now,
        updatedAt: now,
      ));
      await contextRepository.upsertNode(ContextNode(
        id: 'ctx-fc',
        name: 'FC',
        type: ContextNodeType.project,
        createdAt: now,
        updatedAt: now,
      ));

      // Insert Meeting Context
      await contextRepository.upsertNode(ContextNode(
        id: 'ctx-dean',
        name: 'Dean Meeting',
        type: ContextNodeType.episode,
        createdAt: now,
        updatedAt: now,
      ));

      // Insert Person Entity
      await db.entities.upsertEntity(EntitiesTableCompanion.insert(
        id: 'ent-dean-exp',
        name: 'Dean',
        canonicalName: 'dean',
        type: 'person',
        createdAt: now.millisecondsSinceEpoch,
        updatedAt: now.millisecondsSinceEpoch,
      ));

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: MemoryExplorerScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify Categories
      expect(find.text('Memory Explorer'), findsOneWidget);
      expect(find.text('PROJECTS'), findsOneWidget);
      expect(find.text('MEETINGS & EPISODES'), findsOneWidget);
      expect(find.text('PEOPLE & ENTITIES'), findsOneWidget);

      // Verify Nodes
      expect(find.text('ReadSmart AI'), findsWidgets);
      expect(find.text('FC'), findsOneWidget);
      expect(find.text('Dean Meeting'), findsOneWidget);
      expect(find.text('Dean'), findsOneWidget);
    });

    testWidgets('2. Drill-down into context displays breadcrumb path, related notes, and tasks', (tester) async {
      final now = DateTime.now();

      // ReadSmart AI └── Deployment
      await contextRepository.upsertNode(ContextNode(
        id: 'ctx-rs-d',
        name: 'ReadSmart AI',
        type: ContextNodeType.project,
        createdAt: now,
        updatedAt: now,
      ));
      await contextRepository.upsertNode(ContextNode(
        id: 'ctx-deploy-d',
        name: 'Deployment',
        type: ContextNodeType.activity,
        createdAt: now,
        updatedAt: now,
      ));
      await contextRepository.upsertEdge(ContextEdge(
        id: 'e-rs-deploy-d',
        sourceContextId: 'ctx-rs-d',
        targetContextId: 'ctx-deploy-d',
        relationType: 'activity',
        createdAt: now,
        updatedAt: now,
      ));

      // Note linked to Deployment
      const noteId = 'note-deploy-exp';
      await noteRepository.createNote(
        Note(
          id: noteId,
          content: 'Deployment completed on staging cluster.',
          summary: 'Deployment Completed',
          createdAt: now,
          updatedAt: now,
        ),
      );
      await contextRepository.linkMemory(MemoryContextLink(
        memoryId: noteId,
        contextId: 'ctx-deploy-d',
        createdAt: now,
      ));

      // Task linked to note
      await db.tasks.insertTask(TasksTableCompanion.insert(
        id: 'task-smoke-test',
        memoryId: noteId,
        description: 'Run smoke test on staging',
        isCompleted: const Value(false),
        createdAt: now.millisecondsSinceEpoch,
        updatedAt: now.millisecondsSinceEpoch,
      ));

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: MemoryExplorerScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Select ReadSmart AI
      await tester.tap(find.text('ReadSmart AI').first);
      await tester.pumpAndSettle();

      // Verify Breadcrumb Path contains ReadSmart AI
      expect(find.text('ReadSmart AI'), findsWidgets);

      // Verify Sub-Activities chip for Deployment exists
      expect(find.text('Deployment'), findsWidgets);

      // Verify Related Note & Task are in widget tree
      expect(find.text('RELATED MEMORIES (1)'), findsOneWidget);
      expect(find.text('Deployment completed on staging cluster.'), findsWidgets);
      expect(find.text('Run smoke test on staging'), findsOneWidget);
    });

    testWidgets('3. Tab switching between Hierarchy, Graph View, and Timeline', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: MemoryExplorerScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap Graph View Tab (using pump with duration for infinite animations)
      await tester.tap(find.text('Graph View'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(Tab), findsNWidgets(3));

      // Tap Timeline Tab
      await tester.tap(find.text('Timeline'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(Tab), findsNWidgets(3));
    });
  });
}
