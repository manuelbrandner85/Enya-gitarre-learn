import '../curriculum/pedagogy/learning_rules.dart';

enum PracticeBlockType { warmup, review, newLesson, song, jam, cooldown }

class PracticeBlock {
  final String title;
  final String description;
  final int durationMinutes;
  final PracticeBlockType type;
  final String? lessonId;
  final XmariSetup xmariSetup;

  const PracticeBlock({
    required this.title,
    required this.description,
    required this.durationMinutes,
    required this.type,
    this.lessonId,
    required this.xmariSetup,
  });
}

class DailyPlan {
  final List<PracticeBlock> blocks;
  final int totalMinutes;
  final String motivationalMessage;
  final XmariSetup initialSetup;
  final bool requiresPresetChanges;

  const DailyPlan({
    required this.blocks,
    required this.totalMinutes,
    required this.motivationalMessage,
    required this.initialSetup,
    required this.requiresPresetChanges,
  });
}

class DailyPlanGenerator {
  DailyPlanGenerator._();

  static DailyPlan generatePlan({
    required String userId,
    int targetMinutes = 15,
    int completedModules = 0,
  }) {
    final blocks = <PracticeBlock>[
      PracticeBlock(
        title: 'Aufwärmen',
        description: 'Leere Saiten auf der XMARI – lockere Finger, Clean-Sound',
        durationMinutes: 2,
        type: PracticeBlockType.warmup,
        xmariSetup: XmariSetup.beginnerDefault,
      ),
      PracticeBlock(
        title: 'Wiederholung',
        description: 'Letzte Lektion nochmal – festigt das Gelernte',
        durationMinutes: (targetMinutes * 0.3).round(),
        type: PracticeBlockType.review,
        xmariSetup: XmariSetup.beginnerDefault,
      ),
      PracticeBlock(
        title: 'Neue Lektion',
        description: completedModules < 5
            ? 'Auf Clean-Preset – ideal für neue Inhalte'
            : 'Mit Overdrive – du bist bereit für mehr!',
        durationMinutes: (targetMinutes * 0.4).round(),
        type: PracticeBlockType.newLesson,
        xmariSetup: completedModules < 5 ? XmariSetup.beginnerDefault : XmariSetup.overdriveRock,
      ),
      PracticeBlock(
        title: 'Song üben',
        description: 'Wende das Gelernte in einem echten Song an',
        durationMinutes: (targetMinutes * 0.2).round(),
        type: PracticeBlockType.song,
        xmariSetup: completedModules < 5 ? XmariSetup.beginnerDefault : XmariSetup.overdriveRock,
      ),
      PracticeBlock(
        title: 'Abkühlen',
        description: 'Langsames Spielen – entspannte Finger, Clean-Sound',
        durationMinutes: 1,
        type: PracticeBlockType.cooldown,
        xmariSetup: XmariSetup.beginnerDefault,
      ),
    ];

    final usedPresets = blocks.map((b) => b.xmariSetup.presetName).toSet();
    final requiresChanges = usedPresets.length > 1;

    return DailyPlan(
      blocks: blocks,
      totalMinutes: blocks.fold(0, (sum, b) => sum + b.durationMinutes),
      motivationalMessage: _motivationalMessage(completedModules),
      initialSetup: XmariSetup.beginnerDefault,
      requiresPresetChanges: requiresChanges,
    );
  }

  static String _motivationalMessage(int modules) {
    if (modules == 0) return 'Willkommen! Deine XMARI wartet auf dich 🎸';
    if (modules < 3) return 'Super Fortschritt! Weiter so!';
    if (modules < 6) return 'Du wirst immer besser – jeden Tag ein Stück weiter!';
    return 'Wow – schon $modules Module! Du bist ein echter XMARI-Profi!';
  }
}
