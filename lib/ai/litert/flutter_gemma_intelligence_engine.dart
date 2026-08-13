import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../../core/constants/app_constants.dart';
import '../../domain/ai/note_intelligence_engine.dart';
import '../../domain/ai/note_analysis_result.dart';

class FlutterGemmaIntelligenceEngine implements NoteIntelligenceEngine {
  FlutterGemmaIntelligenceEngine();

  dynamic _model;
  bool _ready = false;
  bool _cancelled = false;

  Future<void> init() async {
    try {
      final modelPath = await _resolveModelPath();
      final localFile = File(modelPath);

      // If model not in documents directory yet, check if it's bundled in APK assets
      if (!localFile.existsSync()) {
        try {
          final assetData = await rootBundle.load('assets/models/${AppConstants.llmModelFileName}');
          await localFile.parent.create(recursive: true);
          await localFile.writeAsBytes(assetData.buffer.asUint8List(), flush: true);
        } catch (_) {
          // Model not bundled in assets
        }
      }

      if (!localFile.existsSync()) {
        return;
      }

      await FlutterGemma.initialize();
      _model = await (FlutterGemma as dynamic).instance.createModel(modelPath: modelPath);
      _ready = true;
    } catch (e) {
      _ready = false;
    }
  }

  @override
  bool get isReady => _ready && _model != null;

  @override
  Future<NoteAnalysisResult?> analyze(String text) async {
    if (!isReady) return null;
    _cancelled = false;

    final prompt = _buildPrompt(text);

    try {
      final String? response = (await _model?.generateResponse(prompt: prompt))?.toString();
      if (_cancelled || response == null) return null;
      return _parseResponse(response);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<String?> chat(String userPrompt, {List<String>? contextMemories}) async {
    if (!isReady) return null;
    _cancelled = false;

    final prompt = 'Answer this user query concisely: $userPrompt';
    try {
      final String? response = (await _model?.generateResponse(prompt: prompt))?.toString();
      if (_cancelled || response == null) return null;
      return response;
    } catch (_) {
      return null;
    }
  }

  @override
  void cancel() => _cancelled = true;

  @override
  Future<void> dispose() async {
    try {
      await _model?.close();
    } catch (_) {}
    _model = null;
    _ready = false;
  }

  String _buildPrompt(String noteText) {
    final truncated = noteText.length > 1200
        ? '${noteText.substring(0, 1200)}…'
        : noteText;

    return '''You are a note analysis assistant. Analyze the note and respond with ONLY valid JSON — no markdown, no explanation.

Required JSON format:
{
  "topic": "<main topic in 3-5 words>",
  "summary": "<1-2 sentence summary of the note>",
  "keywords": ["<keyword1>", "<keyword2>"],
  "topics": ["<topic1>", "<topic2>"],
  "project": "<project name if mentioned, otherwise null>",
  "entities": [
    {"name": "<entity name>", "type": "<person|project|technology|concept|organization>"}
  ],
  "facts": [
    {"subject": "<source entity>", "predicate": "<suggested|helps_with|works_on|used_for|relates_to>", "object": "<target entity>"}
  ],
  "tasks": [
    {"description": "<actionable task>", "time": "<due time or relative string if mentioned>"}
  ],
  "actions": [
    {"type": "<completed|in_progress|planned>", "subject": "<action subject e.g. deployment, testing>"}
  ],
  "references": [
    {"text": "<pronoun e.g. this, that, it>", "type": "anaphora", "resolution": null}
  ],
  "events": ["<event/meeting name if mentioned>"],
  "temporalReferences": ["<time or relative date if mentioned>"]
}

Rules:
- respond with ONLY the JSON object, nothing else
- Do not invent missing context or resolve pronouns if the target is not in the text

Note:
$truncated''';
  }

  NoteAnalysisResult? _parseResponse(String raw) {
    final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(raw);
    if (jsonMatch == null) return null;

    try {
      final map = jsonDecode(jsonMatch.group(0)!) as Map<String, dynamic>;
      final topic = (map['topic'] as String?)?.trim() ?? 'General';
      final summary = (map['summary'] as String?)?.trim() ?? '';
      final keywords = (map['keywords'] as List<dynamic>?)
              ?.map((k) => k.toString().trim())
              .where((k) => k.isNotEmpty)
              .take(6)
              .toList() ??
          [];

      final topics = (map['topics'] as List<dynamic>?)
              ?.map((k) => k.toString().trim())
              .where((k) => k.isNotEmpty)
              .toList() ??
          keywords;

      final project = (map['project'] as String?)?.trim();

      final entities = (map['entities'] as List<dynamic>?)
              ?.whereType<Map<String, dynamic>>()
              .map((e) => ExtractedEntityMention.fromJson(e))
              .where((e) => e.name.isNotEmpty)
              .toList() ??
          [];

      final facts = (map['facts'] as List<dynamic>?)
              ?.whereType<Map<String, dynamic>>()
              .map((f) => ExtractedFactTriple.fromJson(f))
              .where((f) => f.subject.isNotEmpty && f.object.isNotEmpty)
              .toList() ??
          [];

      final tasks = (map['tasks'] as List<dynamic>?)
              ?.whereType<Map<String, dynamic>>()
              .map((t) => ExtractedTaskItem.fromJson(t))
              .where((t) => t.description.isNotEmpty)
              .toList() ??
          [];

      final actions = (map['actions'] as List<dynamic>?)
              ?.whereType<Map<String, dynamic>>()
              .map((a) => ContextualAction.fromJson(a))
              .where((a) => a.subject.isNotEmpty)
              .toList() ??
          [];

      final references = (map['references'] as List<dynamic>?)
              ?.whereType<Map<String, dynamic>>()
              .map((r) => ContextualReference.fromJson(r))
              .where((r) => r.text.isNotEmpty)
              .toList() ??
          [];

      final events = (map['events'] as List<dynamic>?)
              ?.map((e) => e.toString().trim())
              .where((e) => e.isNotEmpty)
              .toList() ??
          [];

      final temporalReferences = (map['temporalReferences'] as List<dynamic>?)
              ?.map((t) => t.toString().trim())
              .where((t) => t.isNotEmpty)
              .toList() ??
          [];

      final people = entities
          .where((e) => e.type == 'person')
          .map((e) => e.name)
          .toList();

      final explicitRelationships = facts
          .map((f) => ExplicitRelationshipCandidate(
                source: f.subject,
                target: f.object,
                relation: f.predicate,
                confidence: f.confidence,
              ))
          .toList();

      if (summary.isEmpty) return null;
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
    } catch (_) {
      return null;
    }
  }

  Future<String> _resolveModelPath() async {
    final docsDir = await getApplicationDocumentsDirectory();
    return p.join(docsDir.path, 'models', AppConstants.llmModelFileName);
  }
}
