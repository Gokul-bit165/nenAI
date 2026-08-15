import 'package:flutter_test/flutter_test.dart';
import 'package:nenai/core/nlp/datetime_parser.dart';

void main() {
  group('DateTimeParser', () {
    final reference = DateTime(2026, 8, 4, 10, 0); // Tuesday, Aug 4, 2026 @ 10:00 AM

    test('Parses relative minutes offset', () {
      final parsed = DateTimeParser.parse('in 30 minutes', referenceTime: reference);
      expect(parsed, equals(DateTime(2026, 8, 4, 10, 30)));
    });

    test('Parses relative hours offset', () {
      final parsed = DateTimeParser.parse('in 2 hours', referenceTime: reference);
      expect(parsed, equals(DateTime(2026, 8, 4, 12, 0)));
    });

    test('Parses tomorrow with explicit time', () {
      final parsed = DateTimeParser.parse('tomorrow at 8:30 AM', referenceTime: reference);
      expect(parsed, equals(DateTime(2026, 8, 5, 8, 30)));
    });

    test('Parses relative minutes with after keyword', () {
      final parsed = DateTimeParser.parse('after 10 mins', referenceTime: reference);
      expect(parsed, equals(DateTime(2026, 8, 4, 10, 10)));
    });

    test('Parses explicit am/pm time', () {
      final parsed = DateTimeParser.parse('set alarm for 6 am', referenceTime: reference);
      expect(parsed, equals(DateTime(2026, 8, 5, 6, 0))); // next 6 AM
    });

    test('Parses time with minutes and am/pm', () {
      final parsed = DateTimeParser.parse('alarm at 7:30 pm', referenceTime: reference);
      expect(parsed, equals(DateTime(2026, 8, 4, 19, 30)));
    });
  });
}
