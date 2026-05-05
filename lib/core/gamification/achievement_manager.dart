import '../models/achievement.dart';
import '../models/user_profile.dart';
import '../models/practice_session.dart';

typedef AchievementCondition = bool Function(
    UserProfile profile, PracticeSession? session);

class AchievementManager {
  AchievementManager._();

  /// Map of achievement key → condition function
  static final Map<String, AchievementCondition> _conditions = {
    AchievementRegistry.firstNote: (profile, session) =>
        profile.completedLessonIds.isNotEmpty,

    AchievementRegistry.firstChord: (profile, session) =>
        profile.completedLessonIds.length >= 2,

    AchievementRegistry.powerRocker: (profile, session) =>
        profile.completedModuleIds.contains('module-02'),

    AchievementRegistry.songDebut: (profile, session) =>
        profile.totalLessonsCompleted >= 5,

    AchievementRegistry.nightOwl: (profile, session) {
      if (session == null) return false;
      return session.startTime.hour >= 22;
    },

    AchievementRegistry.earlyBird: (profile, session) {
      if (session == null) return false;
      return session.startTime.hour >= 5 && session.startTime.hour < 8;
    },

    AchievementRegistry.overdriveUnlocked: (profile, session) =>
        profile.unlockedPresets.contains('overdrive'),

    AchievementRegistry.distortionBeast: (profile, session) =>
        profile.unlockedPresets.contains('distortion'),

    AchievementRegistry.highGainHero: (profile, session) =>
        profile.unlockedPresets.contains('highGain'),

    AchievementRegistry.pentatonicMaster: (profile, session) =>
        profile.completedModuleIds.contains('module-04'),

    AchievementRegistry.streak7: (profile, session) =>
        profile.currentStreak >= 7,

    AchievementRegistry.streak30: (profile, session) =>
        profile.currentStreak >= 30,

    AchievementRegistry.streak100: (profile, session) =>
        profile.currentStreak >= 100,

    AchievementRegistry.streak365: (profile, session) =>
        profile.currentStreak >= 365,

    AchievementRegistry.barreConqueror: (profile, session) =>
        profile.completedModuleIds.contains('module-05'),

    AchievementRegistry.earMaster: (profile, session) =>
        profile.completedModuleIds.contains('module-11'),

    AchievementRegistry.theoryScholar: (profile, session) =>
        profile.completedModuleIds.length >= 10,

    AchievementRegistry.moduleComplete1: (profile, session) =>
        profile.completedModuleIds.contains('module-01'),

    AchievementRegistry.moduleComplete6: (profile, session) =>
        profile.completedModuleIds.length >= 6,

    AchievementRegistry.moduleComplete12: (profile, session) =>
        profile.totalModulesCompleted >= 12,

    AchievementRegistry.perfectLesson: (profile, session) {
      if (session == null) return false;
      return session.averageAccuracy >= 0.98;
    },

    AchievementRegistry.tenLessons: (profile, session) =>
        profile.totalLessonsCompleted >= 10,

    AchievementRegistry.fiftyLessons: (profile, session) =>
        profile.totalLessonsCompleted >= 50,

    AchievementRegistry.hundredLessons: (profile, session) =>
        profile.totalLessonsCompleted >= 100,

    AchievementRegistry.level5: (profile, session) => profile.level >= 5,

    AchievementRegistry.level10: (profile, session) => profile.level >= 10,

    AchievementRegistry.level25: (profile, session) => profile.level >= 25,

    AchievementRegistry.level50: (profile, session) => profile.level >= 50,

    AchievementRegistry.oneHourPractice: (profile, session) =>
        profile.totalPracticeMinutes >= 60,

    AchievementRegistry.tenHoursPractice: (profile, session) =>
        profile.totalPracticeMinutes >= 600,

    AchievementRegistry.hundredHoursPractice: (profile, session) =>
        profile.totalPracticeMinutes >= 6000,

    AchievementRegistry.allPresetsUnlocked: (profile, session) =>
        profile.unlockedPresets.contains('clean') &&
        profile.unlockedPresets.contains('overdrive') &&
        profile.unlockedPresets.contains('distortion') &&
        profile.unlockedPresets.contains('highGain'),

    AchievementRegistry.lateNightJam: (profile, session) {
      if (session == null) return false;
      return session.startTime.hour == 0 ||
          session.startTime.hour == 1 ||
          session.startTime.hour == 2 ||
          session.startTime.hour == 3;
    },

    AchievementRegistry.morningPractice: (profile, session) {
      if (session == null) return false;
      return session.startTime.hour < 7;
    },

    AchievementRegistry.metalGod: (profile, session) {
      if (session == null) return false;
      return profile.completedModuleIds.contains('module-10') &&
          session.averageAccuracy >= 0.98;
    },

    AchievementRegistry.speedDemon: (profile, session) => false, // Triggered externally

    AchievementRegistry.recordingArtist: (profile, session) => false, // Tracked externally

    AchievementRegistry.firstRecording: (profile, session) {
      if (session == null) return false;
      return session.wasRecorded;
    },

    AchievementRegistry.bluetoothConnected: (profile, session) => false, // Triggered externally

    AchievementRegistry.xmariConnected: (profile, session) => false, // Triggered externally

    AchievementRegistry.tunerPro: (profile, session) => false, // Tracked externally

    AchievementRegistry.metronomeMaster: (profile, session) => false, // Tracked externally

    AchievementRegistry.weekendWarrior: (profile, session) => false, // Complex tracking

    AchievementRegistry.firstFeedback: (profile, session) => false, // Triggered externally

    AchievementRegistry.secretRiff: (profile, session) => false, // Triggered externally

    AchievementRegistry.openChordMaster: (profile, session) =>
        profile.completedModuleIds.contains('module-03'),

    AchievementRegistry.powerChordPerfect: (profile, session) {
      if (session == null) return false;
      return profile.completedModuleIds.contains('module-02') &&
          session.averageAccuracy >= 0.98;
    },

    AchievementRegistry.bluesBend: (profile, session) =>
        profile.completedModuleIds.contains('module-06'),

    AchievementRegistry.tenRecordings: (profile, session) => false, // Tracked externally

    AchievementRegistry.pentatonicMaster: (profile, session) =>
        profile.completedModuleIds.contains('module-04') &&
        profile.completedModuleIds.contains('module-09'),

    AchievementRegistry.dailyDedication: (profile, session) =>
        profile.longestStreak >= 7,
  };

