import 'package:freezed_annotation/freezed_annotation.dart';

part 'practice_session.freezed.dart';
part 'practice_session.g.dart';

@freezed
class PracticeSession with _$PracticeSession {
  const factory PracticeSession({
    required String id,
    required String userId,
    required DateTime startTime,
    DateTime? endTime,
    @Default(0) int durationSeconds,
    @Default([]) List<String> lessonsCompleted,
    @Default([]) List<String> exercisesCompleted,
    @Default(0) int xpEarned,
    @Default(0.0) double averageAccuracy,
    @Default(0) int notesPlayed,
    @Default(0) int chordsPlayed,
    @Default('') String currentModuleId,
    @Default('') String currentLessonId,
    @Default(false) bool isActive,
    @Default([]) List<String> achievementsUnlocked,
    @Default(false) bool wasRecorded,
    @Default('') String recordingPath,
  }) = _PracticeSession;

  factory PracticeSession.fromJson(Map<String, dynamic> json) =>
      _$PracticeSessionFromJson(json);

  const PracticeSession._();

  /// Creates a new practice session
  factory PracticeSession.start({
    required String id,
    required String userId,
    String moduleId = '',
    String lessonId = '',
  }) =>
      PracticeSession(
        id: id,
        userId: userId,
        startTime: DateTime.now(),
        currentModuleId: moduleId,
        currentLessonId: lessonId,
        isActive: true,
      );

  /// Returns the session duration in minutes
  int get durationMinutes => durationSeconds ~/ 60;

  /// Returns true if the session is at least the minimum required duration
  bool get isSignificant => durationSeconds >= 60;

  /// Returns the end time (now if still active)
  DateTime get effectiveEndTime => endTime ?? DateTime.now();

  /// Returns a human-readable duration string
  String get durationString {
    final minutes = durationSeconds ~/ 60;
    final seconds = durationSeconds % 60;
    if (minutes == 0) return '${seconds}s';
    if (seconds == 0) return '${minutes}min';
    return '${minutes}min ${seconds}s';
  }

  /// Returns true if this session was in the morning (before noon)
  bool get isMorningSession => startTime.hour < 12;

  /// Returns true if this session was at night (after 22:00)
  bool get isNightSession => startTime.hour >= 22;

  /// Returns true if this session was very late (after midnight)
  bool get isLateNightSession => startTime.hour < 4 || startTime.hour >= 0 && startTime.hour < 4;
}
