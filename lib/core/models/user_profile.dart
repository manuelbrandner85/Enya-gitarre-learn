import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id,
    @Default('') String username,
    @Default('') String email,
    @Default('') String avatarUrl,
    @Default(0) int totalXp,
    @Default(1) int level,
    @Default(0) int currentStreak,
    @Default(0) int longestStreak,
    DateTime? lastPracticeDate,
    @Default(0) int totalPracticeMinutes,
    @Default(0) int totalLessonsCompleted,
    @Default(0) int totalModulesCompleted,
    @Default([]) List<String> unlockedAchievements,
    @Default([]) List<String> unlockedPresets,
    @Default([]) List<String> completedLessonIds,
    @Default([]) List<String> completedModuleIds,
    @Default(false) bool onboardingComplete,
    @Default('standard') String preferredTuning,
    @Default(true) bool isDarkMode,
    @Default(true) bool notificationsEnabled,
    @Default(true) bool soundEffectsEnabled,
    @Default(1.0) double masterVolume,
    @Default('de') String language,
    @Default(false) bool isGuest,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);

  const UserProfile._();

  /// Creates a new guest profile
  factory UserProfile.newGuest(String id) => UserProfile(
        id: id,
        username: 'Gitarren-Neuling',
        isGuest: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

  /// Returns the level progress as a 0.0–1.0 value
  double get levelProgress {
    final level = this.level;
    final currentLevelXp = (level * level) * 100;
    final nextLevelXp = ((level + 1) * (level + 1)) * 100;
    final range = nextLevelXp - currentLevelXp;
    if (range <= 0) return 1.0;
    return ((totalXp - currentLevelXp) / range).clamp(0.0, 1.0);
  }

  /// Returns XP needed for next level
  int get xpToNextLevel {
    final nextLevelXp = ((level + 1) * (level + 1)) * 100;
    return (nextLevelXp - totalXp).clamp(0, nextLevelXp);
  }

  /// Returns true if the streak is alive (practiced today or yesterday)
  bool get isStreakAlive {
    if (lastPracticeDate == null) return false;
    final now = DateTime.now();
    final diff = now.difference(lastPracticeDate!).inDays;
    return diff <= 1;
  }

  /// Returns true if this is a completed user (not a new guest)
  bool get isProfileSetup => username.isNotEmpty && !isGuest;
}
