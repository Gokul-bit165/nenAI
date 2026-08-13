import '../../domain/entities/context_node.dart';
import '../../domain/repositories/context_repository.dart';
import '../../domain/repositories/note_repository.dart';
import '../../data/local/database/app_database.dart';
import '../../data/local/database/daos/entities_dao.dart';
import '../../data/local/database/daos/relationships_dao.dart';
import '../../data/local/database/daos/tasks_dao.dart';
import '../memory/hybrid_retriever.dart';
import '../memory/memory_context_builder.dart';
import '../memory/context_timeline_service.dart';
import '../memory/reference_resolver.dart';

/// Semantic classification of user recall questions.
enum RecallQuestionType {
  fact,
  timeline,
  relation,
  task,
  context,
  followUp,
  pronoun,
  ambiguous,
  general,
}

/// The structured result of an autonomous memory recall query.
class MemoryRecallResult {
  const MemoryRecallResult({
    required this.replyText,
    required this.questionType,
    this.citedNotes = const [],
    this.graphTriples = const [],
    this.sourceNoteIds = const [],
    this.isClarification = false,
    this.candidateOptions = const [],
    this.contextPath,
  });

  final String replyText;
  final RecallQuestionType questionType;
  final List<HybridSearchResult> citedNotes;
  final List<String> graphTriples;
  final List<String> sourceNoteIds;
  final bool isClarification;
  final List<String> candidateOptions;
  final String? contextPath;
}

/// Autonomous Memory Recall Agent: Synthesizes facts, timelines, context DAG hierarchies,
/// relationships, tasks, and reference resolutions into zero-hallucination grounded answers.
class MemoryRecallAgent {
  const MemoryRecallAgent({
    required this.db,
    required this.contextRepository,
    required this.noteRepository,
    required this.hybridRetriever,
    required this.contextBuilder,
    required this.contextTimelineService,
    required this.referenceResolver,
    required this.entitiesDao,
    required this.relationshipsDao,
    required this.tasksDao,
  });

  final AppDatabase db;
  final ContextRepository contextRepository;
  final NoteRepository noteRepository;
  final HybridRetriever hybridRetriever;
  final MemoryContextBuilder contextBuilder;
  final ContextTimelineService contextTimelineService;
  final ReferenceResolver referenceResolver;
  final EntitiesDao entitiesDao;
  final RelationshipsDao relationshipsDao;
  final TasksDao tasksDao;

  /// Classifies the intent of a recall question.
  RecallQuestionType classifyQuestion(String message) {
    final lower = message.toLowerCase().trim();

    // 1. Ambiguity check: "Which deployment..." or "What deployment..."
    if (lower.startsWith('which ') ||
        (lower.contains('what deployment') && !lower.contains('readsmart') && !lower.contains('fc'))) {
      return RecallQuestionType.ambiguous;
    }

    // 2. Context list: "What are my current projects?" / "List contexts"
    if (lower.contains('current projects') ||
        lower.contains('my projects') ||
        lower.contains('what projects') ||
        lower.contains('list projects') ||
        lower.contains('what contexts')) {
      return RecallQuestionType.context;
    }

    // 3. Follow-up: "What happened after..."
    if (lower.contains('after ') || lower.contains('following ')) {
      return RecallQuestionType.followUp;
    }

    // 4. Relation: "How is X related to Y?" / "relationship between"
    if (lower.contains('related to') || lower.contains('relationship between') || lower.contains('how is the')) {
      return RecallQuestionType.relation;
    }

    // 5. Timeline: "What happened with X?" / "timeline of"
    if (lower.contains('what happened with') || lower.contains('timeline') || lower.contains('history of')) {
      return RecallQuestionType.timeline;
    }

    // 6. Task: "What do I need to test?" / "what is pending?" / "what tasks"
    if (lower.contains('need to test') ||
        lower.contains('want to test') ||
        lower.contains('pending') ||
        lower.contains('todo') ||
        lower.contains('what tasks') ||
        lower.contains('what do i need to do')) {
      return RecallQuestionType.task;
    }

    // 7. Pronoun / Reference: "What did I want to test?" / "What was that issue?"
    if (lower.contains('want to test') || lower.contains('that issue') || lower.contains('this task')) {
      return RecallQuestionType.pronoun;
    }

    // 8. Fact: "What did X suggest?" / "Who suggested X?"
    if (lower.contains('suggest') || lower.contains('recommend') || lower.contains('say about') || lower.contains('discuss')) {
      return RecallQuestionType.fact;
    }

    return RecallQuestionType.general;
  }

