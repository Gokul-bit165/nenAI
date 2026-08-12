import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:nenai/data/local/database/app_database.dart';
import 'package:nenai/domain/ai/note_analysis_result.dart';
import 'package:nenai/domain/entities/memory_operation.dart';
import 'package:nenai/ai/agents/entity_resolver.dart';
import 'package:nenai/ai/agents/memory_reasoner.dart';
import 'package:nenai/ai/agents/memory_router.dart';
import 'package:nenai/ai/memory/retrieval_planner.dart';
import 'package:nenai/ai/memory/memory_context_builder.dart';
import 'package:nenai/ai/memory/hybrid_retriever.dart';
import 'package:nenai/data/repositories/note_repository_impl.dart';
import 'package:nenai/data/local/vector/vector_store.dart';
import 'package:nenai/domain/ai/embedding_engine.dart';
import 'package:nenai/domain/entities/note.dart';

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
  late EntityResolver entityResolver;
  late MemoryReasoner memoryReasoner;
  late MemoryRouter memoryRouter;
  late NoteRepositoryImpl repository;
  late VectorStore vectorStore;
  late RetrievalPlanner retrievalPlanner;
  late MemoryContextBuilder contextBuilder;
  late HybridRetriever hybridRetriever;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    entityResolver = EntityResolver(db.entities);
    memoryReasoner = MemoryReasoner(db.relationships);
    memoryRouter = MemoryRouter(db);
    vectorStore = VectorStore(db);
    repository = NoteRepositoryImpl(db, vectorStore);
    retrievalPlanner = RetrievalPlanner(db.entities);
    contextBuilder = MemoryContextBuilder(
      entitiesDao: db.entities,
      relationshipsDao: db.relationships,
      tasksDao: db.tasks,
    );
    hybridRetriever = HybridRetriever(
      repository: repository,
      embeddingEngine: MockStubEmbeddingEngine(),
      entitiesDao: db.entities,
      relationshipsDao: db.relationships,
      retrievalPlanner: retrievalPlanner,
    );
  });

  tearDown(() async {
    await db.close();
  });

  test('Canonical Milestone Test: Note Ingestion, Deduplication, and Grounded Recall', () async {
    // ── STEP 1: Process Note 1 ───────────────────────────────────────────────
    const note1Id = 'note-1';
    const note1Content =
        'Today I met Arun. He suggested trying Gemma 3 1B for NENAI. I should test it tomorrow.';

    // Insert raw note into SQLite
    await repository.createNote(
      Note(
        id: note1Id,
        content: note1Content,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );

    // Mock Understanding Agent output for Note 1
    const analysis1 = NoteAnalysisResult(
      topic: 'NENAI Architecture',
      summary: 'Discussed NENAI with Arun, who suggested testing Gemma 3 1B tomorrow.',
      keywords: ['Arun', 'NENAI', 'Gemma 3 1B', 'testing'],
      entities: [
        ExtractedEntityMention(name: 'Arun', type: 'person'),
        ExtractedEntityMention(name: 'NENAI', type: 'project'),
        ExtractedEntityMention(name: 'Gemma 3 1B', type: 'technology'),
      ],
      facts: [
        ExtractedFactTriple(
          subject: 'Arun',
          predicate: 'suggested',
          object: 'Gemma 3 1B',
        ),
      ],
      tasks: [
        ExtractedTaskItem(
          description: 'Test Gemma 3 1B',
          time: 'tomorrow',
        ),
      ],
    );

    // Entity Resolution for Note 1
    final resolved1 = await entityResolver.resolveAll(analysis1.entities);
    expect(resolved1.length, 3);
    expect(resolved1[0].name, 'Arun');
    expect(resolved1[0].status, ResolutionStatus.create);

    final arunEntityId = resolved1[0].entityId;

    // Memory Reasoner for Note 1
    final ops1 = await memoryReasoner.reason(
      noteId: note1Id,
      analysis: analysis1,
      resolvedEntities: resolved1,
    );

    // Verify operations contain entity creation, relationship creation, and task creation
    expect(ops1.any((op) => op.type == OperationType.createEntity && op.payload['name'] == 'Arun'), isTrue);
    expect(ops1.any((op) => op.type == OperationType.createRelationship && op.payload['relation'] == 'suggested'), isTrue);
    expect(ops1.any((op) => op.type == OperationType.createTask && op.payload['description'] == 'Test Gemma 3 1B'), isTrue);

    // Memory Router executes transactional writes to SQLite
    await memoryRouter.execute(
      noteId: note1Id,
      operations: ops1,
      resolvedEntities: resolved1,
    );

    // Verify SQLite Knowledge Graph state
    final allEntitiesAfterNote1 = await db.entities.getAll();
    expect(allEntitiesAfterNote1.length, 3);

    final allRelationshipsAfterNote1 = await db.relationships.getAll();
    expect(allRelationshipsAfterNote1.length, 1);
    expect(allRelationshipsAfterNote1.first.relation, 'suggested');

    final allTasksAfterNote1 = await db.tasks.getAll();
    expect(allTasksAfterNote1.length, 1);
    expect(allTasksAfterNote1.first.description, 'Test Gemma 3 1B');

    // ── STEP 2: Process Note 2 (Entity Resolution & Deduplication) ────────────
    const note2Id = 'note-2';
    const note2Content = 'Arun helped review our Flutter UI.';

    await repository.createNote(
      Note(
        id: note2Id,
        content: note2Content,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );

    // Mock Understanding Agent output for Note 2 with identical entity mention "Arun" (and casing variation " arun ")
    const analysis2 = NoteAnalysisResult(
      topic: 'Flutter UI Review',
      summary: 'Arun helped review the Flutter UI.',
      keywords: ['Arun', 'Flutter UI'],
      entities: [
        ExtractedEntityMention(name: 'Arun', type: 'person'),
        ExtractedEntityMention(name: 'Flutter UI', type: 'technology'),
      ],
      facts: [
        ExtractedFactTriple(
          subject: 'Arun',
          predicate: 'helped_review',
          object: 'Flutter UI',
        ),
      ],
      tasks: [],
    );

    // Resolve entities for Note 2
    final resolved2 = await entityResolver.resolveAll(analysis2.entities);
    
    // Crucial Assertion: Arun MUST match the existing entity ID from Note 1
    final resolvedArun = resolved2.firstWhere((e) => e.name == 'Arun');
    expect(resolvedArun.status, ResolutionStatus.match);
    expect(resolvedArun.entityId, arunEntityId, reason: 'Arun MUST resolve to the exact same entity ID');

    // Memory Reasoner & Router for Note 2
    final ops2 = await memoryReasoner.reason(
      noteId: note2Id,
      analysis: analysis2,
      resolvedEntities: resolved2,
    );

    await memoryRouter.execute(
      noteId: note2Id,
      operations: ops2,
      resolvedEntities: resolved2,
    );

    // Verify entity table only has 4 total entities (Arun, NENAI, Gemma 3 1B, Flutter UI) — no duplicate Arun!
    final allEntitiesAfterNote2 = await db.entities.getAll();
    expect(allEntitiesAfterNote2.length, 4);

    // ── STEP 3: Query & Grounded Recall ("What did Arun suggest?") ───────────
    const query = 'What did Arun suggest?';

    // 1. Retrieval Planner identifies target entity "Arun"
    final plan = await retrievalPlanner.plan(query);
    expect(plan.targetEntities.any((e) => e.name == 'Arun'), isTrue);

    // 2. 3-Way Hybrid Retrieval finds Note 1 and Knowledge Graph triples
    final searchResults = await hybridRetriever.retrieve(query, limit: 3);
    expect(searchResults.isNotEmpty, isTrue);
    expect(searchResults.first.note.id, note1Id);
    expect(searchResults.first.graphTriples.any((t) => t.contains('suggested')), isTrue);

    // 3. Grounded Context Assembly
    final groundedContext = await contextBuilder.buildContext(searchResults);
    expect(groundedContext.contextString.contains('Arun --suggested--> Gemma 3 1B'), isTrue);
    expect(groundedContext.graphTriples.any((t) => t.contains('Arun --suggested--> Gemma 3 1B')), isTrue);
  });
}
