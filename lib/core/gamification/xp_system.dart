import 'dart:math' as math;

import '../utils/constants.dart';

class XpSystem {
  XpSystem._();

  // XP event values
  static const int dailyLogin = AppConstants.xpDailyLogin;
  static const int lessonComplete = AppConstants.xpLessonComplete;
  static const int perfectAccuracy = AppConstants.xpPerfectAccuracy;
  static const int firstTry = AppConstants.xpFirstTry;
  static const int songMastered = AppConstants.xpSongMastered;
  static const int achievementUnlocked = AppConstants.xpAchievementUnlocked;
  static const int streakBonus = AppConstants.xpStreakBonus;
  static const int streakMilestone7 = AppConstants.xpStreakMilestone7;
  static const int streakMilestone30 = AppConstants.xpStreakMilestone30;
  static const int streakMilestone100 = AppConstants.xpStreakMilestone100;
  static const int moduleComplete = AppConstants.xpModuleComplete;
  static const int newChordLearned = AppConstants.xpNewChordLearned;
  static const int newScaleLearned = AppConstants.xpNewScaleLearned;
  static const int practiceSession = AppConstants.xpPracticeSession;
  static const int recordingMade = AppConstants.xpRecordingMade;
  static const int earTrainingCorrect = AppConstants.xpEarTrainingCorrect;

  /// Calculates the level from total XP
  /// Formula: level = floor(sqrt(totalXp / 100))
  static int calculateLevel(int totalXp) {
    if (totalXp <= 0) return 1;
    return math.max(1, math.sqrt(totalXp / AppConstants.levelXpDivisor).floor());
  }

  /// Returns the total XP required to reach a specific level
  /// Inverse of calculateLevel: xp = (level^2) * 100
  static int xpForLevel(int level) {
    if (level <= 1) return 0;
    return ((level * level) * AppConstants.levelXpDivisor).round();
  }

  /// Returns the XP required to reach the next level
  static int xpToNextLevel(int totalXp) {
    final currentLevel = calculateLevel(totalXp);
    final nextLevelXp = xpForLevel(currentLevel + 1);
    return math.max(0, nextLevelXp - totalXp);
  }

  /// Returns progress (0.0–1.0) toward the next level
  static double levelProgress(int totalXp) {
    final currentLevel = calculateLevel(totalXp);
    final currentLevelXp = xpForLevel(currentLevel);
    final nextLevelXp = xpForLevel(currentLevel + 1);
    final range = nextLevelXp - currentLevelXp;
    if (range <= 0) return 1.0;
    return ((totalXp - currentLevelXp) / range).clamp(0.0, 1.0);
  }

  /// Calculates XP for completing a lesson based on difficulty and accuracy
  static int lessonXp(int difficulty, double accuracy) {
    final base = lessonComplete + (difficulty * 10);
    double multiplier = 1.0;

    if (accuracy >= 0.98) {
      multiplier = 2.0; // Perfect: double XP
    } else if (accuracy >= 0.90) {
      multiplier = 1.5; // Gold accuracy
    } else if (accuracy >= 0.75) {
      multiplier = 1.0; // Standard
    } else {
      multiplier = 0.5; // Below threshold
    }

    final bonuses = accuracy >= 0.98 ? perfectAccuracy : 0;
    return (base * multiplier).round() + bonuses;
  }

  /// Calculates XP for a practice session based on duration
  static int sessionXp(int durationSeconds) {
    final minutes = durationSeconds / 60;
    // 10 XP per 5 minutes, up to 60 minutes
    return (math.min(minutes, 60) / 5 * practiceSession).round();
  }

  /// Calculates streak bonus XP
  static int streakDayBonusXp(int currentStreak) {
    if (currentStreak >= 365) return streakBonus * 10;
    if (currentStreak >= 100) return streakBonus * 5;
    if (currentStreak >= 30) return streakBonus * 3;
    if (currentStreak >= 7) return streakBonus * 2;
    return streakBonus;
  }

  /// Returns the milestone XP bonus for a streak
  static int streakMilestoneXp(int streak) {
    if (streak == 365) return 2000;
    if (streak == 100) return streakMilestone100;
    if (streak == 30) return streakMilestone30;
    if (streak == 7) return streakMilestone7;
    return 0;
  }

  /// Returns the XP badge color name for a given XP total
  static String xpTierName(int totalXp) {
    if (totalXp >= 50000) return 'Diamant';
    if (totalXp >= 20000) return 'Platin';
    if (totalXp >= 10000) return 'Gold';
    if (totalXp >= 5000) return 'Silber';
    if (totalXp >= 1000) return 'Bronze';
    return 'Beginner';
  }
}
