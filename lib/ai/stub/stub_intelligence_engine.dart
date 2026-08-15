import '../../domain/ai/note_intelligence_engine.dart';
import '../../domain/ai/note_analysis_result.dart';

/// Fallback engine for [NoteIntelligenceEngine] when LLM weights are not yet present on device.
/// Performs smart extractive summarization, contextual signal extraction, anaphora detection, and action classification.
class StubIntelligenceEngine implements NoteIntelligenceEngine {
  @override
  bool get isReady => true;

  @override
  Future<NoteAnalysisResult?> analyze(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return null;

    final sentences = _splitSentences(trimmed);

    // 1. Summary
    String summary = sentences.take(2).join(' ');
    if (summary.length > 200) {
      summary = '${summary.substring(0, 197)}...';
    }

    // 2. Keywords
    final keywords = _extractKeywords(trimmed);

    // 3. Topic
    final topic = _extractTopic(sentences.first, keywords);

    // 4. Heuristic Entity Extraction
    final entities = _extractEntities(trimmed);

    // 5. Tasks
    final tasks = _extractTasks(sentences);

    // 6. Facts
    final facts = _extractFacts(trimmed, entities);

    // 7. Contextual Actions
    final actions = _extractActions(trimmed);

    // 8. Pronouns and Anaphoric References
    final references = _extractReferences(trimmed);

    // 9. Topics (multi-topic list)
    final topics = _extractMultiTopics(trimmed, keywords, actions);

    // 10. Events
    final events = _extractEvents(trimmed);

    // 11. People
    final people = entities
        .where((e) => e.type == 'person')
        .map((e) => e.name)
        .toList();

    // 12. Project
    final projectEntities = entities.where((e) => e.type == 'project');
    final String? project =
        projectEntities.isNotEmpty ? projectEntities.first.name : null;

    // 13. Temporal References
    final temporalReferences = _extractTemporalReferences(trimmed);

    // 14. Explicit Relationships
    final explicitRelationships = facts
        .map((f) => ExplicitRelationshipCandidate(
              source: f.subject,
              target: f.object,
              relation: f.predicate,
              confidence: f.confidence,
            ))
        .toList();

    return NoteAnalysisResult(
      topic: topic,
      summary: summary,
      keywords: keywords,
      entities: entities,
      facts: facts,
      tasks: tasks,
      actions: actions,
      references: references,
      events: events,
      topics: topics,
      project: project,
      people: people,
      temporalReferences: temporalReferences,
      explicitRelationships: explicitRelationships,
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
      'will', 'just', 'so', 'if', 'about', 'out', 'up', 'down', 'no', 'yes', 'now'
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

    final nameRegex = RegExp(r'\b[A-Z][a-zA-Z0-9]*(?:\s+[A-Z0-9][a-zA-Z0-9]*)*\b');
    final commonIgnore = {
      'Today', 'Yesterday', 'Tomorrow', 'The', 'This', 'That', 'These', 'Those',
      'What', 'How', 'Why', 'When', 'Where', 'Who', 'I', 'My', 'We', 'Our', 'He',
      'She', 'They', 'It', 'Now'
    };

    for (final match in nameRegex.allMatches(text)) {
      final name = match.group(0)!.trim();
      if (name.length > 1 && !commonIgnore.contains(name) && !seen.contains(name.toLowerCase())) {
        seen.add(name.toLowerCase());
        String type = 'concept';
        final lower = name.toLowerCase();
        if (lower.contains('gemma') || lower.contains('flutter') || lower.contains('onnx') || lower.contains('sqlite') || lower.contains('dart')) {
          type = 'technology';
        } else if (lower.contains('nenai') || lower.contains('readsmart') || lower.contains('project') || lower.contains('app') || name == 'FC') {
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
      if (lower.contains('should ') || lower.contains('need to ') || lower.contains('must ') || lower.contains('todo:') || lower.contains('want to test') || lower.startsWith('test ')) {
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

  List<ContextualAction> _extractActions(String text) {
    final actions = <ContextualAction>[];
    final lower = text.toLowerCase();

    // 1. Completed actions
    final completedPatterns = [
      RegExp(r'\b(?:finished|completed|done with)\s+(?:the\s+)?([a-zA-Z0-9_-]+)'),
      RegExp(r'\b([a-zA-Z0-9_-]+)\s+(?:is\s+)?(?:finished|completed|done)\b'),
      RegExp(r'\b(?:deployed|shipped|released)\s+([a-zA-Z0-9_-]+)?'),
    ];

    for (final pattern in completedPatterns) {
      for (final match in pattern.allMatches(lower)) {
        final matchedSubject = match.group(1)?.trim();
        final subject = (matchedSubject != null && matchedSubject.isNotEmpty)
            ? matchedSubject
            : 'deployment';
        actions.add(ContextualAction(type: 'completed', subject: subject));
      }
    }

    // 2. Planned / Future actions
    final plannedPatterns = [
      RegExp(r'\b(?:want to|need to|plan to|going to|will)\s+([a-zA-Z0-9_-]+)'),
      RegExp(r'\b(?:test|evaluate|benchmark)\s+(?:this|that|it|[a-zA-Z0-9_-]+)'),
    ];

    for (final pattern in plannedPatterns) {
      for (final match in pattern.allMatches(lower)) {
        final verb = match.group(0)!;
        String subject = 'testing';
        if (verb.contains('test')) {
          subject = 'testing';
        } else if (match.groupCount >= 1 && match.group(1) != null) {
          subject = match.group(1)!;
        }
        actions.add(ContextualAction(type: 'planned', subject: subject));
      }
    }

    // 3. In-progress actions
    if (lower.contains('working on ') || lower.contains('debugging ') || lower.contains('fixing ')) {
      final inProgressMatch = RegExp(r'\b(?:working on|debugging|fixing)\s+(?:the\s+)?([a-zA-Z0-9_-]+)').firstMatch(lower);
      if (inProgressMatch != null) {
        actions.add(ContextualAction(
          type: 'in_progress',
          subject: inProgressMatch.group(1) ?? 'task',
        ));
      }
    }

    return actions;
  }

  List<ContextualReference> _extractReferences(String text) {
    final references = <ContextualReference>[];
    final words = text.split(RegExp(r'\s+|[.,;!?]+'));

    final anaphoricWords = {'this', 'that', 'it', 'these', 'those'};
    final personalPronouns = {'he', 'she', 'they', 'him', 'her', 'them'};

    final seen = <String>{};

    for (final rawWord in words) {
      final word = rawWord.trim().toLowerCase();
      if (anaphoricWords.contains(word) && !seen.contains(word)) {
        seen.add(word);
        references.add(ContextualReference(
          text: word,
          type: 'anaphora',
          resolution: null, // Unresolved in current note
        ));
      } else if (personalPronouns.contains(word) && !seen.contains(word)) {
        seen.add(word);
        references.add(ContextualReference(
          text: word,
          type: 'pronoun',
          resolution: null,
        ));
      }
    }

    return references;
  }

  List<String> _extractMultiTopics(
      String text, List<String> keywords, List<ContextualAction> actions) {
    final topics = <String>{};
    for (final action in actions) {
      if (action.subject.isNotEmpty && action.subject != 'this' && action.subject != 'it') {
        topics.add(action.subject.toLowerCase());
      }
    }
    for (final kw in keywords) {
      if (topics.length < 5) {
        topics.add(kw.toLowerCase());
      }
    }
    return topics.toList();
  }

  List<String> _extractEvents(String text) {
    final events = <String>[];
    final match = RegExp(r'\b(?:Meeting with|Discussion on|Call with|Sync with|Retro with)\s+([A-Z][a-zA-Z0-9\s]+)', caseSensitive: false)
        .firstMatch(text);
    if (match != null) {
      events.add(match.group(0)!.trim());
    }
    return events;
  }

  List<String> _extractTemporalReferences(String text) {
    final references = <String>[];
    final temporalKeywords = [
      'yesterday', 'today', 'tomorrow', 'next week', 'last week', 'this morning',
      'this afternoon', 'tonight', '1 hr ago', '2 hours ago', 'in 30 minutes'
    ];
    final lower = text.toLowerCase();
    for (final tk in temporalKeywords) {
      if (lower.contains(tk)) {
        references.add(tk);
      }
    }
    return references;
  }

  @override
  void cancel() {}

  @override
  Future<void> dispose() async {}
}
