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

    // 4. Heuristic Entity Extraction (Capitalized proper nouns and key patterns)
    final entities = _extractEntities(trimmed);

    // 5. Heuristic Task Extraction (Sentences with 'should', 'need to', 'test', 'todo')
    final tasks = _extractTasks(sentences);

    // 6. Heuristic Fact Extraction
    final facts = _extractFacts(trimmed, entities);

    return NoteAnalysisResult(
      topic: topic,
      summary: summary,
      keywords: keywords,
      entities: entities,
      facts: facts,
      tasks: tasks,
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

  List<ExtractedEntityMention> _extractEntities(String text) {
    final results = <ExtractedEntityMention>[];
    final seen = <String>{};

    // Match capitalized multi-word phrases or single names: e.g., Arun, Gemma 3 1B, NENAI, Flutter
    final nameRegex = RegExp(r'\b[A-Z][a-zA-Z0-9]*(?:\s+[A-Z0-9][a-zA-Z0-9]*)*\b');
    final commonIgnore = {'Today', 'Yesterday', 'Tomorrow', 'The', 'This', 'That', 'These', 'Those', 'What', 'How', 'Why', 'When', 'Where', 'Who', 'I', 'My', 'We', 'Our', 'He', 'She', 'They', 'It'};

    for (final match in nameRegex.allMatches(text)) {
      final name = match.group(0)!.trim();
      if (name.length > 1 && !commonIgnore.contains(name) && !seen.contains(name.toLowerCase())) {
        seen.add(name.toLowerCase());
        String type = 'concept';
        final lower = name.toLowerCase();
        if (lower.contains('gemma') || lower.contains('flutter') || lower.contains('onnx') || lower.contains('sqlite') || lower.contains('dart')) {
          type = 'technology';
        } else if (lower.contains('nenai') || lower.contains('project') || lower.contains('app')) {
          type = 'project';
        } else if (!name.contains(RegExp(r'[0-9]')) && name.split(' ').length <= 2) {
          type = 'person';
        }
        results.add(ExtractedEntityMention(name: name, type: type));
      }
    }
    return results;
  }

  List<ExtractedTaskItem> _extractTasks(List<String> sentences) {
    final tasks = <ExtractedTaskItem>[];
    for (final s in sentences) {
      final lower = s.toLowerCase();
      if (lower.contains('should ') || lower.contains('need to ') || lower.contains('must ') || lower.contains('todo:') || lower.startsWith('test ')) {
        final desc = s;
        String? time;
        if (lower.contains('tomorrow')) time = 'tomorrow';
        if (lower.contains('today')) time = 'today';
        if (lower.contains('next week')) time = 'next week';

        tasks.add(ExtractedTaskItem(description: desc, time: time));
      }
    }
    return tasks;
  }

  List<ExtractedFactTriple> _extractFacts(String text, List<ExtractedEntityMention> entities) {
    final facts = <ExtractedFactTriple>[];
    if (entities.length < 2) return facts;

    final lower = text.toLowerCase();
    final predicates = ['suggested', 'helps_with', 'works_on', 'used_in', 'relates_to', 'recommended'];

    for (final p in predicates) {
      if (lower.contains(p.replaceAll('_', ' '))) {
        facts.add(ExtractedFactTriple(
          subject: entities[0].name,
          predicate: p,
          object: entities.length > 1 ? entities[1].name : 'Project',
        ));
        break;
      }
    }
    return facts;
  }

  @override
  void cancel() {}

  @override
  Future<void> dispose() async {}
}

