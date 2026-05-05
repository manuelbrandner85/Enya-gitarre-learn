import 'package:enya_gitarre_learn/core/models/exercise.dart';
import 'package:enya_gitarre_learn/core/models/lesson.dart';
import 'package:enya_gitarre_learn/core/models/module.dart';

/// Module 3 — "Intervalle" (Week 3, Difficulty 3, Clean preset).
const String _moduleId = 'module-03';

final List<Lesson> module3Lessons = [
  // 3.1 — Grundton
  Lesson(
    id: 'lesson-3-1',
    moduleId: _moduleId,
    title: 'Der Grundton',
    description:
        'Der Grundton ist das Fundament jeder Skala und jedes Akkords. Lerne, ihn zu erkennen.',
    instructions: [
      'Der Grundton (Tonika) ist die "Heimatnote" einer Tonart.',
      'Spiele A2 (A-Saite, offen) — das ist der Grundton in A.',
      'Höre genau hin: Grundtöne klingen entspannt und "zuhause".',
    ],
    exercises: [
      Exercise(
        id: 'ex-3-1-1',
        lessonId: 'lesson-3-1',
        type: ExerciseType.singleNote,
        instructions: 'Spiele den Grundton A fünf Mal sauber.',
        targetNoteOrChord: 'A2',
        bpm: 60,
        repetitionsRequired: 5,
        accuracyThreshold: 0.80,
        order: 1,
      ),
    ],
    xpReward: 60,
    difficulty: 3,
    targetAccuracy: 0.80,
    presetRequired: GuitarPreset.clean,
    order: 1,
    isUnlocked: true,
    estimatedMinutes: 6,
  ),

  // 3.2 — Sekunde
  Lesson(
    id: 'lesson-3-2',
    moduleId: _moduleId,
    title: 'Die Sekunde',
    description:
        'Eine Sekunde ist der Abstand von zwei Halbtonschritten — z. B. von A nach H.',
    instructions: [
      'Eine große Sekunde = 2 Halbtöne.',
      'Spiele A (A-Saite offen) und dann H (A-Saite, Bund 2).',
      'Höre den Unterschied: Sekunden klingen leicht spannungsvoll.',
    ],
    exercises: [
      Exercise(
        id: 'ex-3-2-1',
        lessonId: 'lesson-3-2',
        type: ExerciseType.singleNote,
        instructions: 'Spiele A und H abwechselnd, fünf Paare.',
        targetNoteOrChord: 'A2,B2',
        noteSequence: ['A2', 'B2'],
        bpm: 60,
        repetitionsRequired: 5,
        accuracyThreshold: 0.80,
        order: 1,
      ),
    ],
    xpReward: 70,
    difficulty: 3,
    targetAccuracy: 0.80,
    presetRequired: GuitarPreset.clean,
    order: 2,
    estimatedMinutes: 7,
  ),

  // 3.3 — Terz
  Lesson(
    id: 'lesson-3-3',
    moduleId: _moduleId,
    title: 'Die Terz',
    description:
        'Die Terz entscheidet, ob ein Akkord Dur oder Moll klingt — der wichtigste Intervalltyp.',
    instructions: [
      'Große Terz (Dur) = 4 Halbtöne — klingt fröhlich.',
      'Kleine Terz (Moll) = 3 Halbtöne — klingt traurig.',
      'Spiele A → C# (große Terz) und A → C (kleine Terz).',
    ],
    exercises: [
      Exercise(
        id: 'ex-3-3-1',
        lessonId: 'lesson-3-3',
        type: ExerciseType.singleNote,
        instructions: 'Spiele A → C# und A → C, je dreimal.',
        targetNoteOrChord: 'A2,C#3,A2,C3',
        noteSequence: ['A2', 'C#3', 'A2', 'C3'],
        bpm: 60,
        repetitionsRequired: 3,
        accuracyThreshold: 0.80,
        order: 1,
      ),
    ],
    xpReward: 80,
    difficulty: 3,
    targetAccuracy: 0.80,
    presetRequired: GuitarPreset.clean,
    order: 3,
    estimatedMinutes: 8,
  ),

  // 3.4 — Quinte
  Lesson(
    id: 'lesson-3-4',
    moduleId: _moduleId,
    title: 'Die Quinte',
    description:
        'Die Quinte ist das stabilste Intervall und das Fundament aller Power Chords.',
    instructions: [
      'Reine Quinte = 7 Halbtöne.',
      'Spiele A (offen) und E (D-Saite, Bund 2) — das ist eine Quinte.',
      'Quinten klingen offen, kraftvoll und "leer".',
    ],
    exercises: [
      Exercise(
        id: 'ex-3-4-1',
        lessonId: 'lesson-3-4',
        type: ExerciseType.singleNote,
        instructions: 'Spiele Grundton und Quinte abwechselnd, fünfmal.',
        targetNoteOrChord: 'A2,E3',
        noteSequence: ['A2', 'E3'],
        bpm: 60,
        repetitionsRequired: 5,
        accuracyThreshold: 0.80,
        order: 1,
      ),
    ],
    xpReward: 90,
    difficulty: 3,
    targetAccuracy: 0.80,
    presetRequired: GuitarPreset.clean,
    order: 4,
    estimatedMinutes: 8,
  ),

  // 3.5 — Intervall-Hörtraining
  Lesson(
    id: 'lesson-3-5',
    moduleId: _moduleId,
    title: 'Intervall-Hörtraining',
    description:
        'Höre dir Intervalle an und identifiziere, ob es sich um Sekunde, Terz oder Quinte handelt.',
    instructions: [
      'Du hörst zwei Töne hintereinander.',
      'Wähle aus: Sekunde, kleine Terz, große Terz oder Quinte.',
      'Vergleiche das Gehörte mit den Beispielen aus den vorigen Lektionen.',
    ],
    exercises: [
      Exercise(
        id: 'ex-3-5-1',
        lessonId: 'lesson-3-5',
        type: ExerciseType.earTraining,
        instructions: 'Erkenne 10 Intervalle korrekt.',
        targetNoteOrChord: 'random_interval',
        bpm: 60,
        repetitionsRequired: 10,
        accuracyThreshold: 0.70,
        timeoutSeconds: 120,
        order: 1,
      ),
    ],
    xpReward: 120,
    difficulty: 4,
    targetAccuracy: 0.70,
    presetRequired: GuitarPreset.clean,
    order: 5,
    estimatedMinutes: 12,
  ),
];

final Module module3 = Module(
  id: _moduleId,
  moduleNumber: 3,
  title: 'Intervalle',
  description:
      'Verstehe die Bausteine der Musik: Grundton, Sekunde, Terz, Quinte und ihr Klangcharakter.',
  weekRange: 'Woche 3',
  presetRequired: GuitarPreset.clean,
  difficulty: 3,
  isLocked: true,
  unlockedPresets: const [],
  learningGoals:
      'Grundton, Sekunde, Terz, Quinte erkennen und spielen, Gehörtraining.',
  lessons: module3Lessons,
);
