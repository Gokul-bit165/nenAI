import 'dart:math' as math;
import '../entities/memory_evidence.dart';

/// Context candidate input for evaluation.
class CandidateContextInput {
  const CandidateContextInput({
    required this.contextId,
    required this.contextName,
    this.relationType = 'relates_to',
    this.signals = const [],
    this.associatedMemoryIds = const [],
    this.lastActiveTime,
  });

  final String contextId;
  final String contextName;
  final String relationType;
  final List<EvidenceSignal> signals;
  final List<String> associatedMemoryIds;
  final DateTime? lastActiveTime;
}

/// Confidence calculation and explainable evidence evaluation engine.
class EvidenceEvaluator {
  const EvidenceEvaluator({
    this.strongInferenceThreshold = 0.80,
    this.weakInferenceThreshold = 0.40,
    this.ambiguityMarginThreshold = 0.15,
  });

  final double strongInferenceThreshold;
  final double weakInferenceThreshold;
  final double ambiguityMarginThreshold;

  /// Evaluates multiple candidate contexts for a given source note and computes confidence and explanations.
  EvidenceEvaluationResult evaluate({
    required String sourceMemoryId,
    required String sourceText,
    required List<CandidateContextInput> candidates,
  }) {
    final snippet = sourceText.length > 120
        ? '${sourceText.substring(0, 117)}...'
        : sourceText;

    if (candidates.isEmpty) {
      return EvidenceEvaluationResult(
        sourceMemoryId: sourceMemoryId,
        sourceTextSnippet: snippet,
        allCandidates: const [],
        isAmbiguous: false,
      );
    }

    final evaluatedCandidates = <CandidateEvidence>[];

    for (final candidate in candidates) {
      final evaluated = evaluateSingle(
        sourceText: sourceText,
        candidate: candidate,
      );
      evaluatedCandidates.add(evaluated);
    }

    // Sort descending by confidence
    evaluatedCandidates.sort((a, b) => b.confidence.compareTo(a.confidence));

    final top = evaluatedCandidates.first;

    // Check for ambiguity: multiple candidates with confidence >= weakInferenceThreshold within ambiguityMargin
    final qualified = evaluatedCandidates
        .where((c) => c.confidence >= weakInferenceThreshold)
        .toList();

    bool isAmbiguous = false;
    final ambiguousCandidates = <CandidateEvidence>[];

    if (top.inferenceType != InferenceType.explicit && qualified.length >= 2) {
      final second = qualified[1];
      if ((top.confidence - second.confidence).abs() <= ambiguityMarginThreshold) {
        isAmbiguous = true;
        ambiguousCandidates.addAll(qualified.take(3));
      }
    }

    // If ambiguous, update inference types of top competing candidates to ambiguousInference
    final finalizedCandidates = evaluatedCandidates.map((c) {
      if (isAmbiguous && ambiguousCandidates.any((a) => a.contextId == c.contextId)) {
        return CandidateEvidence(
          contextId: c.contextId,
          contextName: c.contextName,
          relationType: c.relationType,
          confidence: c.confidence,
          inferenceType: InferenceType.ambiguousInference,
          signals: c.signals,
          explanation: c.explanation,
        );
      }
      return c;
    }).toList();

    final finalizedTop = finalizedCandidates.first;

    return EvidenceEvaluationResult(
      sourceMemoryId: sourceMemoryId,
      sourceTextSnippet: snippet,
      topCandidate: finalizedTop,
      allCandidates: finalizedCandidates,
      isAmbiguous: isAmbiguous,
      ambiguousCandidates: isAmbiguous ? ambiguousCandidates : const [],
    );
  }

  /// Evaluates confidence signals for a single candidate context.
  CandidateEvidence evaluateSingle({
    required String sourceText,
    required CandidateContextInput candidate,
  }) {
    final signals = List<EvidenceSignal>.from(candidate.signals);

    // 1. Check for explicit mention in source text
    final explicitSignal = _detectExplicitMention(sourceText, candidate.contextName);
    if (explicitSignal != null) {
      signals.add(explicitSignal);
    }

    // 2. Compute aggregate confidence from signals
    double totalWeightedScore = 0.0;
    double totalWeight = 0.0;

    for (final signal in signals) {
      totalWeightedScore += signal.weight * signal.score;
      totalWeight += signal.weight;
    }

    double confidence = totalWeight > 0 ? (totalWeightedScore / totalWeight) : 0.0;
    confidence = confidence.clamp(0.0, 1.0);

    // 3. Classify Inference Type
    InferenceType inferenceType;
    if (signals.any((s) => s.signalType == SignalType.explicitMention && s.score >= 0.95)) {
      inferenceType = InferenceType.explicit;
      confidence = math.max(confidence, 0.95);
    } else if (confidence >= strongInferenceThreshold) {
      inferenceType = InferenceType.strongInference;
    } else if (confidence >= weakInferenceThreshold) {
      inferenceType = InferenceType.weakInference;
    } else {
      inferenceType = InferenceType.weakInference;
    }

    // 4. Generate Concise Human-Readable Explanation
    final explanation = _generateExplanation(
      contextName: candidate.contextName,
      inferenceType: inferenceType,
      signals: signals,
    );

    return CandidateEvidence(
      contextId: candidate.contextId,
      contextName: candidate.contextName,
      relationType: candidate.relationType,
      confidence: confidence,
      inferenceType: inferenceType,
      signals: signals,
      explanation: explanation,
    );
  }

  EvidenceSignal? _detectExplicitMention(String sourceText, String contextName) {
    final lowerText = sourceText.toLowerCase();
    final lowerContext = contextName.toLowerCase().trim();

    if (lowerContext.isEmpty) return null;

    if (lowerText.contains(lowerContext)) {
      return EvidenceSignal(
        signalType: SignalType.explicitMention,
        weight: 1.0,
        score: 1.0,
        description: 'Direct mention of "$contextName" in note content',
      );
    }
    return null;
  }

  String _generateExplanation({
    required String contextName,
    required InferenceType inferenceType,
    required List<EvidenceSignal> signals,
  }) {
    if (signals.isEmpty) {
      return 'Linked to $contextName based on general context.';
    }

    if (inferenceType == InferenceType.explicit) {
      return 'Explicitly mentions "$contextName" in the note text.';
    }

    final topSignals = List<EvidenceSignal>.from(signals)
      ..sort((a, b) => b.contribution.compareTo(a.contribution));

    final reasons = topSignals.take(3).map((s) => s.description).toList();

    if (reasons.length == 1) {
      return 'Matched "$contextName" because ${reasons.first.toLowerCase()}.';
    }

    return 'Matched "$contextName" based on:\n${reasons.map((r) => '• $r').join('\n')}';
  }
}
