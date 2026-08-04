import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memai/presentation/theme/app_theme.dart';
import 'package:memai/presentation/components/keyword_chip.dart';

void main() {
  testWidgets('KeywordChip renders label correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: const Scaffold(
          body: KeywordChip(label: 'flutter'),
        ),
      ),
    );

    expect(find.text('#flutter'), findsOneWidget);
  });
}
