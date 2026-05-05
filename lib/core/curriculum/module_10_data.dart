import 'package:enya_gitarre_learn/core/models/exercise.dart';
import 'package:enya_gitarre_learn/core/models/lesson.dart';
import 'package:enya_gitarre_learn/core/models/module.dart';

/// Module 10 — "Musiktheorie & Songwriting" (Wochen 23-28, Schwierigkeit 7).
/// Alle Presets erlaubt; HIGH-GAIN wird in 10.5 freigeschaltet.
const String _moduleId = 'module-10';

final List<Lesson> module10Lessons = [
  Lesson(
    id: 'lesson-10-1',
    moduleId: _moduleId,
    title: 'Dur-Tonleiter G-Dur',
    description:
        'Die wichtigste Tonleiter überhaupt: Ganzton-Halbton-Schema in G-Dur.',
    instructions: [
      'Töne der G-Dur-Tonleiter: G - A - H - C - D - E - F# - G.',
      'Schema: Ganz - Ganz - Halb - Ganz - Ganz - Ganz - Halb.',
      'Spiele die Tonleiter auf der hohen E- und H-Saite.',
      'Auswendig lernen — sie ist die Basis für alles andere.',
    ],
    exercises: [
      Exercise(
        id: 'ex-10-1-1',
        lessonId: 'lesson-10-1',
        type: ExerciseType.scale,
        instructions: 'Spiele die G-Dur-Tonleiter auf und ab, 3 Durchgänge.',
        targetNoteOrChord: 'G,A,B,C,D,E,F#',
        noteSequence: ['G3', 'A3', 'B3', 'C4', 'D4', 'E4', 'F#4', 'G4'],
        bpm: 70,
        repetitionsRequired: 3,
        accuracyThreshold: 0.78,
        order: 1,
      ),
    ],
    xpReward: 140,
    difficulty: 6,
    targetAccuracy: 0.78,
    presetRequired: GuitarPreset.clean,
    scaleIds: const ['G-major'],
    order: 1,
    isUnlocked: true,
    estimatedMinutes: 12,
  ),
  Lesson(
    id: 'lesson-10-2',
    moduleId: _moduleId,
    title: 'Stufenakkorde I-ii-iii-IV-V-vi-vii°',
    description:
        'Jede Tonleiter hat 7 Akkorde — 3 Dur, 3 Moll und ein vermindertes. Entdecke die Familie der G-Dur-Tonart.',
    instructions: [
      'I = G (Dur), ii = Am (Moll), iii = Bm (Moll).',
      'IV = C (Dur), V = D (Dur), vi = Em (Moll).',
      'vii° = F#dim (vermindert).',
      'Spiele jeden Akkord nacheinander — die "Tonart-Familie".',
    ],
    exercises: [
      Exercise(
        id: 'ex-10-2-1',
        lessonId: 'lesson-10-2',
        type: ExerciseType.chord,
        instructions: 'Spiele G - Am - Bm - C - D - Em - F#dim - G.',
        targetNoteOrChord: 'G,Am,Bm,C,D,Em,F#dim',
        noteSequence: ['G', 'Am', 'Bm', 'C', 'D', 'Em', 'F#dim', 'G'],
        bpm: 70,
        repetitionsRequired: 2,
        accuracyThreshold: 0.74,
        timeoutSeconds: 120,
        order: 1,
      ),
    ],
    xpReward: 200,
    difficulty: 7,
    targetAccuracy: 0.74,
    presetRequired: GuitarPreset.clean,
    chordIds: const ['G', 'Am', 'Bm', 'C', 'D', 'Em', 'F#dim'],
    order: 2,
    estimatedMinutes: 18,
  ),
  Lesson(
    id: 'lesson-10-3',
    moduleId: _moduleId,
    title: 'Häufigste Akkordfolgen',
    description:
        'I-V-vi-IV ist die meistverwendete Akkordfolge der Popmusik. Lerne sie und tausende Songs.',
    instructions: [
      'I-V-vi-IV in G-Dur: G - D - Em - C.',
      'I-vi-IV-V (50er Jahre): G - Em - C - D.',
      'ii-V-I (Jazz): Am - D - G.',
      'Spiele jede Folge zwei Durchgänge.',
    ],
    exercises: [
      Exercise(
        id: 'ex-10-3-1',
        lessonId: 'lesson-10-3',
        type: ExerciseType.chord,
        instructions: 'Spiele I-V-vi-IV (G-D-Em-C) viermal sauber durch.',
        targetNoteOrChord: 'G,D,Em,C',
        noteSequence: ['G', 'D', 'Em', 'C'],
        bpm: 80,
        repetitionsRequired: 4,
        accuracyThreshold: 0.76,
        timeoutSeconds: 90,
        order: 1,
      ),
    ],
    xpReward: 200,
    difficulty: 6,
    targetAccuracy: 0.76,
    presetRequired: GuitarPreset.clean,
    chordIds: const ['G', 'D', 'Em', 'C'],
    order: 3,
    estimatedMinutes: 14,
  ),
  Lesson(
    id: 'lesson-10-4',
    moduleId: _moduleId,
    title: 'Melodie verstehen',
    description:
        'Eine Melodie ist eine geordnete Folge von Tönen aus der Tonleiter. Lerne, sie zu hören und zu spielen.',
    instructions: [
      'Wähle Töne der G-Dur-Tonleiter — sie passen zu G-Akkorden.',
      'Beginne und ende auf dem Grundton (G).',
      'Wechsle zwischen Schritt-Bewegung (Nachbartöne) und Sprüngen.',
      'Pausen sind genauso wichtig wie Töne.',
    ],
    exercises: [
      Exercise(
        id: 'ex-10-4-1',
        lessonId: 'lesson-10-4',
        type: ExerciseType.scale,
        instructions: 'Erfinde eine 8-Noten-Melodie in G-Dur und spiele sie 3x.',
        targetNoteOrChord: 'G,A,B,C,D,E,F#',
        bpm: 80,
        repetitionsRequired: 3,
        accuracyThreshold: 0.72,
        timeoutSeconds: 90,
        order: 1,
      ),
    ],
    xpReward: 180,
    difficulty: 6,
    targetAccuracy: 0.72,
    presetRequired: GuitarPreset.clean,
    scaleIds: const ['G-major'],
    order: 4,
    estimatedMinutes: 14,
  ),
  Lesson(
    id: 'lesson-10-5',
    moduleId: _moduleId,
    title: 'Songwriting-Tool + HIGH-GAIN',
    description:
        'Komponiere deinen ersten Song mit dem Songwriting-Tool — und schalte den HIGH-GAIN-Sound frei!',
    instructions: [
      'Wähle eine Akkordfolge (z. B. I-V-vi-IV).',
      'Lege ein Tempo und Strumming-Pattern fest.',
      'Setze einen Refrain mit anderer Akkordfolge dazwischen.',
      'Aktiviere den HIGH-GAIN-Sound für den ultimativen Metal-Vibe!',
    ],
    exercises: [
      Exercise(
        id: 'ex-10-5-1',
        lessonId: 'lesson-10-5',
        type: ExerciseType.chord,
        instructions: 'Spiele deine selbstkomponierte 8-Takt-Folge zweimal mit High-Gain.',
        targetNoteOrChord: 'G,D,Em,C',
        noteSequence: ['G', 'D', 'Em', 'C'],
        bpm: 90,
        repetitionsRequired: 2,
        accuracyThreshold: 0.72,
        timeoutSeconds: 120,
        order: 1,
      ),
    ],
    xpReward: 300,
    difficulty: 7,
    targetAccuracy: 0.72,
    presetRequired: GuitarPreset.highGain,
    chordIds: const ['G', 'D', 'Em', 'C'],
    order: 5,
    estimatedMinutes: 22,
  ),
];

final Module module10 = Module(
  id: _moduleId,
  moduleNumber: 10,
  title: 'Musiktheorie & Songwriting',
  description:
      'Verstehe Tonleitern, Stufenakkorde und Akkordfolgen — und schalte den High-Gain-Sound frei.',
  weekRange: 'Woche 23-28',
  presetRequired: GuitarPreset.clean,
  difficulty: 7,
  isLocked: true,
  unlockedPresets: const ['highGain'],
  learningGoals:
      'G-Dur-Tonleiter, Stufenakkorde, Akkordfolgen, Melodie, Songwriting, High-Gain freischalten.',
  lessons: module10Lessons,
);
