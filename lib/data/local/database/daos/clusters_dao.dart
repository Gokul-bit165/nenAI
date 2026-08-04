import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/clusters_table.dart';

part 'clusters_dao.g.dart';

@DriftAccessor(tables: [ClustersTable])
class ClustersDao extends DatabaseAccessor<AppDatabase>
    with _$ClustersDaoMixin {
  ClustersDao(super.db);

  Stream<List<ClustersTableData>> watchAll() =>
      (select(clustersTable)
            ..orderBy([(t) => OrderingTerm.asc(t.name)]))
          .watch();

  Future<ClustersTableData?> getById(String id) =>
      (select(clustersTable)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<void> upsert(ClustersTableCompanion companion) =>
      into(clustersTable).insertOnConflictUpdate(companion);

  Future<void> rename(String clusterId, String newName) =>
      (update(clustersTable)..where((t) => t.id.equals(clusterId))).write(
        ClustersTableCompanion(name: Value(newName)),
      );

  Future<void> deleteById(String id) =>
      (delete(clustersTable)..where((t) => t.id.equals(id))).go();
}
