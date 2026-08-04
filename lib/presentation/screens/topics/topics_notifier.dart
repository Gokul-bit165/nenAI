import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/cluster.dart';
import '../../../domain/usecases/get_clusters.dart';
import '../../../domain/usecases/rename_cluster.dart';
import '../../../injection.dart';

final clustersProvider = StreamProvider.autoDispose<List<Cluster>>((ref) {
  final getClusters = getIt<GetClustersUseCase>();
  return getClusters();
});

final renameClusterProvider = Provider.autoDispose((ref) {
  return (String id, String newName) async {
    final rename = getIt<RenameClusterUseCase>();
    await rename(id, newName);
  };
});
