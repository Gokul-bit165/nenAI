import 'package:uuid/uuid.dart';

class CalendarEvent {
  const CalendarEvent({
    required this.id,
    required this.title,
    required this.startTime,
    required this.endTime,
    this.description = '',
    this.location = '',
  });

  final String id;
  final String title;
  final DateTime startTime;
  final DateTime endTime;
  final String description;
  final String location;
}

class CalendarService {
  CalendarService();

  final List<CalendarEvent> _events = [];

  List<CalendarEvent> getAllEvents() {
    final list = List<CalendarEvent>.from(_events);
    list.sort((a, b) => a.startTime.compareTo(b.startTime));
    return list;
  }

  List<CalendarEvent> getEventsForDate(DateTime date) {
    return _events.where((e) {
      return e.startTime.year == date.year &&
          e.startTime.month == date.month &&
          e.startTime.day == date.day;
    }).toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
  }

  Future<CalendarEvent> createEvent({
    required String title,
    required DateTime startTime,
    DateTime? endTime,
    String description = '',
    String location = '',
  }) async {
    final id = const Uuid().v4();
    final calculatedEnd = endTime ?? startTime.add(const Duration(hours: 1));

    final event = CalendarEvent(
      id: id,
      title: title,
      startTime: startTime,
      endTime: calculatedEnd,
      description: description,
      location: location,
    );

    _events.add(event);
    return event;
  }
}
