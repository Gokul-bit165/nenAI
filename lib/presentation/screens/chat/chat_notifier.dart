import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../../ai/chat/chat_service.dart';
import '../../../ai/memory/hybrid_retriever.dart';
import '../../../ai/services/memory_capture_service.dart';
import '../../../background/note_processing_isolate.dart';
import '../../../data/local/database/app_database.dart';
import '../../../domain/entities/pending_resolution.dart';
import '../../../domain/repositories/resolution_repository.dart';
import '../../../mcp/tool_executor.dart';
import '../../../injection.dart';

/// A single message in the chat thread.
///
/// The [isProcessing] flag marks user messages while background memory analysis
/// runs — a subtle visual indicator so the follow-up clarification bubble
/// doesn't feel like a random non-sequitur.
///
/// The [isClarificationAsk] flag marks AI-generated Gate 2 clarification
/// messages that render as quick-reply bubbles instead of plain text.
class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.citedNotes = const [],
    this.pendingAction,
    this.actionExecutedMessage,
    this.isProcessing = false,
    this.isClarificationAsk = false,
    this.clarificationResolutionId,
    this.clarificationCandidates,
  });

  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final List<HybridSearchResult> citedNotes;
  final ToolCallRequest? pendingAction;
  final String? actionExecutedMessage;

  /// True while background memory analysis is running for this user message.
  final bool isProcessing;

  /// True when this is an AI-generated Gate 2 clarification prompt.
  final bool isClarificationAsk;

  /// Resolution ID in `pending_resolutions` — used to commit the user's choice.
  final String? clarificationResolutionId;

  /// Candidate contexts presented to the user as quick-reply chips.
  final List<ResolutionCandidateOption>? clarificationCandidates;

  ChatMessage copyWith({
    String? text,
    ToolCallRequest? pendingAction,
    String? actionExecutedMessage,
    bool? isProcessing,
    bool? isClarificationAsk,
    String? clarificationResolutionId,
    List<ResolutionCandidateOption>? clarificationCandidates,
  }) {
    return ChatMessage(
      id: id,
      text: text ?? this.text,
      isUser: isUser,
      timestamp: timestamp,
      citedNotes: citedNotes,
      pendingAction: pendingAction ?? this.pendingAction,
      actionExecutedMessage: actionExecutedMessage ?? this.actionExecutedMessage,
      isProcessing: isProcessing ?? this.isProcessing,
      isClarificationAsk: isClarificationAsk ?? this.isClarificationAsk,
      clarificationResolutionId:
          clarificationResolutionId ?? this.clarificationResolutionId,
      clarificationCandidates:
          clarificationCandidates ?? this.clarificationCandidates,
    );
  }
}

class ChatState {
  const ChatState({
    this.messages = const [],
    this.isLoading = false,
  });

  final List<ChatMessage> messages;
  final bool isLoading;

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// Persistent provider — does NOT auto-dispose when exiting Chat screen
final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  return ChatNotifier();
});

class ChatNotifier extends StateNotifier<ChatState> {
  ChatNotifier() : super(const ChatState()) {
    _loadPersistedMessages();
    _subscribeToClarificationEvents();
  }

  StreamSubscription<ChatClarificationEvent>? _clarificationSub;

  /// Subscribes to Gate 2 events from [MemoryCaptureService].
  ///
  /// The subscription is established at notifier construction time (not screen
  /// lifecycle), so events delivered while the Chat screen is closed are still
  /// received and inserted as follow-up messages. The DB record in
  /// `pending_resolutions` is the durable source of truth regardless.
  void _subscribeToClarificationEvents() {
    try {
      final captureService = getIt<MemoryCaptureService>();
      _clarificationSub = captureService.clarificationEvents.listen(
        (event) => _onClarificationEvent(event),
      );
    } catch (_) {
      // MemoryCaptureService not registered in test environments — safe to ignore.
    }
  }

  void _onClarificationEvent(ChatClarificationEvent event) {
    // 1. Clear the processing indicator on the originating user message.
    final updatedMessages = state.messages.map((m) {
      if (m.id == event.memoryId && m.isProcessing) {
        return m.copyWith(isProcessing: false);
      }
      return m;
    }).toList();

    // 2. Look up the pending_resolutions ID (async — we fire-and-forget the
    //    lookup and insert the bubble once we have the resolution ID).
    _insertClarificationBubble(event, updatedMessages);
  }

