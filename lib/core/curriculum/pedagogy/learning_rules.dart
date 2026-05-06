import '../../../core/bluetooth/xmari_constants.dart';

enum NewElement { newNote, newFinger, newString, newRhythm, newTechnique, newChord }

class XmariSetup {
  final String presetName;
  final int presetIndex;
  final String pickupPosition;
  final int pickupIndex;
  final String? toneKnobSuggestion;
  final String explanation;
  final bool requiresHeadphones;

  const XmariSetup({
    required this.presetName,
    required this.presetIndex,
    required this.pickupPosition,
    required this.pickupIndex,
    this.toneKnobSuggestion,
    required this.explanation,
    this.requiresHeadphones = false,
  });

  static const XmariSetup beginnerDefault = XmariSetup(
    presetName: 'Clean',
    presetIndex: 0,
    pickupPosition: 'Position 4',
    pickupIndex: 4,
    toneKnobSuggestion: 'Tone-Regler auf ca. 7',
    explanation: 'Clean-Sound am Hals-Pickup – der weichste, freundlichste Ton für Anfänger.',
    requiresHeadphones: false,
  );

  static const XmariSetup overdriveRock = XmariSetup(
    presetName: 'Overdrive',
    presetIndex: 1,
    pickupPosition: 'Position 3',
    pickupIndex: 3,
    explanation: 'Overdrive-Sound für Rock und Blues – warm mit leichter Verzerrung.',
  );

  static const XmariSetup distortionMetal = XmariSetup(
    presetName: 'Distortion',
    presetIndex: 2,
    pickupPosition: 'Position 1',
    pickupIndex: 1,
    explanation: 'Distortion am Bridge-Pickup – aggressiver Sound für Metal und Hard Rock.',
  );
}

class LessonPedagogyInfo {
  final NewElement primaryElement;
  final List<String> prerequisites;
  final int maxFingers;
  final bool requiresPreviousLessonComplete;
  final XmariSetup xmariSetup;

  const LessonPedagogyInfo({
    required this.primaryElement,
    required this.prerequisites,
    required this.maxFingers,
    required this.requiresPreviousLessonComplete,
    required this.xmariSetup,
  });
}

class LearningRules {
  LearningRules._();

  static const int maxNewElementsPerLesson = 1;

  static const Map<String, LessonPedagogyInfo> lessonPedagogy = {
    'lesson-01': LessonPedagogyInfo(
      primaryElement: NewElement.newNote,
      prerequisites: [],
      maxFingers: 0,
      requiresPreviousLessonComplete: false,
      xmariSetup: XmariSetup.beginnerDefault,
    ),
    'lesson-02': LessonPedagogyInfo(
      primaryElement: NewElement.newString,
      prerequisites: ['lesson-01'],
      maxFingers: 0,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.beginnerDefault,
    ),
    'lesson-03': LessonPedagogyInfo(
      primaryElement: NewElement.newString,
      prerequisites: ['lesson-02'],
      maxFingers: 0,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.beginnerDefault,
    ),
    'lesson-04': LessonPedagogyInfo(
      primaryElement: NewElement.newFinger,
      prerequisites: ['lesson-03'],
      maxFingers: 1,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.beginnerDefault,
    ),
    'lesson-05': LessonPedagogyInfo(
      primaryElement: NewElement.newNote,
      prerequisites: ['lesson-04'],
      maxFingers: 1,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.beginnerDefault,
    ),
    'lesson-06': LessonPedagogyInfo(
      primaryElement: NewElement.newFinger,
      prerequisites: ['lesson-05'],
      maxFingers: 2,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.beginnerDefault,
    ),
    'lesson-07': LessonPedagogyInfo(
      primaryElement: NewElement.newRhythm,
      prerequisites: ['lesson-06'],
      maxFingers: 2,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.beginnerDefault,
    ),
    'lesson-08': LessonPedagogyInfo(
      primaryElement: NewElement.newTechnique,
      prerequisites: ['lesson-07'],
      maxFingers: 2,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.beginnerDefault,
    ),
    'lesson-09': LessonPedagogyInfo(
      primaryElement: NewElement.newChord,
      prerequisites: ['lesson-08'],
      maxFingers: 3,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.beginnerDefault,
    ),
    'lesson-10': LessonPedagogyInfo(
      primaryElement: NewElement.newChord,
      prerequisites: ['lesson-09'],
      maxFingers: 3,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.beginnerDefault,
    ),
  };
}
