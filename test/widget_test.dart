import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nenai/presentation/theme/app_theme.dart';
import 'package:nenai/presentation/components/keyword_chip.dart';
import 'package:nenai/presentation/components/cluster_chip.dart';
import 'package:nenai/presentation/components/processing_badge.dart';
import 'package:nenai/presentation/components/ai_summary_card.dart';
import 'package:nenai/domain/entities/processing_status.dart';

void main() {
  group('UI Components Test', () {
    testWidgets('KeywordChip renders label correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: KeywordChip(label: 'flutter'),
          ),
        ),
      );

      expect(find.text('flutter'), findsOneWidget);
    });

    testWidgets('ClusterChip renders cluster name correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: ClusterChip(name: 'Technology'),
          ),
        ),
      );

      expect(find.text('Technology'), findsOneWidget);
    });

    testWidgets('ProcessingBadge renders Done for completed status', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: ProcessingBadge(status: ProcessingStatus.completed),
          ),
        ),
      );

      expect(find.text('Done'), findsOneWidget);
      expect(find.byIcon(Icons.check_rounded), findsOneWidget);
    });

    testWidgets('AISummaryCard renders header and summary text', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: AISummaryCard(summary: 'This note explains quantum computing.'),
          ),
        ),
      );

      expect(find.text('AI Summary'), findsOneWidget);
      expect(find.text('This note explains quantum computing.'), findsOneWidget);
    });
  });
}
