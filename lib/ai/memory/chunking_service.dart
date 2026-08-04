import '../../domain/entities/note.dart';

class NoteChunk {
  const NoteChunk({
    required this.id,
    required this.noteId,
    required this.content,
    required this.chunkIndex,
  });

  final String id;
  final String noteId;
  final String content;
  final int chunkIndex;
}

class ChunkingService {
  const ChunkingService();

  /// Splits [note] into semantic chunks (paragraph/sentence clusters with ~15% overlap).
  List<NoteChunk> chunkNote(Note note, {int maxChunkChars = 400, int overlapChars = 60}) {
    final text = note.content.trim();
    if (text.isEmpty) return [];

    if (text.length <= maxChunkChars) {
      return [
        NoteChunk(
          id: '${note.id}_chunk_0',
          noteId: note.id,
          content: text,
          chunkIndex: 0,
        ),
      ];
    }

    final chunks = <NoteChunk>[];
    int start = 0;
    int index = 0;

    while (start < text.length) {
      int end = start + maxChunkChars;
      if (end >= text.length) {
        end = text.length;
      } else {
        // Try to break at paragraph boundary or sentence end
        final sub = text.substring(start, end);
        final breakPos = sub.lastIndexOf(RegExp(r'[.\n!?]\s+'));
        if (breakPos > 100) {
          end = start + breakPos + 1;
        }
      }

      final chunkContent = text.substring(start, end).trim();
      if (chunkContent.isNotEmpty) {
        chunks.add(
          NoteChunk(
            id: '${note.id}_chunk_$index',
            noteId: note.id,
            content: chunkContent,
            chunkIndex: index,
          ),
        );
        index++;
      }

      if (end >= text.length) break;
      start = end - overlapChars;
    }

    return chunks;
  }
}
