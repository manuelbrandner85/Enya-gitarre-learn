// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserProfileImpl _$$UserProfileImplFromJson(Map<String, dynamic> json) =>
    _$UserProfileImpl(
      id: json['id'] as String,
      username: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
      avatarUrl: json['avatarUrl'] as String? ?? '',
      totalXp: (json['totalXp'] as num?)?.toInt() ?? 0,
      level: (json['level'] as num?)?.toInt() ?? 1,
      currentStreak: (json['currentStreak'] as num?)?.toInt() ?? 0,
      longestStreak: (json['longestStreak'] as num?)?.toInt() ?? 0,
      lastPracticeDate: json['lastPracticeDate'] == null
          ? null
          : DateTime.parse(json['lastPracticeDate'] as String),
      totalPracticeMinutes:
          (json['totalPracticeMinutes'] as num?)?.toInt() ?? 0,
      totalLessonsCompleted:
          (json['totalLessonsCompleted'] as num?)?.toInt() ?? 0,
      totalModulesCompleted:
          (json['totalModulesCompleted'] as num?)?.toInt() ?? 0,
      unlockedAchievements: (json['unlockedAchievements'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      unlockedPresets: (json['unlockedPresets'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      completedLessonIds: (json['completedLessonIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      completedModuleIds: (json['completedModuleIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      onboardingComplete: json['onboardingComplete'] as bool? ?? false,
      preferredTuning: json['preferredTuning'] as String? ?? 'standard',
      isDarkMode: json['isDarkMode'] as bool? ?? true,
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      soundEffectsEnabled: json['soundEffectsEnabled'] as bool? ?? true,
      masterVolume: (json['masterVolume'] as num?)?.toDouble() ?? 1.0,
      language: json['language'] as String? ?? 'de',
      isGuest: json['isGuest'] as bool? ?? false,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$UserProfileImplToJson(_$UserProfileImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'email': instance.email,
      'avatarUrl': instance.avatarUrl,
      'totalXp': instance.totalXp,
      'level': instance.level,
      'currentStreak': instance.currentStreak,
      'longestStreak': instance.longestStreak,
      'lastPracticeDate': instance.lastPracticeDate?.toIso8601String(),
      'totalPracticeMinutes': instance.totalPracticeMinutes,
      'totalLessonsCompleted': instance.totalLessonsCompleted,
      'totalModulesCompleted': instance.totalModulesCompleted,
      'unlockedAchievements': instance.unlockedAchievements,
      'unlockedPresets': instance.unlockedPresets,
      'completedLessonIds': instance.completedLessonIds,
      'completedModuleIds': instance.completedModuleIds,
      'onboardingComplete': instance.onboardingComplete,
      'preferredTuning': instance.preferredTuning,
      'isDarkMode': instance.isDarkMode,
      'notificationsEnabled': instance.notificationsEnabled,
      'soundEffectsEnabled': instance.soundEffectsEnabled,
      'masterVolume': instance.masterVolume,
      'language': instance.language,
      'isGuest': instance.isGuest,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
