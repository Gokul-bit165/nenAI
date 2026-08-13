import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/context_node.dart';
import '../../../domain/entities/context_timeline.dart';
import '../../../domain/entities/note.dart';
import '../../../domain/repositories/context_repository.dart';
import '../../../domain/repositories/note_repository.dart';
import '../../../data/local/database/app_database.dart';
import '../../../ai/memory/context_timeline_service.dart';
import '../../../injection.dart';

class MemoryExplorerState {
  const MemoryExplorerState({
    this.projects = const [],
    this.meetings = const [],
    this.topics = const [],
    this.people = const [],
    this.allNotes = const [],
    this.selectedNode,
    this.selectedSubtree,
    this.breadcrumbPath = const [],
    this.relatedNotes = const [],
    this.entities = const [],
    this.tasks = const [],
    this.relationships = const [],
    this.timeline,
    this.expandedNodeIds = const {},
    this.searchQuery = '',
    this.isLoading = false,
  });

  final List<ContextNode> projects;
  final List<ContextNode> meetings;
  final List<ContextNode> topics;
  final List<EntitiesTableData> people;
  final List<Note> allNotes;
  final ContextNode? selectedNode;
  final ContextSubtree? selectedSubtree;
  final List<String> breadcrumbPath;
  final List<Note> relatedNotes;
  final List<EntitiesTableData> entities;
  final List<TasksTableData> tasks;
  final List<({String sourceName, String relation, String targetName})> relationships;
  final ContextTimeline? timeline;
  final Set<String> expandedNodeIds;
  final String searchQuery;
  final bool isLoading;

