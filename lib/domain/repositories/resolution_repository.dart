import '../entities/pending_resolution.dart';

/// Repository interface for Human-in-the-Loop context clarification and resolution.
abstract class ResolutionRepository {
  /// Reactively emits all currently pending resolutions.
  Stream<List<PendingResolution>> watchPendingResolutions();

  /// Fetches all currently pending resolutions.
  Future<List<PendingResolution>> getAllPending();

  /// Fetches pending resolution for a specific memory note.
  Future<PendingResolution?> getPendingByMemoryId(String memoryId);

  /// Saves a new pending resolution record.
  Future<void> savePendingResolution(PendingResolution resolution);

  /// Applies the user's explicit disambiguation choice transactionally.
  Future<void> resolveResolution({
    required String resolutionId,
    required String memoryId,
    required ResolutionChoice choice,
  });

  /// Dismisses a pending resolution.
  Future<void> deleteByMemoryId(String memoryId);
}
