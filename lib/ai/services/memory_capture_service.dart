import 'dart:async';
import '../../background/note_processing_isolate.dart';
import '../../data/local/database/app_database.dart';

/// Shared entry point for both note and chat memory capture.
///
/// ## Responsibilities
/// - Runs the cheap pre-filter ([containsMemoryContent]) before hitting the full pipeline.
/// - Delegates to [NoteProcessingIsolate.process()] with the correct source + context.
/// - Broadcasts [ChatClarificationEvent] to any live Chat UI subscriber when Gate 2 fires.
///
/// ## Durability guarantee
/// Gate 2 results are written to `pending_resolutions` by [MemoryRouter] *before* any
/// event is emitted here. The stream is a real-time convenience notification; callers
/// that miss it (screen closed, app backgrounded) can always recover via
/// [PendingReviewScreen] which queries the DB directly.
///
/// ## Usage
/// ```dart
/// // In ChatNotifier after persisting the user message:
/// if (_captureService.containsMemoryContent(text)) {
///   unawaited(_captureService.process(
///     memoryId: messageId,
///     content: text,
///     source: MemoryCaptureSource.chat,
///     conversationContext: recentTurns,
///   ));
/// }
/// ```
class MemoryCaptureService {
  MemoryCaptureService({
    required NoteProcessingIsolate noteProcessingIsolate,
    required AppDatabase db,
  })  : _isolate = noteProcessingIsolate,
        _db = db;

  final NoteProcessingIsolate _isolate;
  final AppDatabase _db;

  final _clarificationController =
      StreamController<ChatClarificationEvent>.broadcast();

  /// Stream of Gate 2 clarification events for live chat UI notification.
  ///
  /// Events are emitted AFTER `pending_resolutions` has been written to DB.
  Stream<ChatClarificationEvent> get clarificationEvents =>
      _clarificationController.stream;

  /// Runs the full 13-stage memory pipeline for [memoryId].
  ///
  /// The raw content must already be persisted by the caller before this is
  /// invoked — this method only triggers analysis, never saves raw content.
  ///
  /// For [MemoryCaptureSource.chat], pass the last 3–5 chat turns in
  /// [conversationContext] so the understanding agent can resolve pronouns
  /// against them before scoring context candidates.
  Future<void> process({
    required String memoryId,
    required String content,
    required MemoryCaptureSource source,
    List<String>? conversationContext,
  }) async {
    await _isolate.process(
      memoryId,
      source: source,
      content: content,
      conversationContext: conversationContext,
      onClarificationNeeded: source == MemoryCaptureSource.chat
          ? (event) {
              if (!_clarificationController.isClosed) {
                _clarificationController.add(event);
              }
            }
          : null,
    );
  }

  /// Cheap, deterministic pre-filter — no LLM call.
  ///
  /// Returns `true` if [message] likely contains new memory-worthy information:
  /// - Contains a known entity name from the DB (project, person, technology).
  /// - Contains a declarative assertion pattern (past-tense verb + proper noun, "I did", "we shipped").
  /// - NOT a pure retrieval question with no named subject or assertion.
  ///
  /// Pure queries ("what is the weather?", "hi", "when did I start?") return false.
  /// Ambiguous or content-bearing messages ("did I already deploy ReadSmart AI?" — has entity
  /// and implicit assertion) return true.
  Future<bool> containsMemoryContent(String message) async {
    final trimmed = message.trim();
    if (trimmed.length < 6) return false;

    // 1. Known entity name match (fast DB lookup, no LLM)
    final messageLower = trimmed.toLowerCase();
    final knownEntities = await _db.entities.getAll();
    for (final entity in knownEntities) {
      final canonLower = entity.canonicalName.toLowerCase();
      if (canonLower.length > 2 && messageLower.contains(canonLower)) {
        return true;
      }
    }

    // 2. Declarative/assertion patterns — likely contains new facts
    // Matches: "I did X", "we shipped", "X is ready", "X was done", "Priya mentioned", etc.
    final declarativePattern = RegExp(
      r'\b(i |we |they |he |she |it )'
      r'(did|shipped|completed|finished|said|mentioned|noted|deployed|'
      r'built|fixed|started|launched|confirmed|agreed|approved|rejected|'
      r'suggested|decided|moved|joined|left|created|deleted|updated)\b',
      caseSensitive: false,
    );
    if (declarativePattern.hasMatch(trimmed)) return true;

    // 3. Past-tense proper noun assertions (e.g. "ReadSmart AI was deployed")
    final pastTenseAssertion = RegExp(
      r'\b[A-Z][a-zA-Z]+ (is|was|are|were|has been|have been|will be)\b',
    );
    if (pastTenseAssertion.hasMatch(trimmed)) return true;

    // 4. Explicit assignment / ownership statements
    final assignmentPattern = RegExp(
      r'\b(assigned to|belongs to|owned by|managed by|leads|works on|responsible for)\b',
      caseSensitive: false,
    );
    if (assignmentPattern.hasMatch(trimmed)) return true;

    return false;
  }

  /// Releases resources. Call when the app is shutting down.
  void dispose() {
    _clarificationController.close();
  }
}
