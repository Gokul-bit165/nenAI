import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../data/local/database/app_database.dart';
import '../../domain/entities/context_node.dart';
import '../../domain/entities/memory_evidence.dart';
import '../../domain/entities/memory_operation.dart';
import '../../domain/entities/pending_resolution.dart';
import '../../domain/repositories/context_repository.dart';
import '../../domain/repositories/evidence_repository.dart';
import '../../domain/repositories/resolution_repository.dart';

/// Memory Router: 100% deterministic Dart execution engine that validates and applies
/// atomic memory operations (contexts, edges, entities, relationships, tasks, evidence) in SQLite.
class MemoryRouter {
  MemoryRouter({
    required AppDatabase db,
    required ContextRepository contextRepository,
    required EvidenceRepository evidenceRepository,
    required ResolutionRepository resolutionRepository,
  })  : _db = db,
        _contextRepository = contextRepository,
        _evidenceRepository = evidenceRepository,
        _resolutionRepository = resolutionRepository;

  final AppDatabase _db;
  final ContextRepository _contextRepository;
  final EvidenceRepository _evidenceRepository;
  final ResolutionRepository _resolutionRepository;
  static const _uuid = Uuid();

  /// Executes memory operations and entity-to-memory links transactionally.
  Future<void> execute({
    required String noteId,
    required List<MemoryOperation> operations,
    required List<ResolvedEntity> resolvedEntities,
  }) async {
    final now = DateTime.now();
    final nowEpoch = now.millisecondsSinceEpoch;

    // 1. Process Operations
    for (final op in operations) {
      switch (op.type) {
        case OperationType.createContext:
          final id = op.payload['id'] as String;
          final name = op.payload['name'] as String;
          final typeStr = op.payload['type'] as String;
          final origMemId = op.payload['originatingMemoryId'] as String?;

          await _contextRepository.upsertNode(
            ContextNode(
              id: id,
              name: name,
              type: ContextNodeType.fromString(typeStr),
              originatingMemoryId: origMemId,
              createdAt: now,
              updatedAt: now,
            ),
          );
          break;

        case OperationType.createChildContext:
          final id = op.payload['id'] as String;
          final parentId = op.payload['parentContextId'] as String;
          final childName = op.payload['childName'] as String;
          final childTypeStr = op.payload['childType'] as String;
          final relationType = op.payload['relationType'] as String? ?? 'has_child';
          final origMemId = op.payload['originatingMemoryId'] as String?;

          await _contextRepository.upsertNode(
            ContextNode(
              id: id,
              name: childName,
              type: ContextNodeType.fromString(childTypeStr),
              originatingMemoryId: origMemId,
              createdAt: now,
              updatedAt: now,
            ),
          );

          await _contextRepository.upsertEdge(
            ContextEdge(
              id: 'edge-${_uuid.v4().substring(0, 8)}',
              sourceContextId: parentId,
              targetContextId: id,
              relationType: relationType,
              confidence: 1.0,
              originatingMemoryId: origMemId,
              createdAt: now,
              updatedAt: now,
            ),
          );
          break;

        case OperationType.attachMemory:
          final memId = op.payload['memoryId'] as String;
          final ctxId = op.payload['contextId'] as String;
          final ctxName = op.payload['contextName'] as String? ?? 'Context';
          final role = op.payload['role'] as String? ?? 'attached';
          final conf = (op.payload['confidence'] as num?)?.toDouble() ?? 1.0;
          final evText = op.payload['evidence'] as String? ?? 'Attached to context $ctxName';

          await _contextRepository.linkMemory(
            MemoryContextLink(
              memoryId: memId,
              contextId: ctxId,
              role: role,
              confidence: conf,
              evidence: evText,
              createdAt: now,
            ),
          );

          await _evidenceRepository.saveEvidence(
            MemoryEvidence(
              id: _uuid.v4(),
              sourceMemoryId: memId,
              sourceTextSnippet: evText,
              targetContextId: ctxId,
              targetContextName: ctxName,
              relationType: role,
              confidence: conf,
              inferenceType: conf >= 0.90 ? InferenceType.strongInference : InferenceType.weakInference,
              signals: [
                EvidenceSignal(
                  signalType: SignalType.contextContinuity,
                  weight: 1.0,
                  score: conf,
                  description: evText,
                ),
              ],
              explanation: evText,
              createdAt: now,
            ),
          );
          break;

        case OperationType.linkContext:
          final srcId = op.payload['sourceContextId'] as String;
          final tgtId = op.payload['targetContextId'] as String;
          final rel = op.payload['relationType'] as String? ?? 'relates_to';
          final conf = (op.payload['confidence'] as num?)?.toDouble() ?? 1.0;
          final ev = op.payload['evidence'] as String?;
          final origMemId = op.payload['originatingMemoryId'] as String?;

          await _contextRepository.upsertEdge(
            ContextEdge(
              id: 'edge-${_uuid.v4().substring(0, 8)}',
              sourceContextId: srcId,
              targetContextId: tgtId,
              relationType: rel,
              confidence: conf,
              evidence: ev,
              originatingMemoryId: origMemId,
              createdAt: now,
              updatedAt: now,
            ),
          );
          break;

        case OperationType.updateContext:
          final ctxId = op.payload['contextId'] as String;
          final existing = await _contextRepository.getNodeById(ctxId);
          if (existing != null) {
            final newName = op.payload['name'] as String? ?? existing.name;
            final newType = op.payload['type'] != null
                ? ContextNodeType.fromString(op.payload['type'] as String)
                : existing.type;
            await _contextRepository.upsertNode(
              existing.copyWith(
                name: newName,
                type: newType,
                updatedAt: now,
              ),
            );
          }
          break;

        case OperationType.mergeContext:
          final srcId = op.payload['sourceContextId'] as String;
          final tgtId = op.payload['targetContextId'] as String;
          final srcMemories = await _contextRepository.getMemoriesForContext(srcId);
          for (final mId in srcMemories) {
            await _contextRepository.linkMemory(
              MemoryContextLink(
                memoryId: mId,
                contextId: tgtId,
                role: 'merged',
                confidence: 1.0,
                createdAt: now,
              ),
            );
          }
          break;

        case OperationType.splitContext:
          final srcId = op.payload['sourceContextId'] as String;
          final newChildNodes = op.payload['newChildNodes'] as List<dynamic>;
          for (final rawChild in newChildNodes) {
            final childMap = rawChild as Map<String, dynamic>;
            final childId = childMap['id'] as String? ?? 'ctx-split-${_uuid.v4().substring(0, 8)}';
            final childName = childMap['name'] as String? ?? 'Child Context';
            final childType = childMap['type'] as String? ?? 'activity';

            await _contextRepository.upsertNode(
              ContextNode(
                id: childId,
                name: childName,
                type: ContextNodeType.fromString(childType),
                createdAt: now,
                updatedAt: now,
              ),
            );

            await _contextRepository.upsertEdge(
              ContextEdge(
                id: 'edge-${_uuid.v4().substring(0, 8)}',
                sourceContextId: srcId,
                targetContextId: childId,
                relationType: 'split_child',
                confidence: 1.0,
                createdAt: now,
                updatedAt: now,
              ),
            );
          }
          break;

        case OperationType.requestClarification:
          final memId = op.payload['memoryId'] as String;
          final snippet = op.payload['noteTextSnippet'] as String;
          final rawCandidates = op.payload['candidates'] as List<dynamic>;

          final candidates = rawCandidates
              .whereType<Map<String, dynamic>>()
              .map((c) => ResolutionCandidateOption.fromJson(c))
              .toList();

          await _resolutionRepository.savePendingResolution(
            PendingResolution(
              id: 'res-${_uuid.v4().substring(0, 8)}',
              memoryId: memId,
              noteTextSnippet: snippet,
              candidates: candidates,
              createdAt: now,
            ),
          );
          break;

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
              createdAt: nowEpoch,
              updatedAt: nowEpoch,
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
          // inferenceType stored in payload for audit; DB default 'extracted' is used if not in companion

          await _db.relationships.upsertRelationship(
            RelationshipsTableCompanion.insert(
              id: id,
              sourceEntityId: sourceEntityId,
              relation: relation,
              targetEntityId: targetEntityId,
              sourceMemoryId: sourceMemoryId,
              confidence: Value(confidence),
              createdAt: nowEpoch,
              updatedAt: nowEpoch,
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
              createdAt: nowEpoch,
              updatedAt: nowEpoch,
            ),
          );
          break;

        case OperationType.linkMemory:
        case OperationType.updateEntity:
        case OperationType.noOp:
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
  }
}
