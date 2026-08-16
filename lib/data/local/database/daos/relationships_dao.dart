import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/relationships_table.dart';
import '../tables/entities_table.dart';

part 'relationships_dao.g.dart';

@DriftAccessor(tables: [RelationshipsTable, EntitiesTable])
class RelationshipsDao extends DatabaseAccessor<AppDatabase> with _$RelationshipsDaoMixin {
  RelationshipsDao(super.db);

  Stream<List<RelationshipsTableData>> watchAll() =>
      (select(relationshipsTable)..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).watch();

  Future<List<RelationshipsTableData>> getAll() => select(relationshipsTable).get();

  Future<RelationshipsTableData?> findExactRelationship({
    required String sourceEntityId,
    required String relation,
    required String targetEntityId,
  }) {
    return (select(relationshipsTable)
          ..where((t) =>
              t.sourceEntityId.equals(sourceEntityId) &
              t.relation.equals(relation.toLowerCase().trim()) &
              t.targetEntityId.equals(targetEntityId)))
        .getSingleOrNull();
  }

  Future<List<RelationshipsTableData>> getByEntityId(String entityId) {
    return (select(relationshipsTable)
          ..where((t) => t.sourceEntityId.equals(entityId) | t.targetEntityId.equals(entityId)))
        .get();
  }

  Future<List<RelationshipsTableData>> getByMemoryId(String memoryId) {
    return (select(relationshipsTable)..where((t) => t.sourceMemoryId.equals(memoryId))).get();
  }

  /// Traverses 1-hop neighborhood of an entity and returns rich edge triples
  Future<List<({RelationshipsTableData relationship, EntitiesTableData source, EntitiesTableData target})>>
      getNeighborhood(String entityId) async {
    final rels = await getByEntityId(entityId);
    final results = <({RelationshipsTableData relationship, EntitiesTableData source, EntitiesTableData target})>[];

    for (final rel in rels) {
      final source = await (select(entitiesTable)..where((t) => t.id.equals(rel.sourceEntityId))).getSingleOrNull();
      final target = await (select(entitiesTable)..where((t) => t.id.equals(rel.targetEntityId))).getSingleOrNull();
      if (source != null && target != null) {
        results.add((relationship: rel, source: source, target: target));
      }
    }
    return results;
  }

  Future<void> upsertRelationship(RelationshipsTableCompanion relationship) =>
      into(relationshipsTable).insertOnConflictUpdate(relationship);

  Future<void> deleteRelationship(String id) =>
      (delete(relationshipsTable)..where((t) => t.id.equals(id))).go();

  /// Traverses 2-hop paths connecting entityA to entityB via any intermediate node.
  /// Example: Dean (entityA) -> suggested -> Flutter (intermediate) -> for -> NENAI (entityB)
  Future<List<({
    EntitiesTableData source,
    RelationshipsTableData hop1,
    EntitiesTableData intermediate,
    RelationshipsTableData hop2,
    EntitiesTableData target,
  })>> getTwoHopPaths(String entityAId, String entityBId) async {
    final results = <({
      EntitiesTableData source,
      RelationshipsTableData hop1,
      EntitiesTableData intermediate,
      RelationshipsTableData hop2,
      EntitiesTableData target,
    })>[];

    final aEdges = await getByEntityId(entityAId);

    for (final edge1 in aEdges) {
      final intermediateId = edge1.sourceEntityId == entityAId
          ? edge1.targetEntityId
          : edge1.sourceEntityId;

      if (intermediateId == entityBId) continue;

      final bEdges = await getByEntityId(entityBId);
      for (final edge2 in bEdges) {
        final bConnectedId = edge2.sourceEntityId == entityBId
            ? edge2.targetEntityId
            : edge2.sourceEntityId;

        if (bConnectedId == intermediateId) {
          final src = await (select(entitiesTable)..where((t) => t.id.equals(entityAId))).getSingleOrNull();
          final inter = await (select(entitiesTable)..where((t) => t.id.equals(intermediateId))).getSingleOrNull();
          final tgt = await (select(entitiesTable)..where((t) => t.id.equals(entityBId))).getSingleOrNull();

          if (src != null && inter != null && tgt != null) {
            results.add((
              source: src,
              hop1: edge1,
              intermediate: inter,
              hop2: edge2,
              target: tgt,
            ));
          }
        }
      }
    }
    return results;
  }
}
