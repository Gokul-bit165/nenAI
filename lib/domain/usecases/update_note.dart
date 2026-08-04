import '../entities/note.dart';
import '../repositories/note_repository.dart';

class UpdateNoteUseCase {
  const UpdateNoteUseCase(this._repository);
  final NoteRepository _repository;

  Future<void> call(Note note) => _repository.updateNote(note);
}
