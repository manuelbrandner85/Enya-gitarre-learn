// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LessonImpl _$$LessonImplFromJson(Map<String, dynamic> json) => _$LessonImpl(
      id: json['id'] as String,
      moduleId: json['moduleId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      instructions: (json['instructions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      exercises: (json['exercises'] as List<dynamic>?)
              ?.map((e) => Exercise.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      xpReward: (json['xpReward'] as num?)?.toInt() ?? 50,
      difficulty: (json['difficulty'] as num?)?.toInt() ?? 1,
      targetAccuracy: (json['targetAccuracy'] as num?)?.toDouble() ?? 0.75,
      presetRequired:
          $enumDecodeNullable(_$GuitarPresetEnumMap, json['presetRequired']) ??
              GuitarPreset.clean,
      videoUrl: json['videoUrl'] as String? ?? '',
      chordIds: (json['chordIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      scaleIds: (json['scaleIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      order: (json['order'] as num?)?.toInt() ?? 1,
      isUnlocked: json['isUnlocked'] as bool? ?? false,
      isCompleted: json['isCompleted'] as bool? ?? false,
      bestAccuracy: (json['bestAccuracy'] as num?)?.toDouble() ?? 0.0,
      attempts: (json['attempts'] as num?)?.toInt() ?? 0,
      estimatedMinutes: (json['estimatedMinutes'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$LessonImplToJson(_$LessonImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'moduleId': instance.moduleId,
      'title': instance.title,
      'description': instance.description,
      'instructions': instance.instructions,
      'exercises': instance.exercises,
      'xpReward': instance.xpReward,
      'difficulty': instance.difficulty,
      'targetAccuracy': instance.targetAccuracy,
      'presetRequired': _$GuitarPresetEnumMap[instance.presetRequired]!,
      'videoUrl': instance.videoUrl,
      'chordIds': instance.chordIds,
      'scaleIds': instance.scaleIds,
      'order': instance.order,
      'isUnlocked': instance.isUnlocked,
      'isCompleted': instance.isCompleted,
      'bestAccuracy': instance.bestAccuracy,
      'attempts': instance.attempts,
      'estimatedMinutes': instance.estimatedMinutes,
    };

const _$GuitarPresetEnumMap = {
  GuitarPreset.clean: 'clean',
  GuitarPreset.overdrive: 'overdrive',
  GuitarPreset.distortion: 'distortion',
  GuitarPreset.highGain: 'highGain',
  GuitarPreset.acoustic: 'acoustic',
  GuitarPreset.jazz: 'jazz',
};
