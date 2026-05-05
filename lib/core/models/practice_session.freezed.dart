// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'practice_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PracticeSession _$PracticeSessionFromJson(Map<String, dynamic> json) {
  return _PracticeSession.fromJson(json);
}

/// @nodoc
mixin _$PracticeSession {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  DateTime get startTime => throw _privateConstructorUsedError;
  DateTime? get endTime => throw _privateConstructorUsedError;
  int get durationSeconds => throw _privateConstructorUsedError;
  List<String> get lessonsCompleted => throw _privateConstructorUsedError;
  List<String> get exercisesCompleted => throw _privateConstructorUsedError;
  int get xpEarned => throw _privateConstructorUsedError;
  double get averageAccuracy => throw _privateConstructorUsedError;
  int get notesPlayed => throw _privateConstructorUsedError;
  int get chordsPlayed => throw _privateConstructorUsedError;
  String get currentModuleId => throw _privateConstructorUsedError;
  String get currentLessonId => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  List<String> get achievementsUnlocked => throw _privateConstructorUsedError;
  bool get wasRecorded => throw _privateConstructorUsedError;
  String get recordingPath => throw _privateConstructorUsedError;

  /// Serializes this PracticeSession to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PracticeSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PracticeSessionCopyWith<PracticeSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PracticeSessionCopyWith<$Res> {
  factory $PracticeSessionCopyWith(
          PracticeSession value, $Res Function(PracticeSession) then) =
      _$PracticeSessionCopyWithImpl<$Res, PracticeSession>;
  @useResult
  $Res call(
      {String id,
      String userId,
      DateTime startTime,
      DateTime? endTime,
      int durationSeconds,
      List<String> lessonsCompleted,
      List<String> exercisesCompleted,
      int xpEarned,
      double averageAccuracy,
      int notesPlayed,
      int chordsPlayed,
      String currentModuleId,
      String currentLessonId,
      bool isActive,
      List<String> achievementsUnlocked,
      bool wasRecorded,
      String recordingPath});
}

/// @nodoc
class _$PracticeSessionCopyWithImpl<$Res, $Val extends PracticeSession>
    implements $PracticeSessionCopyWith<$Res> {
  _$PracticeSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PracticeSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? startTime = null,
    Object? endTime = freezed,
    Object? durationSeconds = null,
    Object? lessonsCompleted = null,
    Object? exercisesCompleted = null,
    Object? xpEarned = null,
    Object? averageAccuracy = null,
    Object? notesPlayed = null,
    Object? chordsPlayed = null,
    Object? currentModuleId = null,
    Object? currentLessonId = null,
    Object? isActive = null,
    Object? achievementsUnlocked = null,
    Object? wasRecorded = null,
    Object? recordingPath = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: freezed == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      durationSeconds: null == durationSeconds
          ? _value.durationSeconds
          : durationSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      lessonsCompleted: null == lessonsCompleted
          ? _value.lessonsCompleted
          : lessonsCompleted // ignore: cast_nullable_to_non_nullable
              as List<String>,
      exercisesCompleted: null == exercisesCompleted
          ? _value.exercisesCompleted
          : exercisesCompleted // ignore: cast_nullable_to_non_nullable
              as List<String>,
      xpEarned: null == xpEarned
          ? _value.xpEarned
          : xpEarned // ignore: cast_nullable_to_non_nullable
              as int,
      averageAccuracy: null == averageAccuracy
          ? _value.averageAccuracy
          : averageAccuracy // ignore: cast_nullable_to_non_nullable
              as double,
      notesPlayed: null == notesPlayed
          ? _value.notesPlayed
          : notesPlayed // ignore: cast_nullable_to_non_nullable
              as int,
      chordsPlayed: null == chordsPlayed
          ? _value.chordsPlayed
          : chordsPlayed // ignore: cast_nullable_to_non_nullable
              as int,
      currentModuleId: null == currentModuleId
          ? _value.currentModuleId
          : currentModuleId // ignore: cast_nullable_to_non_nullable
              as String,
      currentLessonId: null == currentLessonId
          ? _value.currentLessonId
          : currentLessonId // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      achievementsUnlocked: null == achievementsUnlocked
          ? _value.achievementsUnlocked
          : achievementsUnlocked // ignore: cast_nullable_to_non_nullable
              as List<String>,
      wasRecorded: null == wasRecorded
          ? _value.wasRecorded
          : wasRecorded // ignore: cast_nullable_to_non_nullable
              as bool,
      recordingPath: null == recordingPath
          ? _value.recordingPath
          : recordingPath // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PracticeSessionImplCopyWith<$Res>
    implements $PracticeSessionCopyWith<$Res> {
  factory _$$PracticeSessionImplCopyWith(_$PracticeSessionImpl value,
          $Res Function(_$PracticeSessionImpl) then) =
      __$$PracticeSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      DateTime startTime,
      DateTime? endTime,
      int durationSeconds,
      List<String> lessonsCompleted,
      List<String> exercisesCompleted,
      int xpEarned,
      double averageAccuracy,
      int notesPlayed,
      int chordsPlayed,
      String currentModuleId,
      String currentLessonId,
      bool isActive,
      List<String> achievementsUnlocked,
      bool wasRecorded,
      String recordingPath});
}

