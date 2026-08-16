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
import 'package:nenai/ai/memory/context_timeline_service.dart';
import 'package:nenai/ai/memory/reference_resolver.dart';
import 'package:nenai/ai/memory/temporal_memory_retriever.dart';
import 'package:nenai/ai/agents/memory_recall_agent.dart';
import 'package:nenai/ai/agents/query_understanding_agent.dart';
import 'package:nenai/ai/chat/chat_service.dart';
import 'package:nenai/ai/stub/stub_intelligence_engine.dart';
import 'package:nenai/mcp/tool_registry.dart';
import 'package:nenai/mcp/tool_executor.dart';

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
  late RetrievalPlanner retrievalPlanner;
  late HybridRetriever hybridRetriever;
  late MemoryContextBuilder contextBuilder;
  late ContextTimelineService contextTimelineService;
  late ReferenceResolver referenceResolver;
  late MemoryRecallAgent recallAgent;
  late ChatService chatService;

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

    contextTimelineService = ContextTimelineService(
      db: db,
      contextRepository: contextRepository,
      hybridRetriever: hybridRetriever,
    );

    referenceResolver = ReferenceResolver(
      db: db,
      contextRepository: contextRepository,
    );

    recallAgent = MemoryRecallAgent(
      db: db,
      contextRepository: contextRepository,
      noteRepository: noteRepository,
      hybridRetriever: hybridRetriever,
      contextBuilder: contextBuilder,
      contextTimelineService: contextTimelineService,
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

    final toolRegistry = ToolRegistry();
    final toolExecutor = ToolExecutor(toolRegistry);

    chatService = ChatService(
      hybridRetriever: hybridRetriever,
      contextBuilder: contextBuilder,
      queryAgent: QueryUnderstandingAgent(retrievalPlanner),
      toolRegistry: toolRegistry,
      toolExecutor: toolExecutor,
      intelligenceEngine: StubIntelligenceEngine(),
      recallAgent: recallAgent,
    );
  });

  tearDown(() async {
    await db.close();
  });

  group('Phase 12: Autonomous Memory Recall Agent Tests', () {
    test('1. FACT: "What did Arun suggest?" returns grounded knowledge graph facts with source note IDs', () async {
      final now = DateTime.now();
      const noteId = 'note-arun-1';

      // Insert Note
      await noteRepository.createNote(
        Note(
          id: noteId,
          content: 'Arun suggested using ONNX Runtime for mobile local inference.',
          summary: 'Arun suggested ONNX Runtime',
          createdAt: now,
          updatedAt: now,
        ),
      );

      // Insert Entities
      await db.entities.upsertEntity(EntitiesTableCompanion.insert(
        id: 'ent-arun',
        name: 'Arun',
        canonicalName: 'arun',
        type: 'person',
        createdAt: now.millisecondsSinceEpoch,
        updatedAt: now.millisecondsSinceEpoch,
      ));
      await db.entities.upsertEntity(EntitiesTableCompanion.insert(
        id: 'ent-onnx',
        name: 'ONNX Runtime',
        canonicalName: 'onnx runtime',
        type: 'technology',
        createdAt: now.millisecondsSinceEpoch,
        updatedAt: now.millisecondsSinceEpoch,
      ));
      await db.entities.linkEntityToMemory(noteId, 'ent-arun');
      await db.entities.linkEntityToMemory(noteId, 'ent-onnx');

      // Insert Relationship Triple
      await db.relationships.upsertRelationship(RelationshipsTableCompanion.insert(
        id: 'rel-arun-1',
        sourceEntityId: 'ent-arun',
        relation: 'suggested',
        targetEntityId: 'ent-onnx',
        sourceMemoryId: noteId,
        createdAt: now.millisecondsSinceEpoch,
        updatedAt: now.millisecondsSinceEpoch,
      ));

      final response = await chatService.handleUserMessage('What did Arun suggest?');

      expect(response.replyText, contains('Arun'));
      expect(response.replyText, contains('ONNX Runtime'));
      expect(response.replyText, contains('note-arun-1'));
      expect(response.sourceNoteIds, contains(noteId));
    });

    test('2. TIMELINE: "What happened with ReadSmart AI?" returns chronologically ordered context timeline', () async {
      final now = DateTime.now();

      await contextRepository.upsertNode(ContextNode(
        id: 'ctx-rs',
        name: 'ReadSmart AI',
        type: ContextNodeType.project,
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now,
      ));

      const note1Id = 'note-rs-t1';
      await noteRepository.createNote(
        Note(
          id: note1Id,
          content: 'ReadSmart AI initial kickoff meeting.',
          summary: 'Kickoff meeting',
          createdAt: now.subtract(const Duration(days: 2)),
          updatedAt: now.subtract(const Duration(days: 2)),
        ),
      );
      await contextRepository.linkMemory(MemoryContextLink(
        memoryId: note1Id,
        contextId: 'ctx-rs',
        createdAt: now.subtract(const Duration(days: 2)),
      ));

      const note2Id = 'note-rs-t2';
      await noteRepository.createNote(
        Note(
          id: note2Id,
          content: 'ReadSmart AI deployment finished.',
          summary: 'Deployment finished',
          createdAt: now.subtract(const Duration(days: 1)),
          updatedAt: now.subtract(const Duration(days: 1)),
        ),
      );
      await contextRepository.linkMemory(MemoryContextLink(
        memoryId: note2Id,
        contextId: 'ctx-rs',
        createdAt: now.subtract(const Duration(days: 1)),
      ));

      final response = await chatService.handleUserMessage('What happened with ReadSmart AI?');

      expect(response.questionType, RecallQuestionType.timeline);
      expect(response.replyText, contains('Timeline for **ReadSmart AI**'));
      expect(response.replyText, contains('Kickoff meeting'));
      expect(response.replyText, contains('Deployment finished'));
    });

    test('3. RELATION: "How is the Dean meeting related to ReadSmart?" returns DAG hierarchy relationship', () async {
      final now = DateTime.now();

      await contextRepository.upsertNode(ContextNode(
        id: 'ctx-dean',
        name: 'Dean Meeting',
        type: ContextNodeType.episode,
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ));
      await contextRepository.upsertNode(ContextNode(
        id: 'ctx-rs',
        name: 'ReadSmart AI',
        type: ContextNodeType.project,
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ));
      await contextRepository.upsertEdge(ContextEdge(
        id: 'e-dean-rs',
        sourceContextId: 'ctx-dean',
        targetContextId: 'ctx-rs',
        relationType: 'project',
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ));

      final response = await chatService.handleUserMessage('How is the Dean meeting related to ReadSmart?');

      expect(response.questionType, RecallQuestionType.relation);
      expect(response.replyText, contains('Dean Meeting'));
      expect(response.replyText, contains('ReadSmart AI'));
      expect(response.replyText, contains('project'));
      expect(response.contextPath, 'Dean Meeting └── ReadSmart AI');
    });

    test('4. TASK: "What do I need to test?" retrieves active pending test tasks', () async {
      final now = DateTime.now();
      const noteId = 'note-test-task';

      await noteRepository.createNote(
        Note(
          id: noteId,
          content: 'We must test the ONNX embedding pipeline on iOS.',
          createdAt: now,
          updatedAt: now,
        ),
      );

      await db.tasks.insertTask(TasksTableCompanion.insert(
        id: 'task-onnx-test',
        memoryId: noteId,
        description: 'Test ONNX embedding pipeline on iOS',
        isCompleted: const Value(false),
        dueDate: const Value('tomorrow'),
        createdAt: now.millisecondsSinceEpoch,
        updatedAt: now.millisecondsSinceEpoch,
      ));

      final response = await chatService.handleUserMessage('What do I need to test?');

      expect(response.questionType, RecallQuestionType.task);
      expect(response.replyText, contains('Test ONNX embedding pipeline on iOS'));
      expect(response.replyText, contains('note-test-task'));
      expect(response.sourceNoteIds, contains(noteId));
    });

    test('5. CONTEXT: "What are my current projects?" lists active project context nodes', () async {
      final now = DateTime.now();

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

      final response = await chatService.handleUserMessage('What are my current projects?');

      expect(response.questionType, RecallQuestionType.context);
      expect(response.replyText, contains('ReadSmart AI'));
      expect(response.replyText, contains('FC'));
    });

    test('6. FOLLOW-UP: "What happened after deployment?" returns milestone-relative forward timeline', () async {
      final now = DateTime.now();
      final base = now.subtract(const Duration(hours: 5));

      // Milestone: Deployment
      await noteRepository.createNote(
        Note(
          id: 'note-deploy-base',
          content: 'Deployment finished at 10 AM.',
          createdAt: base,
          updatedAt: base,
        ),
      );

      // Post-Deployment Note
      await noteRepository.createNote(
        Note(
          id: 'note-post-deploy',
          content: 'Mobile beta testing initiated after deployment.',
          summary: 'Mobile beta testing',
          createdAt: base.add(const Duration(hours: 2)),
          updatedAt: base.add(const Duration(hours: 2)),
        ),
      );

      final response = await chatService.handleUserMessage('What happened after deployment?');

      expect(response.questionType, RecallQuestionType.followUp);
      expect(response.replyText, contains('Mobile beta testing'));
    });

    test('7. AMBIGUOUS: "Which deployment did I finish?" triggers clarification dialogue without guessing', () async {
      final now = DateTime.now();

      // ReadSmart AI └── Deployment
      await contextRepository.upsertNode(ContextNode(
        id: 'ctx-rs',
        name: 'ReadSmart AI',
        type: ContextNodeType.project,
        createdAt: now,
        updatedAt: now,
      ));
      await contextRepository.upsertNode(ContextNode(
        id: 'ctx-rs-deploy',
        name: 'Deployment',
        type: ContextNodeType.activity,
        createdAt: now,
        updatedAt: now,
      ));
      await contextRepository.upsertEdge(ContextEdge(
        id: 'e-rs-d',
        sourceContextId: 'ctx-rs',
        targetContextId: 'ctx-rs-deploy',
        relationType: 'activity',
        createdAt: now,
        updatedAt: now,
      ));

      // FC └── Deployment
      await contextRepository.upsertNode(ContextNode(
        id: 'ctx-fc',
        name: 'FC',
        type: ContextNodeType.project,
        createdAt: now,
        updatedAt: now,
      ));
      await contextRepository.upsertNode(ContextNode(
        id: 'ctx-fc-deploy',
        name: 'Deployment',
        type: ContextNodeType.activity,
        createdAt: now,
        updatedAt: now,
      ));
      await contextRepository.upsertEdge(ContextEdge(
        id: 'e-fc-d',
        sourceContextId: 'ctx-fc',
        targetContextId: 'ctx-fc-deploy',
        relationType: 'activity',
        createdAt: now,
        updatedAt: now,
      ));

      final response = await chatService.handleUserMessage('Which deployment did I finish?');

      expect(response.questionType, RecallQuestionType.ambiguous);
      expect(response.isClarification, isTrue);
      expect(response.candidateOptions.length, 2);
      expect(response.replyText, contains('I found multiple possible deployment contexts'));
      expect(response.replyText, contains('ReadSmart AI'));
      expect(response.replyText, contains('FC'));
      expect(response.replyText, contains('Which one do you mean?'));
    });
  });
}
