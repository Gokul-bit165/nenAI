import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/note.dart';
import '../../../domain/repositories/note_repository.dart';
import '../../../data/local/database/app_database.dart';
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

final noteEntitiesProvider = FutureProvider.family.autoDispose<List<EntitiesTableData>, String>((ref, noteId) async {
  final db = getIt<AppDatabase>();
  return await db.entities.getEntitiesForMemory(noteId);
});

final noteRelationshipsProvider = FutureProvider.family.autoDispose<List<({String sourceName, String relation, String targetName})>, String>((ref, noteId) async {
  final db = getIt<AppDatabase>();
  final rels = await db.relationships.getByMemoryId(noteId);
  final results = <({String sourceName, String relation, String targetName})>[];

  for (final rel in rels) {
    final source = await db.entities.getById(rel.sourceEntityId);
    final target = await db.entities.getById(rel.targetEntityId);
    if (source != null && target != null) {
      results.add((
        sourceName: source.name,
        relation: rel.relation,
        targetName: target.name,
      ));
    }
  }
  return results;
});

final noteTasksProvider = FutureProvider.family.autoDispose<List<TasksTableData>, String>((ref, noteId) async {
  final db = getIt<AppDatabase>();
  return await db.tasks.getByMemoryId(noteId);
});