/// @nodoc
class __$$PracticeSessionImplCopyWithImpl<$Res>
    extends _$PracticeSessionCopyWithImpl<$Res, _$PracticeSessionImpl>
    implements _$$PracticeSessionImplCopyWith<$Res> {
  __$$PracticeSessionImplCopyWithImpl(
      _$PracticeSessionImpl _value, $Res Function(_$PracticeSessionImpl) _then)
      : super(_value, _then);

  /// Create a copy of PracticeSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? startTime = null,
    Object? endTime = freezed,
    Object? durationSeconds = null,
    Object? lessonsCompleted = null,
    Object? exercisesCompleted = null,
    Object? xpEarned = null,
    Object? averageAccuracy = null,
    Object? notesPlayed = null,
    Object? chordsPlayed = null,
    Object? currentModuleId = null,
    Object? currentLessonId = null,
    Object? isActive = null,
    Object? achievementsUnlocked = null,
    Object? wasRecorded = null,
    Object? recordingPath = null,
  }) {
    return _then(_$PracticeSessionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: freezed == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      durationSeconds: null == durationSeconds
          ? _value.durationSeconds
          : durationSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      lessonsCompleted: null == lessonsCompleted
          ? _value._lessonsCompleted
          : lessonsCompleted // ignore: cast_nullable_to_non_nullable
              as List<String>,
      exercisesCompleted: null == exercisesCompleted
          ? _value._exercisesCompleted
          : exercisesCompleted // ignore: cast_nullable_to_non_nullable
              as List<String>,
      xpEarned: null == xpEarned
          ? _value.xpEarned
          : xpEarned // ignore: cast_nullable_to_non_nullable
              as int,
      averageAccuracy: null == averageAccuracy
          ? _value.averageAccuracy
          : averageAccuracy // ignore: cast_nullable_to_non_nullable
              as double,
      notesPlayed: null == notesPlayed
          ? _value.notesPlayed
          : notesPlayed // ignore: cast_nullable_to_non_nullable
              as int,
      chordsPlayed: null == chordsPlayed
          ? _value.chordsPlayed
          : chordsPlayed // ignore: cast_nullable_to_non_nullable
              as int,
      currentModuleId: null == currentModuleId
          ? _value.currentModuleId
          : currentModuleId // ignore: cast_nullable_to_non_nullable
              as String,
      currentLessonId: null == currentLessonId
          ? _value.currentLessonId
          : currentLessonId // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      achievementsUnlocked: null == achievementsUnlocked
          ? _value._achievementsUnlocked
          : achievementsUnlocked // ignore: cast_nullable_to_non_nullable
              as List<String>,
      wasRecorded: null == wasRecorded
          ? _value.wasRecorded
          : wasRecorded // ignore: cast_nullable_to_non_nullable
              as bool,
      recordingPath: null == recordingPath
          ? _value.recordingPath
          : recordingPath // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PracticeSessionImpl extends _PracticeSession {
  const _$PracticeSessionImpl(
      {required this.id,
      required this.userId,
      required this.startTime,
      this.endTime,
      this.durationSeconds = 0,
      final List<String> lessonsCompleted = const [],
      final List<String> exercisesCompleted = const [],
      this.xpEarned = 0,
      this.averageAccuracy = 0.0,
      this.notesPlayed = 0,
      this.chordsPlayed = 0,
      this.currentModuleId = '',
      this.currentLessonId = '',
      this.isActive = false,
      final List<String> achievementsUnlocked = const [],
      this.wasRecorded = false,
      this.recordingPath = ''})
      : _lessonsCompleted = lessonsCompleted,
        _exercisesCompleted = exercisesCompleted,
        _achievementsUnlocked = achievementsUnlocked,
        super._();

  factory _$PracticeSessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$PracticeSessionImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final DateTime startTime;
  @override
  final DateTime? endTime;
  @override
  @JsonKey()
  final int durationSeconds;
  final List<String> _lessonsCompleted;
  @override
  @JsonKey()
  List<String> get lessonsCompleted {
    if (_lessonsCompleted is EqualUnmodifiableListView)
      return _lessonsCompleted;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_lessonsCompleted);
  }

  final List<String> _exercisesCompleted;
  @override
  @JsonKey()
  List<String> get exercisesCompleted {
    if (_exercisesCompleted is EqualUnmodifiableListView)
      return _exercisesCompleted;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_exercisesCompleted);
  }

  @override
  @JsonKey()
  final int xpEarned;
  @override
  @JsonKey()
  final double averageAccuracy;
  @override
  @JsonKey()
  final int notesPlayed;
  @override
  @JsonKey()
  final int chordsPlayed;
  @override
  @JsonKey()
  final String currentModuleId;
  @override
  @JsonKey()
  final String currentLessonId;
  @override
  @JsonKey()
  final bool isActive;
  final List<String> _achievementsUnlocked;
  @override
  @JsonKey()
  List<String> get achievementsUnlocked {
    if (_achievementsUnlocked is EqualUnmodifiableListView)
      return _achievementsUnlocked;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_achievementsUnlocked);
  }

  @override
  @JsonKey()
  final bool wasRecorded;
  @override
  @JsonKey()
  final String recordingPath;

  @override
  String toString() {
    return 'PracticeSession(id: $id, userId: $userId, startTime: $startTime, endTime: $endTime, durationSeconds: $durationSeconds, lessonsCompleted: $lessonsCompleted, exercisesCompleted: $exercisesCompleted, xpEarned: $xpEarned, averageAccuracy: $averageAccuracy, notesPlayed: $notesPlayed, chordsPlayed: $chordsPlayed, currentModuleId: $currentModuleId, currentLessonId: $currentLessonId, isActive: $isActive, achievementsUnlocked: $achievementsUnlocked, wasRecorded: $wasRecorded, recordingPath: $recordingPath)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PracticeSessionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.durationSeconds, durationSeconds) ||
                other.durationSeconds == durationSeconds) &&
            const DeepCollectionEquality()
                .equals(other._lessonsCompleted, _lessonsCompleted) &&
            const DeepCollectionEquality()
                .equals(other._exercisesCompleted, _exercisesCompleted) &&
            (identical(other.xpEarned, xpEarned) ||
                other.xpEarned == xpEarned) &&
            (identical(other.averageAccuracy, averageAccuracy) ||
                other.averageAccuracy == averageAccuracy) &&
            (identical(other.notesPlayed, notesPlayed) ||
                other.notesPlayed == notesPlayed) &&
            (identical(other.chordsPlayed, chordsPlayed) ||
                other.chordsPlayed == chordsPlayed) &&
            (identical(other.currentModuleId, currentModuleId) ||
                other.currentModuleId == currentModuleId) &&
            (identical(other.currentLessonId, currentLessonId) ||
                other.currentLessonId == currentLessonId) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            const DeepCollectionEquality()
                .equals(other._achievementsUnlocked, _achievementsUnlocked) &&
            (identical(other.wasRecorded, wasRecorded) ||
                other.wasRecorded == wasRecorded) &&
            (identical(other.recordingPath, recordingPath) ||
                other.recordingPath == recordingPath));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      startTime,
      endTime,
      durationSeconds,
      const DeepCollectionEquality().hash(_lessonsCompleted),
      const DeepCollectionEquality().hash(_exercisesCompleted),
      xpEarned,
      averageAccuracy,
      notesPlayed,
      chordsPlayed,
      currentModuleId,
      currentLessonId,
      isActive,
      const DeepCollectionEquality().hash(_achievementsUnlocked),
      wasRecorded,
      recordingPath);

  /// Create a copy of PracticeSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PracticeSessionImplCopyWith<_$PracticeSessionImpl> get copyWith =>
      __$$PracticeSessionImplCopyWithImpl<_$PracticeSessionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PracticeSessionImplToJson(
      this,
    );
  }
}

