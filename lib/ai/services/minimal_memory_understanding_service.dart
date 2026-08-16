import '../../domain/ai/note_analysis_result.dart';
import '../../domain/ai/context_resolution_result.dart';
import '../../domain/ai/context_candidate.dart';
import '../../domain/entities/memory_operation.dart';
import '../agents/understanding_agent.dart';
import '../agents/entity_resolver.dart';
import '../agents/context_resolution_agent.dart';
import '../agents/query_understanding_agent.dart';
import '../memory/context_candidate_retriever.dart';
import '../memory/reference_resolver.dart';
import '../memory/relationship_evidence_builder.dart';

/// The structured result of fast, synchronous memory understanding (stages 1–6).
class MinimalMemoryUnderstanding {
  const MinimalMemoryUnderstanding({
    required this.content,
    required this.intent,
    this.analysis,
    this.contextResolution,
    this.candidates = const [],
    this.resolvedEntities = const [],
  });

  final String content;
  final MemoryIntent intent;
  final NoteAnalysisResult? analysis;
  final ContextResolutionResult? contextResolution;
  final List<ContextCandidate> candidates;
  final List<ResolvedEntity> resolvedEntities;

  /// Whether context resolution outcome is clear (autoAttach, newContext, multiAttach).
  bool get isClear =>
      contextResolution != null &&
      (contextResolution!.outcome == ResolutionOutcome.autoAttach ||
          contextResolution!.outcome == ResolutionOutcome.newContext ||
          contextResolution!.outcome == ResolutionOutcome.multiAttach);

  /// Whether context resolution is ambiguous (ambiguous or pendingReview).
  bool get isAmbiguous =>
      contextResolution != null &&
      (contextResolution!.outcome == ResolutionOutcome.ambiguous ||
          contextResolution!.outcome == ResolutionOutcome.pendingReview);

  /// Primary target context name if clear.
  String? get targetContextName => contextResolution?.targetContextName;

  /// Candidate options formatted for clarification UI chips.
  List<CandidateScoreBreakdown> get candidateBreakdowns =>
      contextResolution?.candidateBreakdowns ?? const [];
}

/// Minimal Memory Understanding Service: Synchronously executes stages 1–6 of the memory
/// understanding pipeline (Understanding → Relationship Evidence → Candidate Retrieval →
/// Entity Resolution → Reference Resolution → Context Resolution) to determine
/// minimum understanding and confidence before replying in Chat.
///
/// Full stages 7–13 (embedding, memory reasoner, memory router, clustering) continue
/// asynchronously in background isolate.
class MinimalMemoryUnderstandingService {
  MinimalMemoryUnderstandingService({
    required UnderstandingAgent understandingAgent,
    required EntityResolver entityResolver,
    required ContextCandidateRetriever contextCandidateRetriever,
    required ContextResolutionAgent contextResolutionAgent,
    required ReferenceResolver referenceResolver,
    RelationshipEvidenceBuilder? relationshipEvidenceBuilder,
  })  : _understandingAgent = understandingAgent,
        _entityResolver = entityResolver,
        _contextCandidateRetriever = contextCandidateRetriever,
        _contextResolutionAgent = contextResolutionAgent,
        _referenceResolver = referenceResolver,
        _relationshipEvidenceBuilder = relationshipEvidenceBuilder;

  final UnderstandingAgent _understandingAgent;
  final EntityResolver _entityResolver;
  final ContextCandidateRetriever _contextCandidateRetriever;
  final ContextResolutionAgent _contextResolutionAgent;
  final ReferenceResolver _referenceResolver;
  final RelationshipEvidenceBuilder? _relationshipEvidenceBuilder;

  /// Runs stages 1–6 synchronously for a chat memory input.
  Future<MinimalMemoryUnderstanding> understand(
    String content, {
    MemoryIntent intent = MemoryIntent.unknown,
    List<String>? conversationContext,
  }) async {
    final trimmed = content.trim();
    if (trimmed.isEmpty) {
      return MinimalMemoryUnderstanding(content: content, intent: intent);
    }

    final now = DateTime.now();

    // 1. UNDERSTAND
    final analysis = await _understandingAgent.understand(
      trimmed,
      conversationContext: conversationContext,
    );

    if (analysis == null) {
      return MinimalMemoryUnderstanding(content: content, intent: intent);
    }

    // 2. ENTITY EVIDENCE
    final entityEvidences = await _relationshipEvidenceBuilder?.buildEvidenceFor(
          analysis,
          noteTimestamp: now,
        ) ??
        const [];

    // 3. RETRIEVE CANDIDATES
    final candidates = await _contextCandidateRetriever.retrieveCandidates(
      CandidateRetrievalQuery(
        noteText: trimmed,
        analysisResult: analysis,
        noteTimestamp: now,
        topK: 5,
        entityEvidences: entityEvidences,
      ),
    );

    // 4. RESOLVE ENTITIES
    final resolvedEntities = await _entityResolver.resolveAll(analysis.entities);

    // 5. RESOLVE REFERENCES
    await _referenceResolver.resolve(
      noteText: trimmed,
      references: analysis.references,
      noteTimestamp: now,
    );

    // 6. RESOLVE CONTEXT (gates)
    final contextResolution = _contextResolutionAgent.resolve(
      noteText: trimmed,
      analysis: analysis,
      candidates: candidates,
      noteTimestamp: now,
      isMultiContextSupported: true,
    );

    return MinimalMemoryUnderstanding(
      content: trimmed,
      intent: intent,
      analysis: analysis,
      contextResolution: contextResolution,
      candidates: candidates,
      resolvedEntities: resolvedEntities,
    );
  }
}