  /// Checks a single achievement and returns it if newly unlocked
  static Achievement? checkAndUnlock(
    String key,
    UserProfile profile, {
    PracticeSession? session,
  }) {
    // Already unlocked
    if (profile.unlockedAchievements.contains(key)) return null;

    final condition = _conditions[key];
    if (condition == null) return null;

    if (condition(profile, session)) {
      return AchievementRegistry.findByKey(key);
    }

    return null;
  }

  /// Checks all achievements and returns newly unlocked ones
  static List<Achievement> checkAllAchievements(
    UserProfile profile, {
    PracticeSession? session,
  }) {
    final newlyUnlocked = <Achievement>[];

    for (final key in _conditions.keys) {
      if (profile.unlockedAchievements.contains(key)) continue;

      final condition = _conditions[key];
      if (condition == null) continue;

      if (condition(profile, session)) {
        final achievement = AchievementRegistry.findByKey(key);
        if (achievement != null) {
          newlyUnlocked.add(achievement);
        }
      }
    }

    return newlyUnlocked;
  }

  /// Manually triggers an achievement (for external events like Bluetooth connect)
  static Achievement? triggerAchievement(
    String key,
    UserProfile profile,
  ) {
    if (profile.unlockedAchievements.contains(key)) return null;
    return AchievementRegistry.findByKey(key);
  }

  /// Returns all achievements grouped by category
  static Map<String, List<Achievement>> groupedAchievements(
      List<String> unlockedKeys) {
    final all = AchievementRegistry.allAchievements;

    return {
      'Erste Schritte': all
          .where((a) => [
                AchievementRegistry.firstNote,
                AchievementRegistry.firstChord,
                AchievementRegistry.firstRecording,
              ].contains(a.key))
          .map((a) => unlockedKeys.contains(a.key)
              ? a.copyWith(unlockedAt: DateTime.now())
              : a)
          .toList(),
      'Module': all
          .where((a) => a.key.startsWith('module_complete'))
          .map((a) => unlockedKeys.contains(a.key)
              ? a.copyWith(unlockedAt: DateTime.now())
              : a)
          .toList(),
      'Streaks': all
          .where((a) => a.key.startsWith('streak_') || a.key == AchievementRegistry.weekendWarrior || a.key == AchievementRegistry.dailyDedication)
          .map((a) => unlockedKeys.contains(a.key)
              ? a.copyWith(unlockedAt: DateTime.now())
              : a)
          .toList(),
      'Level': all
          .where((a) => a.key.startsWith('level_'))
          .map((a) => unlockedKeys.contains(a.key)
              ? a.copyWith(unlockedAt: DateTime.now())
              : a)
          .toList(),
      'Geheimnis': all
          .where((a) => a.isSecret)
          .map((a) => unlockedKeys.contains(a.key)
              ? a.copyWith(unlockedAt: DateTime.now())
              : a)
          .toList(),
    };
  }
}
