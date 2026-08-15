/// Tracks the lifecycle of on-device AI analysis for each note.
enum ProcessingStatus {
  /// Note written to Drift DB. Worker not yet started.
  pending,

  /// WorkManager job (Android) or Dart Isolate (iOS/foreground) is running.
  processing,

  /// LLM analysis + embedding + clustering are complete.
  completed,

  /// Ambiguous context detected — waiting for user confirmation before final binding.
  needsUserClarification,

  /// Inference failed after all retries. Note is still fully usable via text search.
  failed;

  static ProcessingStatus fromString(String val) {
    return ProcessingStatus.values.firstWhere(
      (e) => e.name.toLowerCase() == val.toLowerCase().trim(),
      orElse: () => ProcessingStatus.pending,
    );
  }
}
