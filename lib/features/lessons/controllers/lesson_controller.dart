import 'dart:async';
import 'dart:math' as math;

import 'package:drift/drift.dart' show Value;
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:enya_gitarre_learn/core/audio/audio_input_service.dart';
import 'package:enya_gitarre_learn/core/audio/pitch_detector.dart';
import 'package:enya_gitarre_learn/core/curriculum/curriculum.dart';
import 'package:enya_gitarre_learn/core/database/app_database.dart';
import 'package:enya_gitarre_learn/core/models/exercise.dart';
import 'package:enya_gitarre_learn/core/models/lesson.dart';
import 'package:enya_gitarre_learn/core/music_theory/note.dart';
import 'package:enya_gitarre_learn/core/providers/app_providers.dart';
import 'package:enya_gitarre_learn/core/supabase/supabase_sync_service.dart';
import 'package:enya_gitarre_learn/core/utils/constants.dart';

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
  final String exerciseId;
  final double accuracy; // 0..1
  final int durationSeconds;
  final DateTime timestamp;

  const ExerciseAttempt({
    required this.exerciseIndex,
    required this.exerciseId,
    required this.accuracy,
    required this.durationSeconds,
    required this.timestamp,
  });
}

/// Immutable state for a lesson in progress.
class LessonState {
  final Lesson? lesson;
  final int currentExerciseIndex;
  final int totalExercises;
  final List<ExerciseAttempt> attempts;
  final double currentAccuracy; // last submitted attempt accuracy (0..1)
  final double bestAccuracy;
  final double avgAccuracy;
  final bool isComplete;
  final PitchResult? livePitch;
  final int detectionsCaptured; // how many on-pitch detections so far
  final bool isListening;

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
    this.detectionsCaptured = 0,
    this.isListening = false,
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
    int? detectionsCaptured,
    bool? isListening,
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
      detectionsCaptured: detectionsCaptured ?? this.detectionsCaptured,
      isListening: isListening ?? this.isListening,
    );
  }
}

/// StateNotifier that owns lesson lifecycle.
class LessonController extends StateNotifier<LessonState> {
  final LessonKey _key;
  final PitchDetector _pitchDetector;
  final AudioInputService _audioInput;
  final AppDatabase _db;
  final SharedPreferences _prefs;
  final SupabaseSyncService _supabase;
  final bool _ownsDetector;
  StreamSubscription<PitchResult>? _pitchSubscription;

  /// Recent valid pitch results for the current exercise — used for scoring.
  final List<PitchResult> _recentResults = [];
  DateTime? _exerciseStartedAt;

  LessonController({
    required LessonKey key,
    required PitchDetector pitchDetector,
    required AudioInputService audioInput,
    required AppDatabase db,
    required SharedPreferences prefs,
    required SupabaseSyncService supabase,
    bool ownsDetector = false,
  })  : _key = key,
        _pitchDetector = pitchDetector,
        _audioInput = audioInput,
        _db = db,
        _prefs = prefs,
        _supabase = supabase,
        _ownsDetector = ownsDetector,
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
    _exerciseStartedAt = DateTime.now();

