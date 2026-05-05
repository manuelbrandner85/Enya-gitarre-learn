import 'package:flutter/foundation.dart';

/// Stub notification service.
///
/// `flutter_local_notifications` is not yet added to pubspec.yaml.
/// All methods are no-ops that log their intent so callers compile and run
/// without crashing when notification code is eventually wired in.
class NotificationService {
  /// Schedules a daily streak reminder.
  ///
  /// Currently a no-op — logs intent until the notifications package is
  /// added and this implementation is completed.
  Future<void> scheduleStreakReminder() async {
    debugPrint('NotificationService: Notifications not yet configured');
  }
}
