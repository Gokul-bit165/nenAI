import 'package:uuid/uuid.dart';
import '../../domain/entities/note.dart';
import '../../domain/entities/processing_status.dart';
import '../../domain/repositories/note_repository.dart';
import '../../ai/memory/hybrid_retriever.dart';
import '../tool_protocol.dart';

/// Tool for performing hybrid memory search across stored notes.
class SearchMemoriesTool implements McpTool {
  SearchMemoriesTool(this._hybridRetriever);

  final HybridRetriever _hybridRetriever;

  @override
  String get name => 'search_memories';

  @override
  String get description => 'Searches stored memory notes using hybrid semantic and keyword search.';

  @override
  PermissionLevel get permissionLevel => PermissionLevel.read;

  @override
  Map<String, String> get parametersSchema => {
        'query': 'The search phrase or question to query in memories',
      };

  @override
  Future<McpToolResult> execute(Map<String, dynamic> params) async {
    final query = params['query'] as String? ?? '';
    if (query.trim().isEmpty) {
      return const McpToolResult(
        success: false,
        resultData: {},
        userDisplayMessage: 'Search query cannot be empty.',
      );
    }

    final results = await _hybridRetriever.retrieve(query, limit: 5);
    final mappedNotes = results.map((r) => {
          'id': r.note.id,
          'content': r.note.content,
          'summary': r.note.summary,
          'keywords': r.note.keywords,
          'score': r.rrfScore,
        }).toList();

    return McpToolResult(
      success: true,
      resultData: {'memories': mappedNotes},
      userDisplayMessage: 'Found ${results.length} relevant memories.',
    );
  }
}

/// Tool for saving a new memory note.
class CreateMemoryTool implements McpTool {
  CreateMemoryTool(this._repository);

  final NoteRepository _repository;

  @override
  String get name => 'create_memory';

  @override
  String get description => 'Saves a new note or memory to local storage.';

  @override
  PermissionLevel get permissionLevel => PermissionLevel.writeSchedule;

  @override
  Map<String, String> get parametersSchema => {
        'content': 'The content of the note or memory to save',
      };

  @override
  Future<McpToolResult> execute(Map<String, dynamic> params) async {
    final content = params['content'] as String? ?? '';
    if (content.trim().isEmpty) {
      return const McpToolResult(
        success: false,
        resultData: {},
        userDisplayMessage: 'Memory content cannot be empty.',
      );
    }

    final now = DateTime.now();
    final noteId = const Uuid().v4();
    final note = Note(
      id: noteId,
      content: content.trim(),
      keywords: [],
      relatedNoteIds: [],
      status: ProcessingStatus.pending,
      createdAt: now,
      updatedAt: now,
    );

    await _repository.createNote(note);

    return McpToolResult(
      success: true,
      resultData: {'noteId': noteId, 'content': content},
      userDisplayMessage: 'Memory saved successfully.',
    );
  }
}

/// Tool for fetching memory stats and total note count.
class GetMemoryStatsTool implements McpTool {
  GetMemoryStatsTool(this._repository);

  final NoteRepository _repository;

  @override
  String get name => 'get_memory_stats';

  @override
  String get description => 'Retrieves total note counts and database stats.';

  @override
  PermissionLevel get permissionLevel => PermissionLevel.read;

  @override
  Map<String, String> get parametersSchema => {};

  @override
  Future<McpToolResult> execute(Map<String, dynamic> params) async {
    final notes = await _repository.textSearch('');
    return McpToolResult(
      success: true,
      resultData: {'totalNotes': notes.length},
      userDisplayMessage: 'You have ${notes.length} total memories stored.',
    );
  }
}
