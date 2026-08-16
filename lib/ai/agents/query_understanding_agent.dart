import '../memory/retrieval_planner.dart';

/// The memory operation intent inferred from a user message.
///
/// Intent and context ambiguity are independent axes:
///   - Intent: *what kind of operation* (update, create, correct, …)
///   - Context: *which entity/project* (resolved by ContextResolutionAgent gates)
///
/// A message like "I finished the deployment" has:
///   Intent = [update]       ← fast deterministic rule
///   Context = AMBIGUOUS     ← two candidates with similar scores → ask user
enum MemoryIntent {
  /// User is asking a question about stored memory. → KGQueryEngine path.
  recall,

  /// User is creating a new entity, project, or concept that doesn't exist yet.
  create,

  /// User is adding a property/fact to an entity that already exists.
  add,

  /// User is marking a state change or completion on an existing entity.
  update,

  /// User is explicitly correcting a previously stored fact.
  /// Marker: "actually", "no wait", "not X but Y", "I meant", "correction".
  correct,

  /// User is connecting two known entities with a relationship.
  /// E.g. "Dean suggested Gemma for NENAI."
  link,

  /// User is capturing an action item or deadline.
  task,

  /// Alarm, calendar, or stats tool invocation.
  action,

  /// Could not be confidently classified — treated as [update] in the
  /// formation path (safest default for content-bearing statements).
  unknown,
}

class QueryUnderstandingResult {
  const QueryUnderstandingResult({
    required this.plan,
    required this.memoryIntent,
    this.actionIntent,
    this.actionTitle,
  });

  final RetrievalPlan plan;

  /// Semantic intent of the message — determines routing in [ChatService].
  final MemoryIntent memoryIntent;

  /// Non-null for tool-invocation intents (alarm, calendar, stats).
  final String? actionIntent;
  final String? actionTitle;

  bool get isFormation =>
      memoryIntent != MemoryIntent.recall && memoryIntent != MemoryIntent.action;

  bool get isRecall => memoryIntent == MemoryIntent.recall;
}

class QueryUnderstandingAgent {
  QueryUnderstandingAgent(this._retrievalPlanner);

  final RetrievalPlanner _retrievalPlanner;

