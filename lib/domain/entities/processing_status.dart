/// Tracks the lifecycle of on-device AI analysis for each note.
enum ProcessingStatus {
  /// Note written to Drift DB. Worker not yet started.
  pending,

  /// WorkManager job (Android) or Dart Isolate (iOS/foreground) is running.
  processing,

  /// LLM analysis + embedding + clustering are complete.
  completed,

  /// Inference failed after all retries. Note is still fully usable via text search.
  failed,
}
