import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/note.dart';
import '../../../domain/entities/cluster.dart';
import '../../../domain/usecases/get_notes.dart';
import '../../../domain/usecases/get_clusters.dart';
import '../../../injection.dart';

final notesStreamProvider = StreamProvider.autoDispose<List<Note>>((ref) {
  final getNotes = getIt<GetNotesUseCase>();
  return getNotes();
});

final clustersStreamProvider = StreamProvider.autoDispose<List<Cluster>>((ref) {
  final getClusters = getIt<GetClustersUseCase>();
  return getClusters();
});
