import '../entities/note.dart';
import '../repositories/note_repository.dart';

class CreateNoteUseCase {
  const CreateNoteUseCase(this._repository);
  final NoteRepository _repository;

  Future<void> call(Note note) => _repository.createNote(note);
}
