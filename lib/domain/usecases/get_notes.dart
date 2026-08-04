import '../entities/note.dart';
import '../repositories/note_repository.dart';

class GetNotesUseCase {
  const GetNotesUseCase(this._repository);
  final NoteRepository _repository;

  Stream<List<Note>> call() => _repository.watchAllNotes();
}
