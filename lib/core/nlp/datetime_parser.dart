/// Isolated Natural Language Date/Time Parser for Alarm & Reminder scheduling.
class DateTimeParser {
  DateTimeParser._();

  /// Parses natural language expressions such as:
  /// - "in 45 minutes", "in 2 hours"
  /// - "tomorrow at 9:00 AM", "tomorrow at 18:30"
  /// - "next Monday at 8:30", "this Friday at 5pm"
  /// - "at 7:00 AM", "at 20:00"
  /// Returns `null` if unable to parse a confident DateTime.
  static DateTime? parse(String input, {DateTime? referenceTime}) {
    final now = referenceTime ?? DateTime.now();
    final text = input.toLowerCase().trim();
    if (text.isEmpty) return null;

    // 1. Relative offset parsing: "in/after X minutes/hours/days"
    final relativeRegex = RegExp(r'\b(?:in|after)\s+(\d+)\s+(minute|min|hour|hr|day)s?\b');
    final relativeMatch = relativeRegex.firstMatch(text);
    if (relativeMatch != null) {
      final amount = int.parse(relativeMatch.group(1)!);
      final unit = relativeMatch.group(2)!;
      if (unit.startsWith('min')) {
        return now.add(Duration(minutes: amount));
      } else if (unit.startsWith('hour') || unit.startsWith('hr')) {
        return now.add(Duration(hours: amount));
      } else if (unit.startsWith('day')) {
        return now.add(Duration(days: amount));
      }
    }

    // Extract target time of day (e.g. "9am", "7:30 PM", "18:00")
    final timeResult = _extractTimeOfDay(text);
    final hour = timeResult?.hour ?? 9; // Default to 9:00 AM if no time specified
    final minute = timeResult?.minute ?? 0;

    // 2. "Tomorrow" detection
    if (text.contains('tomorrow')) {
      final targetDate = now.add(const Duration(days: 1));
      return DateTime(targetDate.year, targetDate.month, targetDate.day, hour, minute);
    }

    // 3. Day of week detection: "next monday", "this friday"
    final daysOfWeek = {
      'monday': DateTime.monday,
      'tuesday': DateTime.tuesday,
      'wednesday': DateTime.wednesday,
      'thursday': DateTime.thursday,
      'friday': DateTime.friday,
      'saturday': DateTime.saturday,
      'sunday': DateTime.sunday,
      'mon': DateTime.monday,
      'tue': DateTime.tuesday,
      'wed': DateTime.wednesday,
      'thu': DateTime.thursday,
      'fri': DateTime.friday,
      'sat': DateTime.saturday,
      'sun': DateTime.sunday,
    };

    for (final entry in daysOfWeek.entries) {
      if (text.contains(entry.key)) {
        final targetWeekday = entry.value;
        int daysUntil = targetWeekday - now.weekday;
        if (daysUntil <= 0) daysUntil += 7; // Next occurrence
        final targetDate = now.add(Duration(days: daysUntil));
        return DateTime(targetDate.year, targetDate.month, targetDate.day, hour, minute);
      }
    }

    // 4. "Today" or explicit time provided
    if (text.contains('today') || text.contains('tonight') || timeResult != null) {
      var candidate = DateTime(now.year, now.month, now.day, hour, minute);
      if (candidate.isBefore(now)) {
        // If time is earlier today, schedule for tomorrow at that time
        candidate = candidate.add(const Duration(days: 1));
      }
      return candidate;
    }

    return null;
  }

  static ({int hour, int minute})? _extractTimeOfDay(String text) {
    // 12-hour or 24-hour with minutes: "7:30 pm", "18:00", "9:00am"
    final timeMinRegex = RegExp(r'\b(\d{1,2}):(\d{2})\s*(am|pm)?\b');
    final minMatch = timeMinRegex.firstMatch(text);
    if (minMatch != null) {
      int h = int.parse(minMatch.group(1)!);
      final m = int.parse(minMatch.group(2)!);
      final ampm = minMatch.group(3);

      if (ampm == 'pm' && h < 12) h += 12;
      if (ampm == 'am' && h == 12) h = 0;
      return (hour: h % 24, minute: m);
    }

    // Hour only with am/pm or o'clock: "9am", "5 pm", "11pm", "6 o'clock"
    final hourAmPmRegex = RegExp(r'\b(\d{1,2})\s*(?:o\s*clock|am|pm)\b');
    final hourMatch = hourAmPmRegex.firstMatch(text);
    if (hourMatch != null) {
      int h = int.parse(hourMatch.group(1)!);
      final raw = hourMatch.group(0)!;
      if (raw.contains('pm') && h < 12) h += 12;
      if (raw.contains('am') && h == 12) h = 0;
      return (hour: h % 24, minute: 0);
    }

    // Explicit "at 6" / "for 7"
    final atForRegex = RegExp(r'\b(?:at|for)\s+(\d{1,2})\b');
    final atForMatch = atForRegex.firstMatch(text);
    if (atForMatch != null) {
      int h = int.parse(atForMatch.group(1)!);
      if (h >= 1 && h <= 24) {
        if (text.contains('night') || text.contains('evening') || text.contains('pm')) {
          if (h < 12) h += 12;
        }
        return (hour: h % 24, minute: 0);
      }
    }

    return null;
  }
}
