import 'package:flutter/material.dart';

class LevelManager {
  LevelManager._();

  /// Returns a German level title for the given level
  static String levelTitle(int level) {
    if (level >= 50) return 'Griffbrett-Meister';
    if (level >= 30) return 'Solo-Anwärter';
    if (level >= 20) return 'Power-Chord-Kämpfer';
    if (level >= 10) return 'Akkord-Entdecker';
    if (level >= 5) return 'Riff-Lehrling';
    return 'Gitarren-Neuling';
  }

  /// Returns the level range description
  static String levelRangeDescription(int level) {
    if (level >= 50) return 'Level 50+';
    if (level >= 30) return 'Level 30–49';
    if (level >= 20) return 'Level 20–29';
    if (level >= 10) return 'Level 10–19';
    if (level >= 5) return 'Level 5–9';
    return 'Level 1–4';
  }

  /// Returns the badge color for a given level
  static Color levelBadgeColor(int level) {
    if (level >= 50) return const Color(0xFF9C27B0); // Purple - Master
    if (level >= 30) return const Color(0xFF00B4D8); // Diamond Blue
    if (level >= 20) return const Color(0xFFFFD700); // Gold
    if (level >= 10) return const Color(0xFFC0C0C0); // Silver
    if (level >= 5) return const Color(0xFFCD7F32);  // Bronze
    return const Color(0xFF737373); // Gray - Beginner
  }

  /// Returns the badge gradient for a given level
  static List<Color> levelBadgeGradient(int level) {
    if (level >= 50) {
      return [const Color(0xFF9C27B0), const Color(0xFF673AB7)];
    }
    if (level >= 30) {
      return [const Color(0xFF00B4D8), const Color(0xFF0077B6)];
    }
    if (level >= 20) {
      return [const Color(0xFFFFD700), const Color(0xFFFF8C00)];
    }
    if (level >= 10) {
      return [const Color(0xFFC0C0C0), const Color(0xFF808080)];
    }
    if (level >= 5) {
      return [const Color(0xFFCD7F32), const Color(0xFF8B4513)];
    }
    return [const Color(0xFF555555), const Color(0xFF333333)];
  }

  /// Returns features unlocked at a specific level
  static List<String> unlockedFeaturesAtLevel(int level) {
    final features = <String>[];

    switch (level) {
      case 1:
        features.addAll([
          'Grundlegende Lektionen',
          'Metronom',
          'Gitarren-Tuner',
        ]);
        break;
      case 3:
        features.add('Fortschritts-Dashboard');
        break;
      case 5:
        features.addAll([
          'Übungsaufnahmen',
          'Gehörtraining-Modus',
        ]);
        break;
      case 8:
        features.add('Erweiterte Statistiken');
        break;
      case 10:
        features.addAll([
          'Lied-Bibliothek',
          'Benutzerdefinierte Übungen',
        ]);
        break;
      case 15:
        features.add('Community-Features');
        break;
      case 20:
        features.addAll([
          'Fortgeschrittene Theorie-Module',
          'Tonarten-Transposer',
        ]);
        break;
      case 25:
        features.add('Eigene Akkorddiagramme erstellen');
        break;
      case 30:
        features.addAll([
          'Kompositions-Werkzeuge',
          'Loopmacher',
        ]);
        break;
      case 40:
        features.add('Professionelle Aufnahme-Einstellungen');
        break;
      case 50:
        features.addAll([
          'Meister-Modus',
          'Alle Premium-Inhalte',
          'Mentor-Badge',
        ]);
        break;
    }

    return features;
  }

  /// Returns a motivational message for reaching a level
  static String levelUpMessage(int level) {
    if (level >= 50) {
      return 'Du bist ein Gitarren-Meister! Unglaubliche Leistung!';
    }
    if (level >= 30) {
      return 'Beeindruckend! Du spielst wie ein Profi!';
    }
    if (level >= 20) {
      return 'Fantastisch! Dein Können wächst rasant!';
    }
    if (level >= 10) {
      return 'Großartig! Du hast die Grundlagen gemeistert!';
    }
    if (level >= 5) {
      return 'Gut gemacht! Du machst schnelle Fortschritte!';
    }
    return 'Willkommen! Deine Gitarren-Reise beginnt!';
  }

  /// Returns the level icon emoji
  static String levelIcon(int level) {
    if (level >= 50) return '👑';
    if (level >= 30) return '💎';
    if (level >= 20) return '⭐';
    if (level >= 10) return '🎸';
    if (level >= 5) return '🎵';
    return '🎯';
  }

  /// Returns the XP required for the next title (level threshold)
  static int xpForNextTitle(int currentLevel) {
    if (currentLevel < 5) return _xpForLevel(5);
    if (currentLevel < 10) return _xpForLevel(10);
    if (currentLevel < 20) return _xpForLevel(20);
    if (currentLevel < 30) return _xpForLevel(30);
    if (currentLevel < 50) return _xpForLevel(50);
    return _xpForLevel(currentLevel + 10);
  }

  static int _xpForLevel(int level) => (level * level) * 100;
}
