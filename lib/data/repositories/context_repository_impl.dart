import 'package:drift/drift.dart';
import '../../domain/entities/context_node.dart';
import '../../domain/repositories/context_repository.dart';
import '../local/database/app_database.dart';

class ContextRepositoryImpl implements ContextRepository {
  ContextRepositoryImpl(this._db);

  final AppDatabase _db;

  // ── Context Nodes ──────────────────────────────────────────────────────────

  @override
  Stream<List<ContextNode>> watchAllNodes() {
    return _db.contexts.watchAllNodes().map(
          (rows) => rows.map(_rowToNode).toList(),
        );
  }

  @override
  Future<List<ContextNode>> getAllNodes() async {
    final rows = await _db.contexts.getAllNodes();
    return rows.map(_rowToNode).toList();
  }

  @override
  Future<ContextNode?> getNodeById(String id) async {
    final row = await _db.contexts.getNodeById(id);
    return row == null ? null : _rowToNode(row);
  }

  @override
  Future<ContextNode?> getNodeByName(String name) async {
    final row = await _db.contexts.getNodeByName(name);
    return row == null ? null : _rowToNode(row);
  }

  @override
  Future<List<ContextNode>> searchNodes(String query) async {
    final rows = await _db.contexts.searchNodes(query);
    return rows.map(_rowToNode).toList();
  }

  @override
  Future<void> upsertNode(ContextNode node) {
    return _db.contexts.upsertNode(
      ContextNodesTableCompanion.insert(
        id: node.id,
        name: node.name,
        type: Value(node.type.name),
        description: Value(node.description),
        originatingMemoryId: Value(node.originatingMemoryId),
        createdAt: node.createdAt.millisecondsSinceEpoch,
        updatedAt: node.updatedAt.millisecondsSinceEpoch,
      ),
    );
  }

  @override
  Future<void> deleteNode(String id) {
    return _db.contexts.deleteNode(id);
  }

  // ── DAG Edges ──────────────────────────────────────────────────────────────

  @override
  Future<void> upsertEdge(ContextEdge edge) {
    return _db.contexts.upsertEdge(
      ContextEdgesTableCompanion.insert(
        id: edge.id,
        sourceContextId: edge.sourceContextId,
        targetContextId: edge.targetContextId,
        relationType: edge.relationType,
        confidence: Value(edge.confidence),
        originatingMemoryId: Value(edge.originatingMemoryId),
        evidence: Value(edge.evidence),
        createdAt: edge.createdAt.millisecondsSinceEpoch,
        updatedAt: edge.updatedAt.millisecondsSinceEpoch,
      ),
    );
  }

  @override
  Future<void> deleteEdge(String id) {
    return _db.contexts.deleteEdge(id);
  }

  @override
  Future<List<ContextEdge>> getChildEdges(String nodeId) async {
    final rows = await _db.contexts.getChildEdges(nodeId);
    return rows.map(_rowToEdge).toList();
  }

  @override
  Future<List<ContextEdge>> getParentEdges(String nodeId) async {
    final rows = await _db.contexts.getParentEdges(nodeId);
    return rows.map(_rowToEdge).toList();
  }

  @override
  Future<List<ContextNode>> getChildren(String nodeId) async {
    final rows = await _db.contexts.getChildren(nodeId);
    return rows.map(_rowToNode).toList();
  }

  @override
  Future<List<ContextNode>> getParents(String nodeId) async {
    final rows = await _db.contexts.getParents(nodeId);
    return rows.map(_rowToNode).toList();
  }

  // ── Memory Links ───────────────────────────────────────────────────────────

  @override
  Future<void> linkMemory(MemoryContextLink link) {
    return _db.contexts.linkMemory(
      MemoryContextsTableCompanion.insert(
        memoryId: link.memoryId,
        contextId: link.contextId,
        role: Value(link.role),
        confidence: Value(link.confidence),
        evidence: Value(link.evidence),
        createdAt: link.createdAt.millisecondsSinceEpoch,
      ),
    );
  }

  @override
  Future<void> unlinkMemory(String memoryId, String contextId) {
    return _db.contexts.unlinkMemory(memoryId, contextId);
  }

  @override
  Future<List<ContextNode>> getContextsForMemory(String memoryId) async {
    final rows = await _db.contexts.getContextsForMemory(memoryId);
    return rows.map(_rowToNode).toList();
  }

  @override
  Future<List<String>> getMemoriesForContext(String contextId) {
    return _db.contexts.getMemoriesForContext(contextId);
  }

  // ── Hierarchy & Subtree Traversal ──────────────────────────────────────────

  @override
  Future<ContextSubtree?> getSubtree(String rootNodeId, {int maxDepth = 6}) async {
    final root = await getNodeById(rootNodeId);
    if (root == null) return null;

    return _buildSubtreeRecursive(root, currentDepth: 0, maxDepth: maxDepth, visited: {});
  }

  Future<ContextSubtree> _buildSubtreeRecursive(
    ContextNode node, {
    required int currentDepth,
    required int maxDepth,
    required Set<String> visited,
  }) async {
    visited.add(node.id);

    final outboundRows = await _db.contexts.getChildEdges(node.id);
    final inboundRows = await _db.contexts.getParentEdges(node.id);
    final linkedMemoryIds = await _db.contexts.getMemoriesForContext(node.id);

    final children = <ContextSubtree>[];

    if (currentDepth < maxDepth) {
      final childNodes = await _db.contexts.getChildren(node.id);
      for (final child in childNodes) {
        if (!visited.contains(child.id)) {
          final childTree = await _buildSubtreeRecursive(
            _rowToNode(child),
            currentDepth: currentDepth + 1,
            maxDepth: maxDepth,
            visited: visited,
          );
          children.add(childTree);
        }
      }
    }

    return ContextSubtree(
      node: node,
      children: children,
      inboundEdges: inboundRows.map(_rowToEdge).toList(),
      outboundEdges: outboundRows.map(_rowToEdge).toList(),
      linkedMemoryIds: linkedMemoryIds,
    );
  }

  @override
  Future<List<ContextNode>> getAncestors(String nodeId) async {
    final rows = await _db.contexts.getAncestors(nodeId);
    return rows.map(_rowToNode).toList();
  }

  // ── Mappers ────────────────────────────────────────────────────────────────

  ContextNode _rowToNode(ContextNodesTableData row) {
    return ContextNode(
      id: row.id,
      name: row.name,
      type: ContextNodeType.fromString(row.type),
      description: row.description,
      originatingMemoryId: row.originatingMemoryId,
      createdAt: DateTime.fromMillisecondsSinceEpoch(row.createdAt),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(row.updatedAt),
    );
  }

  ContextEdge _rowToEdge(ContextEdgesTableData row) {
    return ContextEdge(
      id: row.id,
      sourceContextId: row.sourceContextId,
      targetContextId: row.targetContextId,
      relationType: row.relationType,
      confidence: row.confidence,
      originatingMemoryId: row.originatingMemoryId,
      evidence: row.evidence,
      createdAt: DateTime.fromMillisecondsSinceEpoch(row.createdAt),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(row.updatedAt),
    );
  }
}
