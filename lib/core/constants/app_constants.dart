/// Central constants for NENAI.
/// All magic strings and thresholds live here — never hardcode elsewhere.
library;

class AppConstants {
  AppConstants._();

  // ── Database ─────────────────────────────────────────────────────────────
  static const String dbName = 'nenai.db';
  static const int dbVersion = 6;

  // ── Model files (relative to assets/models/) ──────────────────────────────
  static const String embeddingModelAsset = 'assets/models/embedding_model.onnx';
  static const String tokenizerAsset = 'assets/models/tokenizer.json';

  /// LLM model filename — placed in app documents dir (not in assets).
  /// See README for download instructions.
  static const String llmModelFileName = 'gemma3-1b-it-gpu-int4.litertlm';

  // ── Embedding ─────────────────────────────────────────────────────────────
  static const int embeddingDimension = 384;
  static const int maxTokenLength = 128;

  // ── Clustering ────────────────────────────────────────────────────────────
  /// Cosine similarity threshold above which a note is assigned to an existing cluster.
  static const double clusterSimilarityThreshold = 0.65;

  /// Max number of related notes shown in the detail screen.
  static const int maxRelatedNotes = 5;

  // ── LLM prompting ─────────────────────────────────────────────────────────
  static const int llmMaxOutputTokens = 256;
  static const double llmTemperature = 0.3;

  // ── Search ────────────────────────────────────────────────────────────────
  static const int searchDebounceMs = 300;
  static const int maxSemanticResults = 20;

  // ── WorkManager (Android) ─────────────────────────────────────────────────
  static const String noteProcessingTaskName = 'nenai.noteProcessing';
  static const String noteIdInputKey = 'noteId';

  // ── Cluster colours (cycling palette) ─────────────────────────────────────
  static const List<String> clusterColors = [
    '#7C4DFF', // Deep purple
    '#00BCD4', // Cyan
    '#FF6D00', // Deep orange
    '#2E7D32', // Dark green
    '#D81B60', // Pink
    '#1565C0', // Dark blue
    '#F9A825', // Amber
    '#4E342E', // Brown
  ];
}
