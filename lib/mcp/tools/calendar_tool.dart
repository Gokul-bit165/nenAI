import '../../core/nlp/datetime_parser.dart';
import '../../core/services/calendar_service.dart';
import '../tool_protocol.dart';

/// Tool for creating calendar events via natural language parsing.
class CreateCalendarEventTool implements McpTool {
  CreateCalendarEventTool(this._calendarService);

  final CalendarService _calendarService;

  @override
  String get name => 'create_calendar_event';

  @override
  String get description => 'Schedules a new event on the calendar.';

  @override
  PermissionLevel get permissionLevel => PermissionLevel.writeSchedule;

  @override
  Map<String, String> get parametersSchema => {
        'title': 'Short title for the event',
        'timeExpression': 'Natural language time (e.g. "tomorrow at 3 PM", "next Friday at 10 AM")',
      };

  @override
  Future<McpToolResult> execute(Map<String, dynamic> params) async {
    final title = params['title'] as String? ?? 'New Event';
    final timeExpression = params['timeExpression'] as String? ?? '';

    final startTime = DateTimeParser.parse(timeExpression);
    if (startTime == null) {
      return McpToolResult(
        success: false,
        resultData: {},
        userDisplayMessage: 'Could not parse date/time from "$timeExpression". Please specify like "tomorrow at 3:00 PM".',
      );
    }

    final event = await _calendarService.createEvent(
      title: title,
      startTime: startTime,
    );

    final formattedTime = '${startTime.year}-${startTime.month.toString().padLeft(2, '0')}-${startTime.day.toString().padLeft(2, '0')} at ${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';

    return McpToolResult(
      success: true,
      resultData: {
        'eventId': event.id,
        'title': event.title,
        'startTime': event.startTime.toIso8601String(),
      },
      userDisplayMessage: 'Calendar event "$title" added for $formattedTime.',
    );
  }
}

/// Tool for querying scheduled calendar events.
class GetCalendarEventsTool implements McpTool {
  GetCalendarEventsTool(this._calendarService);

  final CalendarService _calendarService;

  @override
  String get name => 'get_calendar_events';

  @override
  String get description => 'Retrieves upcoming calendar events.';

  @override
  PermissionLevel get permissionLevel => PermissionLevel.read;

  @override
  Map<String, String> get parametersSchema => {};

  @override
  Future<McpToolResult> execute(Map<String, dynamic> params) async {
    final events = _calendarService.getAllEvents();
    final mapped = events
        .map((e) => {
              'id': e.id,
              'title': e.title,
              'startTime': e.startTime.toIso8601String(),
            })
        .toList();

    return McpToolResult(
      success: true,
      resultData: {'events': mapped},
      userDisplayMessage: 'Found ${events.length} calendar events.',
    );
  }
}
