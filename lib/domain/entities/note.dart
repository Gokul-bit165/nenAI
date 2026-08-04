import 'processing_status.dart';

/// Clean domain entity for a note — zero framework dependencies.
///
/// AI-enriched fields ([summary], [keywords], [clusterId], [relatedNoteIds])
/// are null / empty until [status] == [ProcessingStatus.completed].
class Note {
  const Note({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.summary,
    this.keywords = const [],
    this.clusterId,
    this.relatedNoteIds = const [],
    this.status = ProcessingStatus.pending,
  });

  final String id;

  /// Raw text the user wrote.
  final String content;

  /// AI-generated 1–2 sentence summary (null until processed).
  final String? summary;

  /// AI-extracted keyword list (empty until processed).
  final List<String> keywords;

  /// ID of the auto-assigned topic cluster (null until processed).
  final String? clusterId;

  /// IDs of semantically similar notes (populated after embedding comparison).
  final List<String> relatedNoteIds;

  final ProcessingStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Derived title — first non-empty line of [content], truncated to 60 chars.
  String get title {
    final firstLine = content.split('\n').firstWhere(
          (l) => l.trim().isNotEmpty,
          orElse: () => '',
        );
    return firstLine.length > 60 ? '${firstLine.substring(0, 60)}…' : firstLine;
  }

  /// Preview snippet shown in the note list card (first ~120 chars of content).
  String get snippet {
    final trimmed = content.trim();
    return trimmed.length > 120 ? '${trimmed.substring(0, 120)}…' : trimmed;
  }

  Note copyWith({
    String? id,
    String? content,
    String? summary,
    List<String>? keywords,
    String? clusterId,
    List<String>? relatedNoteIds,
    ProcessingStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Note(
      id: id ?? this.id,
      content: content ?? this.content,
      summary: summary ?? this.summary,
      keywords: keywords ?? this.keywords,
      clusterId: clusterId ?? this.clusterId,
      relatedNoteIds: relatedNoteIds ?? this.relatedNoteIds,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Note && other.id == id);

  @override
  int get hashCode => id.hashCode;
}
