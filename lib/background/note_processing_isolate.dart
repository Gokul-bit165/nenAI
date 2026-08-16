import 'dart:async';
import '../domain/entities/processing_status.dart';
import '../domain/entities/note.dart';
import '../domain/entities/pending_resolution.dart';
import '../domain/repositories/note_repository.dart';
import '../domain/ai/context_candidate.dart';
import '../ai/agents/understanding_agent.dart';
import '../ai/agents/entity_resolver.dart';
import '../ai/agents/context_resolution_agent.dart';
import '../ai/agents/memory_reasoner.dart';
import '../ai/agents/memory_router.dart';
import '../ai/memory/context_candidate_retriever.dart';
import '../ai/memory/reference_resolver.dart';
import '../ai/memory/memory_linker.dart';
import '../ai/memory/relationship_evidence_builder.dart';
import 'clustering_manager.dart';

/// Identifies the originating surface of a memory capture.
enum MemoryCaptureSource { note, chat }

/// Event emitted when Gate 2 (pendingReview) fires for a chat message.
///
/// This is a real-time convenience notification for the Chat UI.
/// The `pending_resolutions` DB row is ALWAYS written first, so even if
/// this event is missed (screen closed, app backgrounded), the Pending
/// Review screen acts as the safety-net fallback.
class ChatClarificationEvent {
  const ChatClarificationEvent({
    required this.memoryId,
    required this.candidates,
    required this.noteTextSnippet,
  });

  final String memoryId;
  final List<ResolutionCandidateOption> candidates;
  final String noteTextSnippet;
}

/// Complete NENAI Autonomous Memory Formation Pipeline (Write Flow).
///
/// Refactored 13-Stage Pipeline:
/// SAVE -> UNDERSTAND -> RETRIEVE CONTEXT -> RESOLVE ENTITIES -> RESOLVE REFERENCES
/// -> RESOLVE CONTEXT -> REASON -> DECIDE -> VALIDATE -> STORE -> EMBED -> LINK -> UPDATE CONTEXT
///
/// Accepts both [MemoryCaptureSource.note] and [MemoryCaptureSource.chat] inputs.
/// When [source] == [MemoryCaptureSource.chat], an optional [conversationContext]
/// list of recent turns is passed to [UnderstandingAgent] for pronoun resolution,
/// and Gate 2 results additionally emit a [ChatClarificationEvent] via [onClarificationNeeded].
class NoteProcessingIsolate {
  NoteProcessingIsolate({
    required NoteRepository repository,
    required UnderstandingAgent understandingAgent,
    required EntityResolver entityResolver,
    required ContextCandidateRetriever contextCandidateRetriever,
    required ReferenceResolver referenceResolver,
    required ContextResolutionAgent contextResolutionAgent,
    required MemoryReasoner memoryReasoner,
    required MemoryRouter memoryRouter,
    required MemoryLinker memoryLinker,
    required ClusteringManager clusteringManager,
    RelationshipEvidenceBuilder? relationshipEvidenceBuilder,
  })  : _repository = repository,
        _understandingAgent = understandingAgent,
        _entityResolver = entityResolver,
        _contextCandidateRetriever = contextCandidateRetriever,
        _referenceResolver = referenceResolver,
        _contextResolutionAgent = contextResolutionAgent,
        _memoryReasoner = memoryReasoner,
        _memoryRouter = memoryRouter,
        _memoryLinker = memoryLinker,
        _clusteringManager = clusteringManager,
        _relationshipEvidenceBuilder = relationshipEvidenceBuilder;

  final NoteRepository _repository;
  final UnderstandingAgent _understandingAgent;
  final EntityResolver _entityResolver;
  final ContextCandidateRetriever _contextCandidateRetriever;
  final ReferenceResolver _referenceResolver;
  final ContextResolutionAgent _contextResolutionAgent;
  final MemoryReasoner _memoryReasoner;
  final MemoryRouter _memoryRouter;
  final MemoryLinker _memoryLinker;
  final ClusteringManager _clusteringManager;
  final RelationshipEvidenceBuilder? _relationshipEvidenceBuilder;

