/// Extracted entity mention from raw note.
class ExtractedEntityMention {
  const ExtractedEntityMention({
    required this.name,
    required this.type,
  });

  final String name;
  
  /// 'person', 'project', 'technology', 'organization', 'concept', 'location'
  final String type;

  factory ExtractedEntityMention.fromJson(Map<String, dynamic> json) =>
      ExtractedEntityMention(
        name: (json['name'] as String?)?.trim() ?? '',
        type: (json['type'] as String?)?.trim().toLowerCase() ?? 'concept',
      );

  Map<String, dynamic> toJson() => {'name': name, 'type': type};

  @override
  String toString() => 'ExtractedEntityMention(name: $name, type: $type)';
}

/// Extracted fact triple (Subject -> Predicate -> Object).
class ExtractedFactTriple {
  const ExtractedFactTriple({
    required this.subject,
    required this.predicate,
    required this.object,
    this.confidence = 1.0,
  });

  final String subject;
  final String predicate;
  final String object;
  final double confidence;

  factory ExtractedFactTriple.fromJson(Map<String, dynamic> json) =>
      ExtractedFactTriple(
        subject: (json['subject'] as String?)?.trim() ?? '',
        predicate: (json['predicate'] as String?)?.trim().toLowerCase() ?? 'relates_to',
        object: (json['object'] as String?)?.trim() ?? '',
        confidence: (json['confidence'] as num?)?.toDouble() ?? 1.0,
      );

  Map<String, dynamic> toJson() => {
        'subject': subject,
        'predicate': predicate,
        'object': object,
        'confidence': confidence,
      };

  @override
  String toString() => 'ExtractedFactTriple($subject --$predicate--> $object)';
}

/// Extracted task item.
class ExtractedTaskItem {
  const ExtractedTaskItem({
    required this.description,
    this.time,
  });

  final String description;
  final String? time;

  factory ExtractedTaskItem.fromJson(Map<String, dynamic> json) =>
      ExtractedTaskItem(
        description: (json['description'] as String?)?.trim() ?? '',
        time: (json['time'] as String?)?.trim(),
      );

  Map<String, dynamic> toJson() => {
        'description': description,
        if (time != null) 'time': time,
      };

  @override
  String toString() => 'ExtractedTaskItem(desc: $description, time: $time)';
}

/// The comprehensive structured output of the Understanding Agent.
class NoteAnalysisResult {
  const NoteAnalysisResult({
    required this.topic,
    required this.summary,
    this.keywords = const [],
    this.entities = const [],
    this.facts = const [],
    this.tasks = const [],
  });

  /// Short (3–5 word) topic label.
  final String topic;

  /// 1–2 sentence human-readable summary.
  final String summary;

  /// 3–6 key concepts / keywords.
  final List<String> keywords;

  /// Extracted entity mentions (e.g. Arun [person], Gemma 3 1B [technology]).
  final List<ExtractedEntityMention> entities;

  /// Extracted relationship triples (e.g. Arun -> suggested -> Gemma 3 1B).
  final List<ExtractedFactTriple> facts;

  /// Extracted action items (e.g. "Test Gemma 3 1B", due "tomorrow").
  final List<ExtractedTaskItem> tasks;

  @override
  String toString() =>
      'NoteAnalysisResult(topic: $topic, summary: $summary, entities: ${entities.length}, facts: ${facts.length}, tasks: ${tasks.length})';
}
