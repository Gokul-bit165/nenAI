import 'dart:async';
import '../core/constants/app_constants.dart';
import '../domain/entities/processing_status.dart';
import '../domain/ai/note_intelligence_engine.dart';
import '../domain/ai/embedding_engine.dart';
import '../domain/repositories/note_repository.dart';
import 'clustering_manager.dart';

class NoteProcessingIsolate {
  NoteProcessingIsolate(
    this._repository,
    this._intelligenceEngine,
    this._embeddingEngine,
  );

  final NoteRepository _repository;
  final NoteIntelligenceEngine _intelligenceEngine;
  final EmbeddingEngine _embeddingEngine;

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
      final analysis = await _intelligenceEngine.analyze(note.content);

      final vector = await _embeddingEngine.embed(note.content);
      if (vector != null) {
        await _repository.saveEmbedding(noteId, vector);
      }

      List<String> relatedIds = [];
      if (vector != null) {
        final searchResults = await _repository.semanticSearch(vector, limit: AppConstants.maxRelatedNotes + 1);
        relatedIds = searchResults.map((n) => n.id).where((id) => id != noteId).toList();
      }

      String? clusterId = note.clusterId;
      if (analysis != null) {
        final clusteringManager = ClusteringManager(_repository);
        clusterId = await clusteringManager.assignCluster(
          topic: analysis.topic,
          keywords: analysis.keywords,
          vector: vector ?? [],
        );
      }

      final fallbackSummary = note.content.length > 150 ? '${note.content.substring(0, 147)}...' : note.content;

      await _repository.updateNoteAiFields(
        noteId: noteId,
        summary: (analysis?.summary.isNotEmpty == true) ? analysis!.summary : fallbackSummary,
        keywords: analysis?.keywords ?? [],
        clusterId: clusterId,
        relatedNoteIds: relatedIds,
        status: ProcessingStatus.completed.name,
      );
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
