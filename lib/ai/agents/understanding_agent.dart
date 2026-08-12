import '../../domain/ai/note_intelligence_engine.dart';
import '../../domain/ai/note_analysis_result.dart';

/// Understanding Agent: Analyzes raw notes to extract structured entities, facts, and tasks.
class UnderstandingAgent {
  UnderstandingAgent(this._intelligenceEngine);

  final NoteIntelligenceEngine _intelligenceEngine;

  Future<NoteAnalysisResult?> understand(String rawText) async {
    final trimmed = rawText.trim();
    if (trimmed.isEmpty) return null;

    if (_intelligenceEngine.isReady) {
      final analysis = await _intelligenceEngine.analyze(trimmed);
      if (analysis != null) return analysis;
    }

    return null;
  }
}
