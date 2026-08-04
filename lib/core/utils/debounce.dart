import 'dart:async';

/// A simple debounce utility for search input and autosave triggers.
class Debounce {
  Debounce({required this.duration});

  final Duration duration;
  Timer? _timer;

  /// Cancels any pending call and schedules [action] to run after [duration].
  void call(void Function() action) {
    _timer?.cancel();
    _timer = Timer(duration, action);
  }

  /// Immediately cancels any pending invocation.
  void cancel() => _timer?.cancel();

  /// Whether a call is currently pending.
  bool get isPending => _timer?.isActive ?? false;
}
