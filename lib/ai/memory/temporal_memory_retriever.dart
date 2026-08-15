import '../../data/local/database/daos/tasks_dao.dart';
import '../../domain/entities/note.dart';
import '../../domain/repositories/context_repository.dart';
import '../../domain/repositories/note_repository.dart';

/// Temporal retrieval scope for date-based memory queries.
enum TemporalScope { today, yesterday, thisWeek, thisMonth }

/// Lightweight task summary — avoids dependency on Drift-generated types.
class TaskSummary {
  const TaskSummary({
    required this.id,
    required this.memoryId,
    required this.description,
    this.dueDate,
  });
  final String id;
  final String memoryId;
  final String description;
  final String? dueDate;
}

/// Structured result of a temporal memory query.
class TemporalSummary {
  const TemporalSummary({
    required this.scopeLabel,
    required this.byContext,
    required this.uncontextualizedNotes,
    required this.pendingTasks,
    required this.highlights,
    required this.noteCount,
  });

  /// Human-readable scope label, e.g. "Today, Aug 15"
  final String scopeLabel;

  /// Notes grouped by context name: {"ReadSmart AI": [Note...], "General": [...]}
  final Map<String, List<Note>> byContext;

  /// Notes that are not linked to any context
  final List<Note> uncontextualizedNotes;

  /// Pending tasks due in or created in this scope
  final List<TaskSummary> pendingTasks;

  /// Auto-generated summary bullet points
  final List<String> highlights;

  final int noteCount;

  bool get isEmpty => noteCount == 0 && pendingTasks.isEmpty;

  /// Renders the summary as a formatted response string.
  String toResponseString() {
    if (isEmpty) {
      return 'Nothing recorded in your memory for $scopeLabel.';
    }

    final buffer = StringBuffer();
    buffer.writeln('**$scopeLabel** � $noteCount note${noteCount == 1 ? '' : 's'} recorded\n');

    if (byContext.isNotEmpty) {
      for (final entry in byContext.entries) {
        buffer.writeln('**${entry.key}** (${entry.value.length} note${entry.value.length == 1 ? '' : 's'}):');
        for (final note in entry.value) {
          final summary = note.summary?.isNotEmpty == true
              ? note.summary!
              : (note.content.length > 80
                  ? '${note.content.substring(0, 77)}...'
                  : note.content);
          buffer.writeln('  � $summary');
        }
        buffer.writeln();
      }
    }

    if (uncontextualizedNotes.isNotEmpty) {
      buffer.writeln('**Other notes:**');
      for (final note in uncontextualizedNotes) {
        final summary = note.summary?.isNotEmpty == true
            ? note.summary!
            : (note.content.length > 80
                ? '${note.content.substring(0, 77)}...'
                : note.content);
        buffer.writeln('  � $summary');
      }
      buffer.writeln();
    }

    if (pendingTasks.isNotEmpty) {
      buffer.writeln('**Pending tasks:**');
      for (final task in pendingTasks) {
        final due = task.dueDate != null ? ' (due: ${task.dueDate})' : '';
        buffer.writeln('  ☐ ${task.description}$due');
      }
    }

    return buffer.toString().trim();
  }
}

/// Retrieves notes and tasks within a specific time window.
///
/// Used for queries like "Summarize today", "What happened this week?",
/// "Show me yesterday's notes". Groups results by context for a structured view.
class TemporalMemoryRetriever {
  const TemporalMemoryRetriever({
    required NoteRepository noteRepository,
    required ContextRepository contextRepository,
    required TasksDao tasksDao,
  })  : _noteRepository = noteRepository,
        _contextRepository = contextRepository,
        _tasksDao = tasksDao;

  final NoteRepository _noteRepository;
  final ContextRepository _contextRepository;
  final TasksDao _tasksDao;

  /// Retrieves a [TemporalSummary] for the given [scope].
  Future<TemporalSummary> retrieve(
    TemporalScope scope, {
    DateTime? referenceDate,
  }) async {
    final now = referenceDate ?? DateTime.now();
    final (start, end, label) = _scopeWindow(scope, now);

    // Fetch all domain notes
    final allNotes = await _noteRepository.getAllNotes();
    final windowNotes = allNotes
        .where((n) =>
            n.createdAt.isAfter(start.subtract(const Duration(seconds: 1))) &&
            n.createdAt.isBefore(end))
        .toList();

    // Group notes by context
    final byContextName = <String, List<Note>>{};
    final uncontextualizedNotes = <Note>[];

    for (final note in windowNotes) {
      final contexts =
          await _contextRepository.getContextsForMemory(note.id);
      if (contexts.isEmpty) {
        uncontextualizedNotes.add(note);
      } else {
        for (final ctx in contexts) {
          byContextName.putIfAbsent(ctx.name, () => []).add(note);
        }
      }
    }

    // Fetch pending tasks
    final rawTasks = await _tasksDao.getPendingTasks();
    final pendingTasks = rawTasks
        .map((t) => TaskSummary(
              id: t.id,
              memoryId: t.memoryId,
              description: t.description,
              dueDate: t.dueDate,
            ))
        .toList();

    // Build highlights
    final highlights =
        _buildHighlights(byContextName, uncontextualizedNotes);

    return TemporalSummary(
      scopeLabel: label,
      byContext: byContextName,
      uncontextualizedNotes: uncontextualizedNotes,
      pendingTasks: pendingTasks,
      highlights: highlights,
      noteCount: windowNotes.length,
    );
  }

  (DateTime start, DateTime end, String label) _scopeWindow(
    TemporalScope scope,
    DateTime now,
  ) {
    const monthNames = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    switch (scope) {
      case TemporalScope.today:
        final start = DateTime(now.year, now.month, now.day);
        final end = start.add(const Duration(days: 1));
        return (start, end,
            'Today, ${monthNames[now.month - 1]} ${now.day}');

      case TemporalScope.yesterday:
        final yd = now.subtract(const Duration(days: 1));
        final start = DateTime(yd.year, yd.month, yd.day);
        final end = DateTime(now.year, now.month, now.day);
        return (start, end,
            'Yesterday, ${monthNames[yd.month - 1]} ${yd.day}');

      case TemporalScope.thisWeek:
        final startOfWeek =
            now.subtract(Duration(days: now.weekday - 1));
        final start = DateTime(
            startOfWeek.year, startOfWeek.month, startOfWeek.day);
        final end = start.add(const Duration(days: 7));
        return (start, end, 'This week');

      case TemporalScope.thisMonth:
        final start = DateTime(now.year, now.month);
        final end = DateTime(now.year, now.month + 1);
        return (start, end,
            '${monthNames[now.month - 1]} ${now.year}');
    }
  }

  List<String> _buildHighlights(
    Map<String, List<Note>> byContext,
    List<Note> uncontextualized,
  ) {
    final highlights = <String>[];
    if (byContext.isEmpty && uncontextualized.isEmpty) return highlights;

    if (byContext.isNotEmpty) {
      final topCtx = byContext.entries.reduce(
          (a, b) => a.value.length >= b.value.length ? a : b);
      highlights.add(
          'Most active: **${topCtx.key}** (${topCtx.value.length} notes)');
    }
    final total = byContext.values.fold(0, (s, l) => s + l.length) +
        uncontextualized.length;
    highlights.add('Total notes: $total');
    return highlights;
  }
}
