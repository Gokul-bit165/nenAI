import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/calendar_service.dart';
import '../../../injection.dart';

class CalendarState {
  const CalendarState({
    required this.selectedDate,
    this.events = const [],
    this.isLoading = false,
  });

  final DateTime selectedDate;
  final List<CalendarEvent> events;
  final bool isLoading;

  CalendarState copyWith({
    DateTime? selectedDate,
    List<CalendarEvent>? events,
    bool? isLoading,
  }) {
    return CalendarState(
      selectedDate: selectedDate ?? this.selectedDate,
      events: events ?? this.events,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

final calendarNotifierProvider = StateNotifierProvider.autoDispose<CalendarNotifier, CalendarState>((ref) {
  return CalendarNotifier();
});

class CalendarNotifier extends StateNotifier<CalendarState> {
  CalendarNotifier() : super(CalendarState(selectedDate: DateTime.now())) {
    loadEventsForDate(state.selectedDate);
  }

  void selectDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
    loadEventsForDate(date);
  }

  void loadEventsForDate(DateTime date) {
    final service = getIt<CalendarService>();
    final events = service.getEventsForDate(date);
    state = state.copyWith(events: events);
  }

  Future<void> addEvent({
    required String title,
    required DateTime startTime,
  }) async {
    final service = getIt<CalendarService>();
    await service.createEvent(title: title, startTime: startTime);
    loadEventsForDate(state.selectedDate);
  }
}
