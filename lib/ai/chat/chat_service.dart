import '../memory/hybrid_retriever.dart';
import '../../mcp/tool_executor.dart';
import '../../mcp/tool_registry.dart';
import '../../mcp/tool_protocol.dart';
import '../../domain/ai/note_intelligence_engine.dart';

class ChatResponse {
  const ChatResponse({
    required this.replyText,
    required this.citedNotes,
    this.pendingAction,
  });

  final String replyText;
  final List<HybridSearchResult> citedNotes;
  final ToolCallRequest? pendingAction;
}

class ChatService {
  ChatService({
    required HybridRetriever hybridRetriever,
    required ToolRegistry toolRegistry,
    required ToolExecutor toolExecutor,
    required NoteIntelligenceEngine intelligenceEngine,
  })  : _hybridRetriever = hybridRetriever,
        _toolRegistry = toolRegistry,
        _toolExecutor = toolExecutor,
        _intelligenceEngine = intelligenceEngine;

  final HybridRetriever _hybridRetriever;
  final ToolRegistry _toolRegistry;
  final ToolExecutor _toolExecutor;
  final NoteIntelligenceEngine _intelligenceEngine;

  Future<ChatResponse> handleUserMessage(String message) async {
    final lower = message.toLowerCase().trim();

    // 1. Detect Alarm Intent ("set alarm...", "remind me to...", "alarm for...")
    if (lower.contains('alarm') || lower.contains('remind me') || lower.contains('schedule reminder')) {
      String title = 'Reminder';
      if (lower.contains('remind me to')) {
        title = message.substring(message.toLowerCase().indexOf('remind me to') + 12).trim();
      } else if (lower.contains('alarm for')) {
        title = message.substring(message.toLowerCase().indexOf('alarm for') + 9).trim();
      }

      return ChatResponse(
        replyText: 'I detected an alarm request. Please confirm to set this alarm:',
        citedNotes: [],
        pendingAction: ToolCallRequest(
          toolName: 'set_alarm',
          parameters: {
            'title': title,
            'timeExpression': message,
          },
        ),
      );
    }

    // 2. Detect Calendar Intent ("add to calendar", "calendar event", "schedule meeting")
    if (lower.contains('calendar') || lower.contains('schedule meeting') || lower.contains('add event')) {
      String title = 'Calendar Event';
      if (lower.contains('meeting with')) {
        title = message.substring(message.toLowerCase().indexOf('meeting with')).trim();
      } else if (lower.contains('add')) {
        title = message.substring(message.toLowerCase().indexOf('add') + 3).trim();
      }

      return ChatResponse(
        replyText: 'I detected a calendar request. Please confirm to schedule this calendar event:',
        citedNotes: [],
        pendingAction: ToolCallRequest(
          toolName: 'create_calendar_event',
          parameters: {
            'title': title,
            'timeExpression': message,
          },
        ),
      );
    }

    // 3. Detect Stats Intent ("how many notes", "stats", "count")
    if (lower.contains('how many notes') || lower.contains('count notes') || lower.contains('memory stats')) {
      final result = await _toolExecutor.executeRequest(
        const ToolCallRequest(toolName: 'get_memory_stats', parameters: {}),
      );
      return ChatResponse(
        replyText: result.userDisplayMessage,
        citedNotes: [],
      );
    }

    // 4. Hybrid RAG Search for Memory Queries
    final searchResults = await _hybridRetriever.retrieve(message, limit: 3);
    final contextTexts = searchResults.map((r) => r.note.content).toList();

    String? llmAnswer;
    if (_intelligenceEngine.isReady) {
      llmAnswer = await _intelligenceEngine.chat(message, contextMemories: contextTexts);
    }

    if (llmAnswer != null && llmAnswer.isNotEmpty) {
      return ChatResponse(
        replyText: llmAnswer,
        citedNotes: searchResults,
      );
    }

    if (searchResults.isNotEmpty) {
      final topNote = searchResults.first.note;
      return ChatResponse(
        replyText: 'Based on your memory: "${topNote.summary ?? topNote.content}"',
        citedNotes: searchResults,
      );
    }

    return const ChatResponse(
      replyText: "I couldn't find any related memories stored in your notes, but feel free to ask me anything or create a new note!",
      citedNotes: [],
    );
  }

  Future<McpToolResult> confirmAndExecuteTool(ToolCallRequest request) async {
    return await _toolExecutor.executeRequest(request, userConfirmed: true);
  }
}
