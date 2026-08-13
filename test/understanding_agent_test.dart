import 'package:flutter_test/flutter_test.dart';
import 'package:nenai/ai/agents/understanding_agent.dart';
import 'package:nenai/ai/stub/stub_intelligence_engine.dart';

void main() {
  late StubIntelligenceEngine engine;
  late UnderstandingAgent agent;

  setUp(() {
    engine = StubIntelligenceEngine();
    agent = UnderstandingAgent(engine);
  });

  group('Phase 3: Context-Aware Understanding Agent Tests', () {
    test('1. Canonical Note: Actions, Anaphora Detection & Unresolved References', () async {
      const note = 'I finished the deployment and now I want to test this.';

      final result = await agent.understand(note);

      expect(result, isNotNull);

      // Actions
      expect(result!.actions.isNotEmpty, isTrue);
      final completedAction = result.actions.firstWhere((a) => a.type == 'completed');
      expect(completedAction.subject, 'deployment');

      final plannedAction = result.actions.firstWhere((a) => a.type == 'planned');
      expect(plannedAction.subject, 'testing');

      // References & Anaphora
      expect(result.references.isNotEmpty, isTrue);
      final thisRef = result.references.firstWhere((r) => r.text == 'this');
      expect(thisRef.type, 'anaphora');
      expect(thisRef.resolution, isNull);
      expect(thisRef.isUnresolved, isTrue);

      // Unresolved references list
      expect(result.unresolvedReferences, contains('this'));

      // Topics
      expect(result.topics, containsAll(['deployment', 'testing']));

      // Must NOT invent or hallucinate a project when not mentioned
      expect(result.project, isNull);
    });

    test('2. Explicit Entities, People, Events, Tasks & Temporal References', () async {
      const note = 'Meeting with Dean about ReadSmart AI. Arun suggested we should optimize SQLite vector search tomorrow.';

      final result = await agent.understand(note);

      expect(result, isNotNull);

      // Entities
      final entityNames = result!.entities.map((e) => e.name).toList();
      expect(entityNames, contains('ReadSmart AI'));
      expect(entityNames, contains('Arun'));

      // People
      expect(result.people, contains('Arun'));

      // Project
      expect(result.project, 'ReadSmart AI');

      // Events
      expect(result.events.any((e) => e.contains('Meeting with Dean')), isTrue);

      // Tasks
      expect(result.tasks.isNotEmpty, isTrue);
      expect(result.tasks.any((t) => t.time == 'tomorrow'), isTrue);

      // Temporal References
      expect(result.temporalReferences, contains('tomorrow'));
    });

    test('3. Multiple Pronouns and Anaphoric References Detection', () async {
      const note = 'He reviewed that pull request and they will deploy it tonight.';

      final result = await agent.understand(note);

      expect(result, isNotNull);

      final refTexts = result!.references.map((r) => r.text).toSet();
      expect(refTexts, containsAll(['he', 'that', 'they', 'it']));

      // All pronouns are unresolved locally without guessing
      expect(result.unresolvedReferences, containsAll(['he', 'that', 'they', 'it']));
    });

    test('4. Empty and Edge Case Robustness', () async {
      final emptyResult = await agent.understand('   ');
      expect(emptyResult, isNull);

      final shortResult = await agent.understand('Quick note.');
      expect(shortResult, isNotNull);
      expect(shortResult!.summary, isNotEmpty);
    });
  });
}
