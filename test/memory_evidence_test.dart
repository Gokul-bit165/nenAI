import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:nenai/data/local/database/app_database.dart';
import 'package:nenai/data/repositories/evidence_repository_impl.dart';
import 'package:nenai/domain/entities/memory_evidence.dart';
import 'package:nenai/domain/ai/evidence_evaluator.dart';

void main() {
  late AppDatabase db;
  late EvidenceRepositoryImpl repository;
  late EvidenceEvaluator evaluator;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repository = EvidenceRepositoryImpl(db);
    evaluator = const EvidenceEvaluator();
  });

  tearDown(() async {
    await db.close();
  });

  group('Phase 2: Memory Evidence Engine Tests', () {
    test('1. Explicit evidence evaluation with 1.0 confidence', () {
      const sourceNote = 'I completed the ReadSmart AI architecture review with team.';

      const candidate = CandidateContextInput(
        contextId: 'ctx-readsmart',
        contextName: 'ReadSmart AI',
        relationType: 'activity_of',
        signals: [
          EvidenceSignal(
            signalType: SignalType.keywordActionOverlap,
            weight: 0.5,
            score: 0.8,
            description: 'Mentions architecture review',
          ),
        ],
      );

      final result = evaluator.evaluate(
        sourceMemoryId: 'note-100',
        sourceText: sourceNote,
        candidates: [candidate],
      );

      expect(result.allCandidates.length, 1);
      final top = result.topCandidate;
      expect(top, isNotNull);
      expect(top!.contextName, 'ReadSmart AI');
      expect(top.inferenceType, InferenceType.explicit);
      expect(top.confidence, greaterThanOrEqualTo(0.95));
      expect(top.explanation.contains('Explicitly mentions "ReadSmart AI"'), isTrue);
      expect(result.isAmbiguous, isFalse);
    });

    test('2. Multi-signal strong inference evaluation (ReadSmart AI vs FC Canonical Case)', () {
      // Source Note does not explicitly name the project
      const sourceNote = 'I finished the deployment and now I want to test this.';

      const candidateReadSmart = CandidateContextInput(
        contextId: 'ctx-readsmart',
        contextName: 'ReadSmart AI',
        relationType: 'activity_of',
        signals: [
          EvidenceSignal(
            signalType: SignalType.temporalRecency,
            weight: 0.35,
            score: 0.90,
            description: 'Discussed in recent meeting (1 hr ago)',
            sourceMemoryId: 'note-meeting-1',
          ),
          EvidenceSignal(
            signalType: SignalType.keywordActionOverlap,
            weight: 0.35,
            score: 0.85,
            description: 'Recent notes mention ReadSmart AI deployment workflow',
            sourceMemoryId: 'note-prior-workflow',
          ),
          EvidenceSignal(
            signalType: SignalType.vectorSimilarity,
            weight: 0.30,
            score: 0.90,
            description: 'Semantic vector similarity to ReadSmart AI activity stream',
          ),
        ],
      );

      const candidateFC = CandidateContextInput(
        contextId: 'ctx-fc',
        contextName: 'FC',
        relationType: 'activity_of',
        signals: [
          EvidenceSignal(
            signalType: SignalType.temporalRecency,
            weight: 0.35,
            score: 0.90,
            description: 'Discussed in recent meeting',
            sourceMemoryId: 'note-meeting-1',
          ),
          EvidenceSignal(
            signalType: SignalType.keywordActionOverlap,
            weight: 0.35,
            score: 0.0,
            description: 'No deployment activity or workflow exists for FC',
          ),
          EvidenceSignal(
            signalType: SignalType.vectorSimilarity,
            weight: 0.30,
            score: 0.20,
            description: 'Low semantic similarity to FC notes',
          ),
        ],
      );

      final result = evaluator.evaluate(
        sourceMemoryId: 'note-deploy-1',
        sourceText: sourceNote,
        candidates: [candidateReadSmart, candidateFC],
      );

      expect(result.allCandidates.length, 2);
      expect(result.isAmbiguous, isFalse);

      final top = result.topCandidate;
      expect(top, isNotNull);
      expect(top!.contextName, 'ReadSmart AI');
      expect(top.inferenceType, InferenceType.strongInference);
      expect(top.confidence, greaterThan(0.80));

      final fcCandidate = result.allCandidates.firstWhere((c) => c.contextName == 'FC');
      expect(fcCandidate.confidence, lessThan(0.45));

      // Verify concise structured explanation
      expect(top.explanation.contains('Matched "ReadSmart AI" based on:'), isTrue);
      expect(top.explanation.contains('Discussed in recent meeting'), isTrue);
      expect(top.explanation.contains('ReadSmart AI deployment workflow'), isTrue);
    });

    test('3. Ambiguous inference detection (Competing candidates with close scores)', () {
      const sourceNote = 'I worked on the database schema optimization.';

      // Two candidate projects with nearly identical confidence scores
      const candidateA = CandidateContextInput(
        contextId: 'ctx-proj-a',
        contextName: 'Project Alpha',
        relationType: 'activity_of',
        signals: [
          EvidenceSignal(
            signalType: SignalType.temporalRecency,
            weight: 0.5,
            score: 0.80,
            description: 'Active project in current sprint',
          ),
          EvidenceSignal(
            signalType: SignalType.vectorSimilarity,
            weight: 0.5,
            score: 0.70,
            description: 'High semantic relevance to Alpha backend',
          ),
        ],
      );

      const candidateB = CandidateContextInput(
        contextId: 'ctx-proj-b',
        contextName: 'Project Beta',
        relationType: 'activity_of',
        signals: [
          EvidenceSignal(
            signalType: SignalType.temporalRecency,
            weight: 0.5,
            score: 0.80,
            description: 'Active project in current sprint',
          ),
          EvidenceSignal(
            signalType: SignalType.vectorSimilarity,
            weight: 0.5,
            score: 0.68,
            description: 'High semantic relevance to Beta backend',
          ),
        ],
      );

      final result = evaluator.evaluate(
        sourceMemoryId: 'note-db-opt',
        sourceText: sourceNote,
        candidates: [candidateA, candidateB],
      );

      expect(result.isAmbiguous, isTrue);
      expect(result.ambiguousCandidates.length, 2);
      expect(result.topCandidate!.inferenceType, InferenceType.ambiguousInference);
      expect(result.allCandidates.every((c) => c.inferenceType == InferenceType.ambiguousInference), isTrue);
    });

    test('4. Weak inference classification (< 0.40 threshold)', () {
      const sourceNote = 'Bought some coffee and apples.';

      const candidate = CandidateContextInput(
        contextId: 'ctx-readsmart',
        contextName: 'ReadSmart AI',
        relationType: 'relates_to',
        signals: [
          EvidenceSignal(
            signalType: SignalType.temporalRecency,
            weight: 0.5,
            score: 0.20,
            description: 'Vaguely recent',
          ),
          EvidenceSignal(
            signalType: SignalType.vectorSimilarity,
            weight: 0.5,
            score: 0.10,
            description: 'Near zero semantic similarity',
          ),
        ],
      );

      final result = evaluator.evaluate(
        sourceMemoryId: 'note-grocery',
        sourceText: sourceNote,
        candidates: [candidate],
      );

      expect(result.topCandidate!.inferenceType, InferenceType.weakInference);
      expect(result.topCandidate!.confidence, lessThan(0.40));
      expect(result.isAmbiguous, isFalse);
    });

    test('5. Persistence and retrieval in Drift SQLite with signal JSON breakdown', () async {
      final now = DateTime.now();

      const signal1 = EvidenceSignal(
        signalType: SignalType.temporalRecency,
        weight: 0.4,
        score: 0.9,
        description: 'Discussed 2 hours ago in meeting',
        sourceMemoryId: 'note-meet-1',
      );

      const signal2 = EvidenceSignal(
        signalType: SignalType.keywordActionOverlap,
        weight: 0.6,
        score: 0.85,
        description: 'Mentions deployment and testing',
        sourceMemoryId: 'note-deploy-prior',
      );

      final evidence = MemoryEvidence(
        id: 'ev-101',
        sourceMemoryId: 'note-deploy-1',
        sourceTextSnippet: 'I finished the deployment and now I want to test this.',
        targetContextId: 'ctx-readsmart',
        targetContextName: 'ReadSmart AI',
        relationType: 'activity_of',
        confidence: 0.88,
        inferenceType: InferenceType.strongInference,
        signals: [signal1, signal2],
        explanation: 'Matched "ReadSmart AI" based on recent deployment activity and meeting discussion.',
        createdAt: now,
      );

      await repository.saveEvidence(evidence);

      // Query by ID
      final fetched = await repository.getById('ev-101');
      expect(fetched, isNotNull);
      expect(fetched!.sourceMemoryId, 'note-deploy-1');
      expect(fetched.targetContextName, 'ReadSmart AI');
      expect(fetched.confidence, 0.88);
      expect(fetched.inferenceType, InferenceType.strongInference);
      expect(fetched.signals.length, 2);
      expect(fetched.signals[0].signalType, SignalType.temporalRecency);
      expect(fetched.signals[0].sourceMemoryId, 'note-meet-1');
      expect(fetched.signals[1].signalType, SignalType.keywordActionOverlap);
      expect(fetched.explanation, contains('ReadSmart AI'));

      // Query by memory ID
      final byMemory = await repository.getByMemoryId('note-deploy-1');
      expect(byMemory.length, 1);
      expect(byMemory.first.id, 'ev-101');

      // Query by context ID
      final byContext = await repository.getByContextId('ctx-readsmart');
      expect(byContext.length, 1);
      expect(byContext.first.id, 'ev-101');
    });
  });
}
