import '../../domain/ai/note_intelligence_engine.dart';
import '../../domain/ai/note_analysis_result.dart';

/// Understanding Agent: Analyzes raw notes/chat messages to extract structured
/// entities, facts, tasks, and references.
///
/// When [conversationContext] is provided (chat source), the agent prepends
/// recent turns to the analysis prompt so pronouns and vague references
/// ("it", "this", "that") resolve against the live conversation before
/// falling back to long-term KG/recency evidence.
class UnderstandingAgent {
  UnderstandingAgent(this._intelligenceEngine);

  final NoteIntelligenceEngine _intelligenceEngine;

  Future<NoteAnalysisResult?> understand(
    String rawText, {
    List<String>? conversationContext,
  }) async {
    final trimmed = rawText.trim();
    if (trimmed.isEmpty) return null;

    if (!_intelligenceEngine.isReady) return null;

    // If conversation context is provided, prepend it so the LLM can resolve
    // pronouns and vague references before treating them as ambiguous.
    final inputText = conversationContext != null && conversationContext.isNotEmpty
        ? _buildContextualInput(trimmed, conversationContext)
        : trimmed;

    final analysis = await _intelligenceEngine.analyze(inputText);
    return analysis;
  }

  /// Builds the enriched input string by prepending conversation context turns.
  ///
  /// The context block uses a clear delimiter so the LLM can distinguish prior
  /// turns from the message being analyzed. The analysis instruction is explicit:
  /// resolve pronouns against the context turns first.
  String _buildContextualInput(String message, List<String> context) {
    final buf = StringBuffer();
    buf.writeln(
      '[CONVERSATION CONTEXT — resolve pronouns and vague references ("it", "this", '
      '"that", "the project") against these recent turns before treating them as '
      'ambiguous. If a preceding turn names the specific entity, use that name.]',
    );
    for (var i = 0; i < context.length; i++) {
      buf.writeln('Turn ${i + 1}: ${context[i]}');
    }
    buf.writeln('---');
    buf.writeln('Now analyze the following message:');
    buf.writeln(message);
    return buf.toString();
  }
}
