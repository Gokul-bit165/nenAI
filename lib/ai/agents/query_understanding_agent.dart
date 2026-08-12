import '../memory/retrieval_planner.dart';

class QueryUnderstandingResult {
  const QueryUnderstandingResult({
    required this.plan,
    this.actionIntent,
    this.actionTitle,
  });

  final RetrievalPlan plan;
  final String? actionIntent;
  final String? actionTitle;
}

class QueryUnderstandingAgent {
  QueryUnderstandingAgent(this._retrievalPlanner);

  final RetrievalPlanner _retrievalPlanner;

  Future<QueryUnderstandingResult> analyzeQuery(String message) async {
    final lower = message.toLowerCase().trim();
    final plan = await _retrievalPlanner.plan(message);

    String? actionIntent;
    String? actionTitle;

    // Detect Alarm Intent
    if (lower.contains('alarm') || lower.contains('remind me') || lower.contains('schedule reminder')) {
      actionIntent = 'set_alarm';
      if (lower.contains('remind me to')) {
        actionTitle = message.substring(message.toLowerCase().indexOf('remind me to') + 12).trim();
      } else if (lower.contains('alarm for')) {
        actionTitle = message.substring(message.toLowerCase().indexOf('alarm for') + 9).trim();
      } else {
        actionTitle = 'Reminder';
      }
    }
    // Detect Calendar Intent
    else if (lower.contains('calendar') || lower.contains('schedule meeting') || lower.contains('add event')) {
      actionIntent = 'create_calendar_event';
      if (lower.contains('meeting with')) {
        actionTitle = message.substring(message.toLowerCase().indexOf('meeting with')).trim();
      } else if (lower.contains('add')) {
        actionTitle = message.substring(message.toLowerCase().indexOf('add') + 3).trim();
      } else {
        actionTitle = 'Calendar Event';
      }
    }
    // Detect Stats Intent
    else if (lower.contains('how many notes') || lower.contains('count notes') || lower.contains('memory stats')) {
      actionIntent = 'get_memory_stats';
    }

    return QueryUnderstandingResult(
      plan: plan,
      actionIntent: actionIntent,
      actionTitle: actionTitle,
    );
  }
}
