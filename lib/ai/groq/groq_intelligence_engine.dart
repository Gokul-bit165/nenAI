import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/ai/note_intelligence_engine.dart';
import '../../domain/ai/note_analysis_result.dart';

/// Groq API Intelligence Engine powered by Llama 3.3 70B (`llama-3.3-70b-versatile`).
class GroqIntelligenceEngine implements NoteIntelligenceEngine {
  GroqIntelligenceEngine({
    this.apiKey = const String.fromEnvironment('GROQ_API_KEY'),
    this.model = 'llama-3.3-70b-versatile',
  });

  final String apiKey;
  final String model;
  bool _cancelled = false;

  @override
  bool get isReady => apiKey.isNotEmpty;

  @override
  Future<NoteAnalysisResult?> analyze(String text) async {
    if (!isReady || text.trim().isEmpty) return null;
    _cancelled = false;

    const endpoint = 'https://api.groq.com/openai/v1/chat/completions';
    final prompt = _buildPrompt(text);

    try {
      final response = await http.post(
        Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': model,
          'messages': [
            {
              'role': 'system',
              'content': 'You are an AI note analysis engine. Respond ONLY with valid JSON — no markdown fences, no explanations.',
            },
            {
              'role': 'user',
              'content': prompt,
            },
          ],
          'temperature': 0.2,
          'max_tokens': 300,
        }),
      );

      if (_cancelled || response.statusCode != 200) return null;

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final content = data['choices']?[0]?['message']?['content'] as String?;
      if (content == null) return null;

      return _parseResponse(content);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<String?> chat(String userPrompt, {List<String>? contextMemories}) async {
    if (!isReady || userPrompt.trim().isEmpty) return null;
    _cancelled = false;

    const endpoint = 'https://api.groq.com/openai/v1/chat/completions';

    final systemPrompt = StringBuffer(
      'You are NENAI Memory Assistant. Answer the user clearly, concisely, and helpfully.',
    );

    if (contextMemories != null && contextMemories.isNotEmpty) {
      systemPrompt.writeln('\nRelevant private user notes/memories for context:');
      for (int i = 0; i < contextMemories.length; i++) {
        systemPrompt.writeln('- Memory [${i + 1}]: ${contextMemories[i]}');
      }
    }

    try {
      final response = await http.post(
        Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': model,
          'messages': [
            {'role': 'system', 'content': systemPrompt.toString()},
            {'role': 'user', 'content': userPrompt},
          ],
          'temperature': 0.6,
          'max_tokens': 500,
        }),
      );

      if (_cancelled || response.statusCode != 200) return null;

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final content = data['choices']?[0]?['message']?['content'] as String?;
      return content?.trim();
    } catch (_) {
      return null;
    }
  }

  String _buildPrompt(String noteText) {
    final truncated = noteText.length > 1500 ? '${noteText.substring(0, 1500)}…' : noteText;

    return '''Analyze the note text and return JSON matching this schema exactly:
{
  "topic": "<3-5 word topic title>",
  "summary": "<1-2 sentence concise summary>",
  "keywords": ["<keyword1>", "<keyword2>", "<keyword3>"]
}

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

  @override
  void cancel() => _cancelled = true;

  @override
  Future<void> dispose() async {}
}
