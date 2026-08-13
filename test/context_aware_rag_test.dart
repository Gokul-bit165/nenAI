import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:nenai/data/local/database/app_database.dart';
import 'package:nenai/data/local/vector/vector_store.dart';
import 'package:nenai/data/repositories/context_repository_impl.dart';
import 'package:nenai/data/repositories/note_repository_impl.dart';
import 'package:nenai/domain/entities/context_node.dart';
import 'package:nenai/domain/entities/note.dart';
import 'package:nenai/domain/ai/embedding_engine.dart';
import 'package:nenai/ai/memory/retrieval_planner.dart';
import 'package:nenai/ai/memory/hybrid_retriever.dart';
import 'package:nenai/ai/memory/memory_context_builder.dart';

class MockStubEmbeddingEngine implements EmbeddingEngine {
  @override
  bool get isReady => true;

  @override
  Future<List<double>?> embed(String text) async {
    final lower = text.toLowerCase();
    if (lower.contains('readsmart')) {
      return List<double>.filled(384, 0.9);
    }
    if (lower.contains('fc')) {
      return List<double>.filled(384, 0.2);
    }
    return List<double>.filled(384, 0.5);
  }

  @override
  Future<void> dispose() async {}
}

void main() {
  late AppDatabase db;
  late VectorStore vectorStore;
  late NoteRepositoryImpl noteRepository;
  late ContextRepositoryImpl contextRepository;
  late RetrievalPlanner retrievalPlanner;
  late HybridRetriever hybridRetriever;
  late MemoryContextBuilder contextBuilder;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    vectorStore = VectorStore(db);
    noteRepository = NoteRepositoryImpl(db, vectorStore);
    contextRepository = ContextRepositoryImpl(db);
    retrievalPlanner = RetrievalPlanner(db.entities);

    hybridRetriever = HybridRetriever(
      repository: noteRepository,
      embeddingEngine: MockStubEmbeddingEngine(),
      entitiesDao: db.entities,
      relationshipsDao: db.relationships,
      retrievalPlanner: retrievalPlanner,
      contextRepository: contextRepository,
      tasksDao: db.tasks,
    );

    contextBuilder = MemoryContextBuilder(
      entitiesDao: db.entities,
      relationshipsDao: db.relationships,
      tasksDao: db.tasks,
      contextRepository: contextRepository,
    );
  });

  tearDown(() async {
    await db.close();
  });

  group('Phase 11: Context-Aware RAG Tests', () {
    test('1. "What happened with the ReadSmart AI deployment?" retrieves ReadSmart AI notes and excludes FC notes', () async {
      final now = DateTime.now();

      // ── Create Context Tree 1: ReadSmart AI └── Deployment
      await contextRepository.upsertNode(ContextNode(
        id: 'ctx-rs',
        name: 'ReadSmart AI',
        type: ContextNodeType.project,
        createdAt: now.subtract(const Duration(days: 3)),
        updatedAt: now.subtract(const Duration(days: 3)),
      ));
      await contextRepository.upsertNode(ContextNode(
        id: 'ctx-rs-deploy',
        name: 'Deployment',
        type: ContextNodeType.activity,
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now.subtract(const Duration(hours: 1)),
      ));
      await contextRepository.upsertEdge(ContextEdge(
        id: 'edge-rs-deploy',
        sourceContextId: 'ctx-rs',
        targetContextId: 'ctx-rs-deploy',
        relationType: 'activity',
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now.subtract(const Duration(days: 2)),
      ));

      // ── Create Context Tree 2: FC └── Deployment
      await contextRepository.upsertNode(ContextNode(
        id: 'ctx-fc',
        name: 'FC',
        type: ContextNodeType.project,
        createdAt: now.subtract(const Duration(days: 3)),
        updatedAt: now.subtract(const Duration(days: 3)),
      ));
      await contextRepository.upsertNode(ContextNode(
        id: 'ctx-fc-deploy',
        name: 'Deployment',
        type: ContextNodeType.activity,
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now.subtract(const Duration(hours: 1)),
      ));
      await contextRepository.upsertEdge(ContextEdge(
        id: 'edge-fc-deploy',
        sourceContextId: 'ctx-fc',
        targetContextId: 'ctx-fc-deploy',
        relationType: 'activity',
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now.subtract(const Duration(days: 2)),
      ));

      // Note 1: ReadSmart AI deployment discussion
      const note1Id = 'note-rs-1';
      await noteRepository.createNote(
        Note(
          id: note1Id,
          content: 'ReadSmart AI deployment discussion with Dean.',
          summary: 'Deployment discussion',
          createdAt: now.subtract(const Duration(days: 2)),
          updatedAt: now.subtract(const Duration(days: 2)),
        ),
      );
      await contextRepository.linkMemory(MemoryContextLink(
        memoryId: note1Id,
        contextId: 'ctx-rs-deploy',
        createdAt: now.subtract(const Duration(days: 2)),
      ));

      // Note 2: ReadSmart AI deployment completed
      const note2Id = 'note-rs-2';
      await noteRepository.createNote(
        Note(
          id: note2Id,
          content: 'ReadSmart AI deployment completed successfully on staging.',
          summary: 'Deployment completed',
          createdAt: now.subtract(const Duration(days: 1)),
          updatedAt: now.subtract(const Duration(days: 1)),
        ),
      );
      await contextRepository.linkMemory(MemoryContextLink(
        memoryId: note2Id,
        contextId: 'ctx-rs-deploy',
        createdAt: now.subtract(const Duration(days: 1)),
      ));

      // Note 3: Testing planned
      const note3Id = 'note-rs-3';
      await noteRepository.createNote(
        Note(
          id: note3Id,
          content: 'Testing planned for the ReadSmart AI deployment.',
          summary: 'Testing planned',
          createdAt: now.subtract(const Duration(hours: 4)),
          updatedAt: now.subtract(const Duration(hours: 4)),
        ),
      );
      await contextRepository.linkMemory(MemoryContextLink(
        memoryId: note3Id,
        contextId: 'ctx-rs-deploy',
        createdAt: now.subtract(const Duration(hours: 4)),
      ));

      // Note 4: Unrelated FC deployment note (Contains keyword "deployment")
      const note4Id = 'note-fc-1';
      await noteRepository.createNote(
        Note(
          id: note4Id,
          content: 'FC deployment completed today by the infrastructure team.',
          summary: 'FC Deployment',
          createdAt: now.subtract(const Duration(hours: 2)),
          updatedAt: now.subtract(const Duration(hours: 2)),
        ),
      );
      await contextRepository.linkMemory(MemoryContextLink(
        memoryId: note4Id,
        contextId: 'ctx-fc-deploy',
        createdAt: now.subtract(const Duration(hours: 2)),
      ));

      // ── Execute Context-Aware RAG Query ───────────────────────────────────
      final results = await hybridRetriever.retrieve(
        'What happened with the ReadSmart AI deployment?',
        limit: 3,
      );

      expect(results.length, 3);

      final retrievedIds = results.map((r) => r.note.id).toList();

      // Verified: ReadSmart AI notes retrieved
      expect(retrievedIds, containsAll([note1Id, note2Id, note3Id]));

      // Crucial: FC note must NOT be in top results
      expect(retrievedIds, isNot(contains(note4Id)));

      // Context hierarchy metadata preserved
      expect(results.first.contextPath, 'ReadSmart AI └── Deployment');
      expect(results.first.sourceNoteIds, contains(results.first.note.id));
    });

    test('2. MemoryContextBuilder constructs grounded prompt with context hierarchy, facts, and task provenance', () async {
      final now = DateTime.now();

      const noteId = 'note-grounding-1';
      final note = Note(
        id: noteId,
        content: 'Dean approved the ReadSmart AI production rollout.',
        summary: 'Dean approved rollout',
        createdAt: now,
        updatedAt: now,
      );

      // Create Entity Dean
      await db.entities.upsertEntity(EntitiesTableCompanion.insert(
        id: 'ent-dean-g',
        name: 'Dean',
        canonicalName: 'dean',
        type: 'person',
        createdAt: now.millisecondsSinceEpoch,
        updatedAt: now.millisecondsSinceEpoch,
      ));
      await db.entities.linkEntityToMemory(noteId, 'ent-dean-g');

      // Create Entity ReadSmart AI
      await db.entities.upsertEntity(EntitiesTableCompanion.insert(
        id: 'ent-rs-g',
        name: 'ReadSmart AI',
        canonicalName: 'readsmart ai',
        type: 'project',
        createdAt: now.millisecondsSinceEpoch,
        updatedAt: now.millisecondsSinceEpoch,
      ));
      await db.entities.linkEntityToMemory(noteId, 'ent-rs-g');

      // Create Relationship
      await db.relationships.upsertRelationship(RelationshipsTableCompanion.insert(
        id: 'rel-g-1',
        sourceEntityId: 'ent-dean-g',
        relation: 'approved',
        targetEntityId: 'ent-rs-g',
        sourceMemoryId: noteId,
        createdAt: now.millisecondsSinceEpoch,
        updatedAt: now.millisecondsSinceEpoch,
      ));

      // Create Task
      await db.tasks.insertTask(TasksTableCompanion.insert(
        id: 'task-g-1',
        memoryId: noteId,
        description: 'Execute production rollout',
        isCompleted: const Value(false),
        dueDate: const Value('tomorrow'),
        createdAt: now.millisecondsSinceEpoch,
        updatedAt: now.millisecondsSinceEpoch,
      ));

      final searchResults = [
        HybridSearchResult(
          note: note,
          rrfScore: 0.95,
          contextPath: 'ReadSmart AI └── Deployment',
          contextName: 'ReadSmart AI',
          sourceNoteIds: [noteId],
        ),
      ];

      final groundedContext = await contextBuilder.buildContext(searchResults);

      // Assertions on Grounded Context
      expect(groundedContext.contextString, contains('=== CONTEXT HIERARCHY ==='));
      expect(groundedContext.contextString, contains('Path: ReadSmart AI └── Deployment'));
      expect(groundedContext.contextString, contains('Dean (person)'));
      expect(groundedContext.contextString, contains('Dean --approved--> ReadSmart AI [Source Note: note-grounding-1]'));
      expect(groundedContext.contextString, contains('Execute production rollout [Pending] (Due: tomorrow, Source Note: note-grounding-1)'));
      expect(groundedContext.sourceNoteIds, contains(noteId));
      expect(groundedContext.tasks.length, 1);
    });
  });
}
