import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../../ai/chat/chat_service.dart';
import '../../../ai/memory/hybrid_retriever.dart';
import '../../../data/local/database/app_database.dart';
import '../../../mcp/tool_executor.dart';
import '../../../injection.dart';

class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.citedNotes = const [],
    this.pendingAction,
    this.actionExecutedMessage,
  });

  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final List<HybridSearchResult> citedNotes;
  final ToolCallRequest? pendingAction;
  final String? actionExecutedMessage;

  ChatMessage copyWith({
    String? text,
    ToolCallRequest? pendingAction,
    String? actionExecutedMessage,
  }) {
    return ChatMessage(
      id: id,
      text: text ?? this.text,
      isUser: isUser,
      timestamp: timestamp,
      citedNotes: citedNotes,
      pendingAction: pendingAction ?? this.pendingAction,
      actionExecutedMessage: actionExecutedMessage ?? this.actionExecutedMessage,
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

    final userMsg = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: clean,
      isUser: true,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      messages: [...state.messages, userMsg],
      isLoading: true,
    );

    _persistMessage(userMsg);

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
}
