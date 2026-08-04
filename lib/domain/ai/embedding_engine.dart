/// Swappable interface for on-device sentence embedding generation.
///
/// V1 implementation: [OnnxEmbeddingEngine] (all-MiniLM-L6-v2 via flutter_onnxruntime).
/// Alternative: flutter_gemma_embeddings (Gecko/EmbeddingGemma) — swap by rebinding in AiModule.
abstract class EmbeddingEngine {
  /// Returns true when the ONNX session is loaded and ready.
  bool get isReady;

  /// Embeds [text] into a 384-dimensional float vector (L2-normalised).
  /// Returns null on failure — calling code must handle gracefully.
  Future<List<double>?> embed(String text);

  /// Releases native ONNX session resources.
  Future<void> dispose();
}
