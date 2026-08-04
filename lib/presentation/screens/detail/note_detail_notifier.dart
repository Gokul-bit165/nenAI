import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/note.dart';
import '../../../domain/repositories/note_repository.dart';
import '../../../injection.dart';

final noteDetailProvider = StreamProvider.family.autoDispose<Note?, String>((ref, noteId) async* {
  final repository = getIt<NoteRepository>();
  await for (final notes in repository.watchAllNotes()) {
    final match = notes.where((n) => n.id == noteId).firstOrNull;
    yield match;
  }
});

final relatedNotesProvider = FutureProvider.family.autoDispose<List<Note>, List<String>>((ref, relatedIds) async {
  if (relatedIds.isEmpty) return [];
  final repository = getIt<NoteRepository>();
  final notes = <Note>[];
  for (final id in relatedIds) {
    final note = await repository.getNoteById(id);
    if (note != null) notes.add(note);
  }
  return notes;
});
