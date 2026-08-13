import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/pending_resolutions_table.dart';

part 'pending_resolutions_dao.g.dart';

@DriftAccessor(tables: [PendingResolutionsTable])
class PendingResolutionsDao extends DatabaseAccessor<AppDatabase>
    with _$PendingResolutionsDaoMixin {
  PendingResolutionsDao(super.db);

  Stream<List<PendingResolutionsTableData>> watchPending() =>
      (select(pendingResolutionsTable)
            ..where((t) => t.status.equals('pending'))
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .watch();

  Future<List<PendingResolutionsTableData>> getAllPending() =>
      (select(pendingResolutionsTable)
            ..where((t) => t.status.equals('pending'))
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();

  Future<PendingResolutionsTableData?> getById(String id) =>
      (select(pendingResolutionsTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<PendingResolutionsTableData?> getByMemoryId(String memoryId) =>
      (select(pendingResolutionsTable)..where((t) => t.memoryId.equals(memoryId)))
          .getSingleOrNull();

  Future<void> insertResolution(PendingResolutionsTableCompanion companion) =>
      into(pendingResolutionsTable).insertOnConflictUpdate(companion);

  Future<void> updateResolution(PendingResolutionsTableCompanion companion) =>
      update(pendingResolutionsTable).replace(companion);

  Future<void> markResolved({
    required String id,
    String? selectedContextId,
    required String source,
    required int resolvedAt,
  }) =>
      (update(pendingResolutionsTable)..where((t) => t.id.equals(id))).write(
        PendingResolutionsTableCompanion(
          status: const Value('resolved'),
          selectedContextId: Value(selectedContextId),
          resolutionSource: Value(source),
          resolvedAt: Value(resolvedAt),
        ),
      );

  Future<void> deleteByMemoryId(String memoryId) =>
      (delete(pendingResolutionsTable)..where((t) => t.memoryId.equals(memoryId)))
          .go();
}
