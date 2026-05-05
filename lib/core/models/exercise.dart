import 'package:freezed_annotation/freezed_annotation.dart';

part 'exercise.freezed.dart';
part 'exercise.g.dart';

enum ExerciseType {
  singleNote,
  chord,
  scale,
  strumming,
  rhythm,
  earTraining,
}

extension ExerciseTypeExtension on ExerciseType {
  String get displayName {
    switch (this) {
      case ExerciseType.singleNote:
        return 'Einzeltöne';
      case ExerciseType.chord:
        return 'Akkorde';
      case ExerciseType.scale:
        return 'Tonleiter';
      case ExerciseType.strumming:
        return 'Strumming';
      case ExerciseType.rhythm:
        return 'Rhythmus';
      case ExerciseType.earTraining:
        return 'Gehörtraining';
    }
  }

  String get iconName {
    switch (this) {
      case ExerciseType.singleNote:
        return 'music_note';
      case ExerciseType.chord:
        return 'piano';
      case ExerciseType.scale:
        return 'trending_up';
      case ExerciseType.strumming:
        return 'waves';
      case ExerciseType.rhythm:
        return 'timer';
      case ExerciseType.earTraining:
        return 'hearing';
    }
  }
}

@freezed
class Exercise with _$Exercise {
  const factory Exercise({
    required String id,
    required String lessonId,
    required ExerciseType type,
    required String instructions,
    @Default('') String targetNoteOrChord,
    @Default('') String pattern,
    @Default(80) int bpm,
    @Default(4) int repetitionsRequired,
    @Default(0.75) double accuracyThreshold,
    @Default([]) List<String> noteSequence,
    @Default('') String videoUrl,
    @Default(30) int timeoutSeconds,
    @Default(1) int order,
  }) = _Exercise;

  factory Exercise.fromJson(Map<String, dynamic> json) =>
      _$ExerciseFromJson(json);

  const Exercise._();

  /// Returns true if this is a listening exercise
  bool get isListening => type == ExerciseType.earTraining;

  /// Returns true if this exercise requires audio input
  bool get requiresAudioInput =>
      type != ExerciseType.earTraining;

  /// Returns the difficulty estimate (1-5) based on exercise type and BPM
  int get estimatedDifficulty {
    int base;
    switch (type) {
      case ExerciseType.singleNote:
        base = 1;
        break;
      case ExerciseType.earTraining:
        base = 2;
        break;
      case ExerciseType.chord:
        base = 3;
        break;
      case ExerciseType.scale:
        base = 3;
        break;
      case ExerciseType.rhythm:
        base = 4;
        break;
      case ExerciseType.strumming:
        base = 4;
        break;
    }
    if (bpm > 120) base++;
    if (bpm > 160) base++;
    return base.clamp(1, 5);
  }
}
