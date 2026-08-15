import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:nenai/data/local/database/app_database.dart';
import 'package:nenai/data/repositories/context_repository_impl.dart';
import 'package:nenai/ai/memory/reference_resolver.dart';
import 'package:nenai/domain/entities/context_node.dart';
import 'package:nenai/domain/ai/note_analysis_result.dart';
import 'package:nenai/domain/ai/reference_resolution.dart';

void main() {
  late AppDatabase db;
  late ContextRepositoryImpl contextRepository;
  late ReferenceResolver resolver;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    contextRepository = ContextRepositoryImpl(db);
    resolver = ReferenceResolver(
      db: db,
      contextRepository: contextRepository,
    );
  });

  tearDown(() async {
    await db.close();
  });

  group('Phase 7: Cross-Note Reference Resolution Tests', () {
    test('1. Resolves "this" to recent activity in active context (ReadSmart AI Deployment)', () async {
      final now = DateTime.now();

      // Setup ReadSmart AI Deployment context
      await contextRepository.upsertNode(ContextNode(
        id: 'ctx-readsmart-deploy',
        name: 'ReadSmart AI Deployment',
        type: ContextNodeType.activity,
        createdAt: now.subtract(const Duration(hours: 1)),
        updatedAt: now.subtract(const Duration(minutes: 30)),
      ));

      // Note 1 in DB
      await db.notes.insertNote(
        NotesTableCompanion.insert(
          id: 'note-1',
          content: 'I discussed ReadSmart AI deployment with Dean.',
          createdAt: now.subtract(const Duration(hours: 1)).millisecondsSinceEpoch,
          updatedAt: now.subtract(const Duration(hours: 1)).millisecondsSinceEpoch,
        ),
      );

      // Note 2: "I finished the deployment and now I want to test this."
      final result = await resolver.resolve(
        noteText: 'I finished the deployment and now I want to test this.',
        references: const [
          ContextualReference(text: 'this', type: 'anaphora', resolution: null),
        ],
        noteTimestamp: now,
      );

      expect(result.resolvedReferences.isNotEmpty, isTrue);
      final ref = result.getByText('this');
      expect(ref, isNotNull);
      expect(ref!.status, ReferenceResolutionStatus.resolved);
      expect(ref.targetReferent, 'ReadSmart AI Deployment');
      expect(ref.confidence, greaterThanOrEqualTo(0.75));
    });

    test('2. Resolves "the project" to active project context (ReadSmart AI)', () async {
      final now = DateTime.now();

      await contextRepository.upsertNode(ContextNode(
        id: 'ctx-rs',
        name: 'ReadSmart AI',
        type: ContextNodeType.project,
        createdAt: now.subtract(const Duration(hours: 2)),
        updatedAt: now.subtract(const Duration(hours: 1)),
      ));

      final result = await resolver.resolve(
        noteText: 'The project requires further testing.',
        references: const [
          ContextualReference(text: 'the project', type: 'definite_noun_phrase', resolution: null),
        ],
        noteTimestamp: now,
      );

      final ref = result.getByText('the project');
      expect(ref, isNotNull);
      expect(ref!.status, ReferenceResolutionStatus.resolved);
      expect(ref.targetReferent, 'ReadSmart AI');
      expect(ref.targetReferentType, 'project');
    });

    test('3. Resolves "the meeting" to episode context', () async {
      final now = DateTime.now();

      await contextRepository.upsertNode(ContextNode(
        id: 'ctx-dean-meeting',
        name: 'Meeting with Dean',
        type: ContextNodeType.episode,
        createdAt: now.subtract(const Duration(hours: 1)),
        updatedAt: now.subtract(const Duration(hours: 1)),
      ));

      final result = await resolver.resolve(
        noteText: 'The meeting was very productive.',
        references: const [
          ContextualReference(text: 'the meeting', type: 'definite_noun_phrase', resolution: null),
        ],
        noteTimestamp: now,
      );

      final ref = result.getByText('the meeting');
      expect(ref, isNotNull);
      expect(ref!.status, ReferenceResolutionStatus.resolved);
      expect(ref.targetReferent, 'Meeting with Dean');
    });

    test('4. Resolves pronoun "he" to person entity (Dean)', () async {
      final now = DateTime.now();

      // Create entity Dean
      await db.entities.upsertEntity(EntitiesTableCompanion.insert(
        id: 'ent-dean',
        name: 'Dean',
        canonicalName: 'dean',
        type: 'person',
        createdAt: now.millisecondsSinceEpoch,
        updatedAt: now.millisecondsSinceEpoch,
      ));

      await db.notes.insertNote(NotesTableCompanion.insert(
        id: 'note-dean-1',
        content: 'Dean reviewed the system architecture.',
        createdAt: now.subtract(const Duration(minutes: 20)).millisecondsSinceEpoch,
        updatedAt: now.subtract(const Duration(minutes: 20)).millisecondsSinceEpoch,
      ));

      await db.entities.linkEntityToMemory(
        'note-dean-1',
        'ent-dean',
      );

      final result = await resolver.resolve(
        noteText: 'He approved the deployment plan.',
        references: const [
          ContextualReference(text: 'he', type: 'pronoun', resolution: null),
        ],
        noteTimestamp: now,
      );

      final ref = result.getByText('he');
      expect(ref, isNotNull);
      expect(ref!.status, ReferenceResolutionStatus.resolved);
      expect(ref.targetReferent, 'Dean');
      expect(ref.targetReferentType, 'person');
    });

    test('5. Resolves "it" and "that" demonstrative pronouns', () async {
      final now = DateTime.now();

      await contextRepository.upsertNode(ContextNode(
        id: 'ctx-staging',
        name: 'Staging Deployment',
        type: ContextNodeType.activity,
        createdAt: now.subtract(const Duration(minutes: 15)),
        updatedAt: now.subtract(const Duration(minutes: 15)),
      ));

      final result = await resolver.resolve(
        noteText: 'It works reliably and that solved the issue.',
        references: const [
          ContextualReference(text: 'it', type: 'pronoun', resolution: null),
          ContextualReference(text: 'that', type: 'demonstrative', resolution: null),
        ],
        noteTimestamp: now,
      );

      final itRef = result.getByText('it');
      final thatRef = result.getByText('that');

      expect(itRef!.status, ReferenceResolutionStatus.resolved);
      expect(thatRef!.status, ReferenceResolutionStatus.resolved);
      expect(itRef.targetReferent, 'Staging Deployment');
    });

    test('6. Marks reference as AMBIGUOUS when competing candidates have close scores', () async {
      final now = DateTime.now();

      // Two equally recent deployment contexts
      await contextRepository.upsertNode(ContextNode(
        id: 'ctx-rs-deploy',
        name: 'ReadSmart AI Deployment',
        type: ContextNodeType.activity,
        createdAt: now.subtract(const Duration(minutes: 10)),
        updatedAt: now.subtract(const Duration(minutes: 10)),
      ));
      await contextRepository.upsertNode(ContextNode(
        id: 'ctx-fc-deploy',
        name: 'FC Deployment',
        type: ContextNodeType.activity,
        createdAt: now.subtract(const Duration(minutes: 10)),
        updatedAt: now.subtract(const Duration(minutes: 10)),
      ));

      final result = await resolver.resolve(
        noteText: 'I finished the task and now want to test this.',
        references: const [
          ContextualReference(text: 'this', type: 'anaphora', resolution: null),
        ],
        noteTimestamp: now,
      );

      expect(result.hasAmbiguities, isTrue);
      final ref = result.getByText('this');
      expect(ref!.status, ReferenceResolutionStatus.ambiguous);
      expect(ref.candidates.length, 2);
    });

    test('7. Marks reference as UNRESOLVED when no matching antecedent exists', () async {
      final now = DateTime.now();

      final result = await resolver.resolve(
        noteText: 'I tested this and it broke.',
        references: const [
          ContextualReference(text: 'this', type: 'anaphora', resolution: null),
        ],
        noteTimestamp: now,
      );

      expect(result.unresolvedCount, 1);
      final ref = result.getByText('this');
      expect(ref!.status, ReferenceResolutionStatus.unresolved);
    });
  });
}
