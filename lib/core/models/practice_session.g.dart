// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'practice_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PracticeSessionImpl _$$PracticeSessionImplFromJson(
        Map<String, dynamic> json) =>
    _$PracticeSessionImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime'] as String),
      durationSeconds: (json['durationSeconds'] as num?)?.toInt() ?? 0,
      lessonsCompleted: (json['lessonsCompleted'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      exercisesCompleted: (json['exercisesCompleted'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      xpEarned: (json['xpEarned'] as num?)?.toInt() ?? 0,
      averageAccuracy: (json['averageAccuracy'] as num?)?.toDouble() ?? 0.0,
      notesPlayed: (json['notesPlayed'] as num?)?.toInt() ?? 0,
      chordsPlayed: (json['chordsPlayed'] as num?)?.toInt() ?? 0,
      currentModuleId: json['currentModuleId'] as String? ?? '',
      currentLessonId: json['currentLessonId'] as String? ?? '',
      isActive: json['isActive'] as bool? ?? false,
      achievementsUnlocked: (json['achievementsUnlocked'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      wasRecorded: json['wasRecorded'] as bool? ?? false,
      recordingPath: json['recordingPath'] as String? ?? '',
    );

Map<String, dynamic> _$$PracticeSessionImplToJson(
        _$PracticeSessionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
      'durationSeconds': instance.durationSeconds,
      'lessonsCompleted': instance.lessonsCompleted,
      'exercisesCompleted': instance.exercisesCompleted,
      'xpEarned': instance.xpEarned,
      'averageAccuracy': instance.averageAccuracy,
      'notesPlayed': instance.notesPlayed,
      'chordsPlayed': instance.chordsPlayed,
      'currentModuleId': instance.currentModuleId,
      'currentLessonId': instance.currentLessonId,
      'isActive': instance.isActive,
      'achievementsUnlocked': instance.achievementsUnlocked,
      'wasRecorded': instance.wasRecorded,
      'recordingPath': instance.recordingPath,
    };