  Future<void> _insertClarificationBubble(
    ChatClarificationEvent event,
    List<ChatMessage> updatedMessages,
  ) async {
    // Fetch the newly written pending_resolutions row to get its stable ID.
    String? resolutionId;
    try {
      final resRepo = getIt<ResolutionRepository>();
      final pending = await resRepo.getPendingByMemoryId(event.memoryId);
      resolutionId = pending?.id;
    } catch (_) {}

    final clarificationMsg = ChatMessage(
      id: 'clarify-${event.memoryId}',
      text: "NENAI isn't sure which context this belongs to — can you confirm?",
      isUser: false,
      timestamp: DateTime.now(),
      isClarificationAsk: true,
      clarificationResolutionId: resolutionId,
      clarificationCandidates: event.candidates,
    );

    if (mounted) {
      state = state.copyWith(
        messages: [...updatedMessages, clarificationMsg],
      );
    }
  }

  Future<void> _loadPersistedMessages() async {
    try {
      final db = getIt<AppDatabase>();
      final stored = await db.chatMessages.getAllMessages();

      if (stored.isEmpty) {
        final welcomeMsg = ChatMessage(
          id: 'welcome',
          text: 'Hello! I am your MemAI Memory Assistant. Ask me anything about your notes, or ask me to schedule reminders & alarms!',
          isUser: false,
          timestamp: DateTime.now(),
        );
        state = ChatState(messages: [welcomeMsg]);
        await db.chatMessages.insertMessage(
          ChatMessagesTableCompanion(
            id: const drift.Value('welcome'),
            textContent: drift.Value(welcomeMsg.text),
            isUser: const drift.Value(false),
            timestamp: drift.Value(welcomeMsg.timestamp.millisecondsSinceEpoch),
          ),
        );
      } else {
        final loaded = stored.map((s) {
          return ChatMessage(
            id: s.id,
            text: s.textContent,
            isUser: s.isUser,
            timestamp: DateTime.fromMillisecondsSinceEpoch(s.timestamp),
            actionExecutedMessage: s.actionExecutedMessage,
          );
        }).toList();

        state = ChatState(messages: loaded);
      }
    } catch (_) {
      // Fallback
      if (state.messages.isEmpty) {
        state = ChatState(
          messages: [
            ChatMessage(
              id: 'welcome',
              text: 'Hello! I am your MemAI Memory Assistant. Ask me anything about your notes, or ask me to schedule reminders & alarms!',
              isUser: false,
              timestamp: DateTime.now(),
            ),
          ],
        );
      }
    }
  }

  Future<void> sendMessage(String text) async {
    final clean = text.trim();
    if (clean.isEmpty) return;

    final msgId = DateTime.now().millisecondsSinceEpoch.toString();

    final userMsg = ChatMessage(
      id: msgId,
      text: clean,
      isUser: true,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      messages: [...state.messages, userMsg],
      isLoading: true,
    );

    _persistMessage(userMsg);

    // ── Recall/query path (unchanged) ───────────────────────────────────────
    final chatService = getIt<ChatService>();
    final response = await chatService.handleUserMessage(clean);

    final botMsg = ChatMessage(
      id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
      text: response.replyText,
      isUser: false,
      timestamp: DateTime.now(),
      citedNotes: response.citedNotes,
      pendingAction: response.pendingAction,
    );

    state = state.copyWith(
      messages: [...state.messages, botMsg],
      isLoading: false,
    );

    _persistMessage(botMsg);

    // ── Memory capture path (async, non-blocking) ───────────────────────────
    // Cheap pre-filter first; only content-bearing messages hit the pipeline.
    _triggerMemoryCaptureIfNeeded(clean, msgId);
  }

