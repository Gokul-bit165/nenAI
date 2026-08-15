import '../../domain/ai/context_candidate.dart';
import '../../domain/ai/context_resolution_result.dart';
import '../../domain/ai/note_analysis_result.dart';

/// Context Resolution Agent: Deterministically resolves where an incoming memory belongs
/// using a 3-gate confidence system:
///
/// HIGH   ≥ 0.80 → AUTO_ATTACH    (note linked automatically, audit trail stored)
/// MEDIUM 0.55–0.79 → PENDING_REVIEW (note saved unlinked, soft suggestion card shown)
/// LOW    < 0.55 → UNRESOLVED     (note saved unlinked, no prompt shown)
class ContextResolutionAgent {
  const ContextResolutionAgent({
    this.highConfidenceThreshold = 0.80,
    this.mediumConfidenceThreshold = 0.55,
    this.autoAttachMargin = 0.15,
    this.ambiguityMargin = 0.12,
    this.multiAttachThreshold = 0.80,
  });

  /// HIGH gate: score ≥ this → auto-attach
  final double highConfidenceThreshold;

  /// MEDIUM gate: score ≥ this → pending review (soft suggestion)
  final double mediumConfidenceThreshold;

  /// Minimum score margin between top and runner-up for a clean auto-attach
  final double autoAttachMargin;

  /// Maximum margin below which two candidates are considered ambiguous
  final double ambiguityMargin;

  /// Both top candidates must exceed this for multi-context DAG attachment
  final double multiAttachThreshold;

  /// Resolves the destination context for a newly analysed note.
  ContextResolutionResult resolve({
    required String noteText,
    required NoteAnalysisResult analysis,
    required List<ContextCandidate> candidates,
    required DateTime noteTimestamp,
    bool isMultiContextSupported = false,
  }) {
    final trimmed = noteText.trim();

    // 1. Trivial / Empty
    if (trimmed.length < 5) {
      return ContextResolutionResult(
        outcome: ResolutionOutcome.ignore,
        confidence: 1.0,
        reasoningSummary: 'Note content is too short or ephemeral.',
        unresolvedReferences: analysis.unresolvedReferences,
      );
    }

    // 2. Build multi-signal score breakdowns
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

    breakdowns.sort((a, b) => b.finalScore.compareTo(a.finalScore));

    // ── Case A: No existing candidates ────────────────────────────────────────
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

    // ── Case B: Explicit new project with weak candidates ────────────────────
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

    // ── Case C: MULTI_ATTACH (both candidates above HIGH threshold) ───────────
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

    // ── Case D: HIGH gate — AUTO_ATTACH ≥ 0.80 with clear margin ─────────────
    if (top.finalScore >= highConfidenceThreshold && margin >= autoAttachMargin) {
      return ContextResolutionResult(
        outcome: ResolutionOutcome.autoAttach,
        targetContextId: top.candidateId,
        targetContextName: top.candidateName,
        targetContextPath: top.contextPath,
        confidence: top.finalScore,
        candidateBreakdowns: breakdowns,
        reasoningSummary:
            'HIGH confidence: matched "${top.candidateName}" at ${(top.finalScore * 100).toStringAsFixed(0)}% with clear margin.',
        unresolvedReferences: analysis.unresolvedReferences,
      );
    }

    // ── Case E: AMBIGUOUS — top candidates too close at HIGH level ───────────
    if (top.finalScore >= highConfidenceThreshold &&
        runnerUp != null &&
        margin < ambiguityMargin) {
      return ContextResolutionResult(
        outcome: ResolutionOutcome.ambiguous,
        targetContextId: top.candidateId,
        targetContextName: top.candidateName,
        targetContextPath: top.contextPath,
        confidence: top.finalScore,
        candidateBreakdowns: breakdowns,
        ambiguousCandidates: [top, runnerUp!],
        reasoningSummary:
            'Ambiguous between "${top.candidateName}" (${(top.finalScore * 100).toStringAsFixed(0)}%) and "${runnerUp.candidateName}" (${(runnerUp.finalScore * 100).toStringAsFixed(0)}%). User input needed.',
        unresolvedReferences: analysis.unresolvedReferences,
      );
    }

    // ── Case F: MEDIUM gate — PENDING_REVIEW 0.55–0.79 ───────────────────────
    if (top.finalScore >= mediumConfidenceThreshold) {
      return ContextResolutionResult(
        outcome: ResolutionOutcome.pendingReview,
        targetContextId: top.candidateId,
        targetContextName: top.candidateName,
        targetContextPath: top.contextPath,
        confidence: top.finalScore,
        candidateBreakdowns: breakdowns,
        reasoningSummary:
            'MEDIUM confidence: "${top.candidateName}" at ${(top.finalScore * 100).toStringAsFixed(0)}%. Saved as suggestion — confirm or dismiss.',
        unresolvedReferences: analysis.unresolvedReferences,
      );
    }

    // ── Case G: LOW gate — UNRESOLVED < 0.55 ─────────────────────────────────
    return ContextResolutionResult(
      outcome: ResolutionOutcome.unresolved,
      confidence: top.finalScore,
      candidateBreakdowns: breakdowns,
      reasoningSummary:
          'LOW confidence (${(top.finalScore * 100).toStringAsFixed(0)}%): saved unlinked, no context attached.',
      unresolvedReferences: analysis.unresolvedReferences,
    );
  }
}


