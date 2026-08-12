import 'package:drift/drift.dart';
import '../../data/local/database/app_database.dart';
import '../../domain/entities/memory_operation.dart';

/// Memory Router: 100% deterministic Dart code that executes validated memory operations in SQLite transactions.
class MemoryRouter {
  MemoryRouter(this._db);

  final AppDatabase _db;

  /// Executes memory operations and entity-to-memory links transactionally.
  Future<void> execute({
    required String noteId,
    required List<MemoryOperation> operations,
    required List<ResolvedEntity> resolvedEntities,
  }) async {
    await _db.transaction(() async {
      final now = DateTime.now().millisecondsSinceEpoch;

      // 1. Process Operations
      for (final op in operations) {
        switch (op.type) {
          case OperationType.createEntity:
            final id = op.payload['id'] as String;
            final name = op.payload['name'] as String;
            final type = op.payload['type'] as String;
            final canonicalName = op.payload['canonicalName'] as String;

            await _db.entities.upsertEntity(
              EntitiesTableCompanion.insert(
                id: id,
                name: name,
                type: type,
                canonicalName: canonicalName,
                createdAt: now,
                updatedAt: now,
              ),
            );
            break;

          case OperationType.createRelationship:
            final id = op.payload['id'] as String;
            final sourceEntityId = op.payload['sourceEntityId'] as String;
            final relation = op.payload['relation'] as String;
            final targetEntityId = op.payload['targetEntityId'] as String;
            final sourceMemoryId = op.payload['sourceMemoryId'] as String;
            final confidence = (op.payload['confidence'] as num?)?.toDouble() ?? 1.0;

            await _db.relationships.upsertRelationship(
              RelationshipsTableCompanion.insert(
                id: id,
                sourceEntityId: sourceEntityId,
                relation: relation,
                targetEntityId: targetEntityId,
                sourceMemoryId: sourceMemoryId,
                confidence: Value(confidence),
                createdAt: now,
                updatedAt: now,
              ),
            );
            break;

          case OperationType.createTask:
            final id = op.payload['id'] as String;
            final memoryId = op.payload['memoryId'] as String;
            final description = op.payload['description'] as String;
            final dueDate = op.payload['dueDate'] as String?;
            final dueTimestamp = op.payload['dueTimestamp'] as int?;

            await _db.tasks.insertTask(
              TasksTableCompanion.insert(
                id: id,
                memoryId: memoryId,
                description: description,
                dueDate: Value(dueDate),
                dueTimestamp: Value(dueTimestamp),
                isCompleted: const Value(false),
                createdAt: now,
                updatedAt: now,
              ),
            );
            break;

          case OperationType.linkMemory:
          case OperationType.updateEntity:
          case OperationType.updateRelationship:
          case OperationType.updateTask:
          case OperationType.updateMemory:
          case OperationType.noOp:
            // Handled or no-op
            break;
        }
      }

      // 2. Link all resolved entities to this memory
      for (final resolved in resolvedEntities) {
        if (resolved.entityId.isNotEmpty) {
          await _db.entities.linkEntityToMemory(
            noteId,
            resolved.entityId,
            role: 'mentioned',
          );
        }
      }
    });
  }
}
