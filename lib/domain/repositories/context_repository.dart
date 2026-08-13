import '../entities/context_node.dart';

/// Single source of truth for hierarchical context nodes, DAG edges, and memory-context links.
abstract class ContextRepository {
  // ── Context Nodes ──────────────────────────────────────────────────────────

  /// Reactively emits all context nodes.
  Stream<List<ContextNode>> watchAllNodes();

  /// Fetches all context nodes.
  Future<List<ContextNode>> getAllNodes();

  /// Fetches a single context node by ID.
  Future<ContextNode?> getNodeById(String id);

  /// Fetches a context node by exact name.
  Future<ContextNode?> getNodeByName(String name);

  /// Searches context nodes by name substring.
  Future<List<ContextNode>> searchNodes(String query);

  /// Creates or updates a context node.
  Future<void> upsertNode(ContextNode node);

  /// Deletes a context node and associated edges/links.
  Future<void> deleteNode(String id);

  // ── DAG Edges ──────────────────────────────────────────────────────────────

  /// Adds or updates a directed edge in the context hierarchy.
  Future<void> upsertEdge(ContextEdge edge);

  /// Deletes an edge by ID.
  Future<void> deleteEdge(String id);

  /// Fetches all edges where [nodeId] is the source (outgoing/children edges).
  Future<List<ContextEdge>> getChildEdges(String nodeId);

  /// Fetches all edges where [nodeId] is the target (incoming/parent edges).
  Future<List<ContextEdge>> getParentEdges(String nodeId);

  /// Fetches all child context nodes for [nodeId].
  Future<List<ContextNode>> getChildren(String nodeId);

  /// Fetches all parent context nodes for [nodeId] (supports DAG with multiple parents).
  Future<List<ContextNode>> getParents(String nodeId);

  // ── Memory Links ───────────────────────────────────────────────────────────

  /// Links a raw memory note to a context node.
  Future<void> linkMemory(MemoryContextLink link);

  /// Removes a memory from a context.
  Future<void> unlinkMemory(String memoryId, String contextId);

  /// Fetches all context nodes associated with [memoryId].
  Future<List<ContextNode>> getContextsForMemory(String memoryId);

  /// Fetches all memory IDs associated with [contextId].
  Future<List<String>> getMemoriesForContext(String contextId);

  // ── Hierarchy & Subtree Traversal ──────────────────────────────────────────

  /// Recursively retrieves a full context hierarchy subtree rooted at [rootNodeId].
  Future<ContextSubtree?> getSubtree(String rootNodeId, {int maxDepth = 6});

  /// Traverses upward through the DAG to find all ancestor nodes for [nodeId].
  Future<List<ContextNode>> getAncestors(String nodeId);
}
