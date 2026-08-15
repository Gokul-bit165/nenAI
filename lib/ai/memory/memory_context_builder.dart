import '../../data/local/database/app_database.dart';
import '../../data/local/database/daos/entities_dao.dart';
import '../../data/local/database/daos/relationships_dao.dart';
import '../../data/local/database/daos/tasks_dao.dart';
import '../../domain/repositories/context_repository.dart';
import 'hybrid_retriever.dart';
import 'context_timeline_service.dart';

/// Comprehensive grounded context container injected into the local Gemma LLM prompt.
class GroundedMemoryContext {
  const GroundedMemoryContext({
    required this.contextString,
    required this.citedNotes,
    required this.graphTriples,
    required this.tasks,
    this.contextHierarchyTree,
    this.timelineSnippet,
    this.sourceNoteIds = const [],
  });

  final String contextString;
  final List<HybridSearchResult> citedNotes;
  final List<String> graphTriples;
  final List<TasksTableData> tasks;
  final String? contextHierarchyTree;
  final String? timelineSnippet;
  final List<String> sourceNoteIds;
}

/// Context-Aware Prompt & Context Builder: Synthesizes hierarchical context paths,
/// cited memory notes, knowledge graph facts, and pending tasks into a compressed grounded prompt.
class MemoryContextBuilder {
  MemoryContextBuilder({
    required EntitiesDao entitiesDao,
    required RelationshipsDao relationshipsDao,
    required TasksDao tasksDao,
    ContextRepository? contextRepository,
    ContextTimelineService? contextTimelineService,
  })  : _entitiesDao = entitiesDao,
        _relationshipsDao = relationshipsDao,
        _tasksDao = tasksDao,
        _contextRepository = contextRepository,
        _contextTimelineService = contextTimelineService;

  final EntitiesDao _entitiesDao;
  final RelationshipsDao _relationshipsDao;
  final TasksDao _tasksDao;
  final ContextRepository? _contextRepository;
  final ContextTimelineService? _contextTimelineService;

  /// Builds a structured, context-compressed grounding payload for LLM response generation.
  Future<GroundedMemoryContext> buildContext(
    List<HybridSearchResult> searchResults, {
    String? explicitContextId,
  }) async {
    final buffer = StringBuffer();
    final allTriples = <String>{};
    final allTasks = <TasksTableData>[];
    final allSourceIds = <String>{};
    String? contextHierarchyTree;
    String? timelineSnippet;

    // 1. Context Hierarchy Tree Header
    if (searchResults.isNotEmpty && searchResults.first.contextPath != null) {
      final path = searchResults.first.contextPath!;
      buffer.writeln('=== CONTEXT HIERARCHY ===');
      buffer.writeln('Path: $path');
      buffer.writeln();
    }

    if (_contextRepository != null && explicitContextId != null) {
      final subtree = await _contextRepository.getSubtree(explicitContextId);
      if (subtree != null) {
        contextHierarchyTree = subtree.toTreeString();
        buffer.writeln('=== CONTEXT TREE ===');
        buffer.writeln(contextHierarchyTree);
        buffer.writeln();
      }
    }

    // 2. Timeline Highlights
    if (_contextTimelineService != null && searchResults.isNotEmpty && searchResults.first.contextId != null) {
      final timeline = await _contextTimelineService.getContextTimeline(searchResults.first.contextId!);
      if (timeline.items.isNotEmpty) {
        timelineSnippet = timeline.toTreeString();
        buffer.writeln('=== CONTEXT TIMELINE ===');
        buffer.writeln(timelineSnippet);
        buffer.writeln();
      }
    }

    // 3. Grounded Memories & Facts (with compression & provenance)
    for (int i = 0; i < searchResults.length; i++) {
      final res = searchResults[i];
      final note = res.note;
      allSourceIds.add(note.id);

      buffer.writeln('--- MEMORY [${i + 1}] (Note ID: ${note.id}) ---');
      buffer.writeln('Content: ${note.content}');
      if (note.summary != null && note.summary!.isNotEmpty) {
        buffer.writeln('Summary: ${note.summary}');
      }

      // Fetch entities linked to this note
      final entities = await _entitiesDao.getEntitiesForMemory(note.id);
      if (entities.isNotEmpty) {
        final entityDescriptions = entities.map((e) => '${e.name} (${e.type})').join(', ');
        buffer.writeln('Entities: $entityDescriptions');
      }

      // Fetch relationships for this note
      final rels = await _relationshipsDao.getByMemoryId(note.id);
      for (final rel in rels) {
        final source = await _entitiesDao.getById(rel.sourceEntityId);
        final target = await _entitiesDao.getById(rel.targetEntityId);
        if (source != null && target != null) {
          final triple = '${source.name} --${rel.relation}--> ${target.name} [Source Note: ${note.id}]';
          allTriples.add(triple);
          buffer.writeln('Knowledge Graph Fact: $triple');
        }
      }

      // Fetch tasks for this note
      final tasks = await _tasksDao.getByMemoryId(note.id);
      allTasks.addAll(tasks);
      if (tasks.isNotEmpty) {
        final taskDescriptions = tasks.map((t) {
          final status = t.isCompleted ? '[Done]' : '[Pending]';
          return '${t.description} $status (Due: ${t.dueDate ?? "unspecified"}, Source Note: ${note.id})';
        }).join('; ');
        buffer.writeln('Tasks: $taskDescriptions');
      }

      buffer.writeln();
    }

    return GroundedMemoryContext(
      contextString: buffer.toString().trim(),
      citedNotes: searchResults,
      graphTriples: allTriples.toList(),
      tasks: allTasks,
      contextHierarchyTree: contextHierarchyTree,
      timelineSnippet: timelineSnippet,
      sourceNoteIds: allSourceIds.toList(),
    );
  }
}
