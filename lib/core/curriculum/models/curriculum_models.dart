// Plain Dart curriculum models (no code generation required)

enum ExerciseType {
  playNote,
  playChord,
  rhythm,
  earTraining,
  freestyle,
  scale,
  chordChange,
}

class ModuleModel {
  final String id;
  final String titleDe;
  final String titleEn;
  final String descriptionDe;
  final String descriptionEn;
  final int orderIndex;
  final String iconName;
  final int requiredLevel;
  final String? xmariPreset;
  final bool isFree;
  final int version;

  const ModuleModel({
    required this.id,
    required this.titleDe,
    required this.titleEn,
    required this.descriptionDe,
    required this.descriptionEn,
    required this.orderIndex,
    required this.iconName,
    this.requiredLevel = 1,
    this.xmariPreset,
    this.isFree = false,
    this.version = 1,
  });

  factory ModuleModel.fromJson(Map<String, dynamic> j) => ModuleModel(
        id: j['id'] as String,
        titleDe: j['title_de'] as String? ?? j['titleDe'] as String? ?? '',
        titleEn: j['title_en'] as String? ?? j['titleEn'] as String? ?? '',
        descriptionDe: j['description_de'] as String? ??
            j['descriptionDe'] as String? ??
            '',
        descriptionEn: j['description_en'] as String? ??
            j['descriptionEn'] as String? ??
            '',
        orderIndex:
            j['order_index'] as int? ?? j['orderIndex'] as int? ?? 0,
        iconName: j['icon_name'] as String? ??
            j['iconName'] as String? ??
            'music_note',
        requiredLevel:
            j['required_level'] as int? ?? j['requiredLevel'] as int? ?? 1,
        xmariPreset:
            j['xmari_preset'] as String? ?? j['xmariPreset'] as String?,
        isFree: j['is_free'] as bool? ?? j['isFree'] as bool? ?? false,
        version: j['version'] as int? ?? 1,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title_de': titleDe,
        'title_en': titleEn,
        'description_de': descriptionDe,
        'description_en': descriptionEn,
        'order_index': orderIndex,
        'icon_name': iconName,
        'required_level': requiredLevel,
        'xmari_preset': xmariPreset,
        'is_free': isFree,
        'version': version,
      };
}

class LessonModel {
  final String id;
  final String moduleId;
  final String titleDe;
  final String titleEn;
  final String descriptionDe;
  final String descriptionEn;
  final int orderIndex;
  final int difficulty;
  final int estimatedMinutes;
  final int xpReward;
  final Map<String, dynamic> contentJson;
  final int version;

  const LessonModel({
    required this.id,
    required this.moduleId,
    required this.titleDe,
    required this.titleEn,
    required this.descriptionDe,
    required this.descriptionEn,
    required this.orderIndex,
    this.difficulty = 1,
    this.estimatedMinutes = 5,
    this.xpReward = 50,
    this.contentJson = const {},
    this.version = 1,
  });

  factory LessonModel.fromJson(Map<String, dynamic> j) => LessonModel(
        id: j['id'] as String,
        moduleId:
            j['module_id'] as String? ?? j['moduleId'] as String? ?? '',
        titleDe: j['title_de'] as String? ?? j['titleDe'] as String? ?? '',
        titleEn: j['title_en'] as String? ?? j['titleEn'] as String? ?? '',
        descriptionDe: j['description_de'] as String? ??
            j['descriptionDe'] as String? ??
            '',
        descriptionEn: j['description_en'] as String? ??
            j['descriptionEn'] as String? ??
            '',
        orderIndex:
            j['order_index'] as int? ?? j['orderIndex'] as int? ?? 0,
        difficulty: j['difficulty'] as int? ?? 1,
        estimatedMinutes: j['estimated_minutes'] as int? ??
            j['estimatedMinutes'] as int? ??
            5,
        xpReward:
            j['xp_reward'] as int? ?? j['xpReward'] as int? ?? 50,
        contentJson:
            (j['content_json'] as Map?)?.cast<String, dynamic>() ?? {},
        version: j['version'] as int? ?? 1,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'module_id': moduleId,
        'title_de': titleDe,
        'title_en': titleEn,
        'description_de': descriptionDe,
        'description_en': descriptionEn,
        'order_index': orderIndex,
        'difficulty': difficulty,
        'estimated_minutes': estimatedMinutes,
        'xp_reward': xpReward,
        'content_json': contentJson,
        'version': version,
      };
}

class ExerciseModel {
  final String id;
  final String lessonId;
  final ExerciseType type;
  final String instructionDe;
  final String instructionEn;
  final int orderIndex;
  final List<String> targetNotes;
  final String? targetChord;
  final int? bpm;
  final int? durationSeconds;
  final double accuracyThreshold;
  final Map<String, dynamic> contentJson;

  const ExerciseModel({
    required this.id,
    required this.lessonId,
    required this.type,
    required this.instructionDe,
    required this.instructionEn,
    required this.orderIndex,
    this.targetNotes = const [],
    this.targetChord,
    this.bpm,
    this.durationSeconds,
    this.accuracyThreshold = 0.7,
    this.contentJson = const {},
  });

  factory ExerciseModel.fromJson(Map<String, dynamic> j) {
    final typeRaw =
        j['type'] as String? ?? j['exercise_type'] as String? ?? 'playNote';
    final type = ExerciseType.values.firstWhere(
      (e) => e.name == typeRaw,
      orElse: () => ExerciseType.playNote,
    );
    return ExerciseModel(
      id: j['id'] as String,
      lessonId:
          j['lesson_id'] as String? ?? j['lessonId'] as String? ?? '',
      type: type,
      instructionDe: j['instruction_de'] as String? ??
          j['instructionDe'] as String? ??
          '',
      instructionEn: j['instruction_en'] as String? ??
          j['instructionEn'] as String? ??
          '',
      orderIndex:
          j['order_index'] as int? ?? j['orderIndex'] as int? ?? 0,
      targetNotes: (j['target_notes'] as List?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      targetChord:
          j['target_chord'] as String? ?? j['targetChord'] as String?,
      bpm: j['bpm'] as int?,
      durationSeconds: j['duration_seconds'] as int? ??
          j['durationSeconds'] as int?,
      accuracyThreshold:
          (j['accuracy_threshold'] as num?)?.toDouble() ??
              (j['accuracyThreshold'] as num?)?.toDouble() ??
              0.7,
      contentJson:
          (j['content_json'] as Map?)?.cast<String, dynamic>() ?? {},
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'lesson_id': lessonId,
        'type': type.name,
        'instruction_de': instructionDe,
        'instruction_en': instructionEn,
        'order_index': orderIndex,
        'target_notes': targetNotes,
        'target_chord': targetChord,
        'bpm': bpm,
        'duration_seconds': durationSeconds,
        'accuracy_threshold': accuracyThreshold,
        'content_json': contentJson,
      };
}
