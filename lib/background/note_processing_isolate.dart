import 'dart:async';
import '../domain/entities/processing_status.dart';
import '../domain/repositories/note_repository.dart';
import '../ai/agents/understanding_agent.dart';
import '../ai/agents/entity_resolver.dart';
import '../ai/agents/memory_reasoner.dart';
import '../ai/agents/memory_router.dart';
import '../ai/memory/memory_linker.dart';
import 'clustering_manager.dart';

/// Complete NENAI V2 Memory Formation Pipeline (Write Flow).
class NoteProcessingIsolate {
  NoteProcessingIsolate({
    required NoteRepository repository,
    required UnderstandingAgent understandingAgent,
    required EntityResolver entityResolver,
    required MemoryReasoner memoryReasoner,
    required MemoryRouter memoryRouter,
    required MemoryLinker memoryLinker,
    required ClusteringManager clusteringManager,
  })  : _repository = repository,
        _understandingAgent = understandingAgent,
        _entityResolver = entityResolver,
        _memoryReasoner = memoryReasoner,
        _memoryRouter = memoryRouter,
        _memoryLinker = memoryLinker,
        _clusteringManager = clusteringManager;

  final NoteRepository _repository;
  final UnderstandingAgent _understandingAgent;
  final EntityResolver _entityResolver;
  final MemoryReasoner _memoryReasoner;
  final MemoryRouter _memoryRouter;
  final MemoryLinker _memoryLinker;
  final ClusteringManager _clusteringManager;

  Future<void> processNote(String noteId) async {
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
      // 1. Understand: Extract Entities, Facts, Tasks & Summary
      final analysis = await _understandingAgent.understand(note.content);

      if (analysis != null) {
        // 2. Resolve Entities: Match / Disambiguate against Existing Records
        final resolvedEntities = await _entityResolver.resolveAll(analysis.entities);

        // 3. Reason: Compare with Knowledge Graph & emit operations
        final operations = await _memoryReasoner.reason(
          noteId: noteId,
          analysis: analysis,
          resolvedEntities: resolvedEntities,
        );

        // 4. Route & Store: Transactional Drift execution
        await _memoryRouter.execute(
          noteId: noteId,
          operations: operations,
          resolvedEntities: resolvedEntities,
        );

        // 5. Connect: Generate 384D vector and link high-confidence memories
        final relatedIds = await _memoryLinker.linkMemory(
          noteId: noteId,
          rawContent: note.content,
          analysis: analysis,
        );

        // 6. Cluster Assignment
        final clusterId = await _clusteringManager.assignCluster(
          topic: analysis.topic,
          keywords: analysis.keywords,
          vector: [],
        );

        await _repository.updateNoteAiFields(
          noteId: noteId,
          summary: analysis.summary,
          keywords: analysis.keywords,
          clusterId: clusterId,
          relatedNoteIds: relatedIds,
          status: ProcessingStatus.completed.name,
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