  /// Classifies [message] into a [MemoryIntent] using fast deterministic
  /// rules — no LLM call required. The full semantics are handled downstream
  /// by [UnderstandingAgent] when in the formation path.
  Future<QueryUnderstandingResult> analyzeQuery(String message) async {
    final lower = message.toLowerCase().trim();
    final plan = await _retrievalPlanner.plan(message);

    // ── Tool (action) intents ─────────────────────────────────────────────
    String? actionIntent;
    String? actionTitle;

    if (lower.contains('alarm') ||
        lower.contains('remind') ||
        lower.contains('wake me') ||
        lower.contains('set timer') ||
        lower.contains('schedule reminder')) {
      actionIntent = 'set_alarm';
      if (lower.contains('remind me to')) {
        actionTitle = message.substring(message.toLowerCase().indexOf('remind me to') + 12).trim();
      } else if (lower.contains('remind me')) {
        actionTitle = message.substring(message.toLowerCase().indexOf('remind me') + 9).trim();
      } else if (lower.contains('alarm for')) {
        actionTitle = message.substring(message.toLowerCase().indexOf('alarm for') + 9).trim();
      } else if (lower.contains('wake me up')) {
        actionTitle = 'Morning Alarm';
      } else {
        actionTitle = 'Alarm';
      }

      return QueryUnderstandingResult(
        plan: plan,
        memoryIntent: MemoryIntent.action,
        actionIntent: actionIntent,
        actionTitle: actionTitle,
      );
    }

    if (lower.contains('calendar') ||
        lower.contains('schedule meeting') ||
        lower.contains('add event')) {
      actionIntent = 'create_calendar_event';
      if (lower.contains('meeting with')) {
        actionTitle = message.substring(message.toLowerCase().indexOf('meeting with')).trim();
      } else if (lower.contains('add')) {
        actionTitle = message.substring(message.toLowerCase().indexOf('add') + 3).trim();
      } else {
        actionTitle = 'Calendar Event';
      }

      return QueryUnderstandingResult(
        plan: plan,
        memoryIntent: MemoryIntent.action,
        actionIntent: actionIntent,
        actionTitle: actionTitle,
      );
    }

    if (lower.contains('how many notes') ||
        lower.contains('count notes') ||
        lower.contains('memory stats')) {
      return QueryUnderstandingResult(
        plan: plan,
        memoryIntent: MemoryIntent.action,
        actionIntent: 'get_memory_stats',
      );
    }

    // ── Memory intent classification ──────────────────────────────────────

    // 1. RECALL — question word patterns
    final recallPattern = RegExp(
      r'^(what|when|where|who|which|how|did|does|do|is|are|was|were|can|could|show|tell|give|find|list)',
    );
    if (recallPattern.hasMatch(lower)) {
      return QueryUnderstandingResult(
        plan: plan,
        memoryIntent: MemoryIntent.recall,
      );
    }

    // 2. CORRECT — explicit correction markers
    final correctMarkers = RegExp(
      r'\b(actually|correction|no wait|i meant|not .+ but|should be|was wrong|update that|change that)\b',
      caseSensitive: false,
    );
    if (correctMarkers.hasMatch(lower)) {
      return QueryUnderstandingResult(
        plan: plan,
        memoryIntent: MemoryIntent.correct,
      );
    }

    // 3. TASK — action item / deadline markers
    final taskMarkers = RegExp(
      r'\b(need to|have to|should|todo|to-do|to do|by tomorrow|deadline|due date|follow up|follow-up)\b',
      caseSensitive: false,
    );
    if (taskMarkers.hasMatch(lower)) {
      return QueryUnderstandingResult(
        plan: plan,
        memoryIntent: MemoryIntent.task,
      );
    }

    // 4. CREATE — explicit new entity creation
    final createPattern = RegExp(
      r'\b(new project|new company|new person|started a new|created a new|i started|just started|beginning|launched a new)\b',
      caseSensitive: false,
    );
    if (createPattern.hasMatch(lower)) {
      return QueryUnderstandingResult(
        plan: plan,
        memoryIntent: MemoryIntent.create,
      );
    }

    // 5. LINK — two proper-noun entities + linking verb
    // e.g. "Dean suggested Gemma for NENAI", "Priya introduced me to FC"
    final linkVerbs = RegExp(
      r'\b(suggested|recommended|introduced|mentioned to|connected|linked|referred|hired|assigned|brought in)\b',
      caseSensitive: false,
    );
    // Also check: message has two capitalized words (rough entity proxy)
    final capitalizedWords = RegExp(r'\b[A-Z][a-zA-Z]+\b').allMatches(message);
    if (linkVerbs.hasMatch(lower) && capitalizedWords.length >= 2) {
      return QueryUnderstandingResult(
        plan: plan,
        memoryIntent: MemoryIntent.link,
      );
    }

    // 6. UPDATE — state-change / completion verbs (past tense + "I/we" subject)
    final updatePattern = RegExp(
      r'\b(i |we )(finished|completed|deployed|shipped|launched|fixed|closed|resolved|merged|released|approved|rejected|cancelled|paused|resumed)\b',
      caseSensitive: false,
    );
    if (updatePattern.hasMatch(lower)) {
      return QueryUnderstandingResult(
        plan: plan,
        memoryIntent: MemoryIntent.update,
      );
    }

    // 7. ADD — adding a property/attribute to a known entity
    final addPattern = RegExp(
      r'\b(it uses|built with|using|runs on|implemented in|works with|integrates|connects to|powered by)\b',
      caseSensitive: false,
    );
    if (addPattern.hasMatch(lower)) {
      return QueryUnderstandingResult(
        plan: plan,
        memoryIntent: MemoryIntent.add,
      );
    }

    // Default — treat as unknown (formation path, context resolution handles the rest)
    return QueryUnderstandingResult(
      plan: plan,
      memoryIntent: MemoryIntent.unknown,
    );
  }
}
