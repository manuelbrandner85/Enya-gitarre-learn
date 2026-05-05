import 'package:enya_gitarre_learn/core/models/exercise.dart';
import 'package:enya_gitarre_learn/core/models/lesson.dart';
import 'package:enya_gitarre_learn/core/models/module.dart';

/// Module 5 — "Offene Akkorde" (Wochen 5-8, Schwierigkeit 2).
/// Hauptpreset: CLEAN.
const String _moduleId = 'module-05';

final List<Lesson> module5Lessons = [
  // 5.1 — E-Moll – dein erster voller Akkord
  Lesson(
    id: 'lesson-5-1',
    moduleId: _moduleId,
    title: 'E-Moll – dein erster voller Akkord',
    description:
        'E-Moll ist der einfachste volle Akkord: zwei Finger, alle sechs Saiten klingen.',
    instructions: [
      'Lege Finger 1 (Zeigefinger) auf die A-Saite, Bund 2.',
      'Lege Finger 2 (Mittelfinger) auf die D-Saite, Bund 2.',
      'Schlage alle 6 Saiten von oben nach unten an.',
      'Achte darauf, dass jede Saite klar klingt — kein Schnarren.',
    ],
    exercises: [
      Exercise(
        id: 'ex-5-1-1',
        lessonId: 'lesson-5-1',
        type: ExerciseType.chord,
        instructions:
            'Greife E-Moll: Finger 1 auf A-Saite Bund 2, Finger 2 auf D-Saite Bund 2.',
        targetNoteOrChord: 'Em',
        bpm: 60,
        repetitionsRequired: 5,
        accuracyThreshold: 0.75,
        order: 1,
      ),
      Exercise(
        id: 'ex-5-1-2',
        lessonId: 'lesson-5-1',
        type: ExerciseType.chord,
        instructions:
            'Schlage alle 6 Saiten an und halte den Akkord 4 Sekunden.',
        targetNoteOrChord: 'Em',
        bpm: 60,
        repetitionsRequired: 4,
        accuracyThreshold: 0.78,
        timeoutSeconds: 30,
        order: 2,
      ),
      Exercise(
        id: 'ex-5-1-3',
        lessonId: 'lesson-5-1',
        type: ExerciseType.rhythm,
        instructions: 'Wechsel: zupfe E2 einzeln, dann greife Em und schlage an.',
        targetNoteOrChord: 'E2,Em',
        noteSequence: ['E2', 'Em'],
        bpm: 60,
        repetitionsRequired: 4,
        accuracyThreshold: 0.75,
        order: 3,
      ),
    ],
    xpReward: 60,
    difficulty: 2,
    targetAccuracy: 0.75,
    presetRequired: GuitarPreset.clean,
    chordIds: const ['Em'],
    order: 1,
    isUnlocked: true,
    estimatedMinutes: 10,
  ),

  // 5.2 — A-Moll – der melancholische Bruder
  Lesson(
    id: 'lesson-5-2',
    moduleId: _moduleId,
    title: 'A-Moll – der melancholische Bruder',
    description:
        'A-Moll: drei Finger, der klassisch melancholische Klang — ideal für ruhige Songs.',
    instructions: [
      'Zeigefinger auf H-Saite, Bund 1.',
      'Mittelfinger auf D-Saite, Bund 2.',
      'Ringfinger auf G-Saite, Bund 2.',
      'Schlage ab A-Saite an — tiefe E bleibt stumm.',
    ],
    exercises: [
      Exercise(
        id: 'ex-5-2-1',
        lessonId: 'lesson-5-2',
        type: ExerciseType.chord,
        instructions: 'Spiele Am fünfmal sauber mit klar klingenden Saiten.',
        targetNoteOrChord: 'Am',
        bpm: 60,
        repetitionsRequired: 5,
        accuracyThreshold: 0.75,
        order: 1,
      ),
      Exercise(
        id: 'ex-5-2-2',
        lessonId: 'lesson-5-2',
        type: ExerciseType.chord,
        instructions:
            'Wechsel Em → Am, 4 Takte je Akkord bei 60 BPM.',
        targetNoteOrChord: 'Em,Am',
        noteSequence: ['Em', 'Am', 'Em', 'Am', 'Em', 'Am', 'Em', 'Am'],
        bpm: 60,
        repetitionsRequired: 8,
        accuracyThreshold: 0.75,
        timeoutSeconds: 60,
        order: 2,
      ),
    ],
    xpReward: 70,
    difficulty: 2,
    targetAccuracy: 0.75,
    presetRequired: GuitarPreset.clean,
    chordIds: const ['Am', 'Em'],
    order: 2,
    estimatedMinutes: 12,
  ),

  // 5.3 — D-Dur – der fröhliche Dreiklang
  Lesson(
    id: 'lesson-5-3',
    moduleId: _moduleId,
    title: 'D-Dur – der fröhliche Dreiklang',
    description:
        'D-Dur: kompakte Dreiecksform auf den hohen Saiten — hell und fröhlich klingend.',
    instructions: [
      'Zeigefinger auf G-Saite, Bund 2.',
      'Mittelfinger auf hoher E-Saite, Bund 2.',
      'Ringfinger auf H-Saite, Bund 3.',
      'Schlage ab D-Saite — A und tiefe E bleiben stumm.',
    ],
    exercises: [
      Exercise(
        id: 'ex-5-3-1',
        lessonId: 'lesson-5-3',
        type: ExerciseType.chord,
        instructions: 'Spiele D-Dur fünfmal sauber.',
        targetNoteOrChord: 'D',
        bpm: 60,
        repetitionsRequired: 5,
        accuracyThreshold: 0.75,
        order: 1,
      ),
      Exercise(
        id: 'ex-5-3-2',
        lessonId: 'lesson-5-3',
        type: ExerciseType.strumming,
        instructions: 'Abschlag auf 1-2-3-4 — spiele D-Dur im 4/4-Takt bei 60 BPM.',
        targetNoteOrChord: 'D',
        pattern: 'D-D-D-D',
        bpm: 60,
        repetitionsRequired: 8,
        accuracyThreshold: 0.75,
        order: 2,
      ),
    ],
    xpReward: 70,
    difficulty: 2,
    targetAccuracy: 0.75,
    presetRequired: GuitarPreset.clean,
    chordIds: const ['D'],
    order: 3,
    estimatedMinutes: 12,
  ),

  // 5.4 — G-Dur – der große Griff
  Lesson(
    id: 'lesson-5-4',
    moduleId: _moduleId,
    title: 'G-Dur – der große Griff',
    description:
        'G-Dur: kraftvoller Akkord über alle sechs Saiten — Herzstück unzähliger Songs.',
    instructions: [
      'Mittelfinger auf tiefer E-Saite, Bund 3.',
      'Zeigefinger auf A-Saite, Bund 2.',
      'Ringfinger auf hoher E-Saite, Bund 3.',
      'D-, G- und H-Saite bleiben offen.',
    ],
    exercises: [
      Exercise(
        id: 'ex-5-4-1',
        lessonId: 'lesson-5-4',
        type: ExerciseType.chord,
        instructions: 'Spiele G-Dur fünfmal — alle sechs Saiten müssen klingen.',
        targetNoteOrChord: 'G',
        bpm: 60,
        repetitionsRequired: 5,
        accuracyThreshold: 0.75,
        order: 1,
      ),
      Exercise(
        id: 'ex-5-4-2',
        lessonId: 'lesson-5-4',
        type: ExerciseType.chord,
        instructions:
            'Em → G Wechsel (häufigster Pop-Wechsel) — 8 Wechsel bei 60 BPM.',
        targetNoteOrChord: 'Em,G',
        noteSequence: ['Em', 'G', 'Em', 'G', 'Em', 'G', 'Em', 'G'],
        bpm: 60,
        repetitionsRequired: 8,
        accuracyThreshold: 0.75,
        timeoutSeconds: 60,
        order: 2,
      ),
    ],
    xpReward: 80,
    difficulty: 2,
    targetAccuracy: 0.75,
    presetRequired: GuitarPreset.clean,
    chordIds: const ['G', 'Em'],
    order: 4,
    estimatedMinutes: 15,
  ),

  // 5.5 — C-Dur – der König der Akkorde
  Lesson(
    id: 'lesson-5-5',
    moduleId: _moduleId,
    title: 'C-Dur – der König der Akkorde',
    description:
        'C-Dur: klassische Dreifinger-Form — heller, freundlicher Klang.',
    instructions: [
      'Ringfinger auf A-Saite, Bund 3.',
      'Mittelfinger auf D-Saite, Bund 2.',
      'Zeigefinger auf H-Saite, Bund 1.',
      'Schlage ab A-Saite an — tiefe E bleibt stumm.',
    ],
    exercises: [
      Exercise(
        id: 'ex-5-5-1',
        lessonId: 'lesson-5-5',
        type: ExerciseType.chord,
        instructions: 'Spiele C-Dur fünfmal sauber.',
        targetNoteOrChord: 'C',
        bpm: 60,
        repetitionsRequired: 5,
        accuracyThreshold: 0.75,
        order: 1,
      ),
      Exercise(
        id: 'ex-5-5-2',
        lessonId: 'lesson-5-5',
        type: ExerciseType.chord,
        instructions:
            'Vier-Akkord-Progression: G → Em → C → D — je 4 Schläge bei 60 BPM.',
        targetNoteOrChord: 'G,Em,C,D',
        noteSequence: ['G', 'Em', 'C', 'D'],
        bpm: 60,
        repetitionsRequired: 4,
        accuracyThreshold: 0.75,
        timeoutSeconds: 90,
        order: 2,
      ),
    ],
    xpReward: 80,
    difficulty: 2,
    targetAccuracy: 0.75,
    presetRequired: GuitarPreset.clean,
    chordIds: const ['C', 'G', 'Em', 'D'],
    order: 5,
    estimatedMinutes: 15,
  ),

  // 5.6 — Dein erster Song mit offenen Akkorden
  Lesson(
    id: 'lesson-5-6',
    moduleId: _moduleId,
    title: 'Dein erster Song mit offenen Akkorden',
    description:
        "Bob Dylans Knockin' on Heaven's Door — nur drei Akkorde, und du spielst deinen ersten Song.",
    instructions: [
      "Akkordfolge: G → D → Am (Vers 1) und G → D → C (Vers 2).",
      'Starte langsam bei 50 BPM und steigere auf Originaltempo 66 BPM.',
      'Spiele Abschläge auf jeden Beat — ruhig und gleichmäßig.',
      'Genießen erlaubt!',
    ],
    exercises: [
      Exercise(
        id: 'ex-5-6-1',
        lessonId: 'lesson-5-6',
        type: ExerciseType.chord,
        instructions:
            "Knockin' on Heaven's Door – langsam (50 BPM): G → D → Am.",
        targetNoteOrChord: 'G,D,Am',
        noteSequence: ['G', 'D', 'Am'],
        bpm: 50,
        repetitionsRequired: 4,
        accuracyThreshold: 0.75,
        timeoutSeconds: 120,
        order: 1,
      ),
      Exercise(
        id: 'ex-5-6-2',
        lessonId: 'lesson-5-6',
        type: ExerciseType.chord,
        instructions:
            "Knockin' on Heaven's Door – Originaltempo (66 BPM): G → D → C.",
        targetNoteOrChord: 'G,D,C',
        noteSequence: ['G', 'D', 'C'],
        bpm: 66,
        repetitionsRequired: 4,
        accuracyThreshold: 0.75,
        timeoutSeconds: 120,
        order: 2,
      ),
    ],
    xpReward: 100,
    difficulty: 3,
    targetAccuracy: 0.75,
    presetRequired: GuitarPreset.clean,
    chordIds: const ['G', 'D', 'Am', 'C'],
    order: 6,
    estimatedMinutes: 20,
  ),
];

final Module module5 = Module(
  id: _moduleId,
  moduleNumber: 5,
  title: 'Offene Akkorde',
  description:
      'Lerne die wichtigsten offenen Akkorde — Em, Am, D, G, C — und spiele deinen ersten Song.',
  weekRange: 'Woche 5-8',
  presetRequired: GuitarPreset.clean,
  difficulty: 2,
  isLocked: true,
  unlockedPresets: const [],
  learningGoals:
      'Em, Am, D-Dur, G-Dur, C-Dur lernen, Akkordwechsel üben, Knockin on Heavens Door spielen.',
  lessons: module5Lessons,
);
