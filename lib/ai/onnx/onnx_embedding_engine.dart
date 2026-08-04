import 'package:flutter/services.dart';
import 'package:flutter_onnxruntime/flutter_onnxruntime.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/vector_math.dart';
import '../../domain/ai/embedding_engine.dart';
import 'bert_tokenizer.dart';

class OnnxEmbeddingEngine implements EmbeddingEngine {
  OnnxEmbeddingEngine();

  dynamic _session;
  BertTokenizer? _tokenizer;
  bool _ready = false;

  Future<void> init() async {
    try {
      final modelBytes =
          await rootBundle.load(AppConstants.embeddingModelAsset);
      final bytes = modelBytes.buffer.asUint8List();

      final ort = OnnxRuntime();
      _session = await (ort as dynamic).createSession(bytes);

      _tokenizer = await BertTokenizer.load();
      _ready = true;
    } catch (e) {
      _ready = false;
    }
  }

  @override
  bool get isReady => _ready && _session != null && _tokenizer != null;

  @override
  Future<List<double>?> embed(String text) async {
    if (!isReady) return null;

    try {
      final tokenized = _tokenizer!.tokenize(text);
      final seqLen = tokenized.inputIds.length;

      final inputIds = tokenized.inputIds.map((i) => i.toDouble()).toList();
      final attentionMask = tokenized.attentionMask.map((i) => i.toDouble()).toList();
      final tokenTypeIds = tokenized.tokenTypeIds.map((i) => i.toDouble()).toList();

      final outputs = await _session.run({
        'input_ids': [inputIds],
        'attention_mask': [attentionMask],
        'token_type_ids': [tokenTypeIds],
      });

      final lastHiddenState = outputs['last_hidden_state'] ?? outputs.values.first;
      if (lastHiddenState == null) return null;

      final flat = (lastHiddenState as List).cast<double>();
      const dims = AppConstants.embeddingDimension;

      final matrix = List.generate(
        seqLen,
        (i) => flat.sublist(i * dims, (i + 1) * dims),
      );

      final pooled = VectorMath.meanPool(
        tokenEmbeddings: matrix,
        attentionMask: tokenized.attentionMask,
      );

      return VectorMath.l2Normalize(pooled);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> dispose() async {
    try {
      await _session?.close();
    } catch (_) {}
    _session = null;
    _ready = false;
  }
}
