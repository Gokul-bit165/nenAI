import 'package:workmanager/workmanager.dart';
import '../core/constants/app_constants.dart';
import '../domain/entities/processing_status.dart';
import '../domain/ai/note_intelligence_engine.dart';
import '../domain/ai/embedding_engine.dart';
import '../domain/repositories/note_repository.dart';
import '../injection.dart';
import 'clustering_manager.dart';

/// Entry point for WorkManager tasks on Android.
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == AppConstants.noteProcessingTaskName) {
      final noteId = inputData?[AppConstants.noteIdInputKey] as String?;
      if (noteId == null) return true;

      // Configure dependency injection for background isolate if needed
      await configureDependencies();

      final repository = getIt<NoteRepository>();
      final intelligenceEngine = getIt<NoteIntelligenceEngine>();
      final embeddingEngine = getIt<EmbeddingEngine>();

      final note = await repository.getNoteById(noteId);
      if (note == null) return true;

      // Mark processing status
      await repository.updateNoteAiFields(
        noteId: noteId,
        summary: note.summary ?? '',
        keywords: note.keywords,
        clusterId: note.clusterId,
        relatedNoteIds: note.relatedNoteIds,
        status: ProcessingStatus.processing.name,
      );

      try {
        // Step 1: LLM Inference (Topic, Summary, Keywords)
        final analysis = await intelligenceEngine.analyze(note.content);

        // Step 2: Embedding Generation
        final vector = await embeddingEngine.embed(note.content);
        if (vector != null) {
          await repository.saveEmbedding(noteId, vector);
        }

        // Step 3: Related Notes Scan
        List<String> relatedIds = [];
        if (vector != null) {
          final searchResults = await repository.semanticSearch(vector, limit: AppConstants.maxRelatedNotes + 1);
          relatedIds = searchResults.map((n) => n.id).where((id) => id != noteId).toList();
        }

        // Step 4: Clustering Assignment
        String? clusterId = note.clusterId;
        if (analysis != null) {
          final clusteringManager = ClusteringManager(repository);
          clusterId = await clusteringManager.assignCluster(
            topic: analysis.topic,
            keywords: analysis.keywords,
            vector: vector ?? [],
          );
        }

        final fallbackSummary = note.content.length > 150 ? '${note.content.substring(0, 147)}...' : note.content;

        // Write back results
        await repository.updateNoteAiFields(
          noteId: noteId,
          summary: (analysis?.summary.isNotEmpty == true) ? analysis!.summary : fallbackSummary,
          keywords: analysis?.keywords ?? [],
          clusterId: clusterId,
          relatedNoteIds: relatedIds,
          status: ProcessingStatus.completed.name,
        );

        return true;
      } catch (e) {
        // Handle failure gracefully — note remains intact
        await repository.updateNoteAiFields(
          noteId: noteId,
          summary: note.summary ?? '',
          keywords: note.keywords,
          clusterId: note.clusterId,
          relatedNoteIds: note.relatedNoteIds,
          status: ProcessingStatus.failed.name,
        );
        return false;
      }
    }
    return true;
  });
}
