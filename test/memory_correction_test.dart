import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:nenai/data/local/database/app_database.dart';
import 'package:nenai/data/local/vector/vector_store.dart';
import 'package:nenai/data/repositories/context_repository_impl.dart';
import 'package:nenai/data/repositories/evidence_repository_impl.dart';
import 'package:nenai/data/repositories/note_repository_impl.dart';
import 'package:nenai/domain/entities/context_node.dart';
import 'package:nenai/domain/entities/memory_evidence.dart';
import 'package:nenai/domain/entities/note.dart';
import 'package:nenai/domain/ai/context_candidate.dart';
import 'package:nenai/ai/memory/context_evolution_engine.dart';
import 'package:nenai/ai/memory/context_candidate_retriever.dart';
import 'package:nenai/ai/memory/memory_correction_service.dart';

void main() {
  late AppDatabase db;
  late VectorStore vectorStore;
  late NoteRepositoryImpl noteRepository;
  late ContextRepositoryImpl contextRepository;
  late EvidenceRepositoryImpl evidenceRepository;
  late ContextEvolutionEngine evolutionEngine;
  late MemoryCorrectionService correctionService;
  late ContextCandidateRetriever candidateRetriever;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    vectorStore = VectorStore(db);
    noteRepository = NoteRepositoryImpl(db, vectorStore);
    contextRepository = ContextRepositoryImpl(db);
    evidenceRepository = EvidenceRepositoryImpl(db);
    evolutionEngine = ContextEvolutionEngine(
      contextRepository: contextRepository,
      evidenceRepository: evidenceRepository,
    );
    correctionService = MemoryCorrectionService(
      db: db,
      contextRepository: contextRepository,
      evidenceRepository: evidenceRepository,
      contextEvolutionEngine: evolutionEngine,
    );
    candidateRetriever = ContextCandidateRetriever(
      db: db,
      contextRepository: contextRepository,
    );
  });

  tearDown(() async {
    await db.close();
  });

  group('Phase 15: Memory Correction & User Feedback Tests', () {
    test('1. "Move to another context" (FC -> ReadSmart AI) sets user_confirmed with 1.0 confidence and preserves audit trail', () async {
      final now = DateTime.now();

      // Initial contexts
      await contextRepository.upsertNode(ContextNode(
        id: 'ctx-fc-corr',
        name: 'FC',
        type: ContextNodeType.project,
        createdAt: now,
        updatedAt: now,
      ));
      await contextRepository.upsertNode(ContextNode(
        id: 'ctx-rs-corr',
        name: 'ReadSmart AI',
        type: ContextNodeType.project,
        createdAt: now,
        updatedAt: now,
      ));

      // Note initially inferred to FC
      const noteId = 'note-deploy-corr';
      await noteRepository.createNote(Note(
        id: noteId,
        content: 'I finished the deployment and now I want to test this.',
        createdAt: now,
        updatedAt: now,
      ));
      await contextRepository.linkMemory(MemoryContextLink(
        memoryId: noteId,
        contextId: 'ctx-fc-corr',
        role: 'inferred',
        confidence: 0.65,
        createdAt: now,
      ));

      // User performs Correction: "This belongs to ReadSmart AI"
      final result = await correctionService.moveMemoryContext(
        memoryId: noteId,
        fromContextId: 'ctx-fc-corr',
        toContextId: 'ctx-rs-corr',
        reason: 'User manual override: deployment is part of ReadSmart AI',
      );

      expect(result.success, isTrue);

      // Verify unlinked from FC and linked to ReadSmart AI
      final fcMemories = await contextRepository.getMemoriesForContext('ctx-fc-corr');
      expect(fcMemories.contains(noteId), isFalse);

      final rsMemories = await contextRepository.getMemoriesForContext('ctx-rs-corr');
      expect(rsMemories.contains(noteId), isTrue);

      final links = await contextRepository.getContextsForMemory(noteId);
      expect(links.length, 1);
      expect(links.first.id, 'ctx-rs-corr');

      // Verify Audit Evidence created without deleting history
      final evidence = await evidenceRepository.getByMemoryId(noteId);
      expect(evidence.isNotEmpty, isTrue);
      final relocationEvidence = evidence.firstWhere((e) => e.relationType == 'user_relocated');
      expect(relocationEvidence.confidence, 1.0);
      expect(relocationEvidence.targetContextId, 'ctx-rs-corr');
      expect(relocationEvidence.explanation, contains('ReadSmart AI'));
    });

    test('2. "Not related to FC" unlinks note and negative preference suppresses candidate in future retrieval', () async {
      final now = DateTime.now();

      await contextRepository.upsertNode(ContextNode(
        id: 'ctx-fc-ex',
        name: 'FC',
        type: ContextNodeType.project,
        createdAt: now,
        updatedAt: now,
      ));

      const noteId = 'note-ex-1';
      const text = 'Testing FC staging cluster';
      await noteRepository.createNote(Note(
        id: noteId,
        content: text,
        createdAt: now,
        updatedAt: now,
      ));
      await contextRepository.linkMemory(MemoryContextLink(
        memoryId: noteId,
        contextId: 'ctx-fc-ex',
        createdAt: now,
      ));

      // User declares "Not related to FC"
      final result = await correctionService.excludeMemoryFromContext(
        memoryId: noteId,
        contextId: 'ctx-fc-ex',
        reason: text,
      );

      expect(result.success, isTrue);

      // Verify unlinked
      final mems = await contextRepository.getMemoriesForContext('ctx-fc-ex');
      expect(mems.contains(noteId), isFalse);

      // Verify audit evidence exists
      final evidence = await evidenceRepository.getByMemoryId(noteId);
      expect(evidence.any((e) => e.relationType == 'user_excluded'), isTrue);

      // Verify future retrieval suppresses FC context
      final candidates = await candidateRetriever.retrieveCandidates(
        CandidateRetrievalQuery(
          noteText: text,
          noteTimestamp: now,
        ),
      );
      expect(candidates.any((c) => c.contextId == 'ctx-fc-ex'), isFalse);
    });

    test('3. "Merge these contexts" merges synonymous contexts and preserves history', () async {
      final now = DateTime.now();

      await contextRepository.upsertNode(ContextNode(
        id: 'ctx-primary',
        name: 'ReadSmart AI',
        type: ContextNodeType.project,
        createdAt: now,
        updatedAt: now,
      ));
      await contextRepository.upsertNode(ContextNode(
        id: 'ctx-duplicate',
        name: 'ReadSmart-AI-v1',
        type: ContextNodeType.project,
        createdAt: now,
        updatedAt: now,
      ));

      const noteId = 'note-merge-1';
      await noteRepository.createNote(Note(
        id: noteId,
        content: 'Legacy v1 notes',
        createdAt: now,
        updatedAt: now,
      ));
      await contextRepository.linkMemory(MemoryContextLink(
        memoryId: noteId,
        contextId: 'ctx-duplicate',
        createdAt: now,
      ));

      // Merge duplicate into primary
      final result = await correctionService.mergeContexts(
        primaryContextId: 'ctx-primary',
        duplicateContextId: 'ctx-duplicate',
      );

      expect(result.success, isTrue);

      // Verify note moved to primary
      final primaryMems = await contextRepository.getMemoriesForContext('ctx-primary');
      expect(primaryMems.contains(noteId), isTrue);

      // Duplicate node deleted or deactivated
      final dupNode = await contextRepository.getNodeById('ctx-duplicate');
      expect(dupNode, isNull);
    });

    test('4. "Rename context" updates context name and logs audit evidence', () async {
      final now = DateTime.now();

      await contextRepository.upsertNode(ContextNode(
        id: 'ctx-rename',
        name: 'Old Project Name',
        type: ContextNodeType.project,
        createdAt: now,
        updatedAt: now,
      ));

      final result = await correctionService.renameContext(
        contextId: 'ctx-rename',
        newName: 'New Brand Project',
      );

      expect(result.success, isTrue);

      final updated = await contextRepository.getNodeById('ctx-rename');
      expect(updated?.name, 'New Brand Project');
    });

    test('5. "Correct entity" updates local Knowledge Graph entity name and canonical mapping', () async {
      final now = DateTime.now();

      await db.entities.upsertEntity(EntitiesTableCompanion.insert(
        id: 'ent-misspelled',
        name: 'Deen',
        canonicalName: 'deen',
        type: 'person',
        createdAt: now.millisecondsSinceEpoch,
        updatedAt: now.millisecondsSinceEpoch,
      ));

      final result = await correctionService.correctEntity(
        entityId: 'ent-misspelled',
        newName: 'Dean',
      );

      expect(result.success, isTrue);

      final entity = await db.entities.getById('ent-misspelled');
      expect(entity?.name, 'Dean');
      expect(entity?.canonicalName, 'dean');
    });

    test('6. "Remove relationship" deletes relationship from local Knowledge Graph', () async {
      final now = DateTime.now();

      await db.relationships.upsertRelationship(RelationshipsTableCompanion.insert(
        id: 'rel-to-del',
        sourceEntityId: 'e1',
        targetEntityId: 'e2',
        relation: 'manages',
        sourceMemoryId: 'note-1',
        createdAt: now.millisecondsSinceEpoch,
        updatedAt: now.millisecondsSinceEpoch,
      ));

      final result = await correctionService.removeRelationship(
        relationshipId: 'rel-to-del',
        memoryId: 'note-1',
      );

      expect(result.success, isTrue);

      final rels = await db.relationships.getByMemoryId('note-1');
      expect(rels.isEmpty, isTrue);
    });

    test('7. Learned context preference returns user-confirmed context for future queries without LLM fine-tuning', () async {
      final now = DateTime.now();

      // Seed user relocation evidence: "deployment" -> "ctx-rs-pref"
      await evidenceRepository.saveEvidence(MemoryEvidence(
        id: 'ev-pref-1',
        sourceMemoryId: 'note-sample',
        sourceTextSnippet: 'deployment',
        targetContextId: 'ctx-rs-pref',
        targetContextName: 'ReadSmart AI',
        relationType: 'user_relocated',
        confidence: 1.0,
        inferenceType: InferenceType.explicit,
        explanation: 'User manually moved deployment note to ReadSmart AI',
        createdAt: now,
        signals: const [
          EvidenceSignal(
            signalType: SignalType.explicitMention,
            weight: 1.0,
            score: 1.0,
            description: 'User confirmed preference',
          ),
        ],
      ));

      final preferredContext = await correctionService.getLearnedContextPreference(
        'I finished the deployment and want to test.',
      );

      expect(preferredContext, 'ctx-rs-pref');
    });
  });
}
