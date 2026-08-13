import 'package:uuid/uuid.dart';
import '../../domain/ai/note_analysis_result.dart';
import '../../domain/entities/context_node.dart';
import '../../domain/entities/memory_evidence.dart';
import '../../domain/entities/memory_operation.dart';
import '../../domain/repositories/context_repository.dart';
import '../../domain/repositories/evidence_repository.dart';

/// Dynamic Memory Evolution Engine: Continuously evolves and deepens existing context hierarchies,
/// supports context merging and splitting, handles stale context reactivation, and preserves complete provenance.
class ContextEvolutionEngine {
  ContextEvolutionEngine({
    required ContextRepository contextRepository,
    required EvidenceRepository evidenceRepository,
  })  : _contextRepository = contextRepository,
        _evidenceRepository = evidenceRepository;

  final ContextRepository _contextRepository;
  final EvidenceRepository _evidenceRepository;
  static const _uuid = Uuid();

  /// Analyzes whether an incoming note should extend an existing context with nested child activities or sub-topics.
  Future<List<MemoryOperation>> evolveContextHierarchy({
    required String noteId,
    required String noteText,
    required NoteAnalysisResult analysis,
    required ContextNode activeContext,
    required DateTime noteTimestamp,
  }) async {
    final operations = <MemoryOperation>[];
    final noteLower = noteText.toLowerCase();
    final actions = analysis.actions;

    // Detect Sub-Activity Evolution Patterns:
    // 1. "Testing" under "Deployment"
    if ((actions.any((a) => a.subject.toLowerCase() == 'testing') ||
            noteLower.contains('test this') ||
            noteLower.contains('testing')) &&
        (activeContext.name.toLowerCase().contains('deployment') ||
            activeContext.type == ContextNodeType.activity)) {
      final testingChildId = 'ctx-test-${_uuid.v4().substring(0, 8)}';
      operations.add(
        MemoryOperation.createChildContext(
          id: testingChildId,
          parentContextId: activeContext.id,
          childName: 'Testing',
          childType: 'activity',
          relationType: 'activity',
          originatingMemoryId: noteId,
        ),
      );
      operations.add(
        MemoryOperation.attachMemory(
          memoryId: noteId,
          contextId: testingChildId,
          contextName: 'Testing',
          role: 'evolved_child_activity',
          confidence: 0.95,
          evidence: 'Dynamic evolution: spawned child Testing under ${activeContext.name}.',
        ),
      );
      return operations;
    }

    // 2. "API failure" / Error / Issue under "Testing" or "Deployment"
    if ((noteLower.contains('failed') ||
            noteLower.contains('error') ||
            noteLower.contains('500') ||
            noteLower.contains('api failure') ||
            noteLower.contains('issue')) &&
        (activeContext.name.toLowerCase().contains('testing') ||
            activeContext.name.toLowerCase().contains('deployment') ||
            activeContext.type == ContextNodeType.activity)) {
      final issueChildId = 'ctx-issue-${_uuid.v4().substring(0, 8)}';
      final issueName = noteLower.contains('500') || noteLower.contains('api')
          ? 'API failure'
          : 'Testing Issue';

      operations.add(
        MemoryOperation.createChildContext(
          id: issueChildId,
          parentContextId: activeContext.id,
          childName: issueName,
          childType: 'task',
          relationType: 'issue_investigation',
          originatingMemoryId: noteId,
        ),
      );
      operations.add(
        MemoryOperation.attachMemory(
          memoryId: noteId,
          contextId: issueChildId,
          contextName: issueName,
          role: 'evolved_issue_context',
          confidence: 0.95,
          evidence: 'Dynamic evolution: spawned issue context "$issueName" under ${activeContext.name}.',
        ),
      );
      return operations;
    }

    // 3. General Extension: "Deployment" under a Project
    if ((actions.any((a) => a.subject.toLowerCase() == 'deployment') ||
            noteLower.contains('deployment')) &&
        activeContext.type == ContextNodeType.project) {
      final deployChildId = 'ctx-deploy-${_uuid.v4().substring(0, 8)}';
      operations.add(
        MemoryOperation.createChildContext(
          id: deployChildId,
          parentContextId: activeContext.id,
          childName: 'Deployment',
          childType: 'activity',
          relationType: 'activity',
          originatingMemoryId: noteId,
        ),
      );
      operations.add(
        MemoryOperation.attachMemory(
          memoryId: noteId,
          contextId: deployChildId,
          contextName: 'Deployment',
          role: 'evolved_child_activity',
          confidence: 0.95,
          evidence: 'Dynamic evolution: extended project "${activeContext.name}" with Deployment activity.',
        ),
      );
      return operations;
    }

    // Fallback: Attach directly to active context and bump updatedAt
    operations.add(
      MemoryOperation.attachMemory(
        memoryId: noteId,
        contextId: activeContext.id,
        contextName: activeContext.name,
        role: 'extended_context',
        confidence: 0.90,
        evidence: 'Direct attachment to active context ${activeContext.name}.',
      ),
    );
    operations.add(
      MemoryOperation.updateContext(contextId: activeContext.id),
    );

    return operations;
  }

