// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'module.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ModuleImpl _$$ModuleImplFromJson(Map<String, dynamic> json) => _$ModuleImpl(
      id: json['id'] as String,
      moduleNumber: (json['moduleNumber'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String,
      weekRange: json['weekRange'] as String,
      presetRequired:
          $enumDecodeNullable(_$GuitarPresetEnumMap, json['presetRequired']) ??
              GuitarPreset.clean,
      difficulty: (json['difficulty'] as num?)?.toInt() ?? 1,
      lessons: (json['lessons'] as List<dynamic>?)
              ?.map((e) => Lesson.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      unlockedPresets: (json['unlockedPresets'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isLocked: json['isLocked'] as bool? ?? true,
      completionPercentage:
          (json['completionPercentage'] as num?)?.toDouble() ?? 0.0,
      imageAsset: json['imageAsset'] as String? ?? '',
      learningGoals: json['learningGoals'] as String? ?? '',
    );

Map<String, dynamic> _$$ModuleImplToJson(_$ModuleImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'moduleNumber': instance.moduleNumber,
      'title': instance.title,
      'description': instance.description,
      'weekRange': instance.weekRange,
      'presetRequired': _$GuitarPresetEnumMap[instance.presetRequired]!,
      'difficulty': instance.difficulty,
      'lessons': instance.lessons,
      'unlockedPresets': instance.unlockedPresets,
      'isLocked': instance.isLocked,
      'completionPercentage': instance.completionPercentage,
      'imageAsset': instance.imageAsset,
      'learningGoals': instance.learningGoals,
    };

const _$GuitarPresetEnumMap = {
  GuitarPreset.clean: 'clean',
  GuitarPreset.overdrive: 'overdrive',
  GuitarPreset.distortion: 'distortion',
  GuitarPreset.highGain: 'highGain',
  GuitarPreset.acoustic: 'acoustic',
  GuitarPreset.jazz: 'jazz',
};
