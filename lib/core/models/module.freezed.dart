// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'module.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Module _$ModuleFromJson(Map<String, dynamic> json) {
  return _Module.fromJson(json);
}

/// @nodoc
mixin _$Module {
  String get id => throw _privateConstructorUsedError;
  int get moduleNumber => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get weekRange => throw _privateConstructorUsedError;
  GuitarPreset get presetRequired => throw _privateConstructorUsedError;
  int get difficulty => throw _privateConstructorUsedError;
  List<Lesson> get lessons => throw _privateConstructorUsedError;
  List<String> get unlockedPresets => throw _privateConstructorUsedError;
  bool get isLocked => throw _privateConstructorUsedError;
  double get completionPercentage => throw _privateConstructorUsedError;
  String get imageAsset => throw _privateConstructorUsedError;
  String get learningGoals => throw _privateConstructorUsedError;

  /// Serializes this Module to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Module
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ModuleCopyWith<Module> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ModuleCopyWith<$Res> {
  factory $ModuleCopyWith(Module value, $Res Function(Module) then) =
      _$ModuleCopyWithImpl<$Res, Module>;
  @useResult
  $Res call(
      {String id,
      int moduleNumber,
      String title,
      String description,
      String weekRange,
      GuitarPreset presetRequired,
      int difficulty,
      List<Lesson> lessons,
      List<String> unlockedPresets,
      bool isLocked,
      double completionPercentage,
      String imageAsset,
      String learningGoals});
}

/// @nodoc
class _$ModuleCopyWithImpl<$Res, $Val extends Module>
    implements $ModuleCopyWith<$Res> {
  _$ModuleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Module
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? moduleNumber = null,
    Object? title = null,
    Object? description = null,
    Object? weekRange = null,
    Object? presetRequired = null,
    Object? difficulty = null,
    Object? lessons = null,
    Object? unlockedPresets = null,
    Object? isLocked = null,
    Object? completionPercentage = null,
    Object? imageAsset = null,
    Object? learningGoals = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      moduleNumber: null == moduleNumber
          ? _value.moduleNumber
          : moduleNumber // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      weekRange: null == weekRange
          ? _value.weekRange
          : weekRange // ignore: cast_nullable_to_non_nullable
              as String,
      presetRequired: null == presetRequired
          ? _value.presetRequired
          : presetRequired // ignore: cast_nullable_to_non_nullable
              as GuitarPreset,
      difficulty: null == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as int,
      lessons: null == lessons
          ? _value.lessons
          : lessons // ignore: cast_nullable_to_non_nullable
              as List<Lesson>,
      unlockedPresets: null == unlockedPresets
          ? _value.unlockedPresets
          : unlockedPresets // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isLocked: null == isLocked
          ? _value.isLocked
          : isLocked // ignore: cast_nullable_to_non_nullable
              as bool,
      completionPercentage: null == completionPercentage
          ? _value.completionPercentage
          : completionPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      imageAsset: null == imageAsset
          ? _value.imageAsset
          : imageAsset // ignore: cast_nullable_to_non_nullable
              as String,
      learningGoals: null == learningGoals
          ? _value.learningGoals
          : learningGoals // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ModuleImplCopyWith<$Res> implements $ModuleCopyWith<$Res> {
  factory _$$ModuleImplCopyWith(
          _$ModuleImpl value, $Res Function(_$ModuleImpl) then) =
      __$$ModuleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      int moduleNumber,
      String title,
      String description,
      String weekRange,
      GuitarPreset presetRequired,
      int difficulty,
      List<Lesson> lessons,
      List<String> unlockedPresets,
      bool isLocked,
      double completionPercentage,
      String imageAsset,
      String learningGoals});
}

