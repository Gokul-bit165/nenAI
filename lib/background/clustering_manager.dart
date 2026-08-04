import 'package:uuid/uuid.dart';
import '../core/constants/app_constants.dart';
import '../core/utils/vector_math.dart';
import '../domain/entities/cluster.dart';
import '../domain/entities/note.dart';
import '../domain/repositories/note_repository.dart';

/// Handles auto-clustering notes based on topic similarity and centroids.
class ClusteringManager {
  ClusteringManager(this._repository);

  final NoteRepository _repository;

  /// Assigns a cluster ID for a note based on its extracted [topic], [keywords], and optional [vector].
  Future<String> assignCluster({
    required String topic,
    required List<String> keywords,
    required List<double> vector,
  }) async {
    final clusters = await _repository.watchAllClusters().first;
    final embeddings = await _repository.getAllEmbeddings();

    if (clusters.isEmpty) {
      return _createNewCluster(topic, keywords);
    }

    String? bestClusterId;
    double bestSim = -1.0;

    for (final cluster in clusters) {
      final clusterNotes = (await _repository.watchNotesByCluster(cluster.id).first);

      // 1. Try vector centroid similarity if vector embeddings exist
      if (vector.isNotEmpty) {
        final clusterVectors = clusterNotes
            .map((n) => embeddings[n.id])
            .whereType<List<double>>()
            .where((v) => v.isNotEmpty)
            .toList();

        if (clusterVectors.isNotEmpty) {
          double simSum = 0.0;
          for (final cVec in clusterVectors) {
            simSum += VectorMath.cosineSimilarity(vector, cVec);
          }
          final avgSim = simSum / clusterVectors.length;

          if (avgSim > bestSim) {
            bestSim = avgSim;
            bestClusterId = cluster.id;
          }
        }
      }

      // 2. Text/Keyword Overlap Similarity (collect terms from cluster name + all cluster notes)
      final textSim = _calculateTextSimilarity(topic, keywords, cluster.name, clusterNotes);
      if (textSim > bestSim) {
        bestSim = textSim;
        bestClusterId = cluster.id;
      }
    }

    if (bestClusterId != null && bestSim >= 0.15) {
      return bestClusterId;
    } else {
      return _createNewCluster(topic, keywords);
    }
  }

  double _calculateTextSimilarity(
    String topic,
    List<String> keywords,
    String clusterName,
    List<Note> clusterNotes,
  ) {
    final newTerms = {
      ...topic.toLowerCase().split(RegExp(r'[\s_,-]+')),
      ...keywords.map((k) => k.toLowerCase()),
    }.where((t) => t.length > 1).toSet();

    final clusterTerms = {
      ...clusterName.toLowerCase().split(RegExp(r'[\s_,-]+')),
      for (final note in clusterNotes) ...[
        ...note.keywords.map((k) => k.toLowerCase()),
        if (note.summary != null) ...note.summary!.toLowerCase().split(RegExp(r'[\s_,-]+')),
      ],
    }.where((t) => t.length > 1).toSet();

    if (newTerms.isEmpty || clusterTerms.isEmpty) return 0.0;

    final intersection = newTerms.intersection(clusterTerms);
    if (intersection.isEmpty) return 0.0;

    // Stopwords filter for overlap score calculation
    const stopWords = {'the', 'and', 'for', 'with', 'app', 'note', 'this', 'that', 'from'};
    final significantMatches = intersection.where((t) => !stopWords.contains(t)).toList();

    if (significantMatches.isNotEmpty) {
      // If a major topic word matches (e.g. "memai"), boost similarity score significantly
      final jaccard = significantMatches.length / newTerms.union(clusterTerms).length;
      return (jaccard + 0.4).clamp(0.0, 1.0);
    }

    return intersection.length / newTerms.union(clusterTerms).length;
  }

  Future<String> _createNewCluster(String topic, List<String> keywords) async {
    final id = const Uuid().v4();
    final name = topic.isNotEmpty ? topic : (keywords.isNotEmpty ? keywords.first : 'General');
    final colorHex = AppConstants.clusterColors[DateTime.now().millisecondsSinceEpoch % AppConstants.clusterColors.length];

    final cluster = Cluster(
      id: id,
      name: name,
      colorHex: colorHex,
      createdAt: DateTime.now(),
    );

    await _repository.upsertCluster(cluster);
    return id;
  }
}
