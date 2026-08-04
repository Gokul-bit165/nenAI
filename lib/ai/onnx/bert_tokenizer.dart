import 'dart:convert';
import 'package:flutter/services.dart';
import '../../core/constants/app_constants.dart';

class BertTokenizer {
  BertTokenizer._({
    required Map<String, int> vocab,
  }) : _vocab = vocab;

  final Map<String, int> _vocab;

  static const int clsTokenId = 101;
  static const int sepTokenId = 102;
  static const int padTokenId = 0;
  static const int unkTokenId = 100;

  static Future<BertTokenizer> load() async {
    final raw = await rootBundle.loadString(AppConstants.tokenizerAsset);
    final json = jsonDecode(raw) as Map<String, dynamic>;

    final vocabMap = json.containsKey('model')
        ? (json['model'] as Map<String, dynamic>)['vocab'] as Map<String, dynamic>
        : json;

    final vocab = vocabMap.map((k, v) => MapEntry(k, v as int));
    return BertTokenizer._(vocab: vocab);
  }

  ({
    List<int> inputIds,
    List<int> attentionMask,
    List<int> tokenTypeIds,
  }) tokenize(String text, {int maxLength = AppConstants.maxTokenLength}) {
    final tokens = _wordpieceTokenize(text.toLowerCase().trim());

    final maxContent = maxLength - 2;
    final truncated = tokens.take(maxContent).toList();

    final ids = [clsTokenId, ...truncated.map(_toId), sepTokenId];
    final realLength = ids.length;

    final paddedIds = [...ids, ...List.filled(maxLength - realLength, padTokenId)];
    final mask = [
      ...List.filled(realLength, 1),
      ...List.filled(maxLength - realLength, 0),
    ];
    final typeIds = List.filled(maxLength, 0);

    return (
      inputIds: paddedIds,
      attentionMask: mask,
      tokenTypeIds: typeIds,
    );
  }

  int _toId(String token) => _vocab[token] ?? unkTokenId;

  List<String> _wordpieceTokenize(String text) {
    final outputTokens = <String>[];
    final words = _basicTokenize(text);
    for (final word in words) {
      final pieces = _wordpieceWord(word);
      outputTokens.addAll(pieces);
    }
    return outputTokens;
  }

  List<String> _basicTokenize(String text) {
    final cleaned = text.replaceAllMapped(
      RegExp(r'([^\w\s])'),
      (m) => ' ${m.group(0)} ',
    );
    return cleaned.split(RegExp(r'\s+')).where((s) => s.isNotEmpty).toList();
  }

  List<String> _wordpieceWord(String word) {
    if (word.length > 200) return [unkTokenId.toString()];
    if (_vocab.containsKey(word)) return [word];

    final subTokens = <String>[];
    var start = 0;
    var isBad = false;

    while (start < word.length) {
      var end = word.length;
      String? curSubStr;
      while (start < end) {
        var subStr = word.substring(start, end);
        if (start > 0) subStr = '##$subStr';
        if (_vocab.containsKey(subStr)) {
          curSubStr = subStr;
          break;
        }
        end--;
      }
      if (curSubStr == null) {
        isBad = true;
        break;
      }
      subTokens.add(curSubStr);
      start = end;
    }

    return isBad ? ['[UNK]'] : subTokens;
  }
}
