import 'dart:async';
import '../domain/entities/processing_status.dart';
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

/// Complete NENAI Autonomous Memory Formation Pipeline (Write Flow).
///
/// Refactored 13-Stage Pipeline:
/// SAVE -> UNDERSTAND -> RETRIEVE CONTEXT -> RESOLVE ENTITIES -> RESOLVE REFERENCES
/// -> RESOLVE CONTEXT -> REASON -> DECIDE -> VALIDATE -> STORE -> EMBED -> LINK -> UPDATE CONTEXT
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

  Future<void> processNote(String noteId) async {
    // 1. SAVE: Note already persisted in repository
    final note = await _repository.getNoteById(noteId);
    if (note == null) return;

    await _repository.updateNoteAiFields(
      noteId: noteId,
      summary: note.summary ?? '',
      keywords: note.keywords,
      clusterId: note.clusterId,
      relatedNoteIds: note.relatedNoteIds,
      status: ProcessingStatus.processing.name,
    );

    try {
      // 2. UNDERSTAND: Extract entities, facts, tasks, actions, topics & references
      final analysis = await _understandingAgent.understand(note.content);

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
          noteId: noteId,
          noteText: note.content,
          analysis: analysis,
          resolvedEntities: resolvedEntities,
          contextCandidates: candidates,
          referenceResolution: referenceResolution,
          contextResolution: contextResolution,
          noteTimestamp: note.createdAt,
        );

        // 8. DECIDE, 9. VALIDATE, 10. STORE: Transactional Drift execution
        await _memoryRouter.execute(
          noteId: noteId,
          operations: operations,
          resolvedEntities: resolvedEntities,
        );

        // 11. EMBED & 12. LINK: 384D ONNX embeddings & semantic memory linking
        final relatedIds = await _memoryLinker.linkMemory(
          noteId: noteId,
          rawContent: note.content,
          analysis: analysis,
        );

        // 13. UPDATE CONTEXT: Cluster assignment & final note state
        final clusterId = await _clusteringManager.assignCluster(
          topic: analysis.topic,
          keywords: analysis.keywords,
          vector: [],
        );

        final finalStatus = contextResolution.isAmbiguous
            ? ProcessingStatus.needsUserClarification.name
            : ProcessingStatus.completed.name;

        await _repository.updateNoteAiFields(
          noteId: noteId,
          summary: analysis.summary,
          keywords: analysis.keywords,
          clusterId: clusterId,
          relatedNoteIds: relatedIds,
          status: finalStatus,
        );
      } else {
        final fallbackSummary = note.content.length > 150
            ? '${note.content.substring(0, 147)}...'
            : note.content;

        await _repository.updateNoteAiFields(
          noteId: noteId,
          summary: fallbackSummary,
          keywords: note.keywords,
          clusterId: note.clusterId,
          relatedNoteIds: note.relatedNoteIds,
          status: ProcessingStatus.completed.name,
        );
      }
    } catch (e) {
      await _repository.updateNoteAiFields(
        noteId: noteId,
        summary: note.summary ?? '',
        keywords: note.keywords,
        clusterId: note.clusterId,
        relatedNoteIds: note.relatedNoteIds,
        status: ProcessingStatus.failed.name,
      );
    }
  }
}
