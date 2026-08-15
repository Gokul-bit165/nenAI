import 'package:uuid/uuid.dart';
import '../../data/local/database/app_database.dart';
import '../../domain/entities/context_node.dart';
import '../../domain/entities/memory_evidence.dart';
import '../../domain/entities/memory_correction.dart';
import '../../domain/repositories/context_repository.dart';
import '../../domain/repositories/evidence_repository.dart';
import 'context_evolution_engine.dart';

/// Memory Correction Service: Manages user-confirmed overrides, context moves,
/// entity corrections, context merges/splits, and historical provenance preservation.
class MemoryCorrectionService {
  MemoryCorrectionService({
    required this.db,
    required this.contextRepository,
    required this.evidenceRepository,
    required this.contextEvolutionEngine,
    Uuid? uuid,
  }) : _uuid = uuid ?? const Uuid();

  final AppDatabase db;
  final ContextRepository contextRepository;
  final EvidenceRepository evidenceRepository;
  final ContextEvolutionEngine contextEvolutionEngine;
  final Uuid _uuid;

  /// Moves a memory note from an inferred context to a user-confirmed target context.
  Future<MemoryCorrectionResult> moveMemoryContext({
    required String memoryId,
    required String fromContextId,
    required String toContextId,
    String? reason,
  }) async {
    final fromNode = await contextRepository.getNodeById(fromContextId);
    final toNode = await contextRepository.getNodeById(toContextId);

    if (toNode == null) {
      return MemoryCorrectionResult(
        success: false,
        message: 'Target context "$toContextId" not found.',
      );
    }

    final fromName = fromNode?.name ?? fromContextId;
    final now = DateTime.now();

    // 1. Unlink from old context
    await contextRepository.unlinkMemory(memoryId, fromContextId);

    // 2. Link to new context with 1.0 confidence (User Authority)
    await contextRepository.linkMemory(
      MemoryContextLink(
        memoryId: memoryId,
        contextId: toContextId,
        role: 'user_confirmed',
        confidence: 1.0,
        evidence: reason ?? 'User manually relocated from "$fromName" to "${toNode.name}"',
        createdAt: now,
      ),
    );

    // 3. Mark note completed
    await db.notes.updateStatus(memoryId, 'completed');

    final note = await db.notes.getById(memoryId);
    final snippet = (note != null && note.content.isNotEmpty)
        ? note.content
        : (reason ?? 'User manual relocation');

    // 4. Create explicit user-confirmed audit evidence record
    final auditEvidenceId = 'ev-move-${_uuid.v4().substring(0, 8)}';
    await evidenceRepository.saveEvidence(
      MemoryEvidence(
        id: auditEvidenceId,
        sourceMemoryId: memoryId,
        sourceTextSnippet: snippet,
        targetContextId: toContextId,
        targetContextName: toNode.name,
        relationType: 'user_relocated',
        confidence: 1.0,
        inferenceType: InferenceType.explicit,
        explanation: 'User moved note from "$fromName" to "${toNode.name}". Previous model inference preserved for audit.',
        createdAt: now,
        signals: const [
          EvidenceSignal(
            signalType: SignalType.explicitMention,
            weight: 1.0,
            score: 1.0,
            description: 'User confirmed context assignment',
          ),
        ],
      ),
    );

    return MemoryCorrectionResult(
      success: true,
      message: 'Moved note from "$fromName" to "${toNode.name}".',
      auditEvidenceId: auditEvidenceId,
      affectedMemoryIds: [memoryId],
      affectedContextIds: [fromContextId, toContextId],
    );
  }

  /// Explicitly unlinks a note from a context and registers a negative user preference.
  Future<MemoryCorrectionResult> excludeMemoryFromContext({
    required String memoryId,
    required String contextId,
    String? reason,
  }) async {
    final node = await contextRepository.getNodeById(contextId);
    final nodeName = node?.name ?? contextId;
    final now = DateTime.now();

    // 1. Unlink
    await contextRepository.unlinkMemory(memoryId, contextId);

    // 2. Record audit evidence of user exclusion
    final auditEvidenceId = 'ev-exclude-${_uuid.v4().substring(0, 8)}';
    await evidenceRepository.saveEvidence(
      MemoryEvidence(
        id: auditEvidenceId,
        sourceMemoryId: memoryId,
        sourceTextSnippet: reason ?? 'User explicit exclusion',
        targetContextId: contextId,
        targetContextName: nodeName,
        relationType: 'user_excluded',
        confidence: 1.0,
        inferenceType: InferenceType.explicit,
        explanation: 'User explicitly declared note unrelated to "$nodeName".',
        createdAt: now,
        signals: const [
          EvidenceSignal(
            signalType: SignalType.explicitMention,
            weight: 1.0,
            score: 1.0,
            description: 'User explicit negative preference',
          ),
        ],
      ),
    );

    return MemoryCorrectionResult(
      success: true,
      message: 'Unlinked note from "$nodeName".',
      auditEvidenceId: auditEvidenceId,
      affectedMemoryIds: [memoryId],
      affectedContextIds: [contextId],
    );
  }

