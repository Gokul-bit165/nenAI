import 'package:intl/intl.dart';
import '../memory/hybrid_retriever.dart';
import '../memory/memory_context_builder.dart';
import '../memory/kg_query_engine.dart';
import '../agents/query_understanding_agent.dart';
import '../agents/memory_recall_agent.dart';
import '../services/minimal_memory_understanding_service.dart';
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
    this.questionType = RecallQuestionType.general,
    this.isClarification = false,
    this.candidateOptions = const [],
    this.sourceNoteIds = const [],
    this.contextPath,
    this.formationTriggered = false,
  });

  final String replyText;
  final List<HybridSearchResult> citedNotes;
  final List<String> graphTriples;
  final ToolCallRequest? pendingAction;
  final RecallQuestionType questionType;
  final bool isClarification;
  final List<String> candidateOptions;
  final List<String> sourceNoteIds;
  final String? contextPath;

  /// True if this message was classified as memory formation (create/add/update/correct/link/task).
  final bool formationTriggered;
}

class ChatService {
  ChatService({
    required HybridRetriever hybridRetriever,
    required MemoryContextBuilder contextBuilder,
    required QueryUnderstandingAgent queryAgent,
    required ToolRegistry toolRegistry,
    required ToolExecutor toolExecutor,
    required NoteIntelligenceEngine intelligenceEngine,
    MemoryRecallAgent? recallAgent,
    KGQueryEngine? kgQueryEngine,
    MinimalMemoryUnderstandingService? minimalUnderstandingService,
  })  : _hybridRetriever = hybridRetriever,
        _contextBuilder = contextBuilder,
        _queryAgent = queryAgent,
        _toolRegistry = toolRegistry,
        _toolExecutor = toolExecutor,
        _intelligenceEngine = intelligenceEngine,
        _recallAgent = recallAgent,
        _kgQueryEngine = kgQueryEngine,
        _minimalUnderstandingService = minimalUnderstandingService;

  final HybridRetriever _hybridRetriever;
  final MemoryContextBuilder _contextBuilder;
  final QueryUnderstandingAgent _queryAgent;
  final ToolRegistry _toolRegistry;
  final ToolExecutor _toolExecutor;
  final NoteIntelligenceEngine _intelligenceEngine;
  final MemoryRecallAgent? _recallAgent;
  final KGQueryEngine? _kgQueryEngine;
  final MinimalMemoryUnderstandingService? _minimalUnderstandingService;

  Future<ChatResponse> handleUserMessage(
    String message, {
    List<String>? conversationContext,
  }) async {
    // 1. Query Understanding & Intent Classification
    final queryAnalysis = await _queryAgent.analyzeQuery(message);

    // 2. Action Handlers (Alarms, Calendar, Stats)
    if (queryAnalysis.actionIntent == 'set_alarm') {
      return ChatResponse(
        replyText: 'I detected an alarm request. Please confirm to set this alarm:',
        citedNotes: const [],
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
        citedNotes: const [],
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
        citedNotes: const [],
      );
    }

    // 3. Memory Formation Path (create, add, update, correct, link, task)
    if (queryAnalysis.isFormation && _minimalUnderstandingService != null) {
      final understanding = await _minimalUnderstandingService.understand(
        message,
        intent: queryAnalysis.memoryIntent,
        conversationContext: conversationContext,
      );

      final intentName = queryAnalysis.memoryIntent.name;

      if (understanding.isAmbiguous) {
        final topic = understanding.analysis?.topic ?? 'this update';
        final options = understanding.candidateBreakdowns
            .take(3)
            .map((c) => c.candidateName)
            .toList();

        return ChatResponse(
          replyText: 'I understood "$topic". Which project is this for?',
          citedNotes: const [],
          isClarification: true,
          candidateOptions: options,
          formationTriggered: true,
        );
      }

      if (understanding.isClear && understanding.targetContextName != null) {
        final ctxName = understanding.targetContextName!;
        final actionText = understanding.analysis?.actions.isNotEmpty == true
            ? understanding.analysis!.actions.first.subject
            : 'information';

        return ChatResponse(
          replyText: 'Got it — stored "$actionText" under $ctxName.',
          citedNotes: const [],
          formationTriggered: true,
        );
      }

      return ChatResponse(
        replyText: 'Got it — recorded that to your memory ($intentName).',
        citedNotes: const [],
        formationTriggered: true,
      );
    }

    // 4. Memory Recall Path (KG-First → Autonomous Recall Agent → Hybrid Search)
    if (_kgQueryEngine != null) {
      final kgResult = await _kgQueryEngine.query(
        message,
        recentContext: conversationContext ?? const [],
      );
      if (kgResult != null) {
        // Fetch cited notes for source evidence display
        final citedNotes = kgResult.sourceNoteIds.isNotEmpty
            ? await _hybridRetriever.retrieve(message, limit: 3)
            : const <HybridSearchResult>[];

        return ChatResponse(
          replyText: kgResult.answer,
          citedNotes: citedNotes,
          graphTriples: kgResult.triples,
          sourceNoteIds: kgResult.sourceNoteIds,
        );
      }
    }

    // 5. Autonomous Recall Agent Fallback
    if (_recallAgent != null) {
      final recallResult = await _recallAgent.answer(message);
      return ChatResponse(
        replyText: recallResult.replyText,
        citedNotes: recallResult.citedNotes,
        graphTriples: recallResult.graphTriples,
        questionType: recallResult.questionType,
        isClarification: recallResult.isClarification,
        candidateOptions: recallResult.candidateOptions,
        sourceNoteIds: recallResult.sourceNoteIds,
        contextPath: recallResult.contextPath,
      );
    }

    // Fallback Grounded Retrieval
    final searchResults = await _hybridRetriever.retrieve(message, limit: 3);
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
        sourceNoteIds: groundedContext.sourceNoteIds,
      );
    }

    if (searchResults.isNotEmpty) {
      final topNote = searchResults.first.note;
      final contextLabel = searchResults.first.contextName ?? topNote.title;
      final dateLabel = DateFormat('MMM d').format(topNote.createdAt);
      final noteRef = '$dateLabel · $contextLabel';
      return ChatResponse(
        replyText:
            'Based on your memory ($noteRef): "${topNote.summary ?? topNote.content}"',
        citedNotes: searchResults,
        graphTriples: groundedContext.graphTriples,
        sourceNoteIds: [topNote.id],
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
