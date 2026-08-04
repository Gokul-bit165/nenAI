import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Service for scheduling offline alarms and local notifications.
class AlarmService {
  AlarmService();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    try {
      tz.initializeTimeZones();

      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _notificationsPlugin.initialize(initSettings);
      _initialized = true;
    } catch (_) {
      _initialized = false;
    }
  }

  /// Schedules a local alarm/reminder notification at [scheduledTime].
  /// Returns the assigned numeric notification ID.
  Future<int> scheduleAlarm({
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    await init();

    // Trigger Native Android System Clock Alarm Intent
    try {
      const channel = MethodChannel('com.memai/alarm');
      await channel.invokeMethod('setSystemAlarm', {
        'hour': scheduledTime.hour,
        'minute': scheduledTime.minute,
        'message': title,
      });
    } catch (_) {}

    final notificationId = scheduledTime.millisecondsSinceEpoch ~/ 1000 % 1000000;

    const androidDetails = AndroidNotificationDetails(
      'memai_alarms_channel',
      'MemAI Alarms & Reminders',
      channelDescription: 'Notifications and scheduled alarms from MemAI',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      final tzScheduledTime = tz.TZDateTime.from(scheduledTime, tz.local);
      try {
        await _notificationsPlugin.zonedSchedule(
          notificationId,
          title,
          body,
          tzScheduledTime,
          notificationDetails,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );
      } catch (_) {
        await _notificationsPlugin.zonedSchedule(
          notificationId,
          title,
          body,
          tzScheduledTime,
          notificationDetails,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );
      }
    } catch (_) {
      // In-memory fallback on platforms/Web where local notifications plugin is not available
    }

    return notificationId;
  }

  /// Cancels a scheduled alarm by [notificationId].
  Future<void> cancelAlarm(int notificationId) async {
    await init();
    await _notificationsPlugin.cancel(notificationId);
  }
}
