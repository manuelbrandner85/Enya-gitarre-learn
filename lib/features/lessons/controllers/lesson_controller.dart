import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:enya_gitarre_learn/core/audio/pitch_detector.dart';
import 'package:enya_gitarre_learn/core/curriculum/curriculum.dart';
import 'package:enya_gitarre_learn/core/models/exercise.dart';
import 'package:enya_gitarre_learn/core/models/lesson.dart';

/// Identifies which lesson is being controlled.
class LessonKey {
  final String moduleId;
  final String lessonId;

  const LessonKey({required this.moduleId, required this.lessonId});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LessonKey &&
          other.moduleId == moduleId &&
          other.lessonId == lessonId;

  @override
  int get hashCode => Object.hash(moduleId, lessonId);
}

/// Per-attempt result.
class ExerciseAttempt {
  final int exerciseIndex;
  final double accuracy;
  final DateTime timestamp;

  const ExerciseAttempt({
    required this.exerciseIndex,
    required this.accuracy,
    required this.timestamp,
  });
}

/// Immutable state for a lesson in progress.
class LessonState {
  final Lesson? lesson;
  final int currentExerciseIndex;
  final int totalExercises;
  final List<ExerciseAttempt> attempts;
  final double currentAccuracy; // last submitted attempt accuracy
  final double bestAccuracy;
  final double avgAccuracy;
  final bool isComplete;
  final PitchResult? livePitch;

  const LessonState({
    this.lesson,
    this.currentExerciseIndex = 0,
    this.totalExercises = 0,
    this.attempts = const [],
    this.currentAccuracy = 0.0,
    this.bestAccuracy = 0.0,
    this.avgAccuracy = 0.0,
    this.isComplete = false,
    this.livePitch,
  });

  Exercise? get currentExercise {
    final l = lesson;
    if (l == null) return null;
    if (currentExerciseIndex < 0 ||
        currentExerciseIndex >= l.exercises.length) {
      return null;
    }
    return l.exercises[currentExerciseIndex];
  }

  double get progress =>
      totalExercises == 0 ? 0.0 : currentExerciseIndex / totalExercises;

  LessonState copyWith({
    Lesson? lesson,
    int? currentExerciseIndex,
    int? totalExercises,
    List<ExerciseAttempt>? attempts,
    double? currentAccuracy,
    double? bestAccuracy,
    double? avgAccuracy,
    bool? isComplete,
    PitchResult? livePitch,
    bool clearLivePitch = false,
  }) {
    return LessonState(
      lesson: lesson ?? this.lesson,
      currentExerciseIndex: currentExerciseIndex ?? this.currentExerciseIndex,
      totalExercises: totalExercises ?? this.totalExercises,
      attempts: attempts ?? this.attempts,
      currentAccuracy: currentAccuracy ?? this.currentAccuracy,
      bestAccuracy: bestAccuracy ?? this.bestAccuracy,
      avgAccuracy: avgAccuracy ?? this.avgAccuracy,
      isComplete: isComplete ?? this.isComplete,
      livePitch: clearLivePitch ? null : (livePitch ?? this.livePitch),
    );
  }
}

/// StateNotifier that owns lesson lifecycle.
///
/// Subscribes to [PitchDetector.pitchStream], tracks accuracy per attempt,
/// and exposes [nextExercise], [submitAttempt], and [completeLesson] methods.
class LessonController extends StateNotifier<LessonState> {
  final LessonKey _key;
  final PitchDetector _pitchDetector;
  final bool _ownsDetector;
  StreamSubscription<PitchResult>? _pitchSubscription;

  LessonController({
    required LessonKey key,
    PitchDetector? pitchDetector,
  })  : _key = key,
        _pitchDetector = pitchDetector ?? PitchDetector(),
        _ownsDetector = pitchDetector == null,
        super(const LessonState()) {
    _initialize();
  }

  Future<void> _initialize() async {
    final lesson = Curriculum.findLesson(_key.moduleId, _key.lessonId);
    state = state.copyWith(
      lesson: lesson,
      totalExercises: lesson?.exercises.length ?? 0,
      currentExerciseIndex: 0,
      attempts: const [],
      isComplete: false,
    );

    _pitchSubscription = _pitchDetector.pitchStream.listen((result) {
      if (!result.isValid) {
        state = state.copyWith(clearLivePitch: true);
        return;
      }
      state = state.copyWith(livePitch: result);
    });

    if (!_pitchDetector.isRunning) {
      await _pitchDetector.start();
    }
  }

  /// Advances to the next exercise. If we're past the last exercise the
  /// lesson is marked complete.
  void nextExercise() {
    final l = state.lesson;
    if (l == null) return;
    final nextIdx = state.currentExerciseIndex + 1;
    if (nextIdx >= l.exercises.length) {
      completeLesson();
      return;
    }
    state = state.copyWith(
      currentExerciseIndex: nextIdx,
      currentAccuracy: 0.0,
    );
  }

  /// Records an attempt for the current exercise.
  ///
  /// [accuracy] is expected as a 0..1 value.
  void submitAttempt(double accuracy) {
    final l = state.lesson;
    if (l == null) return;
    final clamped = accuracy.clamp(0.0, 1.0);
    final attempt = ExerciseAttempt(
      exerciseIndex: state.currentExerciseIndex,
      accuracy: clamped,
      timestamp: DateTime.now(),
    );
    final attempts = [...state.attempts, attempt];
    final best = attempts.fold<double>(0, (m, a) => a.accuracy > m ? a.accuracy : m);
    final avg = attempts.isEmpty
        ? 0.0
        : attempts.fold<double>(0, (s, a) => s + a.accuracy) / attempts.length;

    state = state.copyWith(
      attempts: attempts,
      currentAccuracy: clamped,
      bestAccuracy: best,
      avgAccuracy: avg,
    );
  }

  /// Marks the lesson complete.
  void completeLesson() {
    state = state.copyWith(isComplete: true);
  }

  /// Resets state and starts the lesson from the first exercise.
  void restart() {
    state = state.copyWith(
      currentExerciseIndex: 0,
      attempts: const [],
      currentAccuracy: 0.0,
      bestAccuracy: 0.0,
      avgAccuracy: 0.0,
      isComplete: false,
    );
  }

  @override
  void dispose() {
    _pitchSubscription?.cancel();
    if (_ownsDetector) {
      _pitchDetector.dispose();
    }
    super.dispose();
  }
}

/// Provider exposing a [LessonController] keyed by [LessonKey].
///
/// Use it like: `ref.watch(lessonControllerProvider(LessonKey(moduleId, lessonId)))`.
final lessonControllerProvider = StateNotifierProvider.family
    .autoDispose<LessonController, LessonState, LessonKey>((ref, key) {
  final controller = LessonController(key: key);
  ref.onDispose(controller.dispose);
  return controller;
});
