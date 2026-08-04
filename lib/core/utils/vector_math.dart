import 'dart:math' as math;
import 'dart:typed_data';

/// Pure math utilities for vector operations used in embedding similarity search.
/// No external dependencies — runs on any isolate.
class VectorMath {
  VectorMath._();

  /// Converts a [FloatList] (384 floats) to a byte blob for SQLite storage.
  static Uint8List floatListToBytes(List<double> vector) {
    final byteData = ByteData(vector.length * 4);
    for (var i = 0; i < vector.length; i++) {
      byteData.setFloat32(i * 4, vector[i], Endian.little);
    }
    return byteData.buffer.asUint8List();
  }

  /// Restores a [FloatList] from a byte blob stored in SQLite.
  static List<double> bytesToFloatList(Uint8List bytes) {
    final byteData = ByteData.sublistView(bytes);
    return List.generate(
      bytes.length ~/ 4,
      (i) => byteData.getFloat32(i * 4, Endian.little),
    );
  }

  /// Computes cosine similarity between two equal-length vectors.
  /// Returns a value in [-1, 1]; higher is more similar.
  static double cosineSimilarity(List<double> a, List<double> b) {
    assert(a.length == b.length, 'Vectors must have equal dimensions');
    double dot = 0, normA = 0, normB = 0;
    for (var i = 0; i < a.length; i++) {
      dot += a[i] * b[i];
      normA += a[i] * a[i];
      normB += b[i] * b[i];
    }
    final denom = math.sqrt(normA) * math.sqrt(normB);
    return denom == 0 ? 0 : dot / denom;
  }

  /// L2-normalises a vector in-place (unit norm).
  static List<double> l2Normalize(List<double> vector) {
    double norm = 0;
    for (final v in vector) {
      norm += v * v;
    }
    norm = math.sqrt(norm);
    if (norm == 0) return vector;
    return vector.map((v) => v / norm).toList();
  }

  /// Mean-pools a 2-D token embedding matrix [seqLen × dims] into a single
  /// [dims]-dimensional sentence embedding, respecting the [attentionMask].
  static List<double> meanPool({
    required List<List<double>> tokenEmbeddings,
    required List<int> attentionMask,
  }) {
    final dims = tokenEmbeddings[0].length;
    final pooled = List<double>.filled(dims, 0);
    int validTokens = 0;
    for (var i = 0; i < tokenEmbeddings.length; i++) {
      if (attentionMask[i] == 1) {
        for (var j = 0; j < dims; j++) {
          pooled[j] += tokenEmbeddings[i][j];
        }
        validTokens++;
      }
    }
    if (validTokens == 0) return pooled;
    return pooled.map((v) => v / validTokens).toList();
  }

  /// Computes the centroid (element-wise mean) of a list of vectors.
  static List<double> centroid(List<List<double>> vectors) {
    if (vectors.isEmpty) return [];
    final dims = vectors[0].length;
    final result = List<double>.filled(dims, 0);
    for (final v in vectors) {
      for (var i = 0; i < dims; i++) {
        result[i] += v[i];
      }
    }
    return result.map((v) => v / vectors.length).toList();
  }
}
