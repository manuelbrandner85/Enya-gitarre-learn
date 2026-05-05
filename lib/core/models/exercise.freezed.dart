// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exercise.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Exercise _$ExerciseFromJson(Map<String, dynamic> json) {
  return _Exercise.fromJson(json);
}

/// @nodoc
mixin _$Exercise {
  String get id => throw _privateConstructorUsedError;
  String get lessonId => throw _privateConstructorUsedError;
  ExerciseType get type => throw _privateConstructorUsedError;
  String get instructions => throw _privateConstructorUsedError;
  String get targetNoteOrChord => throw _privateConstructorUsedError;
  String get pattern => throw _privateConstructorUsedError;
  int get bpm => throw _privateConstructorUsedError;
  int get repetitionsRequired => throw _privateConstructorUsedError;
  double get accuracyThreshold => throw _privateConstructorUsedError;
  List<String> get noteSequence => throw _privateConstructorUsedError;
  String get videoUrl => throw _privateConstructorUsedError;
  int get timeoutSeconds => throw _privateConstructorUsedError;
  int get order => throw _privateConstructorUsedError;

  /// Serializes this Exercise to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Exercise
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExerciseCopyWith<Exercise> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExerciseCopyWith<$Res> {
  factory $ExerciseCopyWith(Exercise value, $Res Function(Exercise) then) =
      _$ExerciseCopyWithImpl<$Res, Exercise>;
  @useResult
  $Res call(
      {String id,
      String lessonId,
      ExerciseType type,
      String instructions,
      String targetNoteOrChord,
      String pattern,
      int bpm,
      int repetitionsRequired,
      double accuracyThreshold,
      List<String> noteSequence,
      String videoUrl,
      int timeoutSeconds,
      int order});
}

/// @nodoc
class _$ExerciseCopyWithImpl<$Res, $Val extends Exercise>
    implements $ExerciseCopyWith<$Res> {
  _$ExerciseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Exercise
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? lessonId = null,
    Object? type = null,
    Object? instructions = null,
    Object? targetNoteOrChord = null,
    Object? pattern = null,
    Object? bpm = null,
    Object? repetitionsRequired = null,
    Object? accuracyThreshold = null,
    Object? noteSequence = null,
    Object? videoUrl = null,
    Object? timeoutSeconds = null,
    Object? order = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      lessonId: null == lessonId
          ? _value.lessonId
          : lessonId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ExerciseType,
      instructions: null == instructions
          ? _value.instructions
          : instructions // ignore: cast_nullable_to_non_nullable
              as String,
      targetNoteOrChord: null == targetNoteOrChord
          ? _value.targetNoteOrChord
          : targetNoteOrChord // ignore: cast_nullable_to_non_nullable
              as String,
      pattern: null == pattern
          ? _value.pattern
          : pattern // ignore: cast_nullable_to_non_nullable
              as String,
      bpm: null == bpm
          ? _value.bpm
          : bpm // ignore: cast_nullable_to_non_nullable
              as int,
      repetitionsRequired: null == repetitionsRequired
          ? _value.repetitionsRequired
          : repetitionsRequired // ignore: cast_nullable_to_non_nullable
              as int,
      accuracyThreshold: null == accuracyThreshold
          ? _value.accuracyThreshold
          : accuracyThreshold // ignore: cast_nullable_to_non_nullable
              as double,
      noteSequence: null == noteSequence
          ? _value.noteSequence
          : noteSequence // ignore: cast_nullable_to_non_nullable
              as List<String>,
      videoUrl: null == videoUrl
          ? _value.videoUrl
          : videoUrl // ignore: cast_nullable_to_non_nullable
              as String,
      timeoutSeconds: null == timeoutSeconds
          ? _value.timeoutSeconds
          : timeoutSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExerciseImplCopyWith<$Res>
    implements $ExerciseCopyWith<$Res> {
  factory _$$ExerciseImplCopyWith(
          _$ExerciseImpl value, $Res Function(_$ExerciseImpl) then) =
      __$$ExerciseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String lessonId,
      ExerciseType type,
      String instructions,
      String targetNoteOrChord,
      String pattern,
      int bpm,
      int repetitionsRequired,
      double accuracyThreshold,
      List<String> noteSequence,
      String videoUrl,
      int timeoutSeconds,
      int order});
}

