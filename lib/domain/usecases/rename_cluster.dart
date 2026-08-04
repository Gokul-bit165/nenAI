import '../repositories/note_repository.dart';

class RenameClusterUseCase {
  const RenameClusterUseCase(this._repository);
  final NoteRepository _repository;

  Future<void> call(String clusterId, String newName) =>
      _repository.renameCluster(clusterId, newName);
}
