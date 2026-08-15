import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:nenai/data/local/database/app_database.dart';
import 'package:nenai/data/repositories/context_repository_impl.dart';
import 'package:nenai/data/repositories/evidence_repository_impl.dart';
import 'package:nenai/data/repositories/resolution_repository_impl.dart';
import 'package:nenai/domain/entities/context_node.dart';
import 'package:nenai/domain/entities/pending_resolution.dart';
import 'package:nenai/domain/entities/processing_status.dart';
import 'package:nenai/domain/entities/memory_evidence.dart';

void main() {
  late AppDatabase db;
  late ContextRepositoryImpl contextRepository;
  late EvidenceRepositoryImpl evidenceRepository;
  late ResolutionRepositoryImpl resolutionRepository;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    contextRepository = ContextRepositoryImpl(db);
    evidenceRepository = EvidenceRepositoryImpl(db);
    resolutionRepository = ResolutionRepositoryImpl(
      db: db,
      contextRepository: contextRepository,
      evidenceRepository: evidenceRepository,
    );
  });

  tearDown(() async {
    await db.close();
  });

  group('Phase 6: Human-in-the-Loop Context Resolution Tests', () {
    test('1. Ambiguous resolution marks note as needsUserClarification and creates PendingResolution', () async {
      final now = DateTime.now();

      // Create existing contexts
      await contextRepository.upsertNode(ContextNode(
        id: 'ctx-readsmart',
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

      // Insert raw note into Drift DB
      const noteId = 'note-ambig-1';
      const noteText = 'I finished the deployment and now I want to test this.';
      await db.notes.insertNote(
        NotesTableCompanion.insert(
          id: noteId,
          content: noteText,
          processingStatus: Value(ProcessingStatus.processing.name),
          createdAt: now.millisecondsSinceEpoch,
          updatedAt: now.millisecondsSinceEpoch,
        ),
      );

      // Save Pending Resolution
      final pending = PendingResolution(
        id: 'res-1',
        memoryId: noteId,
        noteTextSnippet: noteText,
        candidates: const [
          ResolutionCandidateOption(
            contextId: 'ctx-readsmart',
            contextName: 'ReadSmart AI',
            contextPath: 'Meeting with Dean └── ReadSmart AI └── Deployment',
            confidence: 0.61,
            evidenceSummary: 'ReadSmart AI has recent notes about deployment and testing.',
          ),
          ResolutionCandidateOption(
            contextId: 'ctx-fc',
            contextName: 'FC',
            contextPath: 'FC └── Deployment',
            confidence: 0.59,
            evidenceSummary: 'FC also has deployment-related notes.',
          ),
        ],
        createdAt: now,
      );

      await resolutionRepository.savePendingResolution(pending);

      // Verify Note is now marked as needsUserClarification
      final noteRow = await db.notes.getById(noteId);
      expect(noteRow, isNotNull);
      expect(noteRow!.processingStatus, ProcessingStatus.needsUserClarification.name);

      // Verify PendingResolution is retrieved
      final pendingList = await resolutionRepository.getAllPending();
      expect(pendingList.length, 1);
      expect(pendingList.first.memoryId, noteId);
      expect(pendingList.first.candidates.length, 2);
      expect(pendingList.first.candidates.first.evidenceSummary,
          'ReadSmart AI has recent notes about deployment and testing.');
    });

    test('2. User confirms Single Context: updates note to completed and creates high-authority evidence link', () async {
      final now = DateTime.now();

      await contextRepository.upsertNode(ContextNode(
        id: 'ctx-readsmart',
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

      const noteId = 'note-ambig-2';
      const noteText = 'I finished the deployment and now I want to test this.';
      await db.notes.insertNote(
        NotesTableCompanion.insert(
          id: noteId,
          content: noteText,
          processingStatus: Value(ProcessingStatus.processing.name),
          createdAt: now.millisecondsSinceEpoch,
          updatedAt: now.millisecondsSinceEpoch,
        ),
      );

      final pending = PendingResolution(
        id: 'res-2',
        memoryId: noteId,
        noteTextSnippet: noteText,
        candidates: const [
          ResolutionCandidateOption(
            contextId: 'ctx-readsmart',
            contextName: 'ReadSmart AI',
            contextPath: 'ReadSmart AI',
            confidence: 0.61,
            evidenceSummary: 'Recent deployment note.',
          ),
          ResolutionCandidateOption(
            contextId: 'ctx-fc',
            contextName: 'FC',
            contextPath: 'FC',
            confidence: 0.59,
            evidenceSummary: 'Recent FC deployment note.',
          ),
        ],
        createdAt: now,
      );

      await resolutionRepository.savePendingResolution(pending);

      // User confirms ReadSmart AI
      await resolutionRepository.resolveResolution(
        resolutionId: 'res-2',
        memoryId: noteId,
        choice: const ResolutionChoice.single('ctx-readsmart'),
      );

      // 1. Note status must be completed
      final noteRow = await db.notes.getById(noteId);
      expect(noteRow!.processingStatus, ProcessingStatus.completed.name);

      // 2. MemoryContext link must exist with confidence 1.0
      final memories = await contextRepository.getMemoriesForContext('ctx-readsmart');
      expect(memories, contains(noteId));

      // 3. MemoryEvidence must exist with explicit inference
      final evidenceList = await evidenceRepository.getByMemoryId(noteId);
      expect(evidenceList.isNotEmpty, isTrue);
      expect(evidenceList.first.confidence, 1.0);
      expect(evidenceList.first.inferenceType, InferenceType.explicit);
      expect(evidenceList.first.relationType, 'user_confirmed');

      // 4. Pending list must now be empty
      final pendingList = await resolutionRepository.getAllPending();
      expect(pendingList, isEmpty);
    });

    test('3. User confirms Both Contexts: creates multi-attach links', () async {
      final now = DateTime.now();

      await contextRepository.upsertNode(ContextNode(id: 'ctx-alpha', name: 'Alpha', createdAt: now, updatedAt: now));
      await contextRepository.upsertNode(ContextNode(id: 'ctx-beta', name: 'Beta', createdAt: now, updatedAt: now));

      const noteId = 'note-ambig-3';
      await db.notes.insertNote(
        NotesTableCompanion.insert(
          id: noteId,
          content: 'Dual context note',
          createdAt: now.millisecondsSinceEpoch,
          updatedAt: now.millisecondsSinceEpoch,
        ),
      );

      final pending = PendingResolution(
        id: 'res-3',
        memoryId: noteId,
        noteTextSnippet: 'Dual context note',
        candidates: const [
          ResolutionCandidateOption(contextId: 'ctx-alpha', contextName: 'Alpha', contextPath: 'Alpha', confidence: 0.60, evidenceSummary: ''),
          ResolutionCandidateOption(contextId: 'ctx-beta', contextName: 'Beta', contextPath: 'Beta', confidence: 0.60, evidenceSummary: ''),
        ],
        createdAt: now,
      );

      await resolutionRepository.savePendingResolution(pending);

      // User chooses Both
      await resolutionRepository.resolveResolution(
        resolutionId: 'res-3',
        memoryId: noteId,
        choice: const ResolutionChoice.both(),
      );

      final alphaMemories = await contextRepository.getMemoriesForContext('ctx-alpha');
      final betaMemories = await contextRepository.getMemoriesForContext('ctx-beta');

      expect(alphaMemories, contains(noteId));
      expect(betaMemories, contains(noteId));
    });

    test('4. User creates New Context during resolution', () async {
      final now = DateTime.now();
      const noteId = 'note-ambig-4';
      await db.notes.insertNote(
        NotesTableCompanion.insert(
          id: noteId,
          content: 'New project note',
          createdAt: now.millisecondsSinceEpoch,
          updatedAt: now.millisecondsSinceEpoch,
        ),
      );

      final pending = PendingResolution(
        id: 'res-4',
        memoryId: noteId,
        noteTextSnippet: 'New project note',
        candidates: const [],
        createdAt: now,
      );

      await resolutionRepository.savePendingResolution(pending);

      // User creates new context "Project Hyperion"
      await resolutionRepository.resolveResolution(
        resolutionId: 'res-4',
        memoryId: noteId,
        choice: const ResolutionChoice.newContext(
          newContextName: 'Project Hyperion',
          newContextType: 'project',
        ),
      );

      final hyperion = await contextRepository.getNodeByName('Project Hyperion');
      expect(hyperion, isNotNull);
      expect(hyperion!.type, ContextNodeType.project);

      final memories = await contextRepository.getMemoriesForContext(hyperion.id);
      expect(memories, contains(noteId));
    });

    test('5. User selects None of these (rejects suggested candidates)', () async {
      final now = DateTime.now();
      const noteId = 'note-ambig-5';
      await db.notes.insertNote(
        NotesTableCompanion.insert(
          id: noteId,
          content: 'Scratchpad note',
          createdAt: now.millisecondsSinceEpoch,
          updatedAt: now.millisecondsSinceEpoch,
        ),
      );

      final pending = PendingResolution(
        id: 'res-5',
        memoryId: noteId,
        noteTextSnippet: 'Scratchpad note',
        candidates: const [
          ResolutionCandidateOption(contextId: 'ctx-other', contextName: 'Other', contextPath: 'Other', confidence: 0.50, evidenceSummary: ''),
        ],
        createdAt: now,
      );

      await resolutionRepository.savePendingResolution(pending);

      // User selects None
      await resolutionRepository.resolveResolution(
        resolutionId: 'res-5',
        memoryId: noteId,
        choice: const ResolutionChoice.none(),
      );

      final noteRow = await db.notes.getById(noteId);
      expect(noteRow!.processingStatus, ProcessingStatus.completed.name);

      final resolvedRow = await db.pendingResolutions.getById('res-5');
      expect(resolvedRow!.status, 'resolved');
      expect(resolvedRow.resolutionSource, ResolutionSource.userRejected.name);
    });
  });
}