/// @nodoc
class __$$ExerciseImplCopyWithImpl<$Res>
    extends _$ExerciseCopyWithImpl<$Res, _$ExerciseImpl>
    implements _$$ExerciseImplCopyWith<$Res> {
  __$$ExerciseImplCopyWithImpl(
      _$ExerciseImpl _value, $Res Function(_$ExerciseImpl) _then)
      : super(_value, _then);

  /// Create a copy of Exercise
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? lessonId = null,
    Object? type = null,
    Object? instructions = null,
    Object? targetNoteOrChord = null,
    Object? pattern = null,
    Object? bpm = null,
    Object? repetitionsRequired = null,
    Object? accuracyThreshold = null,
    Object? noteSequence = null,
    Object? videoUrl = null,
    Object? timeoutSeconds = null,
    Object? order = null,
  }) {
    return _then(_$ExerciseImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      lessonId: null == lessonId
          ? _value.lessonId
          : lessonId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ExerciseType,
      instructions: null == instructions
          ? _value.instructions
          : instructions // ignore: cast_nullable_to_non_nullable
              as String,
      targetNoteOrChord: null == targetNoteOrChord
          ? _value.targetNoteOrChord
          : targetNoteOrChord // ignore: cast_nullable_to_non_nullable
              as String,
      pattern: null == pattern
          ? _value.pattern
          : pattern // ignore: cast_nullable_to_non_nullable
              as String,
      bpm: null == bpm
          ? _value.bpm
          : bpm // ignore: cast_nullable_to_non_nullable
              as int,
      repetitionsRequired: null == repetitionsRequired
          ? _value.repetitionsRequired
          : repetitionsRequired // ignore: cast_nullable_to_non_nullable
              as int,
      accuracyThreshold: null == accuracyThreshold
          ? _value.accuracyThreshold
          : accuracyThreshold // ignore: cast_nullable_to_non_nullable
              as double,
      noteSequence: null == noteSequence
          ? _value._noteSequence
          : noteSequence // ignore: cast_nullable_to_non_nullable
              as List<String>,
      videoUrl: null == videoUrl
          ? _value.videoUrl
          : videoUrl // ignore: cast_nullable_to_non_nullable
              as String,
      timeoutSeconds: null == timeoutSeconds
          ? _value.timeoutSeconds
          : timeoutSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExerciseImpl extends _Exercise {
  const _$ExerciseImpl(
      {required this.id,
      required this.lessonId,
      required this.type,
      required this.instructions,
      this.targetNoteOrChord = '',
      this.pattern = '',
      this.bpm = 80,
      this.repetitionsRequired = 4,
      this.accuracyThreshold = 0.75,
      final List<String> noteSequence = const [],
      this.videoUrl = '',
      this.timeoutSeconds = 30,
      this.order = 1})
      : _noteSequence = noteSequence,
        super._();

  factory _$ExerciseImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExerciseImplFromJson(json);

  @override
  final String id;
  @override
  final String lessonId;
  @override
  final ExerciseType type;
  @override
  final String instructions;
  @override
  @JsonKey()
  final String targetNoteOrChord;
  @override
  @JsonKey()
  final String pattern;
  @override
  @JsonKey()
  final int bpm;
  @override
  @JsonKey()
  final int repetitionsRequired;
  @override
  @JsonKey()
  final double accuracyThreshold;
  final List<String> _noteSequence;
  @override
  @JsonKey()
  List<String> get noteSequence {
    if (_noteSequence is EqualUnmodifiableListView) return _noteSequence;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_noteSequence);
  }

  @override
  @JsonKey()
  final String videoUrl;
  @override
  @JsonKey()
  final int timeoutSeconds;
  @override
  @JsonKey()
  final int order;

  @override
  String toString() {
    return 'Exercise(id: $id, lessonId: $lessonId, type: $type, instructions: $instructions, targetNoteOrChord: $targetNoteOrChord, pattern: $pattern, bpm: $bpm, repetitionsRequired: $repetitionsRequired, accuracyThreshold: $accuracyThreshold, noteSequence: $noteSequence, videoUrl: $videoUrl, timeoutSeconds: $timeoutSeconds, order: $order)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExerciseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.lessonId, lessonId) ||
                other.lessonId == lessonId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.instructions, instructions) ||
                other.instructions == instructions) &&
            (identical(other.targetNoteOrChord, targetNoteOrChord) ||
                other.targetNoteOrChord == targetNoteOrChord) &&
            (identical(other.pattern, pattern) || other.pattern == pattern) &&
            (identical(other.bpm, bpm) || other.bpm == bpm) &&
            (identical(other.repetitionsRequired, repetitionsRequired) ||
                other.repetitionsRequired == repetitionsRequired) &&
            (identical(other.accuracyThreshold, accuracyThreshold) ||
                other.accuracyThreshold == accuracyThreshold) &&
            const DeepCollectionEquality()
                .equals(other._noteSequence, _noteSequence) &&
            (identical(other.videoUrl, videoUrl) ||
                other.videoUrl == videoUrl) &&
            (identical(other.timeoutSeconds, timeoutSeconds) ||
                other.timeoutSeconds == timeoutSeconds) &&
            (identical(other.order, order) || other.order == order));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      lessonId,
      type,
      instructions,
      targetNoteOrChord,
      pattern,
      bpm,
      repetitionsRequired,
      accuracyThreshold,
      const DeepCollectionEquality().hash(_noteSequence),
      videoUrl,
      timeoutSeconds,
      order);

  /// Create a copy of Exercise
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExerciseImplCopyWith<_$ExerciseImpl> get copyWith =>
      __$$ExerciseImplCopyWithImpl<_$ExerciseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExerciseImplToJson(
      this,
    );
  }
}

abstract class _Exercise extends Exercise {
  const factory _Exercise(
      {required final String id,
      required final String lessonId,
      required final ExerciseType type,
      required final String instructions,
      final String targetNoteOrChord,
      final String pattern,
      final int bpm,
      final int repetitionsRequired,
      final double accuracyThreshold,
      final List<String> noteSequence,
      final String videoUrl,
      final int timeoutSeconds,
      final int order}) = _$ExerciseImpl;
  const _Exercise._() : super._();

  factory _Exercise.fromJson(Map<String, dynamic> json) =
      _$ExerciseImpl.fromJson;

  @override
  String get id;
  @override
  String get lessonId;
  @override
  ExerciseType get type;
  @override
  String get instructions;
  @override
  String get targetNoteOrChord;
  @override
  String get pattern;
  @override
  int get bpm;
  @override
  int get repetitionsRequired;
  @override
  double get accuracyThreshold;
  @override
  List<String> get noteSequence;
  @override
  String get videoUrl;
  @override
  int get timeoutSeconds;
  @override
  int get order;

  /// Create a copy of Exercise
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExerciseImplCopyWith<_$ExerciseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
