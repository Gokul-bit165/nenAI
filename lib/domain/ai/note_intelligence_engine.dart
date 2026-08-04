import 'note_analysis_result.dart';

/// **The key swappable interface for on-device LLM inference.**
///
/// V1 implementation: [FlutterGemmaIntelligenceEngine] (flutter_gemma + LiteRT-LM).
/// To swap models or backends, provide a new implementation and rebind in AiModule.
///
/// Contract:
/// - [analyze] must never throw. On failure it returns null; the note still exists.
/// - [isReady] must be checked before calling [analyze].
/// - [cancel] cancels any in-progress inference (called when app backgrounds on iOS).
abstract class NoteIntelligenceEngine {
  /// Returns true when the model is loaded and ready for inference.
  bool get isReady;

  /// Analyses [text] and returns a structured result, or null on failure.
  Future<NoteAnalysisResult?> analyze(String text);

  /// Generates a conversational chat response for [userPrompt] using optional [contextMemories].
  Future<String?> chat(String userPrompt, {List<String>? contextMemories});

  /// Cancels any in-progress inference. Safe to call even if not running.
  void cancel();

  /// Releases native resources. Call when the engine will no longer be used.
  Future<void> dispose();
}
