import '../entities/cluster.dart';
import '../repositories/note_repository.dart';

class GetClustersUseCase {
  const GetClustersUseCase(this._repository);
  final NoteRepository _repository;

  Stream<List<Cluster>> call() => _repository.watchAllClusters();
}
