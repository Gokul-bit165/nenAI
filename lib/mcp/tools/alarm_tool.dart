import '../../core/nlp/datetime_parser.dart';
import '../../core/services/alarm_service.dart';
import '../tool_protocol.dart';

/// Tool for setting alarms and reminders using natural language date/time parsing.
class SetAlarmTool implements McpTool {
  SetAlarmTool(this._alarmService);

  final AlarmService _alarmService;

  @override
  String get name => 'set_alarm';

  @override
  String get description => 'Schedules an offline alarm or reminder for a specific date and time.';

  @override
  PermissionLevel get permissionLevel => PermissionLevel.writeSchedule;

  @override
  Map<String, String> get parametersSchema => {
        'title': 'Short title for the alarm or reminder',
        'timeExpression': 'Natural language time expression (e.g., "tomorrow at 8:00 AM", "in 30 minutes")',
      };

  @override
  Future<McpToolResult> execute(Map<String, dynamic> params) async {
    final title = params['title'] as String? ?? 'MemAI Reminder';
    final timeExpression = params['timeExpression'] as String? ?? '';

    final scheduledTime = DateTimeParser.parse(timeExpression);
    if (scheduledTime == null) {
      return McpToolResult(
        success: false,
        resultData: {},
        userDisplayMessage: 'Could not parse date/time from "$timeExpression". Please specify time like "tomorrow at 8:00 AM" or "in 30 mins".',
      );
    }

    final id = await _alarmService.scheduleAlarm(
      title: title,
      body: 'Reminder: $title',
      scheduledTime: scheduledTime,
    );

    final formattedTime = '${scheduledTime.year}-${scheduledTime.month.toString().padLeft(2, '0')}-${scheduledTime.day.toString().padLeft(2, '0')} at ${scheduledTime.hour.toString().padLeft(2, '0')}:${scheduledTime.minute.toString().padLeft(2, '0')}';

    return McpToolResult(
      success: true,
      resultData: {
        'alarmId': id,
        'title': title,
        'scheduledTime': scheduledTime.toIso8601String(),
      },
      userDisplayMessage: 'Alarm set for $formattedTime ("$title").',
    );
  }
}
