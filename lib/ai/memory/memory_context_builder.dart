import '../../data/local/database/app_database.dart';
import '../../data/local/database/daos/entities_dao.dart';
import '../../data/local/database/daos/relationships_dao.dart';
import '../../data/local/database/daos/tasks_dao.dart';
import 'hybrid_retriever.dart';

class GroundedMemoryContext {
  const GroundedMemoryContext({
    required this.contextString,
    required this.citedNotes,
    required this.graphTriples,
    required this.tasks,
  });

  final String contextString;
  final List<HybridSearchResult> citedNotes;
  final List<String> graphTriples;
  final List<TasksTableData> tasks;
}

class MemoryContextBuilder {
  MemoryContextBuilder({
    required EntitiesDao entitiesDao,
    required RelationshipsDao relationshipsDao,
    required TasksDao tasksDao,
  })  : _entitiesDao = entitiesDao,
        _relationshipsDao = relationshipsDao,
        _tasksDao = tasksDao;

  final EntitiesDao _entitiesDao;
  final RelationshipsDao _relationshipsDao;
  final TasksDao _tasksDao;

  Future<GroundedMemoryContext> buildContext(List<HybridSearchResult> searchResults) async {
    final buffer = StringBuffer();
    final allTriples = <String>{};
    final allTasks = <TasksTableData>[];

    for (int i = 0; i < searchResults.length; i++) {
      final res = searchResults[i];
      final note = res.note;
      buffer.writeln('--- MEMORY [${i + 1}] ---');
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
          final triple = '${source.name} --${rel.relation}--> ${target.name}';
          allTriples.add(triple);
          buffer.writeln('Knowledge Graph Fact: $triple');
        }
      }

      // Fetch tasks for this note
      final tasks = await _tasksDao.getByMemoryId(note.id);
      allTasks.addAll(tasks);
      if (tasks.isNotEmpty) {
        final taskDescriptions = tasks.map((t) => '${t.description} (Due: ${t.dueDate ?? "unspecified"})').join('; ');
        buffer.writeln('Tasks: $taskDescriptions');
      }

      buffer.writeln();
    }

    return GroundedMemoryContext(
      contextString: buffer.toString().trim(),
      citedNotes: searchResults,
      graphTriples: allTriples.toList(),
      tasks: allTasks,
    );
  }
}
