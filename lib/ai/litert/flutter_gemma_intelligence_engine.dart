import 'dart:convert';
import 'dart:io';
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
      if (!File(modelPath).existsSync()) {
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
  "keywords": ["<keyword1>", "<keyword2>", "<keyword3>"]
}

Rules:
- keywords must be 3 to 6 items
- topic must be concise and descriptive
- respond with ONLY the JSON object, nothing else

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

      if (summary.isEmpty) return null;
      return NoteAnalysisResult(
        topic: topic,
        summary: summary,
        keywords: keywords,
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
