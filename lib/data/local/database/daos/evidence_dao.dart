import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/memory_evidence_table.dart';

part 'evidence_dao.g.dart';

@DriftAccessor(tables: [MemoryEvidenceTable])
class EvidenceDao extends DatabaseAccessor<AppDatabase> with _$EvidenceDaoMixin {
  EvidenceDao(super.db);

  Stream<List<MemoryEvidenceTableData>> watchAll() =>
      (select(memoryEvidenceTable)..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .watch();

  Future<List<MemoryEvidenceTableData>> getAll() =>
      select(memoryEvidenceTable).get();

  Future<MemoryEvidenceTableData?> getById(String id) =>
      (select(memoryEvidenceTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<List<MemoryEvidenceTableData>> getByMemoryId(String memoryId) =>
      (select(memoryEvidenceTable)
            ..where((t) => t.sourceMemoryId.equals(memoryId))
            ..orderBy([(t) => OrderingTerm.desc(t.confidence)]))
          .get();

  Future<List<MemoryEvidenceTableData>> getByContextId(String contextId) =>
      (select(memoryEvidenceTable)
            ..where((t) => t.targetContextId.equals(contextId))
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();

  Future<void> insertEvidence(MemoryEvidenceTableCompanion evidence) =>
      into(memoryEvidenceTable).insertOnConflictUpdate(evidence);

  Future<void> deleteByMemoryId(String memoryId) =>
      (delete(memoryEvidenceTable)..where((t) => t.sourceMemoryId.equals(memoryId)))
          .go();

  Future<void> deleteById(String id) =>
      (delete(memoryEvidenceTable)..where((t) => t.id.equals(id))).go();
}
