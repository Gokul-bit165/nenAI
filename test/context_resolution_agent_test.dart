import 'package:flutter_test/flutter_test.dart';
import 'package:nenai/ai/agents/context_resolution_agent.dart';
import 'package:nenai/domain/ai/context_candidate.dart';
import 'package:nenai/domain/ai/context_resolution_result.dart';
import 'package:nenai/domain/ai/note_analysis_result.dart';

void main() {
  const agent = ContextResolutionAgent();
  final now = DateTime.now();

  group('Phase 5: Context Resolution Engine Tests', () {
    test('1. Canonical AUTO_ATTACH: High confidence with clear margin (ReadSmart AI = 0.87 vs FC = 0.42)', () {
      const noteText = 'I finished the deployment and now I want to test this.';
      const analysis = NoteAnalysisResult(
        topic: 'Deployment Testing',
        summary: noteText,
        topics: ['deployment', 'testing'],
        actions: [
          ContextualAction(type: 'completed', subject: 'deployment'),
          ContextualAction(type: 'planned', subject: 'testing'),
        ],
        references: [
          ContextualReference(text: 'this', type: 'anaphora', resolution: null),
        ],
      );

      const candidateReadSmart = ContextCandidate(
        contextId: 'ctx-readsmart',
        contextName: 'ReadSmart AI',
        contextPath: 'Meeting with Dean └── Project Discussion └── ReadSmart AI',
        semanticSimilarity: 0.82,
        graphRelevance: 0.91,
        temporalRelevance: 0.88,
        lexicalRelevance: 0.85,
        totalScore: 0.87,
        matchedSignals: [
          'Action subject "deployment" matches context "ReadSmart AI"',
          'Active session (< 2 hrs ago)',
        ],
      );

      const candidateFC = ContextCandidate(
        contextId: 'ctx-fc',
        contextName: 'FC',
        contextPath: 'FC',
        semanticSimilarity: 0.35,
        graphRelevance: 0.30,
        temporalRelevance: 0.50,
        lexicalRelevance: 0.40,
        totalScore: 0.42,
      );

      final result = agent.resolve(
        noteText: noteText,
        analysis: analysis,
        candidates: [candidateReadSmart, candidateFC],
        noteTimestamp: now,
      );

      expect(result.outcome, ResolutionOutcome.autoAttach);
      expect(result.isAutoAttached, isTrue);
      expect(result.targetContextId, 'ctx-readsmart');
      expect(result.targetContextName, 'ReadSmart AI');
      expect(result.confidence, 0.87);
      expect(result.candidateBreakdowns.length, 2);
      expect(result.candidateBreakdowns.first.candidateName, 'ReadSmart AI');
      expect(result.candidateBreakdowns.first.finalScore, 0.87);
    });

    test('2. Canonical AMBIGUOUS: Low margin between candidates (ReadSmart AI = 0.61 vs FC = 0.59)', () {
      const noteText = 'Worked on sprint deployment.';
      const analysis = NoteAnalysisResult(
        topic: 'Sprint Deployment',
        summary: noteText,
        topics: ['deployment'],
        actions: [ContextualAction(type: 'in_progress', subject: 'deployment')],
      );

      const candidateReadSmart = ContextCandidate(
        contextId: 'ctx-readsmart',
        contextName: 'ReadSmart AI',
        contextPath: 'ReadSmart AI',
        semanticSimilarity: 0.60,
        graphRelevance: 0.60,
        temporalRelevance: 0.60,
        lexicalRelevance: 0.65,
        totalScore: 0.61,
      );

      const candidateFC = ContextCandidate(
        contextId: 'ctx-fc',
        contextName: 'FC',
        contextPath: 'FC',
        semanticSimilarity: 0.58,
        graphRelevance: 0.60,
        temporalRelevance: 0.60,
        lexicalRelevance: 0.60,
        totalScore: 0.59,
      );

      final result = agent.resolve(
        noteText: noteText,
        analysis: analysis,
        candidates: [candidateReadSmart, candidateFC],
        noteTimestamp: now,
      );

      // System must NEVER auto-attach when margin is only 0.02
      expect(result.outcome, ResolutionOutcome.ambiguous);
      expect(result.isAmbiguous, isTrue);
      expect(result.isAutoAttached, isFalse);
      expect(result.ambiguousCandidates.length, 2);
      expect(result.ambiguousCandidates.map((c) => c.candidateName).toSet(), containsAll(['ReadSmart AI', 'FC']));
      expect(result.reasoningSummary.contains('Ambiguous match'), isTrue);
    });

    test('3. MULTI_ATTACH: High confidence across multiple non-conflicting parent contexts', () {
      const noteText = 'Working on backend services for Alpha during my internship.';
      const analysis = NoteAnalysisResult(
        topic: 'Internship Work',
        summary: noteText,
        topics: ['backend', 'internship'],
        actions: [ContextualAction(type: 'in_progress', subject: 'backend')],
      );

      const candidateAlpha = ContextCandidate(
        contextId: 'ctx-alpha',
        contextName: 'Project Alpha',
        contextPath: 'Project Alpha',
        totalScore: 0.85,
      );

      const candidateInternship = ContextCandidate(
        contextId: 'ctx-intern',
        contextName: 'Summer Internship',
        contextPath: 'Summer Internship',
        totalScore: 0.82,
      );

      final result = agent.resolve(
        noteText: noteText,
        analysis: analysis,
        candidates: [candidateAlpha, candidateInternship],
        noteTimestamp: now,
        isMultiContextSupported: true,
      );

      expect(result.outcome, ResolutionOutcome.multiAttach);
      expect(result.isMultiAttached, isTrue);
      expect(result.targetContextId, 'ctx-alpha');
      expect(result.additionalTargetContextIds, contains('ctx-intern'));
    });

    test('4. NEW_CONTEXT: Explicit mention of a new project when no candidate matches', () {
      const noteText = 'Kickoff meeting for Project Hyperion with tech lead.';
      const analysis = NoteAnalysisResult(
        topic: 'Project Hyperion Kickoff',
        summary: noteText,
        project: 'Project Hyperion',
        events: ['Kickoff meeting for Project Hyperion'],
      );

      final result = agent.resolve(
        noteText: noteText,
        analysis: analysis,
        candidates: const [],
        noteTimestamp: now,
      );

      expect(result.outcome, ResolutionOutcome.newContext);
      expect(result.isNewContext, isTrue);
      expect(result.suggestedNewContextName, 'Project Hyperion');
      expect(result.suggestedNewContextType, 'project');
    });

    test('5. UNRESOLVED: Dangling references with low candidate scores (< 0.40)', () {
      const noteText = 'I tested this and it broke.';
      const analysis = NoteAnalysisResult(
        topic: 'Testing issue',
        summary: noteText,
        references: [
          ContextualReference(text: 'this', type: 'anaphora', resolution: null),
          ContextualReference(text: 'it', type: 'anaphora', resolution: null),
        ],
      );

      const candidateWeak = ContextCandidate(
        contextId: 'ctx-old-app',
        contextName: 'Old Legacy App',
        contextPath: 'Old Legacy App',
        totalScore: 0.22,
      );

      final result = agent.resolve(
        noteText: noteText,
        analysis: analysis,
        candidates: [candidateWeak],
        noteTimestamp: now,
      );

      expect(result.outcome, ResolutionOutcome.unresolved);
      expect(result.isUnresolved, isTrue);
      expect(result.unresolvedReferences, containsAll(['this', 'it']));
    });

    test('6. IGNORE: Short or trivial scratchpad content', () {
      const analysis = NoteAnalysisResult(
        topic: 'Short',
        summary: 'hi',
      );

      final result = agent.resolve(
        noteText: 'hi',
        analysis: analysis,
        candidates: const [],
        noteTimestamp: now,
      );

      expect(result.outcome, ResolutionOutcome.ignore);
      expect(result.isIgnored, isTrue);
    });

    test('7. Transparent Multi-Signal Score Breakdown serialization', () {
      const candidate = ContextCandidate(
        contextId: 'ctx-readsmart',
        contextName: 'ReadSmart AI',
        contextPath: 'Meeting with Dean └── ReadSmart AI',
        semanticSimilarity: 0.82,
        graphRelevance: 0.91,
        temporalRelevance: 0.88,
        lexicalRelevance: 0.85,
        totalScore: 0.87,
        matchedSignals: ['Action match', 'Session active'],
      );

      const noteText = 'I finished the deployment.';
      const analysis = NoteAnalysisResult(
        topic: 'Deployment',
        summary: noteText,
      );

      final result = agent.resolve(
        noteText: noteText,
        analysis: analysis,
        candidates: [candidate],
        noteTimestamp: now,
      );

      final breakdown = result.candidateBreakdowns.first;
      expect(breakdown.signals.containsKey('semantic'), isTrue);
      expect(breakdown.signals.containsKey('entity'), isTrue);
      expect(breakdown.signals.containsKey('graph'), isTrue);
      expect(breakdown.signals.containsKey('temporal'), isTrue);
      expect(breakdown.signals.containsKey('recency'), isTrue);
      expect(breakdown.signals.containsKey('lexical'), isTrue);
      expect(breakdown.signals.containsKey('explicitMention'), isTrue);
      expect(breakdown.signals.containsKey('previousReference'), isTrue);

      final json = breakdown.toJson();
      expect(json['candidate'], 'ReadSmart AI');
      expect(json['finalScore'], 0.87);
      expect(json['signals'], isA<Map<String, dynamic>>());
    });
  });
}