  /// [memoryId] — ID of the already-persisted note or chat message record.
  /// [source] — whether this came from the note editor or the chat surface.
  /// [content] — required for [MemoryCaptureSource.chat] (the raw message text),
  ///   since chat messages are not in the notes table. For notes, leave null and
  ///   the pipeline fetches the content from the repository.
  /// [conversationContext] — last N chat turns (chat source only), used to
  ///   resolve pronouns before the context-scoring phase.
  /// [onClarificationNeeded] — optional callback fired when Gate 2 fires
  ///   and source == chat. The `pending_resolutions` row is ALWAYS written
  ///   regardless of whether this callback is provided.
  Future<void> process(
    String memoryId, {
    MemoryCaptureSource source = MemoryCaptureSource.note,
    String? content, // required for source==chat; null for source==note
    List<String>? conversationContext,
    void Function(ChatClarificationEvent)? onClarificationNeeded,
  }) async {
    // ── Fetch or construct the note-like object ─────────────────────────────
    final Note? note;
    if (source == MemoryCaptureSource.note) {
      note = await _repository.getNoteById(memoryId);
      if (note == null) return;
    } else {
      // Chat messages are not in the notes table — synthesize a lightweight
      // Note from the provided content so the rest of the pipeline is uniform.
      final msgContent = content ?? '';
      if (msgContent.trim().isEmpty) return;
      note = Note(
        id: memoryId,
        content: msgContent,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }

    // Only update notes-table status for the note source.
    // Chat messages have no notes row — skip these writes.
    if (source == MemoryCaptureSource.note) {
      await _repository.updateNoteAiFields(
        noteId: memoryId,
        summary: note.summary ?? '',
        keywords: note.keywords,
        clusterId: note.clusterId,
        relatedNoteIds: note.relatedNoteIds,
        status: ProcessingStatus.processing.name,
      );
    }

    try {
      // 2. UNDERSTAND: Extract entities, facts, tasks, actions, topics & references.
      // When conversationContext is provided (chat source), the understanding agent
      // injects recent turns into its prompt so pronouns and vague references
      // ("it", "this", "that") resolve against the live conversation before
      // falling back to long-term KG/recency evidence.
      final analysis = await _understandingAgent.understand(
        note.content,
        conversationContext: conversationContext,
      );

      if (analysis != null) {
        // 2.5 ENTITY EVIDENCE: Build relationship evidence bundles before context scoring
        final entityEvidences = await _relationshipEvidenceBuilder
                ?.buildEvidenceFor(analysis, noteTimestamp: note.createdAt) ??
            const [];

        // 3. RETRIEVE CONTEXT: Multi-signal candidate retrieval across context hierarchy
        final candidates = await _contextCandidateRetriever.retrieveCandidates(
          CandidateRetrievalQuery(
            noteText: note.content,
            analysisResult: analysis,
            noteTimestamp: note.createdAt,
            topK: 5,
            entityEvidences: entityEvidences,
          ),
        );

        // 4. RESOLVE ENTITIES: Match/disambiguate entities against Knowledge Graph
        final resolvedEntities = await _entityResolver.resolveAll(analysis.entities);

        // 5. RESOLVE REFERENCES: Cross-note anaphora & definite noun phrase resolution
        final referenceResolution = await _referenceResolver.resolve(
          noteText: note.content,
          references: analysis.references,
          noteTimestamp: note.createdAt,
        );

        // 6. RESOLVE CONTEXT: Deterministic context decision matrix with ambiguity protection
        final contextResolution = _contextResolutionAgent.resolve(
          noteText: note.content,
          analysis: analysis,
          candidates: candidates,
          noteTimestamp: note.createdAt,
          isMultiContextSupported: true,
        );

        // 7. REASON: Synthesize context operations, facts, and tasks into atomic operations
        final operations = await _memoryReasoner.reason(
          noteId: memoryId,
          noteText: note.content,
          analysis: analysis,
          resolvedEntities: resolvedEntities,
          contextCandidates: candidates,
          referenceResolution: referenceResolution,
          contextResolution: contextResolution,
          noteTimestamp: note.createdAt,
        );

        // 8. DECIDE, 9. VALIDATE, 10. STORE: Transactional Drift execution.
        // For Gate 2 (pendingReview): MemoryRouter ALWAYS writes to pending_resolutions
        // regardless of source — this is the durable safety net.
        await _memoryRouter.execute(
          noteId: memoryId,
          operations: operations,
          resolvedEntities: resolvedEntities,
        );

        // Gate 2 + chat source: fire real-time notification callback so ChatNotifier
        // can insert an inline clarification bubble. This is additive convenience
        // on top of the pending_resolutions DB write above.
        if (source == MemoryCaptureSource.chat &&
            contextResolution.isPendingReview &&
            onClarificationNeeded != null) {
          final candidateOptions = contextResolution.candidateBreakdowns
              .take(3)
              .map((c) => ResolutionCandidateOption(
                    contextId: c.candidateId,
                    contextName: c.candidateName,
                    contextPath: c.contextPath,
                    confidence: c.finalScore,
                    evidenceSummary:
                        c.evidenceSnippet ?? 'Medium-confidence context suggestion.',
                  ))
              .toList();

          onClarificationNeeded(ChatClarificationEvent(
            memoryId: memoryId,
            candidates: candidateOptions,
            noteTextSnippet: note.content.length > 100
                ? '${note.content.substring(0, 97)}...'
                : note.content,
          ));
        }

        // 11. EMBED & 12. LINK: 384D ONNX embeddings & semantic memory linking
        final relatedIds = await _memoryLinker.linkMemory(
          noteId: memoryId,
          rawContent: note.content,
          analysis: analysis,
        );

        // 13. UPDATE CONTEXT: Cluster assignment & final note state
        final clusterId = await _clusteringManager.assignCluster(
          topic: analysis.topic,
          keywords: analysis.keywords,
          vector: [],
        );

        if (source == MemoryCaptureSource.note) {
          final finalStatus = contextResolution.isAmbiguous
              ? ProcessingStatus.needsUserClarification.name
              : contextResolution.isPendingReview
                  ? ProcessingStatus.needsUserClarification.name
                  : ProcessingStatus.completed.name;

          await _repository.updateNoteAiFields(
            noteId: memoryId,
            summary: analysis.summary,
            keywords: analysis.keywords,
            clusterId: clusterId,
            relatedNoteIds: relatedIds,
            status: finalStatus,
          );
        }
      } else {
        if (source == MemoryCaptureSource.note) {
          final fallbackSummary = note.content.length > 150
              ? '${note.content.substring(0, 147)}...'
              : note.content;

          await _repository.updateNoteAiFields(
            noteId: memoryId,
            summary: fallbackSummary,
            keywords: note.keywords,
            clusterId: note.clusterId,
            relatedNoteIds: note.relatedNoteIds,
            status: ProcessingStatus.completed.name,
          );
        }
      }
    } catch (e) {
      if (source == MemoryCaptureSource.note) {
        await _repository.updateNoteAiFields(
          noteId: memoryId,
          summary: note.summary ?? '',
          keywords: note.keywords,
          clusterId: note.clusterId,
          relatedNoteIds: note.relatedNoteIds,
          status: ProcessingStatus.failed.name,
        );
      }
    }
  }

  /// Backward-compatible alias so existing call sites (note editor) compile unchanged.
  Future<void> processNote(String noteId) => process(noteId);
}
