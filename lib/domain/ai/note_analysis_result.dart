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
        predicate:
            (json['predicate'] as String?)?.trim().toLowerCase() ?? 'relates_to',
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

/// Contextual action event (e.g. completed deployment, planned testing).
class ContextualAction {
  const ContextualAction({
    required this.type,
    required this.subject,
    this.time,
  });

  /// 'completed', 'in_progress', 'planned', 'scheduled', 'suggested'
  final String type;

  /// The action target / verb phrase: 'deployment', 'testing', 'code review'
  final String subject;

  final String? time;

  factory ContextualAction.fromJson(Map<String, dynamic> json) =>
      ContextualAction(
        type: (json['type'] as String?)?.trim().toLowerCase() ?? 'planned',
        subject: (json['subject'] as String?)?.trim() ?? '',
        time: (json['time'] as String?)?.trim(),
      );

  Map<String, dynamic> toJson() => {
        'type': type,
        'subject': subject,
        if (time != null) 'time': time,
      };

  @override
  String toString() => 'ContextualAction(type: $type, subject: $subject)';
}

/// Pronoun or anaphoric reference requiring contextual resolution (e.g. "this", "it", "that").
class ContextualReference {
  const ContextualReference({
    required this.text,
    this.type = 'anaphora',
    this.resolution,
  });

  /// The raw reference string: 'this', 'it', 'that', 'he', 'they', 'the project'
  final String text;

  /// 'anaphora', 'deictic', 'pronoun', 'definite_noun_phrase'
  final String type;

  /// Target context or entity this reference points to. NULL if unresolved in the local note.
  final String? resolution;

  bool get isUnresolved => resolution == null || resolution!.isEmpty;

  factory ContextualReference.fromJson(Map<String, dynamic> json) =>
      ContextualReference(
        text: (json['text'] as String?)?.trim() ?? '',
        type: (json['type'] as String?)?.trim().toLowerCase() ?? 'anaphora',
        resolution: (json['resolution'] as String?)?.trim(),
      );

  Map<String, dynamic> toJson() => {
        'text': text,
        'type': type,
        'resolution': resolution,
      };

  @override
  String toString() =>
      'ContextualReference(text: "$text", type: $type, resolution: $resolution)';
}

/// Explicit relationship candidate detected between entities in the note.
class ExplicitRelationshipCandidate {
  const ExplicitRelationshipCandidate({
    required this.source,
    required this.target,
    required this.relation,
    this.confidence = 1.0,
  });

  final String source;
  final String target;
  final String relation;
  final double confidence;

  factory ExplicitRelationshipCandidate.fromJson(Map<String, dynamic> json) =>
      ExplicitRelationshipCandidate(
        source: (json['source'] as String?)?.trim() ?? '',
        target: (json['target'] as String?)?.trim() ?? '',
        relation: (json['relation'] as String?)?.trim().toLowerCase() ?? 'relates_to',
        confidence: (json['confidence'] as num?)?.toDouble() ?? 1.0,
      );

  Map<String, dynamic> toJson() => {
        'source': source,
        'target': target,
        'relation': relation,
        'confidence': confidence,
      };

  @override
  String toString() =>
      'ExplicitRelationshipCandidate($source --$relation--> $target)';
}

/// The comprehensive structured output of the Context-Aware Understanding Agent.
class NoteAnalysisResult {
  const NoteAnalysisResult({
    required this.topic,
    required this.summary,
    this.keywords = const [],
    this.entities = const [],
    this.facts = const [],
    this.tasks = const [],
    this.actions = const [],
    this.references = const [],
    this.events = const [],
    this.topics = const [],
    this.project,
    this.people = const [],
    this.temporalReferences = const [],
    this.contextualPhrases = const [],
    this.possibleParentContext,
    this.possibleChildContext,
    this.explicitRelationships = const [],
  });

  /// Short (3–5 word) primary topic label.
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

  /// Structured actions (completed, in-progress, planned).
  final List<ContextualAction> actions;

  /// Pronouns/references detected in note (e.g. "this", "it").
  final List<ContextualReference> references;

  /// Events detected (e.g. "Meeting with Dean", "Sprint Retro").
  final List<String> events;

  /// Multi-topic contextual tags (e.g. ["deployment", "testing"]).
  final List<String> topics;

  /// Explicit project name if present in text, or null.
  final String? project;

  /// Names of people mentioned in text.
  final List<String> people;

  /// Temporal expressions mentioned (e.g. "tomorrow at 3pm", "yesterday").
  final List<String> temporalReferences;

  /// Key contextual cues/phrases.
  final List<String> contextualPhrases;

  /// Candidate parent context suggested by explicit phrasing.
  final String? possibleParentContext;

  /// Candidate child context suggested by explicit phrasing.
  final String? possibleChildContext;

  /// Explicit relationships between entities.
  final List<ExplicitRelationshipCandidate> explicitRelationships;

  /// List of raw reference strings that are unresolved in the local note text.
  List<String> get unresolvedReferences => references
      .where((r) => r.isUnresolved && r.text.isNotEmpty)
      .map((r) => r.text)
      .toList();

  @override
  String toString() =>
      'NoteAnalysisResult(topic: $topic, summary: $summary, entities: ${entities.length}, actions: ${actions.length}, references: ${references.length})';
}