  /// Runs the cheap pre-filter then, if needed, triggers background pipeline.
  /// Marks the originating message as [isProcessing] while analysis runs.
  Future<void> _triggerMemoryCaptureIfNeeded(
      String content, String msgId) async {
    try {
      final captureService = getIt<MemoryCaptureService>();
      final hasContent = await captureService.containsMemoryContent(content);
      if (!hasContent) return;

      // Show processing indicator on the sent message.
      _markProcessing(msgId, true);

      // Build conversation context from last 5 non-system messages.
      final recentTurns = state.messages
          .where((m) => m.id != 'welcome')
          .toList()
          .reversed
          .take(5)
          .map((m) => '${m.isUser ? "User" : "Assistant"}: ${m.text}')
          .toList()
          .reversed
          .toList();

      // Non-blocking: the isolate runs in the background.
      // The processing indicator clears when clarificationEvents fires (Gate 2)
      // or after the isolate completes (Gate 1 / Gate 3).
      unawaited(captureService
          .process(
            memoryId: msgId,
            content: content,
            source: MemoryCaptureSource.chat,
            conversationContext: recentTurns,
          )
          .then((_) => _markProcessing(msgId, false))
          .catchError((_) => _markProcessing(msgId, false)));
    } catch (_) {
      // MemoryCaptureService not registered — safe no-op.
    }
  }

  void _markProcessing(String msgId, bool processing) {
    if (!mounted) return;
    final updated = state.messages.map((m) {
      return m.id == msgId ? m.copyWith(isProcessing: processing) : m;
    }).toList();
    state = state.copyWith(messages: updated);
  }

  /// Resolves a chat clarification bubble using the SAME [ResolutionRepository]
  /// handler that the [ClarificationCard] note widget uses — one confirmation
  /// handler across both surfaces.
  Future<void> confirmClarification({
    required String messageId,
    required String resolutionId,
    required String? contextId, // null == "None of these"
    String? memoryId,
  }) async {
    try {
      final resRepo = getIt<ResolutionRepository>();
      final choice = contextId != null
          ? ResolutionChoice.single(contextId)
          : const ResolutionChoice.none();

      await resRepo.resolveResolution(
        resolutionId: resolutionId,
        memoryId: memoryId ?? messageId,
        choice: choice,
      );

      // Swap the clarification bubble for a confirmation feedback message.
      if (mounted) {
        final updated = state.messages.map((m) {
          if (m.id == 'clarify-${memoryId ?? messageId}') {
            return m.copyWith(
              isClarificationAsk: false,
              text: contextId != null
                  ? '✓ Got it — I\'ve linked that to the context.'
                  : '✓ Noted — keeping this unassigned.',
            );
          }
          return m;
        }).toList();
        state = state.copyWith(messages: updated);
      }
    } catch (_) {}
  }

  Future<void> _persistMessage(ChatMessage msg) async {
    try {
      final db = getIt<AppDatabase>();
      await db.chatMessages.insertMessage(
        ChatMessagesTableCompanion(
          id: drift.Value(msg.id),
          textContent: drift.Value(msg.text),
          isUser: drift.Value(msg.isUser),
          timestamp: drift.Value(msg.timestamp.millisecondsSinceEpoch),
          actionExecutedMessage: drift.Value(msg.actionExecutedMessage),
        ),
      );
    } catch (_) {}
  }

  Future<void> confirmAction(ChatMessage message) async {
    if (message.pendingAction == null) return;

    final chatService = getIt<ChatService>();
    final result = await chatService.confirmAndExecuteTool(message.pendingAction!);

    final updatedMessages = state.messages.map((m) {
      if (m.id == message.id) {
        final updated = m.copyWith(
          pendingAction: null,
          actionExecutedMessage: result.userDisplayMessage,
        );
        _persistMessage(updated);
        return updated;
      }
      return m;
    }).toList();

    state = state.copyWith(messages: updatedMessages);
  }

  Future<void> dismissAction(ChatMessage message) async {
    final updatedMessages = state.messages.map((m) {
      if (m.id == message.id) {
        final updated = m.copyWith(
          pendingAction: null,
          actionExecutedMessage: 'Action cancelled.',
        );
        _persistMessage(updated);
        return updated;
      }
      return m;
    }).toList();

    state = state.copyWith(messages: updatedMessages);
  }

  @override
  void dispose() {
    _clarificationSub?.cancel();
    super.dispose();
  }
}
