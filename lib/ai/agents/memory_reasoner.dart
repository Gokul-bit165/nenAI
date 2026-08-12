import 'package:uuid/uuid.dart';
import '../../core/nlp/datetime_parser.dart';
import '../../data/local/database/daos/relationships_dao.dart';
import '../../domain/ai/note_analysis_result.dart';
import '../../domain/entities/memory_operation.dart';

class MemoryReasoner {
  MemoryReasoner(this._relationshipsDao);

  final RelationshipsDao _relationshipsDao;
  static const _uuid = Uuid();

  /// Decides atomic operations (CREATE, UPDATE, LINK, NO_OP) based on understanding and resolved entities.
  Future<List<MemoryOperation>> reason({
    required String noteId,
    required NoteAnalysisResult analysis,
    required List<ResolvedEntity> resolvedEntities,
  }) async {
    final operations = <MemoryOperation>[];
    final entityMap = <String, ResolvedEntity>{};

    // 1. Process Entities
    for (final resolved in resolvedEntities) {
      entityMap[resolved.originalMention.toLowerCase()] = resolved;
      entityMap[resolved.name.toLowerCase()] = resolved;

      if (resolved.status == ResolutionStatus.create) {
        operations.add(
          MemoryOperation.createEntity(
            id: resolved.entityId,
            name: resolved.name,
            type: resolved.type,
            canonicalName: resolved.canonicalName ?? resolved.name.toLowerCase(),
          ),
        );
      }
    }

    // 2. Process Facts / Relationships
    for (final fact in analysis.facts) {
      final source = _findResolved(fact.subject, entityMap);
      final target = _findResolved(fact.object, entityMap);

      if (source != null && target != null && source.entityId != target.entityId) {
        // Check if edge already exists in Knowledge Graph
        final existingEdge = await _relationshipsDao.findExactRelationship(
          sourceEntityId: source.entityId,
          relation: fact.predicate,
          targetEntityId: target.entityId,
        );

        if (existingEdge != null) {
          operations.add(
            MemoryOperation.noOp(
              reason: 'Relationship ${source.name} --${fact.predicate}--> ${target.name} already exists',
            ),
          );
        } else {
          operations.add(
            MemoryOperation.createRelationship(
              id: _uuid.v4(),
              sourceEntityId: source.entityId,
              relation: fact.predicate,
              targetEntityId: target.entityId,
              sourceMemoryId: noteId,
              confidence: fact.confidence,
            ),
          );
        }
      }
    }

    // 3. Process Tasks
    for (final task in analysis.tasks) {
      int? dueTimestamp;
      if (task.time != null && task.time!.isNotEmpty) {
        final parsedDate = DateTimeParser.parse(task.time!);
        dueTimestamp = parsedDate?.millisecondsSinceEpoch;
      }

      operations.add(
        MemoryOperation.createTask(
          id: _uuid.v4(),
          memoryId: noteId,
          description: task.description,
          dueDate: task.time,
          dueTimestamp: dueTimestamp,
        ),
      );
    }

    return operations;
  }

  ResolvedEntity? _findResolved(String mention, Map<String, ResolvedEntity> map) {
    final key = mention.trim().toLowerCase();
    if (map.containsKey(key)) return map[key];

    // Substring lookup
    for (final entry in map.entries) {
      if (key.contains(entry.key) || entry.key.contains(key)) {
        return entry.value;
      }
    }
    return null;
  }
}
