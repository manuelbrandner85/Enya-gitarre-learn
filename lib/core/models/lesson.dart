import 'package:freezed_annotation/freezed_annotation.dart';

import 'exercise.dart';

part 'lesson.freezed.dart';
part 'lesson.g.dart';

enum GuitarPreset {
  clean,
  overdrive,
  distortion,
  highGain,
  acoustic,
  jazz,
}

extension GuitarPresetExtension on GuitarPreset {
  String get displayName {
    switch (this) {
      case GuitarPreset.clean:
        return 'Clean';
      case GuitarPreset.overdrive:
        return 'Overdrive';
      case GuitarPreset.distortion:
        return 'Distortion';
      case GuitarPreset.highGain:
        return 'High Gain';
      case GuitarPreset.acoustic:
        return 'Akustisch';
      case GuitarPreset.jazz:
        return 'Jazz';
    }
  }

  String get description {
    switch (this) {
      case GuitarPreset.clean:
        return 'Sauberer, unverzerrter Klang';
      case GuitarPreset.overdrive:
        return 'Leichte Verzerrung, warmer Klang';
      case GuitarPreset.distortion:
        return 'Starke Verzerrung für Rock-Sounds';
      case GuitarPreset.highGain:
        return 'Extrem verzerrter Metal-Sound';
      case GuitarPreset.acoustic:
        return 'Simulierter Akustikgitarren-Klang';
      case GuitarPreset.jazz:
        return 'Warmer, gedämpfter Jazz-Ton';
    }
  }
}

@freezed
class Lesson with _$Lesson {
  const factory Lesson({
    required String id,
    required String moduleId,
    required String title,
    required String description,
    @Default([]) List<String> instructions,
    @Default([]) List<Exercise> exercises,
    @Default(50) int xpReward,
    @Default(1) int difficulty,
    @Default(0.75) double targetAccuracy,
    @Default(GuitarPreset.clean) GuitarPreset presetRequired,
    @Default('') String videoUrl,
    @Default([]) List<String> chordIds,
    @Default([]) List<String> scaleIds,
    @Default(1) int order,
    @Default(false) bool isUnlocked,
    @Default(false) bool isCompleted,
    @Default(0.0) double bestAccuracy,
    @Default(0) int attempts,
    @Default(0) int estimatedMinutes,
  }) = _Lesson;

  factory Lesson.fromJson(Map<String, dynamic> json) =>
      _$LessonFromJson(json);

  const Lesson._();

  /// Returns a difficulty label in German
  String get difficultyLabel {
    if (difficulty <= 2) return 'Einfach';
    if (difficulty <= 4) return 'Leicht';
    if (difficulty <= 6) return 'Mittel';
    if (difficulty <= 8) return 'Schwer';
    return 'Experte';
  }

  /// Returns the number of stars (1-3) based on accuracy
  int starsForAccuracy(double accuracy) {
    if (accuracy >= 0.98) return 3;
    if (accuracy >= 0.85) return 2;
    if (accuracy >= targetAccuracy) return 1;
    return 0;
  }

  /// Returns true if this lesson has exercises
  bool get hasExercises => exercises.isNotEmpty;

  /// Returns true if this lesson has a video
  bool get hasVideo => videoUrl.isNotEmpty;
}
