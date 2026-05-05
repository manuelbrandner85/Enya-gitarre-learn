// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lesson.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Lesson _$LessonFromJson(Map<String, dynamic> json) {
  return _Lesson.fromJson(json);
}

/// @nodoc
mixin _$Lesson {
  String get id => throw _privateConstructorUsedError;
  String get moduleId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  List<String> get instructions => throw _privateConstructorUsedError;
  List<Exercise> get exercises => throw _privateConstructorUsedError;
  int get xpReward => throw _privateConstructorUsedError;
  int get difficulty => throw _privateConstructorUsedError;
  double get targetAccuracy => throw _privateConstructorUsedError;
  GuitarPreset get presetRequired => throw _privateConstructorUsedError;
  String get videoUrl => throw _privateConstructorUsedError;
  List<String> get chordIds => throw _privateConstructorUsedError;
  List<String> get scaleIds => throw _privateConstructorUsedError;
  int get order => throw _privateConstructorUsedError;
  bool get isUnlocked => throw _privateConstructorUsedError;
  bool get isCompleted => throw _privateConstructorUsedError;
  double get bestAccuracy => throw _privateConstructorUsedError;
  int get attempts => throw _privateConstructorUsedError;
  int get estimatedMinutes => throw _privateConstructorUsedError;

  /// Serializes this Lesson to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Lesson
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LessonCopyWith<Lesson> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LessonCopyWith<$Res> {
  factory $LessonCopyWith(Lesson value, $Res Function(Lesson) then) =
      _$LessonCopyWithImpl<$Res, Lesson>;
  @useResult
  $Res call(
      {String id,
      String moduleId,
      String title,
      String description,
      List<String> instructions,
      List<Exercise> exercises,
      int xpReward,
      int difficulty,
      double targetAccuracy,
      GuitarPreset presetRequired,
      String videoUrl,
      List<String> chordIds,
      List<String> scaleIds,
      int order,
      bool isUnlocked,
      bool isCompleted,
      double bestAccuracy,
      int attempts,
      int estimatedMinutes});
}

/// @nodoc
class _$LessonCopyWithImpl<$Res, $Val extends Lesson>
    implements $LessonCopyWith<$Res> {
  _$LessonCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Lesson
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? moduleId = null,
    Object? title = null,
    Object? description = null,
    Object? instructions = null,
    Object? exercises = null,
    Object? xpReward = null,
    Object? difficulty = null,
    Object? targetAccuracy = null,
    Object? presetRequired = null,
    Object? videoUrl = null,
    Object? chordIds = null,
    Object? scaleIds = null,
    Object? order = null,
    Object? isUnlocked = null,
    Object? isCompleted = null,
    Object? bestAccuracy = null,
    Object? attempts = null,
    Object? estimatedMinutes = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      moduleId: null == moduleId
          ? _value.moduleId
          : moduleId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      instructions: null == instructions
          ? _value.instructions
          : instructions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      exercises: null == exercises
          ? _value.exercises
          : exercises // ignore: cast_nullable_to_non_nullable
              as List<Exercise>,
      xpReward: null == xpReward
          ? _value.xpReward
          : xpReward // ignore: cast_nullable_to_non_nullable
              as int,
      difficulty: null == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as int,
      targetAccuracy: null == targetAccuracy
          ? _value.targetAccuracy
          : targetAccuracy // ignore: cast_nullable_to_non_nullable
              as double,
      presetRequired: null == presetRequired
          ? _value.presetRequired
          : presetRequired // ignore: cast_nullable_to_non_nullable
              as GuitarPreset,
      videoUrl: null == videoUrl
          ? _value.videoUrl
          : videoUrl // ignore: cast_nullable_to_non_nullable
              as String,
      chordIds: null == chordIds
          ? _value.chordIds
          : chordIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      scaleIds: null == scaleIds
          ? _value.scaleIds
          : scaleIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      isUnlocked: null == isUnlocked
          ? _value.isUnlocked
          : isUnlocked // ignore: cast_nullable_to_non_nullable
              as bool,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      bestAccuracy: null == bestAccuracy
          ? _value.bestAccuracy
          : bestAccuracy // ignore: cast_nullable_to_non_nullable
              as double,
      attempts: null == attempts
          ? _value.attempts
          : attempts // ignore: cast_nullable_to_non_nullable
              as int,
      estimatedMinutes: null == estimatedMinutes
          ? _value.estimatedMinutes
          : estimatedMinutes // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LessonImplCopyWith<$Res> implements $LessonCopyWith<$Res> {
  factory _$$LessonImplCopyWith(
          _$LessonImpl value, $Res Function(_$LessonImpl) then) =
      __$$LessonImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String moduleId,
      String title,
      String description,
      List<String> instructions,
      List<Exercise> exercises,
      int xpReward,
      int difficulty,
      double targetAccuracy,
      GuitarPreset presetRequired,
      String videoUrl,
      List<String> chordIds,
      List<String> scaleIds,
      int order,
      bool isUnlocked,
      bool isCompleted,
      double bestAccuracy,
      int attempts,
      int estimatedMinutes});
}

