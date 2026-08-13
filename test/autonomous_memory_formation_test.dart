import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:nenai/data/local/database/app_database.dart';
import 'package:nenai/data/local/vector/vector_store.dart';
import 'package:nenai/data/repositories/context_repository_impl.dart';
import 'package:nenai/data/repositories/evidence_repository_impl.dart';
import 'package:nenai/data/repositories/note_repository_impl.dart';
import 'package:nenai/data/repositories/resolution_repository_impl.dart';
import 'package:nenai/domain/entities/context_node.dart';
import 'package:nenai/domain/entities/memory_operation.dart';
import 'package:nenai/domain/entities/note.dart';
import 'package:nenai/domain/entities/processing_status.dart';
import 'package:nenai/domain/ai/embedding_engine.dart';
import 'package:nenai/ai/agents/understanding_agent.dart';
import 'package:nenai/ai/agents/entity_resolver.dart';
import 'package:nenai/ai/agents/context_resolution_agent.dart';
import 'package:nenai/ai/agents/memory_reasoner.dart';
import 'package:nenai/ai/agents/memory_router.dart';
import 'package:nenai/ai/memory/context_candidate_retriever.dart';
import 'package:nenai/ai/memory/reference_resolver.dart';
import 'package:nenai/ai/memory/memory_linker.dart';
import 'package:nenai/background/clustering_manager.dart';
import 'package:nenai/background/note_processing_isolate.dart';
import 'package:nenai/ai/stub/stub_intelligence_engine.dart';

class MockEmbeddingEngine implements EmbeddingEngine {
  @override
  bool get isReady => true;

  @override
  Future<List<double>?> embed(String text) async {
    return List<double>.filled(384, 0.2);
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
      embeddingEngine: MockEmbeddingEngine(),
    );
    clusteringManager = ClusteringManager(noteRepository);

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

  group('Phase 8: Autonomous Memory Formation Pipeline Tests', () {
    test('1. End-to-End Hierarchical Formation (Meeting with Dean -> Project Discussion -> ReadSmart AI -> Deployment -> Testing)', () async {
      final now = DateTime.now();

      // Step 1: Ingest Note 1: "Meeting with Dean to discuss projects."
      const note1Id = 'note-dean-meet';
      await noteRepository.createNote(
        Note(
          id: note1Id,
          content: 'Meeting with Dean to discuss projects.',
          createdAt: now.subtract(const Duration(hours: 3)),
          updatedAt: now.subtract(const Duration(hours: 3)),
        ),
      );
      await pipeline.processNote(note1Id);

      // Create hierarchical structure baseline:
      // Meeting with Dean -> Project Discussion -> ReadSmart AI
      final meetingCtx = ContextNode(
        id: 'ctx-dean',
        name: 'Meeting with Dean',
        type: ContextNodeType.episode,
        originatingMemoryId: note1Id,
        createdAt: now.subtract(const Duration(hours: 3)),
        updatedAt: now.subtract(const Duration(hours: 3)),
      );
      final discCtx = ContextNode(
        id: 'ctx-disc',
        name: 'Project Discussion',
        type: ContextNodeType.topic,
        createdAt: now.subtract(const Duration(hours: 3)),
        updatedAt: now.subtract(const Duration(hours: 3)),
      );
      final rsCtx = ContextNode(
        id: 'ctx-readsmart',
        name: 'ReadSmart AI',
        type: ContextNodeType.project,
        createdAt: now.subtract(const Duration(hours: 2)),
        updatedAt: now.subtract(const Duration(hours: 2)),
      );
      final deployCtx = ContextNode(
        id: 'ctx-deploy',
        name: 'Deployment',
        type: ContextNodeType.activity,
        createdAt: now.subtract(const Duration(hours: 1)),
        updatedAt: now.subtract(const Duration(minutes: 30)),
      );

      await contextRepository.upsertNode(meetingCtx);
      await contextRepository.upsertNode(discCtx);
      await contextRepository.upsertNode(rsCtx);
      await contextRepository.upsertNode(deployCtx);

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
        targetContextId: 'ctx-deploy',
        relationType: 'activity',
        createdAt: now,
        updatedAt: now,
      ));

      // Link previous note to deployment context
      await contextRepository.linkMemory(MemoryContextLink(
        memoryId: note1Id,
        contextId: 'ctx-deploy',
        createdAt: now.subtract(const Duration(hours: 1)),
      ));

      // Step 2: Ingest Canonical Note: "I finished the deployment and now I want to test this."
      const note2Id = 'note-canonical-deploy';
      const note2Text = 'I finished the deployment and now I want to test this.';
      await noteRepository.createNote(
        Note(
          id: note2Id,
          content: note2Text,
          createdAt: now,
          updatedAt: now,
        ),
      );

      // Execute 13-stage autonomous pipeline
      await pipeline.processNote(note2Id);

      // Verify Note 2 state
      final processedNote = await noteRepository.getNoteById(note2Id);
      expect(processedNote, isNotNull);
      expect(processedNote!.status, ProcessingStatus.completed);

      // Verify Note 2 is attached to Deployment context
      final deployMemories = await contextRepository.getMemoriesForContext('ctx-deploy');
      expect(deployMemories, contains(note2Id));

      // Verify full ancestral hierarchy path is intact
      final ancestors = await contextRepository.getAncestors('ctx-deploy');
      final ancestorNames = ancestors.map((a) => a.name).toList();
      expect(ancestorNames, containsAll(['ReadSmart AI', 'Project Discussion', 'Meeting with Dean']));
    });

