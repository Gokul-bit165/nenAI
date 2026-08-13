import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nenai/presentation/components/context_breadcrumb_path.dart';
import 'package:nenai/presentation/components/memory_understanding_card.dart';

void main() {
  group('Phase 13: Memory Understanding UI Tests', () {
    testWidgets('1. ContextBreadcrumbPath renders full hierarchical path with arrows', (tester) async {
      final pathNodes = [
        'Meeting with Dean',
        'Project Discussion',
        'ReadSmart AI',
        'Deployment',
        'Testing',
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ContextBreadcrumbPath(pathNodes: pathNodes),
          ),
        ),
      );

      // Verify all node texts are present
      expect(find.text('Meeting with Dean'), findsOneWidget);
      expect(find.text('Project Discussion'), findsOneWidget);
      expect(find.text('ReadSmart AI'), findsOneWidget);
      expect(find.text('Deployment'), findsOneWidget);
      expect(find.text('Testing'), findsOneWidget);

      // Verify chevron separators (4 arrows for 5 nodes)
      expect(find.byIcon(Icons.chevron_right_rounded), findsNWidgets(4));
    });

    testWidgets('2. MemoryUnderstandingCard renders canonical WHAT NENAI UNDERSTOOD state', (tester) async {
      const contextName = 'ReadSmart AI';
      const contextType = 'project';
      final pathNodes = [
        'Meeting with Dean',
        'Project Discussion',
        'ReadSmart AI',
        'Deployment',
        'Testing',
      ];
      const reason = 'Recent memories connect deployment and testing to ReadSmart AI.';
      final evidenceSignals = [
        'ReadSmart AI deployment was recently discussed',
        'Testing is associated with the deployment',
        'Same project context',
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: MemoryUnderstandingCard(
                contextName: contextName,
                contextType: contextType,
                pathNodes: pathNodes,
                reason: reason,
                confidenceLevel: 'High',
                evidenceSignals: evidenceSignals,
                statusText: 'Automatically connected',
              ),
            ),
          ),
        ),
      );

      // 1. Header Banner
      expect(find.text('WHAT NENAI UNDERSTOOD'), findsOneWidget);
      expect(find.text('✓ Automatically connected'), findsOneWidget);

      // 2. Context & Type
      expect(find.text('ReadSmart AI'), findsWidgets);
      expect(find.text('PROJECT'), findsOneWidget);

      // 3. Reason
      expect(find.text(reason), findsOneWidget);

      // 4. Confidence
      expect(find.text('High'), findsOneWidget);

      // 5. Evidence
      expect(find.text('ReadSmart AI deployment was recently discussed'), findsOneWidget);
      expect(find.text('Testing is associated with the deployment'), findsOneWidget);
      expect(find.text('Same project context'), findsOneWidget);
    });

    testWidgets('3. MemoryUnderstandingCard renders Ambiguous Clarification Panel and handles actions', (tester) async {
      String? selectedCandidateId;
      bool bothSelected = false;
      bool createNewSelected = false;

      final candidates = [
        const CandidateOption(
          id: 'ctx-rs',
          name: 'ReadSmart AI',
          scorePercent: 61,
          evidenceSummary: 'Recent deployment and testing activity',
        ),
        const CandidateOption(
          id: 'ctx-fc',
          name: 'FC',
          scorePercent: 59,
          evidenceSummary: 'Deployment completed in previous session',
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: MemoryUnderstandingCard(
                contextName: 'Multiple Candidates',
                pathNodes: const [],
                isAmbiguous: true,
                candidateOptions: candidates,
                onSelectCandidate: (id) => selectedCandidateId = id,
                onSelectBoth: () => bothSelected = true,
                onCreateNewContext: () => createNewSelected = true,
              ),
            ),
          ),
        ),
      );

      // Verify Ambiguous Header
      expect(find.text('Context uncertain'), findsOneWidget);
      expect(find.text('I found multiple possible matching contexts for this note:'), findsOneWidget);

      // Verify Candidates & Scores
      expect(find.text('ReadSmart AI'), findsOneWidget);
      expect(find.text('61%'), findsOneWidget);
      expect(find.text('FC'), findsOneWidget);
      expect(find.text('59%'), findsOneWidget);

      // Verify Action Buttons
      expect(find.text('Choose ReadSmart AI'), findsOneWidget);
      expect(find.text('Choose FC'), findsOneWidget);
      expect(find.text('Both'), findsOneWidget);
      expect(find.text('Create New Context'), findsOneWidget);

      // Tap "Choose ReadSmart AI"
      await tester.tap(find.text('Choose ReadSmart AI'));
      await tester.pump();
      expect(selectedCandidateId, 'ctx-rs');

      // Tap "Both"
      await tester.tap(find.text('Both'));
      await tester.pump();
      expect(bothSelected, isTrue);

      // Tap "Create New Context"
      await tester.tap(find.text('Create New Context'));
      await tester.pump();
      expect(createNewSelected, isTrue);
    });
  });
}
