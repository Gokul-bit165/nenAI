import '../entities/memory_evidence.dart';

/// Single source of truth for explainable memory evidence records.
abstract class EvidenceRepository {
  /// Reactively emits all evidence records.
  Stream<List<MemoryEvidence>> watchAll();

  /// Fetches an evidence record by ID.
  Future<MemoryEvidence?> getById(String id);

  /// Fetches all evidence records linked to a specific source memory note.
  Future<List<MemoryEvidence>> getByMemoryId(String memoryId);

  /// Fetches all evidence records pointing to a specific context node.
  Future<List<MemoryEvidence>> getByContextId(String contextId);

  /// Saves or updates a memory evidence record.
  Future<void> saveEvidence(MemoryEvidence evidence);

  /// Deletes evidence associated with a note.
  Future<void> deleteByMemoryId(String memoryId);
}