  MemoryExplorerState copyWith({
    List<ContextNode>? projects,
    List<ContextNode>? meetings,
    List<ContextNode>? topics,
    List<EntitiesTableData>? people,
    List<Note>? allNotes,
    ContextNode? selectedNode,
    ContextSubtree? selectedSubtree,
    List<String>? breadcrumbPath,
    List<Note>? relatedNotes,
    List<EntitiesTableData>? entities,
    List<TasksTableData>? tasks,
    List<({String sourceName, String relation, String targetName})>? relationships,
    ContextTimeline? timeline,
    Set<String>? expandedNodeIds,
    String? searchQuery,
    bool? isLoading,
    bool clearSelected = false,
  }) {
    return MemoryExplorerState(
      projects: projects ?? this.projects,
      meetings: meetings ?? this.meetings,
      topics: topics ?? this.topics,
      people: people ?? this.people,
      allNotes: allNotes ?? this.allNotes,
      selectedNode: clearSelected ? null : (selectedNode ?? this.selectedNode),
      selectedSubtree: clearSelected ? null : (selectedSubtree ?? this.selectedSubtree),
      breadcrumbPath: clearSelected ? const [] : (breadcrumbPath ?? this.breadcrumbPath),
      relatedNotes: clearSelected ? const [] : (relatedNotes ?? this.relatedNotes),
      entities: clearSelected ? const [] : (entities ?? this.entities),
      tasks: clearSelected ? const [] : (tasks ?? this.tasks),
      relationships: clearSelected ? const [] : (relationships ?? this.relationships),
      timeline: clearSelected ? null : (timeline ?? this.timeline),
      expandedNodeIds: expandedNodeIds ?? this.expandedNodeIds,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class MemoryExplorerNotifier extends StateNotifier<MemoryExplorerState> {
  MemoryExplorerNotifier() : super(const MemoryExplorerState()) {
    loadAll();
  }

  final _contextRepository = getIt<ContextRepository>();
  final _noteRepository = getIt<NoteRepository>();
  final _timelineService = getIt<ContextTimelineService>();
  final _db = getIt<AppDatabase>();

  Future<void> loadAll() async {
    state = state.copyWith(isLoading: true);

    final allNodes = await _contextRepository.getAllNodes();
    final allEntities = await _db.entities.getAll();
    final allNotesList = await _noteRepository.getAllNotes();

    final projects = allNodes.where((n) => n.type == ContextNodeType.project).toList();
    final meetings = allNodes.where((n) => n.type == ContextNodeType.episode).toList();
    final topics = allNodes.where((n) => n.type == ContextNodeType.topic || n.type == ContextNodeType.concept).toList();
    final people = allEntities.where((e) => e.type == 'person').toList();

    // Default expand all projects and meetings
    final expanded = <String>{...projects.map((p) => p.id), ...meetings.map((m) => m.id)};

    state = state.copyWith(
      projects: projects,
      meetings: meetings,
      topics: topics,
      people: people,
      allNotes: allNotesList,
      expandedNodeIds: expanded,
      isLoading: false,
    );

    // Auto-select first project if available
    if (projects.isNotEmpty && state.selectedNode == null) {
      await selectNode(projects.first.id);
    }
  }

  void toggleExpand(String nodeId) {
    final next = Set<String>.from(state.expandedNodeIds);
    if (next.contains(nodeId)) {
      next.remove(nodeId);
    } else {
      next.add(nodeId);
    }
    state = state.copyWith(expandedNodeIds: next);
  }

  Future<void> selectNode(String nodeId) async {
    final node = await _contextRepository.getNodeById(nodeId);
    if (node == null) return;

    // 1. Ancestor breadcrumb path
    final ancestors = await _contextRepository.getAncestors(node.id);
    final path = [...ancestors.reversed.map((a) => a.name), node.name];

    // 2. Subtree
    final subtree = await _contextRepository.getSubtree(node.id);

    // 3. Related Notes (from this node and its descendants)
    final targetContextIds = <String>{node.id};
    if (subtree != null) {
      for (final child in subtree.allNodes) {
        targetContextIds.add(child.id);
      }
    }

    final notes = <Note>[];
    final allNoteIds = <String>{};
    for (final ctxId in targetContextIds) {
      final memIds = await _contextRepository.getMemoriesForContext(ctxId);
      for (final mId in memIds) {
        if (!allNoteIds.contains(mId)) {
          allNoteIds.add(mId);
          final n = await _noteRepository.getNoteById(mId);
          if (n != null) notes.add(n);
        }
      }
    }

    // 4. Entities, Tasks, and Relationships
    final entities = <EntitiesTableData>[];
    final seenEntityIds = <String>{};
    final tasks = <TasksTableData>[];
    final relationships = <({String sourceName, String relation, String targetName})>[];

    for (final mId in allNoteIds) {
      final noteEntities = await _db.entities.getEntitiesForMemory(mId);
      for (final e in noteEntities) {
        if (seenEntityIds.add(e.id)) {
          entities.add(e);
        }
      }

      final noteTasks = await _db.tasks.getByMemoryId(mId);
      tasks.addAll(noteTasks);

      final noteRels = await _db.relationships.getByMemoryId(mId);
      for (final r in noteRels) {
        final src = await _db.entities.getById(r.sourceEntityId);
        final tgt = await _db.entities.getById(r.targetEntityId);
        if (src != null && tgt != null) {
          relationships.add((
            sourceName: src.name,
            relation: r.relation,
            targetName: tgt.name,
          ));
        }
      }
    }

    // 5. Timeline
    final timeline = await _timelineService.getContextTimeline(node.id);

    state = state.copyWith(
      selectedNode: node,
      selectedSubtree: subtree,
      breadcrumbPath: path,
      relatedNotes: notes,
      entities: entities,
      tasks: tasks,
      relationships: relationships,
      timeline: timeline,
    );
  }

  void search(String query) {
    state = state.copyWith(searchQuery: query);
  }
}

final memoryExplorerProvider =
    StateNotifierProvider.autoDispose<MemoryExplorerNotifier, MemoryExplorerState>((ref) {
  return MemoryExplorerNotifier();
});
