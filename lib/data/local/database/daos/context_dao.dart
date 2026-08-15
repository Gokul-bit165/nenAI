import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/context_nodes_table.dart';
import '../tables/context_edges_table.dart';
import '../tables/memory_contexts_table.dart';

part 'context_dao.g.dart';

@DriftAccessor(tables: [
  ContextNodesTable,
  ContextEdgesTable,
  MemoryContextsTable,
])
class ContextDao extends DatabaseAccessor<AppDatabase> with _$ContextDaoMixin {
  ContextDao(super.db);

  // ── Context Nodes ──────────────────────────────────────────────────────────

  Stream<List<ContextNodesTableData>> watchAllNodes() =>
      (select(contextNodesTable)..orderBy([(t) => OrderingTerm.asc(t.name)]))
          .watch();

  Future<List<ContextNodesTableData>> getAllNodes() =>
      select(contextNodesTable).get();

  Future<ContextNodesTableData?> getNodeById(String id) =>
      (select(contextNodesTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<ContextNodesTableData?> getNodeByName(String name) =>
      (select(contextNodesTable)
            ..where((t) => t.name.lower().equals(name.toLowerCase().trim())))
          .getSingleOrNull();

  Future<List<ContextNodesTableData>> searchNodes(String query) {
    final q = '%${query.toLowerCase().trim()}%';
    return (select(contextNodesTable)..where((t) => t.name.lower().like(q)))
        .get();
  }

  Future<void> upsertNode(ContextNodesTableCompanion node) =>
      into(contextNodesTable).insertOnConflictUpdate(node);

  Future<void> deleteNode(String id) async {
    await (delete(contextEdgesTable)
          ..where((t) => t.sourceContextId.equals(id) | t.targetContextId.equals(id)))
        .go();
    await (delete(memoryContextsTable)..where((t) => t.contextId.equals(id))).go();
    await (delete(contextNodesTable)..where((t) => t.id.equals(id))).go();
  }

  // ── Context Edges ──────────────────────────────────────────────────────────

  Future<void> upsertEdge(ContextEdgesTableCompanion edge) =>
      into(contextEdgesTable).insertOnConflictUpdate(edge);

  Future<void> deleteEdge(String id) =>
      (delete(contextEdgesTable)..where((t) => t.id.equals(id))).go();

  Future<List<ContextEdgesTableData>> getChildEdges(String nodeId) =>
      (select(contextEdgesTable)..where((t) => t.sourceContextId.equals(nodeId)))
          .get();

  Future<List<ContextEdgesTableData>> getParentEdges(String nodeId) =>
      (select(contextEdgesTable)..where((t) => t.targetContextId.equals(nodeId)))
          .get();

  Future<List<ContextNodesTableData>> getChildren(String nodeId) async {
    final query = select(contextEdgesTable).join([
      innerJoin(
        contextNodesTable,
        contextNodesTable.id.equalsExp(contextEdgesTable.targetContextId),
      ),
    ])..where(contextEdgesTable.sourceContextId.equals(nodeId));

    final rows = await query.get();
    return rows.map((r) => r.readTable(contextNodesTable)).toList();
  }

  Future<List<ContextNodesTableData>> getParents(String nodeId) async {
    final query = select(contextEdgesTable).join([
      innerJoin(
        contextNodesTable,
        contextNodesTable.id.equalsExp(contextEdgesTable.sourceContextId),
      ),
    ])..where(contextEdgesTable.targetContextId.equals(nodeId));

    final rows = await query.get();
    return rows.map((r) => r.readTable(contextNodesTable)).toList();
  }

  // ── Memory Context Links ───────────────────────────────────────────────────

  Future<void> linkMemory(MemoryContextsTableCompanion link) =>
      into(memoryContextsTable).insertOnConflictUpdate(link);

  Future<void> unlinkMemory(String memoryId, String contextId) =>
      (delete(memoryContextsTable)
            ..where((t) =>
                t.memoryId.equals(memoryId) & t.contextId.equals(contextId)))
          .go();

  Future<List<ContextNodesTableData>> getContextsForMemory(String memoryId) async {
    final query = select(memoryContextsTable).join([
      innerJoin(
        contextNodesTable,
        contextNodesTable.id.equalsExp(memoryContextsTable.contextId),
      ),
    ])..where(memoryContextsTable.memoryId.equals(memoryId));

    final rows = await query.get();
    return rows.map((r) => r.readTable(contextNodesTable)).toList();
  }

  Future<List<String>> getMemoriesForContext(String contextId) async {
    final rows = await (select(memoryContextsTable)
          ..where((t) => t.contextId.equals(contextId)))
        .get();
    return rows.map((r) => r.memoryId).toList();
  }

  // ── Ancestor Traversal (DAG) ───────────────────────────────────────────────

  Future<List<ContextNodesTableData>> getAncestors(String nodeId) async {
    final visited = <String>{nodeId};
    final ancestors = <ContextNodesTableData>[];
    final queue = <String>[nodeId];

    while (queue.isNotEmpty) {
      final currentId = queue.removeAt(0);
      final parents = await getParents(currentId);
      for (final parent in parents) {
        if (!visited.contains(parent.id)) {
          visited.add(parent.id);
          ancestors.add(parent);
          queue.add(parent.id);
        }
      }
    }

    return ancestors;
  }
}
