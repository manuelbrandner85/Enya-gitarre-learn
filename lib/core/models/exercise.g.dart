// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExerciseImpl _$$ExerciseImplFromJson(Map<String, dynamic> json) =>
    _$ExerciseImpl(
      id: json['id'] as String,
      lessonId: json['lessonId'] as String,
      type: $enumDecode(_$ExerciseTypeEnumMap, json['type']),
      instructions: json['instructions'] as String,
      targetNoteOrChord: json['targetNoteOrChord'] as String? ?? '',
      pattern: json['pattern'] as String? ?? '',
      bpm: (json['bpm'] as num?)?.toInt() ?? 80,
      repetitionsRequired: (json['repetitionsRequired'] as num?)?.toInt() ?? 4,
      accuracyThreshold:
          (json['accuracyThreshold'] as num?)?.toDouble() ?? 0.75,
      noteSequence: (json['noteSequence'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      videoUrl: json['videoUrl'] as String? ?? '',
      timeoutSeconds: (json['timeoutSeconds'] as num?)?.toInt() ?? 30,
      order: (json['order'] as num?)?.toInt() ?? 1,
    );

Map<String, dynamic> _$$ExerciseImplToJson(_$ExerciseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'lessonId': instance.lessonId,
      'type': _$ExerciseTypeEnumMap[instance.type]!,
      'instructions': instance.instructions,
      'targetNoteOrChord': instance.targetNoteOrChord,
      'pattern': instance.pattern,
      'bpm': instance.bpm,
      'repetitionsRequired': instance.repetitionsRequired,
      'accuracyThreshold': instance.accuracyThreshold,
      'noteSequence': instance.noteSequence,
      'videoUrl': instance.videoUrl,
      'timeoutSeconds': instance.timeoutSeconds,
      'order': instance.order,
    };

const _$ExerciseTypeEnumMap = {
  ExerciseType.singleNote: 'singleNote',
  ExerciseType.chord: 'chord',
  ExerciseType.scale: 'scale',
  ExerciseType.strumming: 'strumming',
  ExerciseType.rhythm: 'rhythm',
  ExerciseType.earTraining: 'earTraining',
};
