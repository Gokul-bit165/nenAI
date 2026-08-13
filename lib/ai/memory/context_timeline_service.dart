import '../../data/local/database/app_database.dart';
import '../../domain/entities/context_timeline.dart';
import '../../domain/repositories/context_repository.dart';
import 'hybrid_retriever.dart';

/// Context Timeline Service: Combines chronological notes, tasks, relationships,
/// context hierarchy evolutions, and completion states into multi-dimensional timelines.
class ContextTimelineService {
  ContextTimelineService({
    required this.db,
    required this.contextRepository,
    required this.hybridRetriever,
  });

  final AppDatabase db;
  final ContextRepository contextRepository;
  final HybridRetriever hybridRetriever;

  /// Builds a rich, chronologically ordered timeline for a specific context and its nested descendants.
  Future<ContextTimeline> getContextTimeline(
    String contextId, {
    bool includeDescendants = true,
  }) async {
    final rootNode = await contextRepository.getNodeById(contextId);
    if (rootNode == null) {
      return const ContextTimeline(
        contextName: 'Unknown Context',
        items: [],
      );
    }

    final targetContextIds = <String>{contextId};
    final contextNames = <String, String>{contextId: rootNode.name};

    if (includeDescendants) {
      final subtree = await contextRepository.getSubtree(contextId);
      if (subtree != null) {
        for (final node in subtree.allNodes) {
          targetContextIds.add(node.id);
          contextNames[node.id] = node.name;
        }
      }
    }

    final items = <TimelineItem>[];
    final processedNoteIds = <String>{};

    // 1. Gather Context Evolution / Milestone Events
    for (final ctxId in targetContextIds) {
      final node = await contextRepository.getNodeById(ctxId);
      if (node != null) {
        items.add(
          TimelineItem(
            id: 'node-created-${node.id}',
            timestamp: node.createdAt,
            type: TimelineItemType.contextEvolution,
            title: '${node.type.name.toUpperCase()}: ${node.name}',
            description: 'Context "${node.name}" established.',
            contextId: node.id,
            contextName: node.name,
          ),
        );
      }

      final childEdges = await contextRepository.getChildEdges(ctxId);
      for (final edge in childEdges) {
        final childNode = await contextRepository.getNodeById(edge.targetContextId);
        if (childNode != null) {
          items.add(
            TimelineItem(
              id: 'edge-${edge.id}',
              timestamp: edge.createdAt,
              type: TimelineItemType.milestone,
              title: '${childNode.name} (${edge.relationType})',
              description: 'Spawned ${edge.relationType} child "${childNode.name}".',
              contextId: ctxId,
              contextName: contextNames[ctxId],
            ),
          );
        }
      }
    }

    // 2. Gather Notes, Tasks, and Relationships
    for (final ctxId in targetContextIds) {
      final memoryIds = await contextRepository.getMemoriesForContext(ctxId);
      for (final mId in memoryIds) {
        if (processedNoteIds.contains(mId)) continue;
        processedNoteIds.add(mId);

        final note = await db.notes.getById(mId);
        if (note == null) continue;

        final noteDate = DateTime.fromMillisecondsSinceEpoch(note.createdAt);
        final entities = await db.entities.getEntitiesForMemory(mId);
        final entityNames = entities.map((e) => e.name).toList();

        // Note Entry
        items.add(
          TimelineItem(
            id: 'note-${note.id}',
            timestamp: noteDate,
            type: TimelineItemType.note,
            title: note.summary ?? note.content.split('\n').first,
            description: note.content,
            contextId: ctxId,
            contextName: contextNames[ctxId],
            entities: entityNames,
          ),
        );

        // Tasks associated with this Note
        final tasks = await db.tasks.getByMemoryId(mId);
        for (final task in tasks) {
          final taskDate = task.dueTimestamp != null
              ? DateTime.fromMillisecondsSinceEpoch(task.dueTimestamp!)
              : DateTime.fromMillisecondsSinceEpoch(task.createdAt);

          items.add(
            TimelineItem(
              id: 'task-${task.id}',
              timestamp: taskDate,
              type: TimelineItemType.task,
              title: task.description,
              description: 'Task: ${task.description}',
              contextId: ctxId,
              contextName: contextNames[ctxId],
              isCompleted: task.isCompleted,
              dueDate: task.dueDate,
              entities: entityNames,
            ),
          );
        }

        // Relationships / Facts created from this Note
        final rels = await db.relationships.getByMemoryId(mId);
        for (final rel in rels) {
          final src = await db.entities.getById(rel.sourceEntityId);
          final tgt = await db.entities.getById(rel.targetEntityId);
          if (src != null && tgt != null) {
            items.add(
              TimelineItem(
                id: 'rel-${rel.id}',
                timestamp: DateTime.fromMillisecondsSinceEpoch(rel.createdAt),
                type: TimelineItemType.relationship,
                title: '${src.name} ${rel.relation.replaceAll('_', ' ')} ${tgt.name}',
                description: 'Fact: ${src.name} -> ${rel.relation} -> ${tgt.name}',
                contextId: ctxId,
                contextName: contextNames[ctxId],
                entities: [src.name, tgt.name],
              ),
            );
          }
        }
      }
    }

    // Sort chronologically ascending
    items.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    return ContextTimeline(
      contextId: contextId,
      contextName: rootNode.name,
      items: items,
    );
  }