/// @nodoc
class __$$LessonImplCopyWithImpl<$Res>
    extends _$LessonCopyWithImpl<$Res, _$LessonImpl>
    implements _$$LessonImplCopyWith<$Res> {
  __$$LessonImplCopyWithImpl(
      _$LessonImpl _value, $Res Function(_$LessonImpl) _then)
      : super(_value, _then);

  /// Create a copy of Lesson
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? moduleId = null,
    Object? title = null,
    Object? description = null,
    Object? instructions = null,
    Object? exercises = null,
    Object? xpReward = null,
    Object? difficulty = null,
    Object? targetAccuracy = null,
    Object? presetRequired = null,
    Object? videoUrl = null,
    Object? chordIds = null,
    Object? scaleIds = null,
    Object? order = null,
    Object? isUnlocked = null,
    Object? isCompleted = null,
    Object? bestAccuracy = null,
    Object? attempts = null,
    Object? estimatedMinutes = null,
  }) {
    return _then(_$LessonImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      moduleId: null == moduleId
          ? _value.moduleId
          : moduleId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      instructions: null == instructions
          ? _value._instructions
          : instructions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      exercises: null == exercises
          ? _value._exercises
          : exercises // ignore: cast_nullable_to_non_nullable
              as List<Exercise>,
      xpReward: null == xpReward
          ? _value.xpReward
          : xpReward // ignore: cast_nullable_to_non_nullable
              as int,
      difficulty: null == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as int,
      targetAccuracy: null == targetAccuracy
          ? _value.targetAccuracy
          : targetAccuracy // ignore: cast_nullable_to_non_nullable
              as double,
      presetRequired: null == presetRequired
          ? _value.presetRequired
          : presetRequired // ignore: cast_nullable_to_non_nullable
              as GuitarPreset,
      videoUrl: null == videoUrl
          ? _value.videoUrl
          : videoUrl // ignore: cast_nullable_to_non_nullable
              as String,
      chordIds: null == chordIds
          ? _value._chordIds
          : chordIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      scaleIds: null == scaleIds
          ? _value._scaleIds
          : scaleIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      isUnlocked: null == isUnlocked
          ? _value.isUnlocked
          : isUnlocked // ignore: cast_nullable_to_non_nullable
              as bool,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      bestAccuracy: null == bestAccuracy
          ? _value.bestAccuracy
          : bestAccuracy // ignore: cast_nullable_to_non_nullable
              as double,
      attempts: null == attempts
          ? _value.attempts
          : attempts // ignore: cast_nullable_to_non_nullable
              as int,
      estimatedMinutes: null == estimatedMinutes
          ? _value.estimatedMinutes
          : estimatedMinutes // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LessonImpl extends _Lesson {
  const _$LessonImpl(
      {required this.id,
      required this.moduleId,
      required this.title,
      required this.description,
      final List<String> instructions = const [],
      final List<Exercise> exercises = const [],
      this.xpReward = 50,
      this.difficulty = 1,
      this.targetAccuracy = 0.75,
      this.presetRequired = GuitarPreset.clean,
      this.videoUrl = '',
      final List<String> chordIds = const [],
      final List<String> scaleIds = const [],
      this.order = 1,
      this.isUnlocked = false,
      this.isCompleted = false,
      this.bestAccuracy = 0.0,
      this.attempts = 0,
      this.estimatedMinutes = 0})
      : _instructions = instructions,
        _exercises = exercises,
        _chordIds = chordIds,
        _scaleIds = scaleIds,
        super._();

  factory _$LessonImpl.fromJson(Map<String, dynamic> json) =>
      _$$LessonImplFromJson(json);

  @override
  final String id;
  @override
  final String moduleId;
  @override
  final String title;
  @override
  final String description;
  final List<String> _instructions;
  @override
  @JsonKey()
  List<String> get instructions {
    if (_instructions is EqualUnmodifiableListView) return _instructions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_instructions);
  }

  final List<Exercise> _exercises;
  @override
  @JsonKey()
  List<Exercise> get exercises {
    if (_exercises is EqualUnmodifiableListView) return _exercises;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_exercises);
  }

  @override
  @JsonKey()
  final int xpReward;
  @override
  @JsonKey()
  final int difficulty;
  @override
  @JsonKey()
  final double targetAccuracy;
  @override
  @JsonKey()
  final GuitarPreset presetRequired;
  @override
  @JsonKey()
  final String videoUrl;
  final List<String> _chordIds;
  @override
  @JsonKey()
  List<String> get chordIds {
    if (_chordIds is EqualUnmodifiableListView) return _chordIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_chordIds);
  }

  final List<String> _scaleIds;
  @override
  @JsonKey()
  List<String> get scaleIds {
    if (_scaleIds is EqualUnmodifiableListView) return _scaleIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_scaleIds);
  }

  @override
  @JsonKey()
  final int order;
  @override
  @JsonKey()
  final bool isUnlocked;
  @override
  @JsonKey()
  final bool isCompleted;
  @override
  @JsonKey()
  final double bestAccuracy;
  @override
  @JsonKey()
  final int attempts;
  @override
  @JsonKey()
  final int estimatedMinutes;

  @override
  String toString() {
    return 'Lesson(id: $id, moduleId: $moduleId, title: $title, description: $description, instructions: $instructions, exercises: $exercises, xpReward: $xpReward, difficulty: $difficulty, targetAccuracy: $targetAccuracy, presetRequired: $presetRequired, videoUrl: $videoUrl, chordIds: $chordIds, scaleIds: $scaleIds, order: $order, isUnlocked: $isUnlocked, isCompleted: $isCompleted, bestAccuracy: $bestAccuracy, attempts: $attempts, estimatedMinutes: $estimatedMinutes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LessonImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.moduleId, moduleId) ||
                other.moduleId == moduleId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality()
                .equals(other._instructions, _instructions) &&
            const DeepCollectionEquality()
                .equals(other._exercises, _exercises) &&
            (identical(other.xpReward, xpReward) ||
                other.xpReward == xpReward) &&
            (identical(other.difficulty, difficulty) ||
                other.difficulty == difficulty) &&
            (identical(other.targetAccuracy, targetAccuracy) ||
                other.targetAccuracy == targetAccuracy) &&
            (identical(other.presetRequired, presetRequired) ||
                other.presetRequired == presetRequired) &&
            (identical(other.videoUrl, videoUrl) ||
                other.videoUrl == videoUrl) &&
            const DeepCollectionEquality().equals(other._chordIds, _chordIds) &&
            const DeepCollectionEquality().equals(other._scaleIds, _scaleIds) &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.isUnlocked, isUnlocked) ||
                other.isUnlocked == isUnlocked) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.bestAccuracy, bestAccuracy) ||
                other.bestAccuracy == bestAccuracy) &&
            (identical(other.attempts, attempts) ||
                other.attempts == attempts) &&
            (identical(other.estimatedMinutes, estimatedMinutes) ||
                other.estimatedMinutes == estimatedMinutes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        moduleId,
        title,
        description,
        const DeepCollectionEquality().hash(_instructions),
        const DeepCollectionEquality().hash(_exercises),
        xpReward,
        difficulty,
        targetAccuracy,
        presetRequired,
        videoUrl,
        const DeepCollectionEquality().hash(_chordIds),
        const DeepCollectionEquality().hash(_scaleIds),
        order,
        isUnlocked,
        isCompleted,
        bestAccuracy,
        attempts,
        estimatedMinutes
      ]);

  /// Create a copy of Lesson
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LessonImplCopyWith<_$LessonImpl> get copyWith =>
      __$$LessonImplCopyWithImpl<_$LessonImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LessonImplToJson(
      this,
    );
  }
}

