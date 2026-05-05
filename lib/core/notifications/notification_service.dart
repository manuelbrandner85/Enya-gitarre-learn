import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static const int _streakReminderId = 1;
  static const String _channelId = 'practice_reminders';
  static const String _channelName = 'Übungs-Erinnerungen';
  static const String _channelDesc = 'Tägliche Erinnerungen zum Gitarre spielen';

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    try {
      tz.initializeTimeZones();

      const android = AndroidInitializationSettings('@mipmap/ic_launcher');
      const ios = DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      );
      await _plugin.initialize(
        const InitializationSettings(android: android, iOS: ios),
      );
      _initialized = true;
    } catch (e) {
      debugPrint('NotificationService.initialize error: $e');
    }
  }

  Future<bool> requestPermission() async {
    try {
      final android = _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      if (android != null) {
        return await android.requestNotificationsPermission() ?? false;
      }
      final ios = _plugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>();
      if (ios != null) {
        return await ios.requestPermissions(
              alert: true,
              badge: true,
              sound: true,
            ) ??
            false;
      }
      return true;
    } catch (e) {
      debugPrint('NotificationService.requestPermission error: $e');
      return false;
    }
  }

  /// Schedules a daily streak reminder at [hour]:[minute] (24h, local time).
  Future<void> scheduleStreakReminder({int hour = 19, int minute = 0}) async {
    if (!_initialized) await initialize();
    try {
      await cancelStreakReminder();

      final now = tz.TZDateTime.now(tz.local);
      var scheduledDate =
          tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      const androidDetails = AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDesc,
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
        icon: '@mipmap/ic_launcher',
      );
      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );
      const details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _plugin.zonedSchedule(
        _streakReminderId,
        '🎸 Zeit zum Üben!',
        'Vergiss nicht, heute Gitarre zu spielen und deinen Streak aufrechtzuerhalten.',
        scheduledDate,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
      debugPrint('NotificationService: streak reminder scheduled at $hour:$minute');
    } catch (e) {
      debugPrint('NotificationService.scheduleStreakReminder error: $e');
    }
  }

  Future<void> cancelStreakReminder() async {
    if (!_initialized) await initialize();
    try {
      await _plugin.cancel(_streakReminderId);
    } catch (e) {
      debugPrint('NotificationService.cancelStreakReminder error: $e');
    }
  }

  Future<void> cancelAll() async {
    if (!_initialized) await initialize();
    try {
      await _plugin.cancelAll();
    } catch (e) {
      debugPrint('NotificationService.cancelAll error: $e');
    }
  }

  /// Shows an immediate notification (e.g. after completing a module).
  Future<void> showAchievementNotification({
    required String title,
    required String body,
  }) async {
    if (!_initialized) await initialize();
    try {
      const androidDetails = AndroidNotificationDetails(
        'achievements',
        'Erfolge',
        channelDescription: 'Benachrichtigungen für neue Achievements',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      );
      const details = NotificationDetails(
        android: androidDetails,
        iOS: DarwinNotificationDetails(presentAlert: true, presentSound: true),
      );
      await _plugin.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title,
        body,
        details,
      );
    } catch (e) {
      debugPrint('NotificationService.showAchievementNotification error: $e');
    }
  }
}
