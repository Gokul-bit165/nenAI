import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:nenai/data/local/database/app_database.dart';
import 'package:nenai/data/local/vector/vector_store.dart';
import 'package:nenai/data/repositories/context_repository_impl.dart';
import 'package:nenai/data/repositories/note_repository_impl.dart';
import 'package:nenai/domain/entities/context_node.dart';
import 'package:nenai/domain/entities/context_timeline.dart';
import 'package:nenai/domain/ai/embedding_engine.dart';
import 'package:nenai/ai/memory/retrieval_planner.dart';
import 'package:nenai/ai/memory/hybrid_retriever.dart';
import 'package:nenai/ai/memory/context_timeline_service.dart';

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

  setUp(() {
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
    );

    timelineService = ContextTimelineService(
      db: db,
      contextRepository: contextRepository,
      hybridRetriever: hybridRetriever,
    );
  });

  tearDown(() async {
    await db.close();
  });

  group('Phase 10: Context Timeline Tests', () {
    test('1. Generates complete chronological context timeline for ReadSmart AI', () async {
      final aug10 = DateTime(2026, 8, 10, 10, 0);
      final aug11 = DateTime(2026, 8, 11, 14, 30);
      final aug12 = DateTime(2026, 8, 12, 16, 0);
      final aug13 = DateTime(2026, 8, 13, 9, 15);

      // Create ReadSmart AI Context
      await contextRepository.upsertNode(ContextNode(
        id: 'ctx-rs',
        name: 'ReadSmart AI',
        type: ContextNodeType.project,
        createdAt: aug10,
        updatedAt: aug13,
      ));

      // Aug 10: Project Discussion Note
      await db.notes.insertNote(NotesTableCompanion.insert(
        id: 'note-aug10',
        content: 'Project discussion on ReadSmart AI architecture.',
        summary: const Value('Project discussion'),
        createdAt: aug10.millisecondsSinceEpoch,
        updatedAt: aug10.millisecondsSinceEpoch,
      ));
      await contextRepository.linkMemory(MemoryContextLink(
        memoryId: 'note-aug10',
        contextId: 'ctx-rs',
        createdAt: aug10,
      ));

      // Aug 11: Development Note & Task
      await db.notes.insertNote(NotesTableCompanion.insert(
        id: 'note-aug11',
        content: 'Core pipeline development.',
        summary: const Value('Development'),
        createdAt: aug11.millisecondsSinceEpoch,
        updatedAt: aug11.millisecondsSinceEpoch,
      ));
      await db.tasks.insertTask(TasksTableCompanion.insert(
        id: 'task-aug11',
        memoryId: 'note-aug11',
        description: 'Complete ONNX integration',
        isCompleted: const Value(true),
        createdAt: aug11.millisecondsSinceEpoch,
        updatedAt: aug11.millisecondsSinceEpoch,
      ));
      await contextRepository.linkMemory(MemoryContextLink(
        memoryId: 'note-aug11',
        contextId: 'ctx-rs',
        createdAt: aug11,
      ));

      // Aug 12: Deployment Completed Note
      await db.notes.insertNote(NotesTableCompanion.insert(
        id: 'note-aug12',
        content: 'ReadSmart AI deployment completed successfully.',
        summary: const Value('Deployment completed'),
        createdAt: aug12.millisecondsSinceEpoch,
        updatedAt: aug12.millisecondsSinceEpoch,
      ));
      await contextRepository.linkMemory(MemoryContextLink(
        memoryId: 'note-aug12',
        contextId: 'ctx-rs',
        createdAt: aug12,
      ));

      // Aug 13: Testing Planned Note & Pending Task
      await db.notes.insertNote(NotesTableCompanion.insert(
        id: 'note-aug13',
        content: 'Testing planned for mobile release.',
        summary: const Value('Testing planned'),
        createdAt: aug13.millisecondsSinceEpoch,
        updatedAt: aug13.millisecondsSinceEpoch,
      ));
      await db.tasks.insertTask(TasksTableCompanion.insert(
        id: 'task-aug13',
        memoryId: 'note-aug13',
        description: 'Run integration test suite',
        isCompleted: const Value(false),
        createdAt: aug13.millisecondsSinceEpoch,
        updatedAt: aug13.millisecondsSinceEpoch,
      ));
      await contextRepository.linkMemory(MemoryContextLink(
        memoryId: 'note-aug13',
        contextId: 'ctx-rs',
        createdAt: aug13,
      ));

      // Fetch Timeline
      final timeline = await timelineService.getContextTimeline('ctx-rs');

      expect(timeline.contextName, 'ReadSmart AI');
      expect(timeline.items.isNotEmpty, isTrue);
      expect(timeline.pendingTasksCount, 1);
      expect(timeline.completedTasksCount, 1);

      // Verify ASCII Tree output contains all dates
      final treeString = timeline.toTreeString();
      expect(treeString, contains('ReadSmart AI'));
      expect(treeString, contains('Aug 10'));
      expect(treeString, contains('Aug 11'));
      expect(treeString, contains('Aug 12'));
      expect(treeString, contains('Aug 13'));
      expect(treeString, contains('Deployment completed'));
    });

    test('2. "What happened with ReadSmart AI?" retrieves complete context timeline', () async {
      final now = DateTime.now();

      await contextRepository.upsertNode(ContextNode(
        id: 'ctx-rs-2',
        name: 'ReadSmart AI',
        type: ContextNodeType.project,
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now,
      ));

      await db.notes.insertNote(NotesTableCompanion.insert(
        id: 'note-q1',
        content: 'ReadSmart AI version 1.0 launched.',
        summary: const Value('V1.0 Launched'),
        createdAt: now.subtract(const Duration(days: 1)).millisecondsSinceEpoch,
        updatedAt: now.subtract(const Duration(days: 1)).millisecondsSinceEpoch,
      ));
      await contextRepository.linkMemory(MemoryContextLink(
        memoryId: 'note-q1',
        contextId: 'ctx-rs-2',
        createdAt: now.subtract(const Duration(days: 1)),
      ));

      final result = await timelineService.queryTimeline('What happened with ReadSmart AI?');
      expect(result.contextName, 'ReadSmart AI');
      expect(result.items.any((i) => i.title.contains('V1.0 Launched')), isTrue);
    });

    test('3. "What did I do yesterday?" returns time-bounded daily interval', () async {
      final now = DateTime.now();
      final yesterdayNoon = DateTime(now.year, now.month, now.day - 1, 12, 0);

      // Note yesterday
      await db.notes.insertNote(NotesTableCompanion.insert(
        id: 'note-yest',
        content: 'Implemented local SQLite vector search yesterday.',
        summary: const Value('SQLite Vector Search'),
        createdAt: yesterdayNoon.millisecondsSinceEpoch,
        updatedAt: yesterdayNoon.millisecondsSinceEpoch,
      ));

      // Note 5 days ago (should not appear)
      await db.notes.insertNote(NotesTableCompanion.insert(
        id: 'note-old',
        content: 'Old design meeting.',
        createdAt: now.subtract(const Duration(days: 5)).millisecondsSinceEpoch,
        updatedAt: now.subtract(const Duration(days: 5)).millisecondsSinceEpoch,
      ));

      final result = await timelineService.queryTimeline('What did I do yesterday?');
      expect(result.items.length, 1);
      expect(result.items.first.title, 'SQLite Vector Search');
    });

    test('4. "What happened after deployment?" returns forward post-event slice', () async {
      final base = DateTime(2026, 8, 12, 10, 0);

      // Milestone: Deployment
      await db.notes.insertNote(NotesTableCompanion.insert(
        id: 'note-deploy-m',
        content: 'Deployment finished at 10 AM.',
        createdAt: base.millisecondsSinceEpoch,
        updatedAt: base.millisecondsSinceEpoch,
      ));

      // After Deployment: Load testing
      await db.notes.insertNote(NotesTableCompanion.insert(
        id: 'note-post-deploy',
        content: 'Ran load testing on production cluster.',
        summary: const Value('Production Load Testing'),
        createdAt: base.add(const Duration(hours: 4)).millisecondsSinceEpoch,
        updatedAt: base.add(const Duration(hours: 4)).millisecondsSinceEpoch,
      ));

      final result = await timelineService.queryTimeline('What happened after deployment?');
      expect(result.items.length, 1);
      expect(result.items.first.title, 'Production Load Testing');
    });

    test('5. "What is pending?" returns active uncompleted tasks across contexts', () async {
      final now = DateTime.now();

      await db.tasks.insertTask(TasksTableCompanion.insert(
        id: 'task-pend-1',
        memoryId: 'note-p1',
        description: 'Verify SSL certificate renewal',
        isCompleted: const Value(false),
        dueDate: const Value('tomorrow'),
        createdAt: now.millisecondsSinceEpoch,
        updatedAt: now.millisecondsSinceEpoch,
      ));

      await db.tasks.insertTask(TasksTableCompanion.insert(
        id: 'task-done-1',
        memoryId: 'note-p2',
        description: 'Write unit tests for router',
        isCompleted: const Value(true),
        createdAt: now.millisecondsSinceEpoch,
        updatedAt: now.millisecondsSinceEpoch,
      ));

      final result = await timelineService.queryTimeline('What is pending?');
      expect(result.items.length, 1);
      expect(result.items.first.title, 'Verify SSL certificate renewal');
      expect(result.items.first.type, TimelineItemType.task);
    });

    test('6. "What was discussed with Dean?" returns entity-centric timeline', () async {
      final now = DateTime.now();

      // Entity Dean
      await db.entities.upsertEntity(EntitiesTableCompanion.insert(
        id: 'ent-dean-q',
        name: 'Dean',
        canonicalName: 'dean',
        type: 'person',
        createdAt: now.millisecondsSinceEpoch,
        updatedAt: now.millisecondsSinceEpoch,
      ));

      // Note with Dean
      await db.notes.insertNote(NotesTableCompanion.insert(
        id: 'note-dean-q',
        content: 'Dean agreed with our multi-signal memory architecture.',
        summary: const Value('Dean Architecture Agreement'),
        createdAt: now.millisecondsSinceEpoch,
        updatedAt: now.millisecondsSinceEpoch,
      ));
      await db.entities.linkEntityToMemory('note-dean-q', 'ent-dean-q');

      final result = await timelineService.queryTimeline('What was discussed with Dean?');
      expect(result.items.isNotEmpty, isTrue);
      expect(result.items.first.title, 'Dean Architecture Agreement');
    });
  });
}
