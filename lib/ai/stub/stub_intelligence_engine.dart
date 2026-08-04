import '../../domain/ai/note_intelligence_engine.dart';
import '../../domain/ai/note_analysis_result.dart';

/// Fallback engine for [NoteIntelligenceEngine] when LLM weights are not yet present on device.
/// Performs smart extractive summarization, topic extraction, and keyword extraction.
class StubIntelligenceEngine implements NoteIntelligenceEngine {
  @override
  bool get isReady => true;

  @override
  Future<NoteAnalysisResult?> analyze(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return null;

    // 1. Extract Summary (First 1-2 sentences, max 200 chars)
    final sentences = _splitSentences(trimmed);
    String summary = sentences.take(2).join(' ');
    if (summary.length > 200) {
      summary = '${summary.substring(0, 197)}...';
    }

    // 2. Extract Keywords
    final keywords = _extractKeywords(trimmed);

    // 3. Extract Topic
    final topic = _extractTopic(sentences.first, keywords);

    return NoteAnalysisResult(
      topic: topic,
      summary: summary,
      keywords: keywords,
    );
  }
  @override
  Future<String?> chat(String userPrompt, {List<String>? contextMemories}) async {
    if (contextMemories != null && contextMemories.isNotEmpty) {
      return 'Based on your memory notes: "${contextMemories.first}"';
    }
    return 'I am your MemAI assistant. I can search your notes, schedule alarms, or create calendar events!';
  }

  List<String> _splitSentences(String text) {
    final rawSentences = text.split(RegExp(r'(?<=[.!?])\s+|\n+'));
    final cleaned = rawSentences
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    return cleaned.isEmpty ? [text] : cleaned;
  }

  List<String> _extractKeywords(String text) {
    final stopWords = {
      'the', 'is', 'at', 'which', 'on', 'a', 'an', 'and', 'or', 'in', 'to', 'for',
      'of', 'with', 'by', 'from', 'this', 'that', 'it', 'be', 'are', 'was', 'were',
      'as', 'has', 'have', 'had', 'not', 'but', 'what', 'all', 'when', 'where',
      'we', 'you', 'your', 'my', 'i', 'me', 'our', 'they', 'them', 'their', 'can',
      'will', 'just', 'so', 'if', 'about', 'out', 'up', 'down', 'no', 'yes'
    };

    final matches = RegExp(r'\b[a-zA-Z0-9_-]{3,}\b')
        .allMatches(text.toLowerCase())
        .map((m) => m.group(0)!)
        .where((w) => !stopWords.contains(w))
        .toList();

    final counts = <String, int>{};
    for (final w in matches) {
      counts[w] = (counts[w] ?? 0) + 1;
    }

    final sorted = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final keywords = sorted.map((e) => e.key).take(5).toList();
    return keywords.isEmpty ? ['note'] : keywords;
  }

  String _extractTopic(String firstSentence, List<String> keywords) {
    if (keywords.isNotEmpty) {
      return keywords.take(3).map((k) => k[0].toUpperCase() + k.substring(1)).join(' ');
    }
    final words = firstSentence.split(RegExp(r'\s+')).take(4).join(' ');
    return words.isEmpty ? 'General' : words;
  }

  @override
  void cancel() {}

  @override
  Future<void> dispose() async {}
}