    test('2. Deterministic execution of all Typed Operations in MemoryRouter', () async {
      const testNoteId = 'test-ops-note';

      final operations = [
        MemoryOperation.createContext(
          id: 'ctx-alpha',
          name: 'Project Alpha',
          type: 'project',
          originatingMemoryId: testNoteId,
        ),
        MemoryOperation.createChildContext(
          id: 'ctx-alpha-backend',
          parentContextId: 'ctx-alpha',
          childName: 'Backend Services',
          childType: 'activity',
          originatingMemoryId: testNoteId,
        ),
        MemoryOperation.attachMemory(
          memoryId: testNoteId,
          contextId: 'ctx-alpha-backend',
          contextName: 'Backend Services',
          confidence: 0.95,
          evidence: 'Active backend implementation.',
        ),
        MemoryOperation.createTask(
          id: 'task-1',
          memoryId: testNoteId,
          description: 'Deploy backend microservice',
        ),
        MemoryOperation.createEntity(
          id: 'ent-grpc',
          name: 'gRPC',
          type: 'technology',
          canonicalName: 'grpc',
        ),
        MemoryOperation.noOp(reason: 'Validated no-op'),
      ];

      await memoryRouter.execute(
        noteId: testNoteId,
        operations: operations,
        resolvedEntities: const [],
      );

      // Verify contexts
      final parentNode = await contextRepository.getNodeById('ctx-alpha');
      expect(parentNode, isNotNull);
      expect(parentNode!.name, 'Project Alpha');

      final childNode = await contextRepository.getNodeById('ctx-alpha-backend');
      expect(childNode, isNotNull);
      expect(childNode!.name, 'Backend Services');

      // Verify edge
      final childEdges = await contextRepository.getChildEdges('ctx-alpha');
      expect(childEdges.any((e) => e.targetContextId == 'ctx-alpha-backend'), isTrue);

      // Verify memory link
      final memories = await contextRepository.getMemoriesForContext('ctx-alpha-backend');
      expect(memories, contains(testNoteId));

      // Verify task
      final allTasks = await db.tasks.getAll();
      expect(allTasks.any((t) => t.description == 'Deploy backend microservice'), isTrue);

      // Verify entity
      final allEntities = await db.entities.getAll();
      expect(allEntities.any((e) => e.name == 'gRPC'), isTrue);
    });

    test('3. Ambiguity triggers REQUEST_CLARIFICATION and marks note as needsUserClarification', () async {
      final now = DateTime.now();

      // Two competing contexts active at the same time
      await contextRepository.upsertNode(ContextNode(id: 'ctx-proj-1', name: 'Alpha Project', createdAt: now, updatedAt: now));
      await contextRepository.upsertNode(ContextNode(id: 'ctx-proj-2', name: 'Beta Project', createdAt: now, updatedAt: now));

      const noteId = 'note-ambig-formation';
      await noteRepository.createNote(
        Note(
          id: noteId,
          content: 'Deploy the service today.',
          createdAt: now,
          updatedAt: now,
        ),
      );

      // Create reasoning with ambiguous context outcome
      final ops = [
        MemoryOperation.requestClarification(
          memoryId: noteId,
          noteTextSnippet: 'Deploy the service today.',
          candidates: [
            {
              'contextId': 'ctx-proj-1',
              'contextName': 'Alpha Project',
              'contextPath': 'Alpha Project',
              'confidence': 0.60,
              'evidenceSummary': 'Alpha has recent service notes.',
            },
            {
              'contextId': 'ctx-proj-2',
              'contextName': 'Beta Project',
              'contextPath': 'Beta Project',
              'confidence': 0.58,
              'evidenceSummary': 'Beta also has service notes.',
            },
          ],
        ),
      ];

      await memoryRouter.execute(
        noteId: noteId,
        operations: ops,
        resolvedEntities: const [],
      );

      // Verify pending resolution exists
      final pending = await resolutionRepository.getPendingByMemoryId(noteId);
      expect(pending, isNotNull);
      expect(pending!.candidates.length, 2);

      // Verify note status is marked as needsUserClarification
      final noteRow = await db.notes.getById(noteId);
      expect(noteRow!.processingStatus, ProcessingStatus.needsUserClarification.name);
    });
  });
}