    _pitchSubscription = _pitchDetector.pitchStream.listen((result) {
      if (!result.isValid) {
        state = state.copyWith(clearLivePitch: true);
        return;
      }
      _onPitch(result);
    });
  }

  /// Starts microphone capture and pitch detection. Safe to call repeatedly.
  Future<void> startListening() async {
    if (state.isListening) return;
    try {
      await _audioInput.requestMicrophonePermission();
    } catch (e) {
      debugPrint('Mic permission request failed: $e');
    }
    if (!_pitchDetector.isRunning) {
      await _pitchDetector.start();
    }
    _exerciseStartedAt ??= DateTime.now();
    _recentResults.clear();
    state = state.copyWith(
      isListening: true,
      detectionsCaptured: 0,
    );
  }

  /// Stops live pitch detection (keeps state intact).
  Future<void> stopListening() async {
    if (!state.isListening) return;
    await _pitchDetector.stop();
    state = state.copyWith(isListening: false);
  }

  void _onPitch(PitchResult result) {
    state = state.copyWith(livePitch: result);

    if (!state.isListening) return;
    if (result.amplitude < 0.02) return;

    // Cache the result for scoring.
    _recentResults.add(result);
    if (_recentResults.length > 64) {
      _recentResults.removeAt(0);
    }

    final exercise = state.currentExercise;

    // Count any audible note when no exercise is defined.
    final matched = exercise != null
        ? _matchesTarget(result, exercise)
        : result.amplitude > 0.05;

    if (!matched) return;

    final next = state.detectionsCaptured + 1;
    state = state.copyWith(detectionsCaptured: next);

    if (exercise != null) {
      final required = math.max(1, exercise.repetitionsRequired);
      if (next >= required) {
        final accuracy = computeAccuracyForExercise(exercise);
        submitAttempt(accuracy);
        stopListening();
      }
    }
  }

  /// Computes accuracy 0..1 for the given exercise from cached pitch results.
  double computeAccuracyForExercise(Exercise exercise) {
    final results =
        _recentResults.where((r) => r.amplitude > 0.02).toList();
    if (results.isEmpty) return 0.0;

    final targetSpec = exercise.targetNoteOrChord.trim();

    if (exercise.type == ExerciseType.chord && targetSpec.contains(',')) {
      // Chord scoring: how many of the chord's notes were detected.
      final targets = _parseNotes(targetSpec);
      if (targets.isEmpty) return _amplitudeFallback(results);
      final detectedMidis = results.map((r) => r.midiNote % 12).toSet();
      final hits = targets
          .where((t) => detectedMidis.contains(t.midiNumber % 12))
          .length;
      return (hits / targets.length).clamp(0.0, 1.0);
    }

    if (targetSpec.isEmpty || targetSpec == 'chromatic') {
      return _amplitudeFallback(results);
    }

    // Single note (or note sequence — score over all targets).
    final targets = _parseNotes(targetSpec);
    if (targets.isEmpty) return _amplitudeFallback(results);

    final targetClasses = targets.map((n) => n.midiNumber % 12).toSet();
    final matching = results
        .where((r) => targetClasses.contains(r.midiNote % 12))
        .toList();
    if (matching.isEmpty) return 0.0;

    double sum = 0;
    for (final r in matching) {
      final score = (100.0 - (r.centsOff.abs() / 50.0) * 100.0).clamp(0.0, 100.0);
      sum += score;
    }
    final avg = sum / matching.length;
    return (avg / 100.0).clamp(0.0, 1.0);
  }

  double _amplitudeFallback(List<PitchResult> results) {
    // "Did the user play anything?" — average amplitude mapped to 0..1.
    final avg = results.fold<double>(0, (s, r) => s + r.amplitude) /
        results.length;
    return (avg * 5.0).clamp(0.0, 1.0);
  }

  List<Note> _parseNotes(String spec) {
    final parts = spec.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty);
    final notes = <Note>[];
    for (final p in parts) {
      final n = _parseNote(p);
      if (n != null) notes.add(n);
    }
    return notes;
  }

  Note? _parseNote(String s) {
    if (s.isEmpty) return null;
    // Find octave digit at the end.
    final match = RegExp(r'^([A-Ga-g][#b]?)(\d+)$').firstMatch(s);
    if (match == null) return null;
    final name = match.group(1)!.toUpperCase();
    final octave = int.tryParse(match.group(2)!) ?? 4;
    return Note(name: name, octave: octave);
  }

  bool _matchesTarget(PitchResult r, Exercise exercise) {
    final spec = exercise.targetNoteOrChord.trim();
    if (spec.isEmpty || spec == 'chromatic') {
      return r.amplitude > 0.05;
    }
    final targets = _parseNotes(spec);
    if (targets.isEmpty) return r.amplitude > 0.05;
    final cls = r.midiNote % 12;
    return targets.any((t) => t.midiNumber % 12 == cls) && r.isOnPitch;
  }

  /// Submits an attempt using current accumulated pitch results.
  /// Works even when no exercises are defined on the lesson.
  void submitManualAttempt() {
    final l = state.lesson;
    if (l == null) return;

    final exercise = state.currentExercise;
    double accuracy;
    if (exercise != null) {
      accuracy = computeAccuracyForExercise(exercise);
    } else {
      final results = _recentResults.where((r) => r.amplitude > 0.02).toList();
      if (results.isEmpty) {
        // User pressed start+stop with no sound — give minimal credit for trying.
        accuracy = state.detectionsCaptured > 0 ? 0.70 : 0.0;
      } else {
        accuracy = _amplitudeFallback(results);
      }
    }

    final clamped = accuracy.clamp(0.0, 1.0);
    final startedAt = _exerciseStartedAt ?? DateTime.now();
    final duration = DateTime.now().difference(startedAt).inSeconds;

    final attempt = ExerciseAttempt(
      exerciseIndex: state.currentExerciseIndex,
      exerciseId: exercise?.id ?? 'manual-${state.currentExerciseIndex}',
      accuracy: clamped,
      durationSeconds: duration,
      timestamp: DateTime.now(),
    );
    final attempts = [...state.attempts, attempt];
    final best =
        attempts.fold<double>(0, (m, a) => a.accuracy > m ? a.accuracy : m);
    final avg = attempts.fold<double>(0, (s, a) => s + a.accuracy) /
        attempts.length;

    state = state.copyWith(
      attempts: attempts,
      currentAccuracy: clamped,
      bestAccuracy: best,
      avgAccuracy: avg,
    );
  }

  /// Advances to the next exercise.
  void nextExercise() {
    final l = state.lesson;
    if (l == null) return;
    final nextIdx = state.currentExerciseIndex + 1;
    _recentResults.clear();
    _exerciseStartedAt = DateTime.now();
    if (nextIdx >= l.exercises.length) {
      completeLesson();
      return;
    }
    state = state.copyWith(
      currentExerciseIndex: nextIdx,
      currentAccuracy: 0.0,
      detectionsCaptured: 0,
    );
  }

  /// Records an attempt for the current exercise. [accuracy] is 0..1.
  void submitAttempt(double accuracy) {
    final l = state.lesson;
    if (l == null) return;
    final exercise = state.currentExercise;
    if (exercise == null) return;

    final clamped = accuracy.clamp(0.0, 1.0);
    final startedAt = _exerciseStartedAt ?? DateTime.now();
    final duration = DateTime.now().difference(startedAt).inSeconds;

    final attempt = ExerciseAttempt(
      exerciseIndex: state.currentExerciseIndex,
      exerciseId: exercise.id,
      accuracy: clamped,
      durationSeconds: duration,
      timestamp: DateTime.now(),
    );
    final attempts = [...state.attempts, attempt];
    final best = attempts.fold<double>(
        0, (m, a) => a.accuracy > m ? a.accuracy : m);
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

  /// Marks the lesson complete and persists progress (local + Supabase).
  Future<void> completeLesson() async {
    state = state.copyWith(isComplete: true);
    await _persistProgress();
  }

  Future<void> _persistProgress() async {
    final lesson = state.lesson;
    if (lesson == null) return;
    final userId = _prefs.getString(AppConstants.prefKeyUserId);
    if (userId == null) return;

    final accuracy = state.avgAccuracy > 0 ? state.avgAccuracy : state.bestAccuracy;
    final stars = lesson.starsForAccuracy(accuracy);
    final completedAt = DateTime.now();

    // Local Drift persistence.
    try {
      await _db.upsertLessonProgress(
        LessonProgressTableCompanion.insert(
          lessonId: lesson.id,
          userId: userId,
          moduleId: lesson.moduleId,
          isCompleted: const Value(true),
          bestAccuracy: Value(accuracy),
          stars: Value(stars),
          attempts: Value(state.attempts.length),
          xpEarned: Value(lesson.xpReward),
          completedAt: Value(completedAt),
          lastAttemptAt: Value(completedAt),
        ),
      );
    } catch (e) {
      debugPrint('LessonController persist lesson_progress failed: $e');
    }

    for (final attempt in state.attempts) {
      try {
        await _db.insertExerciseResult(
          ExerciseResultsTableCompanion.insert(
            exerciseId: attempt.exerciseId,
            lessonId: lesson.id,
            userId: userId,
            sessionId: '',
            accuracy: Value(attempt.accuracy),
            durationSeconds: Value(attempt.durationSeconds),
            passed: Value(attempt.accuracy >= lesson.targetAccuracy),
            completedAt: attempt.timestamp,
          ),
        );
      } catch (e) {
        debugPrint('LessonController persist exercise_result failed: $e');
      }
    }

    // Cloud sync — never block local progression.
    final moduleNum = _moduleIdAsInt(lesson.moduleId);
    try {
      await _supabase.upsertLessonProgress(
        lessonId: lesson.id,
        moduleId: moduleNum,
        isCompleted: true,
        bestAccuracy: accuracy,
        attempts: state.attempts.length,
        xpEarned: lesson.xpReward,
        completedAt: completedAt,
      );
    } catch (e) {
      debugPrint('Supabase upsertLessonProgress failed: $e');
    }

    for (final attempt in state.attempts) {
      try {
        await _supabase.insertExerciseResult(
          exerciseId: attempt.exerciseId,
          lessonId: lesson.id,
          accuracy: attempt.accuracy,
          timingScore: 0.0,
          durationSeconds: attempt.durationSeconds,
        );
      } catch (e) {
        debugPrint('Supabase insertExerciseResult failed: $e');
      }
    }
  }

  int _moduleIdAsInt(String moduleId) {
    final m = Curriculum.findModule(moduleId);
    if (m != null) return m.moduleNumber;
    final digits = RegExp(r'\d+').firstMatch(moduleId)?.group(0);
    return int.tryParse(digits ?? '') ?? 0;
  }

  /// Resets state and starts the lesson from the first exercise.
  void restart() {
    _recentResults.clear();
    _exerciseStartedAt = DateTime.now();
    state = state.copyWith(
      currentExerciseIndex: 0,
      attempts: const [],
      currentAccuracy: 0.0,
      bestAccuracy: 0.0,
      avgAccuracy: 0.0,
      isComplete: false,
      detectionsCaptured: 0,
    );
  }

  @override
  void dispose() {
    _pitchSubscription?.cancel();
    if (_ownsDetector) {
      _pitchDetector.dispose();
    } else {
      // Best effort: stop simulation/audio so it doesn't keep emitting.
      _pitchDetector.stop();
    }
    super.dispose();
  }
}

/// Provider exposing a [LessonController] keyed by [LessonKey].
final lessonControllerProvider = StateNotifierProvider.family
    .autoDispose<LessonController, LessonState, LessonKey>((ref, key) {
  final detector = ref.watch(pitchDetectorProvider);
  final audio = ref.watch(audioInputServiceProvider);
  final db = ref.watch(databaseProvider);
  final prefs = ref.watch(sharedPreferencesProvider);
  final supabase = ref.watch(supabaseSyncProvider);
  final controller = LessonController(
    key: key,
    pitchDetector: detector,
    audioInput: audio,
    db: db,
    prefs: prefs,
    supabase: supabase,
  );
  ref.onDispose(controller.dispose);
  return controller;
});
