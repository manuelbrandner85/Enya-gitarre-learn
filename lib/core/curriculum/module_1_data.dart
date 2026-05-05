import 'package:enya_gitarre_learn/core/models/exercise.dart';
import 'package:enya_gitarre_learn/core/models/lesson.dart';
import 'package:enya_gitarre_learn/core/models/module.dart';

/// Module 1 — "Dein erster Ton" (Week 1, Difficulty 1, Clean preset).
///
/// Five short lessons that take a complete beginner from holding the guitar
/// to playing a simplified Smoke on the Water riff on a single string.
const String _moduleId = 'module-01';

final List<Lesson> module1Lessons = [
  // 1.1 — Eine Note spielen
  Lesson(
    id: 'lesson-1-1',
    moduleId: _moduleId,
    title: 'Eine Note spielen',
    description:
        'Spiele die Note G auf der hohen E-Saite (Saite 1, Bund 3) und höre auf einen sauberen, klaren Klang.',
    instructions: [
      'Halte die Gitarre aufrecht und entspannt vor dir.',
      'Lege deinen Ringfinger leicht hinter den 3. Bund auf die hohe E-Saite.',
      'Drücke fest genug, dass die Saite den Bund berührt — aber nicht zu fest.',
      'Zupfe die Saite einmal mit dem Daumen oder Plektrum.',
      'Lass den Ton frei klingen und höre genau hin: Klingt er sauber?',
    ],
    exercises: [
      Exercise(
        id: 'ex-1-1-1',
        lessonId: 'lesson-1-1',
        type: ExerciseType.singleNote,
        instructions: 'Spiele die Note G fünf Mal in Folge.',
        targetNoteOrChord: 'G3',
        bpm: 60,
        repetitionsRequired: 5,
        accuracyThreshold: 0.70,
        order: 1,
      ),
      Exercise(
        id: 'ex-1-1-2',
        lessonId: 'lesson-1-1',
        type: ExerciseType.singleNote,
        instructions: 'Spiele G zehn Mal — diesmal mit höherer Genauigkeit.',
        targetNoteOrChord: 'G3',
        bpm: 60,
        repetitionsRequired: 10,
        accuracyThreshold: 0.80,
        order: 2,
      ),
    ],
    xpReward: 50,
    difficulty: 1,
    targetAccuracy: 0.70,
    presetRequired: GuitarPreset.clean,
    order: 1,
    isUnlocked: true,
    estimatedMinutes: 5,
  ),

  // 1.2 — Alternate Picking
  Lesson(
    id: 'lesson-1-2',
    moduleId: _moduleId,
    title: 'Alternate Picking',
    description:
        'Wechsle gleichmäßig zwischen Abschlag und Aufschlag — die Grundlage für sauberes Spielen.',
    instructions: [
      'Halte das Plektrum locker zwischen Daumen und Zeigefinger.',
      'Spiele die G-Note: ein Abschlag (↓) und ein Aufschlag (↑).',
      'Achte auf gleichmäßige Lautstärke bei beiden Richtungen.',
      'Bleibe entspannt — die Bewegung kommt aus dem Handgelenk.',
    ],
    exercises: [
      Exercise(
        id: 'ex-1-2-1',
        lessonId: 'lesson-1-2',
        type: ExerciseType.rhythm,
        instructions:
            'Spiele 16 Mal abwechselnd Abschlag/Aufschlag im Tempo 60 BPM.',
        targetNoteOrChord: 'G3',
        bpm: 60,
        repetitionsRequired: 16,
        accuracyThreshold: 0.75,
        order: 1,
      ),
    ],
    xpReward: 60,
    difficulty: 1,
    targetAccuracy: 0.75,
    presetRequired: GuitarPreset.clean,
    order: 2,
    estimatedMinutes: 7,
  ),

  // 1.3 — Drei Noten auf einer Saite
  Lesson(
    id: 'lesson-1-3',
    moduleId: _moduleId,
    title: 'Drei Noten auf einer Saite',
    description:
        'Spiele F, F# und G nacheinander auf der hohen E-Saite (Bünde 1, 2, 3).',
    instructions: [
      'Lege deinen Zeigefinger auf Bund 1: Note F.',
      'Setze deinen Mittelfinger auf Bund 2: Note F#.',
      'Setze deinen Ringfinger auf Bund 3: Note G.',
      'Spiele die Sequenz F → F# → G langsam und sauber.',
      'Hebe nicht alle Finger ab — lass sie auf den Bünden liegen.',
    ],
    exercises: [
      Exercise(
        id: 'ex-1-3-1',
        lessonId: 'lesson-1-3',
        type: ExerciseType.singleNote,
        instructions: 'Spiele F, F#, G fünf Mal hintereinander.',
        targetNoteOrChord: 'F3,F#3,G3',
        noteSequence: ['F3', 'F#3', 'G3'],
        bpm: 60,
        repetitionsRequired: 5,
        accuracyThreshold: 0.75,
        order: 1,
      ),
    ],
    xpReward: 70,
    difficulty: 1,
    targetAccuracy: 0.75,
    presetRequired: GuitarPreset.clean,
    order: 3,
    estimatedMinutes: 8,
  ),

  // 1.4 — Die 1-2-3-4 Fingerübung
  Lesson(
    id: 'lesson-1-4',
    moduleId: _moduleId,
    title: 'Die 1-2-3-4 Fingerübung',
    description:
        'Klassische chromatische Übung — alle vier Finger nacheinander auf jeder Saite.',
    instructions: [
      'Beginne auf der tiefen E-Saite, Bund 1 mit dem Zeigefinger.',
      'Spiele Bund 1, 2, 3, 4 mit Fingern 1-2-3-4 nacheinander.',
      'Wechsle dann zur A-Saite und wiederhole das Muster.',
      'Halte das Tempo konstant bei 60 BPM.',
    ],
    exercises: [
      Exercise(
        id: 'ex-1-4-1',
        lessonId: 'lesson-1-4',
        type: ExerciseType.scale,
        instructions:
            'Spiele 1-2-3-4 auf jeder der sechs Saiten im Tempo 60 BPM.',
        targetNoteOrChord: 'chromatic',
        bpm: 60,
        repetitionsRequired: 6,
        accuracyThreshold: 0.75,
        timeoutSeconds: 60,
        order: 1,
      ),
    ],
    xpReward: 80,
    difficulty: 2,
    targetAccuracy: 0.75,
    presetRequired: GuitarPreset.clean,
    order: 4,
    estimatedMinutes: 10,
  ),

  // 1.5 — Smoke on the Water Riff (vereinfacht)
  Lesson(
    id: 'lesson-1-5',
    moduleId: _moduleId,
    title: 'Smoke on the Water Riff',
    description:
        'Spiele eine vereinfachte Einzeltonversion des wohl berühmtesten Rock-Riffs.',
    instructions: [
      'Alle Töne werden auf der D-Saite gespielt (Saite 3).',
      'Sequenz: 0 → 3 → 5 — Pause — 0 → 3 → 6 → 5.',
      'Spiele zunächst sehr langsam und steigere das Tempo schrittweise.',
      'Achte auf gleichmäßiges Timing — der Groove macht das Riff aus.',
    ],
    exercises: [
      Exercise(
        id: 'ex-1-5-1',
        lessonId: 'lesson-1-5',
        type: ExerciseType.rhythm,
        instructions:
            'Spiele das vereinfachte Smoke on the Water Riff zweimal sauber durch.',
        targetNoteOrChord: 'D3,F3,G3,D3,F3,G#3,G3',
        noteSequence: ['D3', 'F3', 'G3', 'D3', 'F3', 'G#3', 'G3'],
        bpm: 80,
        repetitionsRequired: 2,
        accuracyThreshold: 0.80,
        timeoutSeconds: 60,
        order: 1,
      ),
    ],
    xpReward: 150,
    difficulty: 2,
    targetAccuracy: 0.80,
    presetRequired: GuitarPreset.clean,
    order: 5,
    estimatedMinutes: 12,
  ),
];

final Module module1 = Module(
  id: _moduleId,
  moduleNumber: 1,
  title: 'Dein erster Ton',
  description:
      'Lerne, einen sauberen Einzelton zu spielen, und schließe mit deinem ersten Riff ab.',
  weekRange: 'Woche 1',
  presetRequired: GuitarPreset.clean,
  difficulty: 1,
  isLocked: false,
  unlockedPresets: const ['clean'],
  learningGoals:
      'Einzelton sauber spielen, Alternate Picking, chromatische Übung, einfaches Riff.',
  lessons: module1Lessons,
);
