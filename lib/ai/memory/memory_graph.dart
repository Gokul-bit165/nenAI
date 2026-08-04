import '../../domain/entities/note.dart';

class MemoryEntity {
  const MemoryEntity({
    required this.name,
    required this.type, // 'date', 'tag', 'topic'
  });

  final String name;
  final String type;
}

class MemoryGraph {
  const MemoryGraph();

  /// Extracts lightweight entities (dates, tags, topics) from notes to enable graph filtering.
  List<MemoryEntity> extractEntities(Note note) {
    final entities = <MemoryEntity>[];

    // Tags / Keywords
    for (final kw in note.keywords) {
      entities.add(MemoryEntity(name: kw.toLowerCase(), type: 'tag'));
    }

    // Relative & Date references
    final dateRegex = RegExp(r'\b(january|february|march|april|may|june|july|august|september|october|november|december|monday|tuesday|wednesday|thursday|friday|saturday|sunday|today|yesterday|tomorrow)\b', caseSensitive: false);
    final matches = dateRegex.allMatches(note.content);
    for (final m in matches) {
      entities.add(MemoryEntity(name: m.group(0)!.toLowerCase(), type: 'date'));
    }

    return entities;
  }
}
