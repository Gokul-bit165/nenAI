import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../domain/entities/note.dart';
import '../../../domain/entities/processing_status.dart';
import '../../../domain/usecases/create_note.dart';
import '../../../domain/usecases/update_note.dart';
import '../../../domain/repositories/note_repository.dart';
import '../../../background/note_processing_isolate.dart';
import '../../../injection.dart';

final noteEditorProvider = StateNotifierProvider.family.autoDispose<NoteEditorNotifier, NoteEditorState, String?>(
  (ref, existingNoteId) => NoteEditorNotifier(existingNoteId),
);

class NoteEditorState {
  const NoteEditorState({
    required this.content,
    this.isSaving = false,
    this.savedNoteId,
    this.existingNote,
  });

  final String content;
  final bool isSaving;
  final String? savedNoteId;
  final Note? existingNote;

  NoteEditorState copyWith({
    String? content,
    bool? isSaving,
    String? savedNoteId,
    Note? existingNote,
  }) {
    return NoteEditorState(
      content: content ?? this.content,
      isSaving: isSaving ?? this.isSaving,
      savedNoteId: savedNoteId ?? this.savedNoteId,
      existingNote: existingNote ?? this.existingNote,
    );
  }
}

class NoteEditorNotifier extends StateNotifier<NoteEditorState> {
  NoteEditorNotifier(this.existingNoteId) : super(const NoteEditorState(content: '')) {
    if (existingNoteId != null) {
      _loadExistingNote(existingNoteId!);
    }
  }

  final String? existingNoteId;

  Future<void> _loadExistingNote(String id) async {
    final repository = getIt<NoteRepository>();
    final note = await repository.getNoteById(id);
    if (note != null) {
      state = state.copyWith(content: note.content, existingNote: note);
    }
  }

  void updateContent(String newContent) {
    state = state.copyWith(content: newContent);
  }

  Future<String?> save() async {
    if (state.content.trim().isEmpty) return null;

    state = state.copyWith(isSaving: true);

    final createNote = getIt<CreateNoteUseCase>();
    final updateNote = getIt<UpdateNoteUseCase>();

    final now = DateTime.now();
    final noteId = state.existingNote?.id ?? const Uuid().v4();

    final note = Note(
      id: noteId,
      content: state.content.trim(),
      summary: state.existingNote?.summary,
      keywords: state.existingNote?.keywords ?? [],
      clusterId: state.existingNote?.clusterId,
      relatedNoteIds: state.existingNote?.relatedNoteIds ?? [],
      status: ProcessingStatus.pending,
      createdAt: state.existingNote?.createdAt ?? now,
      updatedAt: now,
    );

    if (state.existingNote == null) {
      await createNote(note);
    } else {
      await updateNote(note);
    }

    // Trigger immediate foreground Isolate processing (also enqueued on WorkManager for Android)
    getIt<NoteProcessingIsolate>().processNote(noteId);

    state = state.copyWith(isSaving: false, savedNoteId: noteId);
    return noteId;
  }
}
