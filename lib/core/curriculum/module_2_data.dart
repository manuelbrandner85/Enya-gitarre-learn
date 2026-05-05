import 'package:enya_gitarre_learn/core/models/exercise.dart';
import 'package:enya_gitarre_learn/core/models/lesson.dart';
import 'package:enya_gitarre_learn/core/models/module.dart';

/// Module 2 — "Das Griffbrett verstehen" (Week 2, Difficulty 2, Clean preset).
const String _moduleId = 'module-02';

final List<Lesson> module2Lessons = [
  // 2.1 — Offene Saiten benennen
  Lesson(
    id: 'lesson-2-1',
    moduleId: _moduleId,
    title: 'Offene Saiten benennen',
    description:
        'Lerne die Namen aller sechs offenen Saiten in Standardstimmung: E-A-D-G-B-E.',
    instructions: [
      'Die tiefste (dickste) Saite ist die tiefe E-Saite.',
      'Es folgen A, D, G, B, und die hohe E-Saite.',
      'Eselsbrücke: "Eine Alte Dame Geht Bier Einkaufen".',
      'Spiele jede Saite einzeln und sprich den Namen laut aus.',
    ],
    exercises: [
      Exercise(
        id: 'ex-2-1-1',
        lessonId: 'lesson-2-1',
        type: ExerciseType.singleNote,
        instructions:
            'Spiele alle sechs offenen Saiten der Reihe nach: E, A, D, G, B, E.',
        targetNoteOrChord: 'E2,A2,D3,G3,B3,E4',
        noteSequence: ['E2', 'A2', 'D3', 'G3', 'B3', 'E4'],
        bpm: 60,
        repetitionsRequired: 3,
        accuracyThreshold: 0.80,
        order: 1,
      ),
    ],
    xpReward: 60,
    difficulty: 2,
    targetAccuracy: 0.80,
    presetRequired: GuitarPreset.clean,
    order: 1,
    isUnlocked: true,
    estimatedMinutes: 6,
  ),

  // 2.2 — Tiefe E-Saite, Bund 1-5
  Lesson(
    id: 'lesson-2-2',
    moduleId: _moduleId,
    title: 'Noten auf der tiefen E-Saite',
    description:
        'Lerne F, F#, G, G# und A in den ersten fünf Bünden der tiefen E-Saite.',
    instructions: [
      'Bund 1 = F, Bund 2 = F#, Bund 3 = G, Bund 4 = G#, Bund 5 = A.',
      'Spiele jede Note langsam und sprich ihren Namen aus.',
      'Wiederhole die Reihe mehrmals, bis sie sicher sitzt.',
    ],
    exercises: [
      Exercise(
        id: 'ex-2-2-1',
        lessonId: 'lesson-2-2',
        type: ExerciseType.singleNote,
        instructions: 'Spiele F, F#, G, G#, A nacheinander auf der tiefen E-Saite.',
        targetNoteOrChord: 'F2,F#2,G2,G#2,A2',
        noteSequence: ['F2', 'F#2', 'G2', 'G#2', 'A2'],
        bpm: 60,
        repetitionsRequired: 5,
        accuracyThreshold: 0.80,
        order: 1,
      ),
    ],
    xpReward: 70,
    difficulty: 2,
    targetAccuracy: 0.80,
    presetRequired: GuitarPreset.clean,
    order: 2,
    estimatedMinutes: 8,
  ),

  // 2.3 — A-Saite, Bund 1-5
  Lesson(
    id: 'lesson-2-3',
    moduleId: _moduleId,
    title: 'Noten auf der A-Saite',
    description:
        'Bund 1-5 auf der A-Saite: A#/Bb, B, C, C#/Db, D — wichtige Töne für Power Chords.',
    instructions: [
      'Bund 1 = A#, Bund 2 = B, Bund 3 = C, Bund 4 = C#, Bund 5 = D.',
      'Diese Töne sind die Wurzeln vieler Power Chords.',
      'Spiele die Reihe langsam und nenne dabei die Tonnamen.',
    ],
    exercises: [
      Exercise(
        id: 'ex-2-3-1',
        lessonId: 'lesson-2-3',
        type: ExerciseType.singleNote,
        instructions: 'Spiele A#, B, C, C#, D auf der A-Saite.',
        targetNoteOrChord: 'A#2,B2,C3,C#3,D3',
        noteSequence: ['A#2', 'B2', 'C3', 'C#3', 'D3'],
        bpm: 60,
        repetitionsRequired: 5,
        accuracyThreshold: 0.80,
        order: 1,
      ),
    ],
    xpReward: 70,
    difficulty: 2,
    targetAccuracy: 0.80,
    presetRequired: GuitarPreset.clean,
    order: 3,
    estimatedMinutes: 8,
  ),

  // 2.4 — Noten-Jagd
  Lesson(
    id: 'lesson-2-4',
    moduleId: _moduleId,
    title: 'Noten-Jagd-Spiel',
    description:
        'Wir nennen dir eine Note — du findest sie so schnell wie möglich auf dem Griffbrett.',
    instructions: [
      'Konzentriere dich auf die Saiten E und A in den Bünden 0-5.',
      'Versuche jede Note innerhalb von 3 Sekunden zu treffen.',
      'Tempo schlägt Genauigkeit — aber nicht zu hektisch werden.',
    ],
    exercises: [
      Exercise(
        id: 'ex-2-4-1',
        lessonId: 'lesson-2-4',
        type: ExerciseType.earTraining,
        instructions:
            'Spiele die zufällig genannte Note innerhalb von 3 Sekunden — 10 Runden.',
        targetNoteOrChord: 'random',
        bpm: 60,
        repetitionsRequired: 10,
        accuracyThreshold: 0.70,
        timeoutSeconds: 90,
        order: 1,
      ),
    ],
    xpReward: 90,
    difficulty: 3,
    targetAccuracy: 0.70,
    presetRequired: GuitarPreset.clean,
    order: 4,
    estimatedMinutes: 10,
  ),

  // 2.5 — Seven Nation Army auf der A-Saite
  Lesson(
    id: 'lesson-2-5',
    moduleId: _moduleId,
    title: 'Seven Nation Army (A-Saite)',
    description:
        'Das ikonische Riff von The White Stripes — komplett auf der A-Saite spielbar.',
    instructions: [
      'Alle Töne werden auf der A-Saite gespielt.',
      'Sequenz: 7 → 7 → 10 → 7 → 5 → 3 → 2 (E E G E D C B).',
      'Beginne langsam und achte auf gleichmäßiges Timing.',
    ],
    exercises: [
      Exercise(
        id: 'ex-2-5-1',
        lessonId: 'lesson-2-5',
        type: ExerciseType.rhythm,
        instructions:
            'Spiele das Seven Nation Army Riff dreimal sauber durch.',
        targetNoteOrChord: 'E3,E3,G3,E3,D3,C3,B2',
        noteSequence: ['E3', 'E3', 'G3', 'E3', 'D3', 'C3', 'B2'],
        bpm: 80,
        repetitionsRequired: 3,
        accuracyThreshold: 0.80,
        timeoutSeconds: 90,
        order: 1,
      ),
    ],
    xpReward: 130,
    difficulty: 3,
    targetAccuracy: 0.80,
    presetRequired: GuitarPreset.clean,
    order: 5,
    estimatedMinutes: 12,
  ),
];

final Module module2 = Module(
  id: _moduleId,
  moduleNumber: 2,
  title: 'Das Griffbrett verstehen',
  description:
      'Erkenne die Töne auf den tiefen Saiten — die Grundlage für Power Chords.',
  weekRange: 'Woche 2',
  presetRequired: GuitarPreset.clean,
  difficulty: 2,
  isLocked: true,
  unlockedPresets: const [],
  learningGoals:
      'Offene Saiten, Bünde 1-5 auf E und A, schnelles Notenfinden, klassisches Riff.',
  lessons: module2Lessons,
);
