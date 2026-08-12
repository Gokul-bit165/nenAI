import '../memory/hybrid_retriever.dart';
import '../memory/memory_context_builder.dart';
import '../agents/query_understanding_agent.dart';
import '../../mcp/tool_executor.dart';
import '../../mcp/tool_registry.dart';
import '../../mcp/tool_protocol.dart';
import '../../domain/ai/note_intelligence_engine.dart';

class ChatResponse {
  const ChatResponse({
    required this.replyText,
    required this.citedNotes,
    this.graphTriples = const [],
    this.pendingAction,
  });

  final String replyText;
  final List<HybridSearchResult> citedNotes;
  final List<String> graphTriples;
  final ToolCallRequest? pendingAction;
}

class ChatService {
  ChatService({
    required HybridRetriever hybridRetriever,
    required MemoryContextBuilder contextBuilder,
    required QueryUnderstandingAgent queryAgent,
    required ToolRegistry toolRegistry,
    required ToolExecutor toolExecutor,
    required NoteIntelligenceEngine intelligenceEngine,
  })  : _hybridRetriever = hybridRetriever,
        _contextBuilder = contextBuilder,
        _queryAgent = queryAgent,
        _toolRegistry = toolRegistry,
        _toolExecutor = toolExecutor,
        _intelligenceEngine = intelligenceEngine;

  final HybridRetriever _hybridRetriever;
  final MemoryContextBuilder _contextBuilder;
  final QueryUnderstandingAgent _queryAgent;
  final ToolRegistry _toolRegistry;
  final ToolExecutor _toolExecutor;
  final NoteIntelligenceEngine _intelligenceEngine;

  Future<ChatResponse> handleUserMessage(String message) async {
    // 1. Query Understanding & Intent Analysis
    final queryAnalysis = await _queryAgent.analyzeQuery(message);

    // 2. Action Handlers (Alarms, Calendar, Stats)
    if (queryAnalysis.actionIntent == 'set_alarm') {
      return ChatResponse(
        replyText: 'I detected an alarm request. Please confirm to set this alarm:',
        citedNotes: [],
        pendingAction: ToolCallRequest(
          toolName: 'set_alarm',
          parameters: {
            'title': queryAnalysis.actionTitle ?? 'Reminder',
            'timeExpression': message,
          },
        ),
      );
    }

    if (queryAnalysis.actionIntent == 'create_calendar_event') {
      return ChatResponse(
        replyText: 'I detected a calendar request. Please confirm to schedule this calendar event:',
        citedNotes: [],
        pendingAction: ToolCallRequest(
          toolName: 'create_calendar_event',
          parameters: {
            'title': queryAnalysis.actionTitle ?? 'Calendar Event',
            'timeExpression': message,
          },
        ),
      );
    }

    if (queryAnalysis.actionIntent == 'get_memory_stats') {
      final result = await _toolExecutor.executeRequest(
        const ToolCallRequest(toolName: 'get_memory_stats', parameters: {}),
      );
      return ChatResponse(
        replyText: result.userDisplayMessage,
        citedNotes: [],
      );
    }

    // 3. 3-Way Grounded Retrieval (FTS + Vector + Knowledge Graph)
    final searchResults = await _hybridRetriever.retrieve(message, limit: 3);
    
    // 4. Build Grounded Context: Notes + Entities + Graph Triples + Tasks
    final groundedContext = await _contextBuilder.buildContext(searchResults);

    String? llmAnswer;
    if (_intelligenceEngine.isReady && groundedContext.contextString.isNotEmpty) {
      llmAnswer = await _intelligenceEngine.chat(
        message,
        contextMemories: [groundedContext.contextString],
      );
    }

    if (llmAnswer != null && llmAnswer.isNotEmpty) {
      return ChatResponse(
        replyText: llmAnswer,
        citedNotes: searchResults,
        graphTriples: groundedContext.graphTriples,
      );
    }

    if (searchResults.isNotEmpty) {
      final topNote = searchResults.first.note;
      final tripleInfo = groundedContext.graphTriples.isNotEmpty
          ? '\n(Fact: ${groundedContext.graphTriples.first})'
          : '';
      return ChatResponse(
        replyText: 'Based on your memory: "${topNote.summary ?? topNote.content}"$tripleInfo',
        citedNotes: searchResults,
        graphTriples: groundedContext.graphTriples,
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