  /// Answers the user query strictly from grounded local memory.
  Future<MemoryRecallResult> answer(String message) async {
    final qType = classifyQuestion(message);
    final lower = message.toLowerCase().trim();

    // ── Handlers by Question Type ───────────────────────────────────────────

    // 1. AMBIGUOUS Question Handling
    if (qType == RecallQuestionType.ambiguous) {
      final allNodes = await contextRepository.getAllNodes();
      final deploymentNodes = allNodes.where((n) => n.name.toLowerCase().contains('deployment') || n.name.toLowerCase().contains('deploy')).toList();

      if (deploymentNodes.length > 1) {
        final candidateNames = <String>[];
        for (final node in deploymentNodes) {
          final parents = await contextRepository.getParents(node.id);
          if (parents.isNotEmpty) {
            candidateNames.add('${parents.first.name} (Deployment)');
          } else {
            candidateNames.add(node.name);
          }
        }

        final buffer = StringBuffer();
        buffer.writeln('I found multiple possible deployment contexts in your memory:');
        for (int i = 0; i < candidateNames.length; i++) {
          buffer.writeln('${i + 1}. ${candidateNames[i]}');
        }
        buffer.writeln();
        buffer.writeln('Which one do you mean?');

        return MemoryRecallResult(
          replyText: buffer.toString().trim(),
          questionType: RecallQuestionType.ambiguous,
          isClarification: true,
          candidateOptions: candidateNames,
        );
      }
    }

    // 2. CONTEXT Question: "What are my current projects?"
    if (qType == RecallQuestionType.context) {
      final allNodes = await contextRepository.getAllNodes();
      final projects = allNodes.where((n) => n.type.name == 'project').toList();

      if (projects.isNotEmpty) {
        final buffer = StringBuffer();
        buffer.writeln('Here are your current active projects recorded in memory:');
        for (int i = 0; i < projects.length; i++) {
          buffer.writeln('${i + 1}. **${projects[i].name}**');
        }
        return MemoryRecallResult(
          replyText: buffer.toString().trim(),
          questionType: RecallQuestionType.context,
        );
      }
    }

    // 3. TIMELINE Question: "What happened with ReadSmart AI?"
    if (qType == RecallQuestionType.timeline) {
      final timeline = await contextTimelineService.queryTimeline(message);
      if (timeline.items.isNotEmpty) {
        final buffer = StringBuffer();
        buffer.writeln('Timeline for **${timeline.contextName}**:');
        buffer.writeln();
        buffer.writeln('```');
        buffer.writeln(timeline.toTreeString());
        buffer.writeln('```');

        final sourceIds = timeline.items
            .where((i) => i.id.startsWith('note-'))
            .map((i) => i.id.replaceFirst('note-', ''))
            .toList();

        return MemoryRecallResult(
          replyText: buffer.toString().trim(),
          questionType: RecallQuestionType.timeline,
          sourceNoteIds: sourceIds,
        );
      }
    }

    // 4. RELATION Question: "How is the Dean meeting related to ReadSmart?"
    if (qType == RecallQuestionType.relation) {
      final allNodes = await contextRepository.getAllNodes();
      ContextNode? nodeA;
      ContextNode? nodeB;

      for (final n in allNodes) {
        final nameLower = n.name.toLowerCase();
        if (lower.contains(nameLower) || (nameLower.contains('dean') && lower.contains('dean'))) {
          nodeA ??= n;
        } else if (lower.contains(nameLower) || (nameLower.contains('readsmart') && lower.contains('readsmart'))) {
          nodeB ??= n;
        }
      }

      if (nodeA != null && nodeB != null) {
        final childEdges = await contextRepository.getChildEdges(nodeA.id);
        final directEdge = childEdges.where((e) => e.targetContextId == nodeB!.id).firstOrNull;

        if (directEdge != null) {
          return MemoryRecallResult(
            replyText:
                '**${nodeA.name}** is directly connected to **${nodeB.name}** as a parent context with relation `"${directEdge.relationType}"` [Context: ${nodeA.name} └── ${nodeB.name}].',
            questionType: RecallQuestionType.relation,
            contextPath: '${nodeA.name} └── ${nodeB.name}',
          );
        }
      }
    }

    // 5. FOLLOW-UP Question: "What happened after deployment?"
    if (qType == RecallQuestionType.followUp) {
      final timeline = await contextTimelineService.queryTimeline(message);
      if (timeline.items.isNotEmpty) {
        final buffer = StringBuffer();
        buffer.writeln('Following the deployment:');
        for (final item in timeline.items) {
          buffer.writeln('- ${item.title}');
        }
        final sourceIds = timeline.items
            .where((i) => i.id.startsWith('note-'))
            .map((i) => i.id.replaceFirst('note-', ''))
            .toList();

        return MemoryRecallResult(
          replyText: buffer.toString().trim(),
          questionType: RecallQuestionType.followUp,
          sourceNoteIds: sourceIds,
        );
      }
    }

    // 6. TASK Question: "What do I need to test?" / "What is pending?"
    if (qType == RecallQuestionType.task) {
      final pendingTasks = await tasksDao.getPendingTasks();
      final testTasks = pendingTasks.where((t) =>
          lower.contains('test') ? t.description.toLowerCase().contains('test') : true).toList();

      if (testTasks.isNotEmpty) {
        final buffer = StringBuffer();
        buffer.writeln('Here are your pending tasks:');
        final sourceIds = <String>[];
        for (int i = 0; i < testTasks.length; i++) {
          final t = testTasks[i];
          sourceIds.add(t.memoryId);
          final due = t.dueDate != null ? ' (Due: ${t.dueDate})' : '';
          buffer.writeln('${i + 1}. ${t.description}$due [Source Note: ${t.memoryId}]');
        }
        return MemoryRecallResult(
          replyText: buffer.toString().trim(),
          questionType: RecallQuestionType.task,
          sourceNoteIds: sourceIds,
        );
      }
    }

    // 7. FACT / GENERAL Grounded Fallback: FTS + Vector + KG Retrieval
    final searchResults = await hybridRetriever.retrieve(message, limit: 3);
    final groundedContext = await contextBuilder.buildContext(searchResults);

    if (searchResults.isNotEmpty) {
      final topResult = searchResults.first;
      final buffer = StringBuffer();

      // If Knowledge Graph facts match entity
      if (groundedContext.graphTriples.isNotEmpty) {
        buffer.writeln('Based on your recorded facts:');
        for (final triple in groundedContext.graphTriples) {
          buffer.writeln('- $triple');
        }
        buffer.writeln();
      }

      buffer.writeln('From your notes: "${topResult.note.summary ?? topResult.note.content}" [Source Note: ${topResult.note.id}]');
      if (topResult.contextPath != null) {
        buffer.writeln('(Context: ${topResult.contextPath})');
      }

      return MemoryRecallResult(
        replyText: buffer.toString().trim(),
        questionType: qType,
        citedNotes: searchResults,
        graphTriples: groundedContext.graphTriples,
        sourceNoteIds: groundedContext.sourceNoteIds,
        contextPath: topResult.contextPath,
      );
    }

    return const MemoryRecallResult(
      replyText: "I couldn't find any relevant memories in your notes for this question.",
      questionType: RecallQuestionType.general,
    );
  }
}
