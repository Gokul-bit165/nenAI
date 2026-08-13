import '../../domain/ai/context_candidate.dart';
import '../../domain/ai/context_resolution_result.dart';
import '../../domain/ai/note_analysis_result.dart';

/// Context Resolution Agent: Deterministically resolves where an incoming memory belongs
/// using multi-signal evidence, confidence margin rules, and strict ambiguity protection.
class ContextResolutionAgent {
  const ContextResolutionAgent({
    this.autoAttachThreshold = 0.75,
    this.autoAttachMargin = 0.20,
    this.ambiguityMargin = 0.15,
    this.weakThreshold = 0.40,
    this.multiAttachThreshold = 0.75,
  });

  final double autoAttachThreshold;
  final double autoAttachMargin;
  final double ambiguityMargin;
  final double weakThreshold;
  final double multiAttachThreshold;

  /// Resolves the destination context for a newly analyzed note.
  ContextResolutionResult resolve({
    required String noteText,
    required NoteAnalysisResult analysis,
    required List<ContextCandidate> candidates,
    required DateTime noteTimestamp,
    bool isMultiContextSupported = false,
  }) {
    final trimmed = noteText.trim();

    // 1. Trivial / Empty Check
    if (trimmed.length < 5) {
      return ContextResolutionResult(
        outcome: ResolutionOutcome.ignore,
        confidence: 1.0,
        reasoningSummary: 'Note content is too short or ephemeral.',
        unresolvedReferences: analysis.unresolvedReferences,
      );
    }

    // 2. Build detailed multi-signal score breakdowns
    final breakdowns = <CandidateScoreBreakdown>[];
    final noteLower = noteText.toLowerCase();

    for (final candidate in candidates) {
      final signals = <String, double>{
        'semantic': candidate.semanticSimilarity,
        'lexical': candidate.lexicalRelevance,
        'entity': candidate.graphRelevance,
        'graph': candidate.graphRelevance,
        'temporal': candidate.temporalRelevance,
        'recency': candidate.temporalRelevance,
        'contextContinuity': candidate.temporalRelevance >= 0.80 ? 0.85 : 0.20,
        'explicitMention': noteLower.contains(candidate.contextName.toLowerCase()) ? 1.0 : 0.0,
        'previousReference': candidate.recentEvidence.isNotEmpty ? 0.75 : 0.10,
      };

      breakdowns.add(CandidateScoreBreakdown(
        candidateId: candidate.contextId,
        candidateName: candidate.contextName,
        contextPath: candidate.contextPath,
        finalScore: candidate.totalScore,
        signals: signals,
        evidenceSnippet: candidate.matchedSignals.isNotEmpty
            ? candidate.matchedSignals.join(', ')
            : null,
      ));
    }

    // Sort breakdowns descending by finalScore
    breakdowns.sort((a, b) => b.finalScore.compareTo(a.finalScore));

    // 3. Evaluate Outcomes

    // Case A: No existing candidates
    if (breakdowns.isEmpty) {
      if (analysis.project != null || analysis.events.isNotEmpty) {
        final newName = analysis.project ?? analysis.events.first;
        final newType = analysis.project != null ? 'project' : 'episode';
        return ContextResolutionResult(
          outcome: ResolutionOutcome.newContext,
          confidence: 0.90,
          suggestedNewContextName: newName,
          suggestedNewContextType: newType,
          reasoningSummary: 'Detected explicit mention of new context: "$newName".',
          unresolvedReferences: analysis.unresolvedReferences,
        );
      }

      return ContextResolutionResult(
        outcome: ResolutionOutcome.unresolved,
        confidence: 0.0,
        reasoningSummary: 'No matching existing context found in database.',
        unresolvedReferences: analysis.unresolvedReferences,
      );
    }

    final top = breakdowns.first;
    final runnerUp = breakdowns.length > 1 ? breakdowns[1] : null;
    final margin = runnerUp != null ? (top.finalScore - runnerUp.finalScore) : 1.0;

    // Case B: Explicit mention of a new project when existing candidates are weak
    if (analysis.project != null &&
        top.finalScore < 0.60 &&
        !top.candidateName.toLowerCase().contains(analysis.project!.toLowerCase())) {
      return ContextResolutionResult(
        outcome: ResolutionOutcome.newContext,
        confidence: 0.90,
        suggestedNewContextName: analysis.project,
        suggestedNewContextType: 'project',
        candidateBreakdowns: breakdowns,
        reasoningSummary: 'Note explicitly names new project "${analysis.project}".',
        unresolvedReferences: analysis.unresolvedReferences,
      );
    }

    // Case C: MULTI_ATTACH (Multi-parent DAG attachment)
    if (isMultiContextSupported &&
        runnerUp != null &&
        top.finalScore >= multiAttachThreshold &&
        runnerUp.finalScore >= multiAttachThreshold &&
        top.candidateId != runnerUp.candidateId) {
      return ContextResolutionResult(
        outcome: ResolutionOutcome.multiAttach,
        targetContextId: top.candidateId,
        targetContextName: top.candidateName,
        targetContextPath: top.contextPath,
        additionalTargetContextIds: [runnerUp.candidateId],
        confidence: top.finalScore,
        candidateBreakdowns: breakdowns,
        reasoningSummary:
            'Memory strongly belongs to multiple parent contexts: "${top.candidateName}" and "${runnerUp.candidateName}".',
        unresolvedReferences: analysis.unresolvedReferences,
      );
    }

    // Case D: AUTO_ATTACH (High confidence with sufficient margin)
    if (top.finalScore >= autoAttachThreshold && margin >= autoAttachMargin) {
      return ContextResolutionResult(
        outcome: ResolutionOutcome.autoAttach,
        targetContextId: top.candidateId,
        targetContextName: top.candidateName,
        targetContextPath: top.contextPath,
        confidence: top.finalScore,
        candidateBreakdowns: breakdowns,
        reasoningSummary:
            'Matched "${top.candidateName}" with high confidence (${(top.finalScore * 100).toStringAsFixed(0)}%) and clear margin over alternatives.',
        unresolvedReferences: analysis.unresolvedReferences,
      );
    }

    // Case E: AMBIGUOUS (Close competition between top candidates)
    if (top.finalScore >= weakThreshold && runnerUp != null && margin <= ambiguityMargin) {
      return ContextResolutionResult(
        outcome: ResolutionOutcome.ambiguous,
        targetContextId: top.candidateId,
        targetContextName: top.candidateName,
        targetContextPath: top.contextPath,
        confidence: top.finalScore,
        candidateBreakdowns: breakdowns,
        ambiguousCandidates: [top, runnerUp],
        reasoningSummary:
            'Ambiguous match between "${top.candidateName}" (${(top.finalScore * 100).toStringAsFixed(0)}%) and "${runnerUp.candidateName}" (${(runnerUp.finalScore * 100).toStringAsFixed(0)}%). User clarification recommended.',
        unresolvedReferences: analysis.unresolvedReferences,
      );
    }

    // Case F: Low confidence / Unresolved
    if (top.finalScore < weakThreshold) {
      return ContextResolutionResult(
        outcome: ResolutionOutcome.unresolved,
        confidence: top.finalScore,
        candidateBreakdowns: breakdowns,
        reasoningSummary:
            'Top candidate confidence (${(top.finalScore * 100).toStringAsFixed(0)}%) is too low to safely attach without guessing.',
        unresolvedReferences: analysis.unresolvedReferences,
      );
    }

    // Default fallback: attach if above threshold, otherwise mark unresolved
    if (top.finalScore >= autoAttachThreshold) {
      return ContextResolutionResult(
        outcome: ResolutionOutcome.autoAttach,
        targetContextId: top.candidateId,
        targetContextName: top.candidateName,
        targetContextPath: top.contextPath,
        confidence: top.finalScore,
        candidateBreakdowns: breakdowns,
        reasoningSummary: 'Attached to "${top.candidateName}".',
        unresolvedReferences: analysis.unresolvedReferences,
      );
    }

    return ContextResolutionResult(
      outcome: ResolutionOutcome.unresolved,
      confidence: top.finalScore,
      candidateBreakdowns: breakdowns,
      reasoningSummary: 'Insufficient confidence to automatically attach context.',
      unresolvedReferences: analysis.unresolvedReferences,
    );
  }
}
