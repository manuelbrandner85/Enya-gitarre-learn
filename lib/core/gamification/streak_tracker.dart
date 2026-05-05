import 'package:flutter/material.dart';

enum StreakLevel {
  none,
  bronze,
  silver,
  gold,
  diamond,
}

extension StreakLevelExtension on StreakLevel {
  String get displayName {
    switch (this) {
      case StreakLevel.none:
        return 'Keine';
      case StreakLevel.bronze:
        return 'Bronze';
      case StreakLevel.silver:
        return 'Silber';
      case StreakLevel.gold:
        return 'Gold';
      case StreakLevel.diamond:
        return 'Diamant';
    }
  }

  Color get color {
    switch (this) {
      case StreakLevel.none:
        return const Color(0xFF737373);
      case StreakLevel.bronze:
        return const Color(0xFFCD7F32);
      case StreakLevel.silver:
        return const Color(0xFFC0C0C0);
      case StreakLevel.gold:
        return const Color(0xFFFFD700);
      case StreakLevel.diamond:
        return const Color(0xFF00B4D8);
    }
  }

  String get emoji {
    switch (this) {
      case StreakLevel.none:
        return '🔥';
      case StreakLevel.bronze:
        return '🥉';
      case StreakLevel.silver:
        return '🥈';
      case StreakLevel.gold:
        return '🥇';
      case StreakLevel.diamond:
        return '💎';
    }
  }

  int get minDays {
    switch (this) {
      case StreakLevel.none:
        return 0;
      case StreakLevel.bronze:
        return 7;
      case StreakLevel.silver:
        return 30;
      case StreakLevel.gold:
        return 100;
      case StreakLevel.diamond:
        return 365;
    }
  }
}

class StreakTracker {
  int _currentStreak;
  int _longestStreak;
  DateTime? _lastPracticeDate;
  bool _hasStreakFreeze;
  int _availableStreakFreezes;

  StreakTracker({
    int currentStreak = 0,
    int longestStreak = 0,
    DateTime? lastPracticeDate,
    int availableStreakFreezes = 0,
  })  : _currentStreak = currentStreak,
        _longestStreak = longestStreak,
        _lastPracticeDate = lastPracticeDate,
        _hasStreakFreeze = availableStreakFreezes > 0,
        _availableStreakFreezes = availableStreakFreezes;

  int get currentStreak => _currentStreak;
  int get longestStreak => _longestStreak;
  DateTime? get lastPracticeDate => _lastPracticeDate;
  int get availableStreakFreezes => _availableStreakFreezes;

  /// Returns true if the streak is still alive
  bool get isStreakAlive => isStreakAliveAt(DateTime.now());

  bool isStreakAliveAt(DateTime now) {
    if (_lastPracticeDate == null) return false;
    final diff = now.difference(_lastPracticeDate!).inDays;
    return diff <= 1;
  }

  /// Returns the current streak level based on days
  StreakLevel get streakLevel => levelForDays(_currentStreak);

  /// Returns the streak level for a given number of days
  static StreakLevel levelForDays(int days) {
    if (days >= 365) return StreakLevel.diamond;
    if (days >= 100) return StreakLevel.gold;
    if (days >= 30) return StreakLevel.silver;
    if (days >= 7) return StreakLevel.bronze;
    return StreakLevel.none;
  }

  /// Returns the next streak milestone
  int get nextMilestone {
    if (_currentStreak < 7) return 7;
    if (_currentStreak < 30) return 30;
    if (_currentStreak < 100) return 100;
    if (_currentStreak < 365) return 365;
    return _currentStreak + 100;
  }

  /// Increments the streak if applicable
  /// Returns true if streak was incremented, false if already practiced today
  bool incrementStreak() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (_lastPracticeDate != null) {
      final lastDay = DateTime(
        _lastPracticeDate!.year,
        _lastPracticeDate!.month,
        _lastPracticeDate!.day,
      );

      if (lastDay == today) {
        // Already practiced today, no increment
        return false;
      }

      final daysDiff = today.difference(lastDay).inDays;

      if (daysDiff == 1) {
        // Consecutive day - increment streak
        _currentStreak++;
      } else if (daysDiff > 1) {
        // Streak broken - check for freeze
        if (!checkStreakFreeze()) {
          _currentStreak = 1;
        }
      }
    } else {
      // First time practicing
      _currentStreak = 1;
    }

    _lastPracticeDate = now;

    if (_currentStreak > _longestStreak) {
      _longestStreak = _currentStreak;
    }

    return true;
  }

  /// Checks if a streak freeze can save the streak
  /// Returns true if the streak was saved by a freeze
  bool checkStreakFreeze() {
    if (_availableStreakFreezes > 0) {
      _availableStreakFreezes--;
      _hasStreakFreeze = _availableStreakFreezes > 0;
      // Don't reset streak, just use the freeze
      return true;
    }
    return false;
  }

  /// Adds a streak freeze (e.g., earned through achievements or purchase)
  void addStreakFreeze() {
    _availableStreakFreezes++;
    _hasStreakFreeze = true;
  }

  /// Returns true if the streak is still alive based on a given last practice date.
  static bool checkAlive(DateTime lastPractice) {
    final now = DateTime.now();
    final diff = now.difference(lastPractice).inDays;
    return diff <= 1;
  }

  /// Returns the days until streak would expire
  int get daysUntilExpiry {
    if (_lastPracticeDate == null) return 0;
    final now = DateTime.now();
    final diff = now.difference(_lastPracticeDate!).inHours;
    if (diff >= 48) return 0;
    return ((48 - diff) / 24).ceil();
  }

  /// Resets the streak to 0
  void resetStreak() {
    _currentStreak = 0;
  }

  @override
  String toString() =>
      'StreakTracker(current: $_currentStreak, longest: $_longestStreak, level: ${streakLevel.displayName})';
}