  /// Returns timeline items bounded by a specific date interval (e.g. "What did I do yesterday?").
  Future<ContextTimeline> getTimelineForDateRange(DateTime start, DateTime end) async {
    final startMs = start.millisecondsSinceEpoch;
    final endMs = end.millisecondsSinceEpoch;

    final allNotes = await db.notes.getAllNotes();
    final matchingNotes = allNotes.where((n) => n.createdAt >= startMs && n.createdAt <= endMs).toList();

    final items = <TimelineItem>[];

    for (final note in matchingNotes) {
      final noteDate = DateTime.fromMillisecondsSinceEpoch(note.createdAt);
      final entities = await db.entities.getEntitiesForMemory(note.id);
      final entityNames = entities.map((e) => e.name).toList();

      items.add(
        TimelineItem(
          id: 'note-${note.id}',
          timestamp: noteDate,
          type: TimelineItemType.note,
          title: note.summary ?? note.content.split('\n').first,
          description: note.content,
          entities: entityNames,
        ),
      );

      final tasks = await db.tasks.getByMemoryId(note.id);
      for (final task in tasks) {
        items.add(
          TimelineItem(
            id: 'task-${task.id}',
            timestamp: DateTime.fromMillisecondsSinceEpoch(task.createdAt),
            type: TimelineItemType.task,
            title: task.description,
            description: 'Task: ${task.description}',
            isCompleted: task.isCompleted,
            dueDate: task.dueDate,
          ),
        );
      }
    }

    items.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    return ContextTimeline(
      contextName: 'Time-Bounded Timeline (${start.month}/${start.day} - ${end.month}/${end.day})',
      items: items,
    );
  }

  /// Returns timeline items occurring after a specific milestone or event (e.g. "What happened after deployment?").
  Future<ContextTimeline> getTimelineAfterEvent(
    String eventOrMilestoneKeyword, {
    String? contextId,
  }) async {
    final keywordLower = eventOrMilestoneKeyword.toLowerCase().trim();
    DateTime? milestoneTimestamp;

    final allNotes = await db.notes.getAllNotes();
    for (final note in allNotes) {
      if (note.content.toLowerCase().contains(keywordLower) ||
          (note.summary?.toLowerCase().contains(keywordLower) ?? false)) {
        final dt = DateTime.fromMillisecondsSinceEpoch(note.createdAt);
        if (milestoneTimestamp == null || dt.isBefore(milestoneTimestamp)) {
          milestoneTimestamp = dt;
        }
      }
    }

    if (milestoneTimestamp == null) {
      return ContextTimeline(
        contextName: 'Post-Event: $eventOrMilestoneKeyword',
        items: const [],
      );
    }

    final postNotes = allNotes
        .where((n) => n.createdAt > milestoneTimestamp!.millisecondsSinceEpoch)
        .toList();

    final items = <TimelineItem>[];
    for (final note in postNotes) {
      items.add(
        TimelineItem(
          id: 'note-${note.id}',
          timestamp: DateTime.fromMillisecondsSinceEpoch(note.createdAt),
          type: TimelineItemType.note,
          title: note.summary ?? note.content.split('\n').first,
          description: note.content,
        ),
      );

      final tasks = await db.tasks.getByMemoryId(note.id);
      for (final task in tasks) {
        items.add(
          TimelineItem(
            id: 'task-${task.id}',
            timestamp: DateTime.fromMillisecondsSinceEpoch(task.createdAt),
            type: TimelineItemType.task,
            title: task.description,
            description: 'Task: ${task.description}',
            isCompleted: task.isCompleted,
            dueDate: task.dueDate,
          ),
        );
      }
    }

    items.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    return ContextTimeline(
      contextName: 'Events After "$eventOrMilestoneKeyword"',
      items: items,
    );
  }

  /// Returns all pending tasks, unresolved items, and planned actions (e.g. "What is pending?").
  Future<ContextTimeline> getPendingItemsTimeline({String? contextId}) async {
    final allTasks = await db.tasks.getPendingTasks();
    final items = <TimelineItem>[];

    for (final task in allTasks) {
      final taskDate = task.dueTimestamp != null
          ? DateTime.fromMillisecondsSinceEpoch(task.dueTimestamp!)
          : DateTime.fromMillisecondsSinceEpoch(task.createdAt);

      items.add(
        TimelineItem(
          id: 'task-${task.id}',
          timestamp: taskDate,
          type: TimelineItemType.task,
          title: task.description,
          description: 'Pending Task: ${task.description}',
          isCompleted: false,
          dueDate: task.dueDate,
        ),
      );
    }

    items.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    return ContextTimeline(
      contextName: 'Pending Tasks & Milestones',
      items: items,
    );
  }

