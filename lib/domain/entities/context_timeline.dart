import 'package:intl/intl.dart';

/// Semantic classification of timeline items.
enum TimelineItemType {
  note,
  task,
  event,
  relationship,
  contextEvolution,
  milestone,
}

/// A discrete chronological item on a context timeline.
class TimelineItem implements Comparable<TimelineItem> {
  const TimelineItem({
    required this.id,
    required this.timestamp,
    required this.type,
    required this.title,
    required this.description,
    this.contextId,
    this.contextName,
    this.isCompleted,
    this.dueDate,
    this.entities = const [],
    this.metadata = const {},
  });

  final String id;
  final DateTime timestamp;
  final TimelineItemType type;
  final String title;
  final String description;
  final String? contextId;
  final String? contextName;
  final bool? isCompleted;
  final String? dueDate;
  final List<String> entities;
  final Map<String, dynamic> metadata;

  @override
  int compareTo(TimelineItem other) => timestamp.compareTo(other.timestamp);

  String get formattedDate => DateFormat('MMM d, yyyy').format(timestamp);
  String get formattedShortDate => DateFormat('MMM d').format(timestamp);
  String get formattedTime => DateFormat('h:mm a').format(timestamp);

  @override
  String toString() =>
      'TimelineItem(date: $formattedShortDate, type: ${type.name}, title: $title)';
}

/// Chronologically ordered timeline representing the evolution of a context, topic, or entity.
class ContextTimeline {
  const ContextTimeline({
    required this.contextName,
    required this.items,
    this.contextId,
    this.contextPath,
    this.summary,
  });

  final String? contextId;
  final String contextName;
  final String? contextPath;
  final List<TimelineItem> items;
  final String? summary;

  int get totalItems => items.length;

  int get pendingTasksCount =>
      items.where((i) => i.type == TimelineItemType.task && i.isCompleted == false).length;

  int get completedTasksCount =>
      items.where((i) => i.type == TimelineItemType.task && i.isCompleted == true).length;

  DateTime? get earliestDate => items.isEmpty ? null : items.first.timestamp;
  DateTime? get latestDate => items.isEmpty ? null : items.last.timestamp;

  /// Returns a clean, human-readable ASCII timeline tree.
  String toTreeString() {
    if (items.isEmpty) {
      return '$contextName\n└── (No timeline events recorded)';
    }

    final buffer = StringBuffer();
    buffer.writeln(contextName);
    buffer.writeln('│');

    // Group by short date
    final grouped = <String, List<TimelineItem>>{};
    for (final item in items) {
      grouped.putIfAbsent(item.formattedShortDate, () => []).add(item);
    }

    final dateKeys = grouped.keys.toList();
    for (int i = 0; i < dateKeys.length; i++) {
      final isLast = (i == dateKeys.length - 1);
      final dateKey = dateKeys[i];
      final dayItems = grouped[dateKey]!;

      buffer.writeln('${isLast ? '└──' : '├──'} $dateKey');
      for (final item in dayItems) {
        final prefix = isLast ? '    ' : '│   ';
        final statusSuffix = item.isCompleted != null
            ? (item.isCompleted! ? ' [Done]' : ' [Pending]')
            : '';
        buffer.writeln('$prefix${item.title}$statusSuffix');
      }
      if (!isLast) {
        buffer.writeln('│');
      }
    }

    return buffer.toString();
  }
}