  /// Renames an existing context node while preserving all DAG edges and memory links.
  Future<MemoryCorrectionResult> renameContext({
    required String contextId,
    required String newName,
  }) async {
    final node = await contextRepository.getNodeById(contextId);
    if (node == null) {
      return MemoryCorrectionResult(
        success: false,
        message: 'Context "$contextId" not found.',
      );
    }

    final oldName = node.name;
    final now = DateTime.now();

    await contextRepository.upsertNode(
      node.copyWith(name: newName, updatedAt: now),
    );

    final auditEvidenceId = 'ev-rename-${_uuid.v4().substring(0, 8)}';
    await evidenceRepository.saveEvidence(
      MemoryEvidence(
        id: auditEvidenceId,
        sourceMemoryId: node.originatingMemoryId ?? 'context-$contextId',
        sourceTextSnippet: 'Rename context $oldName to $newName',
        targetContextId: contextId,
        targetContextName: newName,
        relationType: 'user_renamed',
        confidence: 1.0,
        inferenceType: InferenceType.explicit,
        explanation: 'User renamed context from "$oldName" to "$newName".',
        createdAt: now,
        signals: const [
          EvidenceSignal(
            signalType: SignalType.explicitMention,
            weight: 1.0,
            score: 1.0,
            description: 'User renamed context node',
          ),
        ],
      ),
    );

    return MemoryCorrectionResult(
      success: true,
      message: 'Renamed context "$oldName" to "$newName".',
      auditEvidenceId: auditEvidenceId,
      affectedContextIds: [contextId],
    );
  }

  /// Corrects an entity's name or type in the local Knowledge Graph.
  Future<MemoryCorrectionResult> correctEntity({
    required String entityId,
    required String newName,
    String? newType,
  }) async {
    final existing = await db.entities.getById(entityId);
    if (existing == null) {
      return MemoryCorrectionResult(
        success: false,
        message: 'Entity "$entityId" not found.',
      );
    }

    final now = DateTime.now();
    await db.entities.upsertEntity(
      EntitiesTableCompanion.insert(
        id: entityId,
        name: newName,
        canonicalName: newName.toLowerCase().trim(),
        type: newType ?? existing.type,
        createdAt: existing.createdAt,
        updatedAt: now.millisecondsSinceEpoch,
      ),
    );

    return MemoryCorrectionResult(
      success: true,
      message: 'Updated entity "${existing.name}" to "$newName".',
    );
  }

  /// Removes a Knowledge Graph relationship.
  Future<MemoryCorrectionResult> removeRelationship({
    required String relationshipId,
    String? memoryId,
  }) async {
    await db.relationships.deleteRelationship(relationshipId);

    if (memoryId != null) {
      final auditId = 'ev-rel-del-${_uuid.v4().substring(0, 8)}';
      await evidenceRepository.saveEvidence(
        MemoryEvidence(
          id: auditId,
          sourceMemoryId: memoryId,
          sourceTextSnippet: 'Remove relationship $relationshipId',
          targetContextId: 'graph-relationship',
          targetContextName: 'Knowledge Graph',
          relationType: 'user_removed_relation',
          confidence: 1.0,
          inferenceType: InferenceType.explicit,
          explanation: 'User removed knowledge graph relationship $relationshipId.',
          createdAt: DateTime.now(),
          signals: const [
            EvidenceSignal(
              signalType: SignalType.explicitMention,
              weight: 1.0,
              score: 1.0,
              description: 'User removed knowledge graph edge',
            ),
          ],
        ),
      );
    }

    return const MemoryCorrectionResult(
      success: true,
      message: 'Removed knowledge graph relationship.',
    );
  }

  /// Merges two synonymous or duplicate contexts.
  Future<MemoryCorrectionResult> mergeContexts({
    required String primaryContextId,
    required String duplicateContextId,
  }) async {
    await contextEvolutionEngine.mergeContexts(
      sourceContextId: duplicateContextId,
      targetContextId: primaryContextId,
    );

    return MemoryCorrectionResult(
      success: true,
      message: 'Merged context "$duplicateContextId" into "$primaryContextId".',
      affectedContextIds: [primaryContextId, duplicateContextId],
    );
  }

  /// Splits a broad context into dedicated child contexts.
  Future<MemoryCorrectionResult> splitContext({
    required String contextId,
    required List<String> childNames,
    String childType = 'activity',
  }) async {
    final created = await contextEvolutionEngine.splitContext(
      contextId: contextId,
      newChildNames: childNames,
      childType: childType,
    );

    return MemoryCorrectionResult(
      success: true,
      message: 'Split context into ${created.length} sub-contexts.',
      affectedContextIds: [contextId, ...created.map((c) => c.id)],
    );
  }

  /// Returns learned context preference from past user corrections for a topic or phrase.
  Future<String?> getLearnedContextPreference(String queryText) async {
    final qLower = queryText.toLowerCase().trim();
    final qTokens = qLower.split(RegExp(r'\s+')).where((t) => t.length > 2).toSet();
    final allEvidence = await db.evidence.getAll();

    for (final ev in allEvidence) {
      if (ev.relationType == 'user_relocated' || ev.relationType == 'user_confirmed') {
        final snipLower = ev.sourceTextSnippet.toLowerCase();
        if (snipLower.isNotEmpty && (qLower.contains(snipLower) || snipLower.contains(qLower))) {
          return ev.targetContextId;
        }
        final snipTokens = snipLower.split(RegExp(r'\s+')).where((t) => t.length > 2).toSet();
        if (qTokens.intersection(snipTokens).length >= 2 || (qTokens.isNotEmpty && snipTokens.containsAll(qTokens))) {
          return ev.targetContextId;
        }
        final explLower = ev.explanation.toLowerCase();
        if (explLower.isNotEmpty && (qLower.contains(explLower) || explLower.contains(qLower))) {
          return ev.targetContextId;
        }
      }
    }
    return null;
  }
}