  /// Returns all memories, facts, and meetings associated with a specific person or entity (e.g. "What was discussed with Dean?").
  Future<ContextTimeline> getEntityTimeline(String entityName) async {
    final entityMatches = await db.entities.searchByName(entityName);
    if (entityMatches.isEmpty) {
      return ContextTimeline(
        contextName: 'Entity: $entityName',
        items: const [],
      );
    }

    final entity = entityMatches.first;
    final items = <TimelineItem>[];
    final processedNotes = <String>{};

    // 1. Find memories where entity is mentioned
    final allNotes = await db.notes.getAllNotes();
    for (final note in allNotes) {
      final entities = await db.entities.getEntitiesForMemory(note.id);
      if (entities.any((e) => e.id == entity.id || e.canonicalName == entity.canonicalName)) {
        processedNotes.add(note.id);
        items.add(
          TimelineItem(
            id: 'note-${note.id}',
            timestamp: DateTime.fromMillisecondsSinceEpoch(note.createdAt),
            type: TimelineItemType.note,
            title: note.summary ?? note.content.split('\n').first,
            description: note.content,
            entities: entities.map((e) => e.name).toList(),
          ),
        );
      }
    }

    // 2. Find knowledge graph relationships involving this entity
    final relationships = await db.relationships.getByEntityId(entity.id);
    for (final rel in relationships) {
      final isSource = rel.sourceEntityId == entity.id;
      final otherId = isSource ? rel.targetEntityId : rel.sourceEntityId;
      final other = await db.entities.getById(otherId);

      if (other != null) {
        items.add(
          TimelineItem(
            id: 'rel-${rel.id}',
            timestamp: DateTime.fromMillisecondsSinceEpoch(rel.createdAt),
            type: TimelineItemType.relationship,
            title: isSource
                ? '${entity.name} ${rel.relation.replaceAll('_', ' ')} ${other.name}'
                : '${other.name} ${rel.relation.replaceAll('_', ' ')} ${entity.name}',
            description: 'Fact involving ${entity.name}.',
            entities: [entity.name, other.name],
          ),
        );
      }
    }

    items.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    return ContextTimeline(
      contextName: 'Discussions & Facts: ${entity.name}',
      items: items,
    );
  }

  /// Multi-dimensional query router that combines timeline, graph, and semantic context.
  Future<ContextTimeline> queryTimeline(String queryText) async {
    final qLower = queryText.toLowerCase().trim();

    // 1. "What did I do yesterday?" / "today"
    if (qLower.contains('yesterday')) {
      final now = DateTime.now();
      final yesterdayStart = DateTime(now.year, now.month, now.day - 1, 0, 0, 0);
      final yesterdayEnd = DateTime(now.year, now.month, now.day - 1, 23, 59, 59);
      return getTimelineForDateRange(yesterdayStart, yesterdayEnd);
    }

    // 2. "What happened after <event>?"
    if (qLower.contains('after ')) {
      final afterPart = qLower.split('after ').last.replaceAll('?', '').trim();
      return getTimelineAfterEvent(afterPart);
    }

    // 3. "What is pending?" / "pending tasks" / "todo"
    if (qLower.contains('pending') || qLower.contains('todo') || qLower.contains('remaining')) {
      return getPendingItemsTimeline();
    }

    // 4. Context name match in DB (e.g. "What happened with ReadSmart AI?")
    final allNodes = await db.contexts.getAllNodes();
    for (final node in allNodes) {
      if (qLower.contains(node.name.toLowerCase())) {
        return getContextTimeline(node.id);
      }
    }

    // 5. "What was discussed with <person>?"
    if (qLower.contains('discussed with') ||
        qLower.contains('meeting with') ||
        qLower.contains('talked with') ||
        qLower.contains('with ')) {
      final match = RegExp(r'(?:discussed with|meeting with|talked with|with)\s+([a-zA-Z0-9_-]+)').firstMatch(qLower);
      if (match != null && match.group(1) != null) {
        final entityTimeline = await getEntityTimeline(match.group(1)!);
        if (entityTimeline.items.isNotEmpty) {
          return entityTimeline;
        }
      }
    }

    // 6. Semantic hybrid fallback
    final searchResults = await hybridRetriever.retrieve(queryText, limit: 3);
    if (searchResults.isNotEmpty) {
      final firstNoteId = searchResults.first.note.id;
      final linkedContexts = await db.contexts.getContextsForMemory(firstNoteId);
      if (linkedContexts.isNotEmpty) {
        return getContextTimeline(linkedContexts.first.id);
      }
    }

    return ContextTimeline(
      contextName: 'Timeline for "$queryText"',
      items: const [],
    );
  }
}