abstract class _Lesson extends Lesson {
  const factory _Lesson(
      {required final String id,
      required final String moduleId,
      required final String title,
      required final String description,
      final List<String> instructions,
      final List<Exercise> exercises,
      final int xpReward,
      final int difficulty,
      final double targetAccuracy,
      final GuitarPreset presetRequired,
      final String videoUrl,
      final List<String> chordIds,
      final List<String> scaleIds,
      final int order,
      final bool isUnlocked,
      final bool isCompleted,
      final double bestAccuracy,
      final int attempts,
      final int estimatedMinutes}) = _$LessonImpl;
  const _Lesson._() : super._();

  factory _Lesson.fromJson(Map<String, dynamic> json) = _$LessonImpl.fromJson;

  @override
  String get id;
  @override
  String get moduleId;
  @override
  String get title;
  @override
  String get description;
  @override
  List<String> get instructions;
  @override
  List<Exercise> get exercises;
  @override
  int get xpReward;
  @override
  int get difficulty;
  @override
  double get targetAccuracy;
  @override
  GuitarPreset get presetRequired;
  @override
  String get videoUrl;
  @override
  List<String> get chordIds;
  @override
  List<String> get scaleIds;
  @override
  int get order;
  @override
  bool get isUnlocked;
  @override
  bool get isCompleted;
  @override
  double get bestAccuracy;
  @override
  int get attempts;
  @override
  int get estimatedMinutes;

  /// Create a copy of Lesson
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LessonImplCopyWith<_$LessonImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