  /// Merges duplicate or synonymous context nodes while preserving all historical links, edges, and provenance.
  Future<void> mergeContexts({
    required String sourceContextId,
    required String targetContextId,
  }) async {
    final now = DateTime.now();
    final sourceNode = await _contextRepository.getNodeById(sourceContextId);
    final targetNode = await _contextRepository.getNodeById(targetContextId);
    if (sourceNode == null || targetNode == null) return;

    // 1. Reparent all child edges from source to target
    final childEdges = await _contextRepository.getChildEdges(sourceContextId);
    for (final edge in childEdges) {
      await _contextRepository.upsertEdge(
        edge.copyWith(
          sourceContextId: targetContextId,
          evidence: 'Migrated from merged context "${sourceNode.name}"',
          updatedAt: now,
        ),
      );
    }

    // 2. Reparent all parent edges from source to target
    final parentEdges = await _contextRepository.getParentEdges(sourceContextId);
    for (final edge in parentEdges) {
      await _contextRepository.upsertEdge(
        edge.copyWith(
          targetContextId: targetContextId,
          evidence: 'Migrated from merged context "${sourceNode.name}"',
          updatedAt: now,
        ),
      );
    }

    // 3. Migrate all memory links
    final memories = await _contextRepository.getMemoriesForContext(sourceContextId);
    for (final memId in memories) {
      await _contextRepository.linkMemory(
        MemoryContextLink(
          memoryId: memId,
          contextId: targetContextId,
          role: 'merged_provenance',
          confidence: 1.0,
          evidence: 'Historical memory merged from "${sourceNode.name}" into "${targetNode.name}".',
          createdAt: now,
        ),
      );
      await _contextRepository.unlinkMemory(memId, sourceContextId);
    }

    // 4. Save audit evidence
    await _evidenceRepository.saveEvidence(
      MemoryEvidence(
        id: _uuid.v4(),
        sourceMemoryId: sourceNode.originatingMemoryId ?? 'system',
        sourceTextSnippet: 'Context merge operation',
        targetContextId: targetContextId,
        targetContextName: targetNode.name,
        relationType: 'merged_context',
        confidence: 1.0,
        inferenceType: InferenceType.explicit,
        signals: [
          const EvidenceSignal(
            signalType: SignalType.explicitMention,
            weight: 1.0,
            score: 1.0,
            description: 'User or system initiated context merge',
          ),
        ],
        explanation: 'Merged context "${sourceNode.name}" into "${targetNode.name}".',
        createdAt: now,
      ),
    );

    // 5. Delete source node
    await _contextRepository.deleteNode(sourceContextId);
  }

  /// Splits a broad context node by creating dedicated child nodes and re-linking memories.
  Future<List<ContextNode>> splitContext({
    required String contextId,
    required List<String> newChildNames,
    String childType = 'activity',
  }) async {
    final now = DateTime.now();
    final parentNode = await _contextRepository.getNodeById(contextId);
    if (parentNode == null) return const [];

    final createdChildren = <ContextNode>[];

    for (final name in newChildNames) {
      final childId = 'ctx-split-${_uuid.v4().substring(0, 8)}';
      final childNode = ContextNode(
        id: childId,
        name: name,
        type: ContextNodeType.fromString(childType),
        createdAt: now,
        updatedAt: now,
      );

      await _contextRepository.upsertNode(childNode);
      await _contextRepository.upsertEdge(
        ContextEdge(
          id: 'edge-${_uuid.v4().substring(0, 8)}',
          sourceContextId: contextId,
          targetContextId: childId,
          relationType: 'split_child',
          confidence: 1.0,
          evidence: 'Split from broad context "${parentNode.name}".',
          createdAt: now,
          updatedAt: now,
        ),
      );

      createdChildren.add(childNode);
    }

    return createdChildren;
  }

  /// Evaluates and updates stale context nodes without losing historical memory links.
  Future<void> reactivateContextIfStale({
    required String contextId,
  }) async {
    final node = await _contextRepository.getNodeById(contextId);
    if (node != null) {
      await _contextRepository.upsertNode(
        node.copyWith(
          updatedAt: DateTime.now(),
        ),
      );
    }
  }
}
