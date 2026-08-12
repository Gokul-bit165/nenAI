import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/entities_table.dart';
import '../tables/memory_entities_table.dart';

part 'entities_dao.g.dart';

@DriftAccessor(tables: [EntitiesTable, MemoryEntitiesTable])
class EntitiesDao extends DatabaseAccessor<AppDatabase> with _$EntitiesDaoMixin {
  EntitiesDao(super.db);

  Stream<List<EntitiesTableData>> watchAll() =>
      (select(entitiesTable)..orderBy([(t) => OrderingTerm.asc(t.name)])).watch();

  Future<List<EntitiesTableData>> getAll() => select(entitiesTable).get();

  Future<EntitiesTableData?> getById(String id) =>
      (select(entitiesTable)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<EntitiesTableData?> getByCanonicalName(String canonicalName) =>
      (select(entitiesTable)..where((t) => t.canonicalName.equals(canonicalName))).getSingleOrNull();

  Future<List<EntitiesTableData>> getByType(String type) =>
      (select(entitiesTable)..where((t) => t.type.equals(type))).get();

  Future<List<EntitiesTableData>> searchByName(String query) {
    final q = '%${query.toLowerCase().trim()}%';
    return (select(entitiesTable)..where((t) => t.canonicalName.like(q))).get();
  }

  Future<List<EntitiesTableData>> getEntitiesForMemory(String memoryId) async {
    final query = select(memoryEntitiesTable).join([
      innerJoin(
        entitiesTable,
        entitiesTable.id.equalsExp(memoryEntitiesTable.entityId),
      ),
    ])..where(memoryEntitiesTable.memoryId.equals(memoryId));

    final rows = await query.get();
    return rows.map((row) => row.readTable(entitiesTable)).toList();
  }

  Future<void> upsertEntity(EntitiesTableCompanion entity) =>
      into(entitiesTable).insertOnConflictUpdate(entity);

  Future<void> linkEntityToMemory(String memoryId, String entityId, {String role = 'mentioned'}) =>
      into(memoryEntitiesTable).insertOnConflictUpdate(
        MemoryEntitiesTableCompanion.insert(
          memoryId: memoryId,
          entityId: entityId,
          role: Value(role),
        ),
      );

  Future<void> deleteEntity(String id) =>
      (delete(entitiesTable)..where((t) => t.id.equals(id))).go();
}
