/// The structured output of [NoteIntelligenceEngine.analyze].
class NoteAnalysisResult {
  const NoteAnalysisResult({
    required this.topic,
    required this.summary,
    required this.keywords,
  });

  /// Short (3–5 word) topic label.
  final String topic;

  /// 1–2 sentence human-readable summary.
  final String summary;

  /// 3–6 key concepts / entities extracted from the note.
  final List<String> keywords;

  @override
  String toString() =>
      'NoteAnalysisResult(topic: $topic, summary: $summary, keywords: $keywords)';
}
