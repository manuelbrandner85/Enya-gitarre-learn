import 'package:enya_gitarre_learn/core/models/exercise.dart';
import 'package:enya_gitarre_learn/core/models/lesson.dart';
import 'package:enya_gitarre_learn/core/models/module.dart';

/// Module 4 — "Dein erster Power Chord" (Week 4, Difficulty 4).
///
/// Starts on Clean and unlocks the OVERDRIVE preset in lesson 4.4.
const String _moduleId = 'module-04';

final List<Lesson> module4Lessons = [
  // 4.1 — Zwei-Noten-Power-Chord
  Lesson(
    id: 'lesson-4-1',
    moduleId: _moduleId,
    title: 'Zwei-Noten-Power-Chord',
    description:
        'Spiele E5 — den einfachsten Power Chord — mit nur zwei Noten auf der tiefen E- und A-Saite.',
    instructions: [
      'Tiefe E-Saite offen + A-Saite, Bund 2 (Note H) = E5 Power Chord.',
      'Lege deinen Ringfinger auf die A-Saite, Bund 2.',
      'Schlage beide Saiten gleichzeitig an — höher liegende Saiten dämpfen.',
      'Höre den vollen, kraftvollen Klang einer Quinte.',
    ],
    exercises: [
      Exercise(
        id: 'ex-4-1-1',
        lessonId: 'lesson-4-1',
        type: ExerciseType.chord,
        instructions: 'Spiele E5 fünfmal sauber an.',
        targetNoteOrChord: 'E5',
        bpm: 60,
        repetitionsRequired: 5,
        accuracyThreshold: 0.80,
        order: 1,
      ),
    ],
    xpReward: 80,
    difficulty: 3,
    targetAccuracy: 0.80,
    presetRequired: GuitarPreset.clean,
    chordIds: const ['E5'],
    order: 1,
    isUnlocked: true,
    estimatedMinutes: 8,
  ),

  // 4.2 — Power Chord verschieben
  Lesson(
    id: 'lesson-4-2',
    moduleId: _moduleId,
    title: 'Power Chord verschieben',
    description:
        'Verschiebe die Power-Chord-Form über das Griffbrett — derselbe Griff, neue Töne.',
    instructions: [
      'Greife den Power Chord auf den Bünden 1+3 (F5).',
      'Verschiebe die Form auf 3+5 (G5), dann 5+7 (A5).',
      'Die Form bleibt gleich — nur die Position ändert sich.',
    ],
    exercises: [
      Exercise(
        id: 'ex-4-2-1',
        lessonId: 'lesson-4-2',
        type: ExerciseType.chord,
        instructions: 'Spiele F5, G5, A5 nacheinander, drei Durchgänge.',
        targetNoteOrChord: 'F5,G5,A5',
        noteSequence: ['F5', 'G5', 'A5'],
        bpm: 70,
        repetitionsRequired: 3,
        accuracyThreshold: 0.80,
        order: 1,
      ),
    ],
    xpReward: 100,
    difficulty: 4,
    targetAccuracy: 0.80,
    presetRequired: GuitarPreset.clean,
    chordIds: const ['F5', 'G5', 'A5'],
    order: 2,
    estimatedMinutes: 10,
  ),

  // 4.3 — Drei-Noten-Power-Chord
  Lesson(
    id: 'lesson-4-3',
    moduleId: _moduleId,
    title: 'Drei-Noten-Power-Chord',
    description:
        'Erweitere den Power Chord um die Oktave auf der D-Saite — voller, runder Klang.',
    instructions: [
      'Lege Ringfinger und kleinen Finger auf zwei Saiten desselben Bunds.',
      'Beispiel A5: A-Saite offen + D-Saite Bund 2 + G-Saite Bund 2.',
      'Mit der Oktav-Note klingt der Akkord deutlich voller.',
    ],
    exercises: [
      Exercise(
        id: 'ex-4-3-1',
        lessonId: 'lesson-4-3',
        type: ExerciseType.chord,
        instructions: 'Spiele A5 mit Oktave fünfmal sauber.',
        targetNoteOrChord: 'A5',
        bpm: 70,
        repetitionsRequired: 5,
        accuracyThreshold: 0.80,
        order: 1,
      ),
    ],
    xpReward: 120,
    difficulty: 4,
    targetAccuracy: 0.80,
    presetRequired: GuitarPreset.clean,
    chordIds: const ['A5'],
    order: 3,
    estimatedMinutes: 10,
  ),

  // 4.4 — OVERDRIVE FREISCHALTEN (Special)
  Lesson(
    id: 'lesson-4-4',
    moduleId: _moduleId,
    title: 'OVERDRIVE FREISCHALTEN',
    description:
        'Schalte den Overdrive-Sound deiner Enya XMARI frei — der Moment, auf den du gewartet hast!',
    instructions: [
      'Verbinde dich mit deiner Enya XMARI per Bluetooth.',
      'Wechsle zum Overdrive-Preset — dein Klang wird sofort warm und verzerrt.',
      'Spiele E5 — höre den Unterschied zum Clean-Sound.',
      'Glückwunsch — du klingst jetzt wirklich nach Rock!',
    ],
    exercises: [
      Exercise(
        id: 'ex-4-4-1',
        lessonId: 'lesson-4-4',
        type: ExerciseType.chord,
        instructions: 'Spiele E5 mit Overdrive zehnmal — fühle den Unterschied.',
        targetNoteOrChord: 'E5',
        bpm: 70,
        repetitionsRequired: 10,
        accuracyThreshold: 0.75,
        order: 1,
      ),
    ],
    xpReward: 200,
    difficulty: 4,
    targetAccuracy: 0.75,
    presetRequired: GuitarPreset.overdrive,
    chordIds: const ['E5'],
    order: 4,
    estimatedMinutes: 8,
  ),

  // 4.5 — Smoke on the Water mit Power Chords
  Lesson(
    id: 'lesson-4-5',
    moduleId: _moduleId,
    title: 'Smoke on the Water mit Power Chords',
    description:
        'Spiele das berühmte Riff diesmal mit echten Power Chords und Overdrive.',
    instructions: [
      'Sequenz: G5 → A#5 → C5 — Pause — G5 → A#5 → C#5 → C5.',
      'Spiele jeden Akkord kurz und präzise — Pausen sind wichtig.',
      'Mit Overdrive klingt das Riff genau wie im Original.',
    ],
    exercises: [
      Exercise(
        id: 'ex-4-5-1',
        lessonId: 'lesson-4-5',
        type: ExerciseType.chord,
        instructions:
            'Spiele die volle Power-Chord-Version dreimal sauber durch.',
        targetNoteOrChord: 'G5,A#5,C5,G5,A#5,C#5,C5',
        noteSequence: ['G5', 'A#5', 'C5', 'G5', 'A#5', 'C#5', 'C5'],
        bpm: 90,
        repetitionsRequired: 3,
        accuracyThreshold: 0.80,
        timeoutSeconds: 90,
        order: 1,
      ),
    ],
    xpReward: 180,
    difficulty: 5,
    targetAccuracy: 0.80,
    presetRequired: GuitarPreset.overdrive,
    chordIds: const ['G5', 'A#5', 'C5', 'C#5'],
    order: 5,
    estimatedMinutes: 14,
  ),

  // 4.6 — You Really Got Me
  Lesson(
    id: 'lesson-4-6',
    moduleId: _moduleId,
    title: 'You Really Got Me',
    description:
        'Das berühmte Kinks-Riff — minimalistisch, eingängig und perfekt für Power Chords.',
    instructions: [
      'Hauptmuster: F5 → G5 mit aggressivem Anschlag.',
      'Das ganze Riff verwendet nur zwei Akkorde — der Rhythmus macht\'s.',
      'Versuche das Riff sauber zu zwölf Schlägen zu loopen.',
    ],
    exercises: [
      Exercise(
        id: 'ex-4-6-1',
        lessonId: 'lesson-4-6',
        type: ExerciseType.chord,
        instructions:
            'Spiele F5 → G5 abwechselnd, 16 Schläge im Tempo 100 BPM.',
        targetNoteOrChord: 'F5,G5',
        noteSequence: ['F5', 'G5'],
        bpm: 100,
        repetitionsRequired: 16,
        accuracyThreshold: 0.80,
        timeoutSeconds: 60,
        order: 1,
      ),
    ],
    xpReward: 200,
    difficulty: 5,
    targetAccuracy: 0.80,
    presetRequired: GuitarPreset.overdrive,
    chordIds: const ['F5', 'G5'],
    order: 6,
    estimatedMinutes: 14,
  ),
];

final Module module4 = Module(
  id: _moduleId,
  moduleNumber: 4,
  title: 'Dein erster Power Chord',
  description:
      'Lerne Power Chords und schalte den Overdrive-Sound deiner Enya XMARI frei.',
  weekRange: 'Woche 4',
  presetRequired: GuitarPreset.clean,
  difficulty: 4,
  isLocked: true,
  unlockedPresets: const ['overdrive'],
  learningGoals:
      'Zwei- und Drei-Noten-Power-Chords, Akkord verschieben, Overdrive freischalten, zwei klassische Riffs.',
  lessons: module4Lessons,
);