abstract class _PracticeSession extends PracticeSession {
  const factory _PracticeSession(
      {required final String id,
      required final String userId,
      required final DateTime startTime,
      final DateTime? endTime,
      final int durationSeconds,
      final List<String> lessonsCompleted,
      final List<String> exercisesCompleted,
      final int xpEarned,
      final double averageAccuracy,
      final int notesPlayed,
      final int chordsPlayed,
      final String currentModuleId,
      final String currentLessonId,
      final bool isActive,
      final List<String> achievementsUnlocked,
      final bool wasRecorded,
      final String recordingPath}) = _$PracticeSessionImpl;
  const _PracticeSession._() : super._();

  factory _PracticeSession.fromJson(Map<String, dynamic> json) =
      _$PracticeSessionImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  DateTime get startTime;
  @override
  DateTime? get endTime;
  @override
  int get durationSeconds;
  @override
  List<String> get lessonsCompleted;
  @override
  List<String> get exercisesCompleted;
  @override
  int get xpEarned;
  @override
  double get averageAccuracy;
  @override
  int get notesPlayed;
  @override
  int get chordsPlayed;
  @override
  String get currentModuleId;
  @override
  String get currentLessonId;
  @override
  bool get isActive;
  @override
  List<String> get achievementsUnlocked;
  @override
  bool get wasRecorded;
  @override
  String get recordingPath;

  /// Create a copy of PracticeSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PracticeSessionImplCopyWith<_$PracticeSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