/// @nodoc
class __$$ModuleImplCopyWithImpl<$Res>
    extends _$ModuleCopyWithImpl<$Res, _$ModuleImpl>
    implements _$$ModuleImplCopyWith<$Res> {
  __$$ModuleImplCopyWithImpl(
      _$ModuleImpl _value, $Res Function(_$ModuleImpl) _then)
      : super(_value, _then);

  /// Create a copy of Module
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? moduleNumber = null,
    Object? title = null,
    Object? description = null,
    Object? weekRange = null,
    Object? presetRequired = null,
    Object? difficulty = null,
    Object? lessons = null,
    Object? unlockedPresets = null,
    Object? isLocked = null,
    Object? completionPercentage = null,
    Object? imageAsset = null,
    Object? learningGoals = null,
  }) {
    return _then(_$ModuleImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      moduleNumber: null == moduleNumber
          ? _value.moduleNumber
          : moduleNumber // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      weekRange: null == weekRange
          ? _value.weekRange
          : weekRange // ignore: cast_nullable_to_non_nullable
              as String,
      presetRequired: null == presetRequired
          ? _value.presetRequired
          : presetRequired // ignore: cast_nullable_to_non_nullable
              as GuitarPreset,
      difficulty: null == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as int,
      lessons: null == lessons
          ? _value._lessons
          : lessons // ignore: cast_nullable_to_non_nullable
              as List<Lesson>,
      unlockedPresets: null == unlockedPresets
          ? _value._unlockedPresets
          : unlockedPresets // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isLocked: null == isLocked
          ? _value.isLocked
          : isLocked // ignore: cast_nullable_to_non_nullable
              as bool,
      completionPercentage: null == completionPercentage
          ? _value.completionPercentage
          : completionPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      imageAsset: null == imageAsset
          ? _value.imageAsset
          : imageAsset // ignore: cast_nullable_to_non_nullable
              as String,
      learningGoals: null == learningGoals
          ? _value.learningGoals
          : learningGoals // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ModuleImpl extends _Module {
  const _$ModuleImpl(
      {required this.id,
      required this.moduleNumber,
      required this.title,
      required this.description,
      required this.weekRange,
      this.presetRequired = GuitarPreset.clean,
      this.difficulty = 1,
      final List<Lesson> lessons = const [],
      final List<String> unlockedPresets = const [],
      this.isLocked = true,
      this.completionPercentage = 0.0,
      this.imageAsset = '',
      this.learningGoals = ''})
      : _lessons = lessons,
        _unlockedPresets = unlockedPresets,
        super._();

  factory _$ModuleImpl.fromJson(Map<String, dynamic> json) =>
      _$$ModuleImplFromJson(json);

  @override
  final String id;
  @override
  final int moduleNumber;
  @override
  final String title;
  @override
  final String description;
  @override
  final String weekRange;
  @override
  @JsonKey()
  final GuitarPreset presetRequired;
  @override
  @JsonKey()
  final int difficulty;
  final List<Lesson> _lessons;
  @override
  @JsonKey()
  List<Lesson> get lessons {
    if (_lessons is EqualUnmodifiableListView) return _lessons;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_lessons);
  }

  final List<String> _unlockedPresets;
  @override
  @JsonKey()
  List<String> get unlockedPresets {
    if (_unlockedPresets is EqualUnmodifiableListView) return _unlockedPresets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_unlockedPresets);
  }

  @override
  @JsonKey()
  final bool isLocked;
  @override
  @JsonKey()
  final double completionPercentage;
  @override
  @JsonKey()
  final String imageAsset;
  @override
  @JsonKey()
  final String learningGoals;

  @override
  String toString() {
    return 'Module(id: $id, moduleNumber: $moduleNumber, title: $title, description: $description, weekRange: $weekRange, presetRequired: $presetRequired, difficulty: $difficulty, lessons: $lessons, unlockedPresets: $unlockedPresets, isLocked: $isLocked, completionPercentage: $completionPercentage, imageAsset: $imageAsset, learningGoals: $learningGoals)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ModuleImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.moduleNumber, moduleNumber) ||
                other.moduleNumber == moduleNumber) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.weekRange, weekRange) ||
                other.weekRange == weekRange) &&
            (identical(other.presetRequired, presetRequired) ||
                other.presetRequired == presetRequired) &&
            (identical(other.difficulty, difficulty) ||
                other.difficulty == difficulty) &&
            const DeepCollectionEquality().equals(other._lessons, _lessons) &&
            const DeepCollectionEquality()
                .equals(other._unlockedPresets, _unlockedPresets) &&
            (identical(other.isLocked, isLocked) ||
                other.isLocked == isLocked) &&
            (identical(other.completionPercentage, completionPercentage) ||
                other.completionPercentage == completionPercentage) &&
            (identical(other.imageAsset, imageAsset) ||
                other.imageAsset == imageAsset) &&
            (identical(other.learningGoals, learningGoals) ||
                other.learningGoals == learningGoals));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      moduleNumber,
      title,
      description,
      weekRange,
      presetRequired,
      difficulty,
      const DeepCollectionEquality().hash(_lessons),
      const DeepCollectionEquality().hash(_unlockedPresets),
      isLocked,
      completionPercentage,
      imageAsset,
      learningGoals);

  /// Create a copy of Module
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ModuleImplCopyWith<_$ModuleImpl> get copyWith =>
      __$$ModuleImplCopyWithImpl<_$ModuleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ModuleImplToJson(
      this,
    );
  }
}

abstract class _Module extends Module {
  const factory _Module(
      {required final String id,
      required final int moduleNumber,
      required final String title,
      required final String description,
      required final String weekRange,
      final GuitarPreset presetRequired,
      final int difficulty,
      final List<Lesson> lessons,
      final List<String> unlockedPresets,
      final bool isLocked,
      final double completionPercentage,
      final String imageAsset,
      final String learningGoals}) = _$ModuleImpl;
  const _Module._() : super._();

  factory _Module.fromJson(Map<String, dynamic> json) = _$ModuleImpl.fromJson;

  @override
  String get id;
  @override
  int get moduleNumber;
  @override
  String get title;
  @override
  String get description;
  @override
  String get weekRange;
  @override
  GuitarPreset get presetRequired;
  @override
  int get difficulty;
  @override
  List<Lesson> get lessons;
  @override
  List<String> get unlockedPresets;
  @override
  bool get isLocked;
  @override
  double get completionPercentage;
  @override
  String get imageAsset;
  @override
  String get learningGoals;

  /// Create a copy of Module
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ModuleImplCopyWith<_$ModuleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
