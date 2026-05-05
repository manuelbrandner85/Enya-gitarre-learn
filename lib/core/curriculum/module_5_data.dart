import 'package:enya_gitarre_learn/core/models/exercise.dart';
import 'package:enya_gitarre_learn/core/models/lesson.dart';
import 'package:enya_gitarre_learn/core/models/module.dart';

/// Module 5 — "Rhythmus & Timing" (Wochen 5-6, Schwierigkeit 4).
/// Hauptpreset: OVERDRIVE.
const String _moduleId = 'module-05';

final List<Lesson> module5Lessons = [
  Lesson(
    id: 'lesson-5-1',
    moduleId: _moduleId,
    title: 'Zählen 1-2-3-4',
    description:
        'Lerne das innere Metronom: zähle laut 1-2-3-4 und schlage zu jedem Beat die tiefe E-Saite an.',
    instructions: [
      'Stelle das Metronom auf 70 BPM ein.',
      'Zähle laut mit: "Eins, Zwei, Drei, Vier".',
      'Schlage auf jeder Zahl die tiefe E-Saite an.',
      'Achte darauf, dass dein Anschlag exakt mit dem Klick zusammenfällt.',
    ],
    exercises: [
      Exercise(
        id: 'ex-5-1-1',
        lessonId: 'lesson-5-1',
        type: ExerciseType.rhythm,
        instructions: 'Spiele 16 Beats sauber im Takt zum 70-BPM-Metronom.',
        targetNoteOrChord: 'E2',
        bpm: 70,
        repetitionsRequired: 16,
        accuracyThreshold: 0.80,
        order: 1,
      ),
    ],
    xpReward: 70,
    difficulty: 3,
    targetAccuracy: 0.80,
    presetRequired: GuitarPreset.overdrive,
    order: 1,
    isUnlocked: true,
    estimatedMinutes: 8,
  ),
  Lesson(
    id: 'lesson-5-2',
    moduleId: _moduleId,
    title: 'Achtelnoten 1-und-2-und',
    description:
        'Verdopple das Tempo deiner Anschläge mit Wechselschlag — Down auf Zahlen, Up auf "und".',
    instructions: [
      'Zähle "1 und 2 und 3 und 4 und".',
      'Down-Stroke auf jeder Zahl, Up-Stroke auf jedem "und".',
      'Halte die Hand locker und schwinge gleichmäßig.',
      'Übe zunächst auf einer einzigen Saite.',
    ],
    exercises: [
      Exercise(
        id: 'ex-5-2-1',
        lessonId: 'lesson-5-2',
        type: ExerciseType.rhythm,
        instructions: 'Spiele 32 Achtelnoten im Wechselschlag bei 70 BPM.',
        targetNoteOrChord: 'A2',
        bpm: 70,
        repetitionsRequired: 32,
        accuracyThreshold: 0.78,
        order: 1,
      ),
    ],
    xpReward: 100,
    difficulty: 4,
    targetAccuracy: 0.78,
    presetRequired: GuitarPreset.overdrive,
    order: 2,
    estimatedMinutes: 10,
  ),
  Lesson(
    id: 'lesson-5-3',
    moduleId: _moduleId,
    title: 'Universal-Strumming-Pattern',
    description:
        'Das Pattern, das in tausenden Songs steckt: ↓ ↓ ↑ _ ↑ ↓ ↑ — universell einsetzbar.',
    instructions: [
      'Zähle "1 - 2 und - und 4 und".',
      'Reihenfolge: Down, Down, Up, Pause, Up, Down, Up.',
      'Bei der Pause die Hand weiterschwingen, aber nicht anschlagen.',
      'Übe das Pattern zuerst sehr langsam, dann erhöhe das Tempo.',
    ],
    exercises: [
      Exercise(
        id: 'ex-5-3-1',
        lessonId: 'lesson-5-3',
        type: ExerciseType.strumming,
        instructions: 'Spiele das Universal-Pattern 8x sauber bei 80 BPM.',
        targetNoteOrChord: 'E5',
        pattern: 'D-D-U-_-U-D-U',
        bpm: 80,
        repetitionsRequired: 8,
        accuracyThreshold: 0.78,
        order: 1,
      ),
    ],
    xpReward: 130,
    difficulty: 4,
    targetAccuracy: 0.78,
    presetRequired: GuitarPreset.overdrive,
    chordIds: const ['E5'],
    order: 3,
    estimatedMinutes: 12,
  ),
  Lesson(
    id: 'lesson-5-4',
    moduleId: _moduleId,
    title: 'Palm Muting',
    description:
        'Lege die Handkante locker auf die Saiten direkt vor der Bridge — der Klang wird kurz, perkussiv und tight.',
    instructions: [
      'Lege die rechte Handkante auf die Saiten knapp vor der Brücke.',
      'Schlage einen Power Chord an — der Sound wird abgedämpft, "chuggig".',
      'Variiere den Druck: zu fest = ton, zu locker = klingt offen.',
      'Mit Overdrive klingt Palm Muting besonders kraftvoll.',
    ],
    exercises: [
      Exercise(
        id: 'ex-5-4-1',
        lessonId: 'lesson-5-4',
        type: ExerciseType.rhythm,
        instructions: 'Spiele 16 palm-muted E5 in Achtelnoten bei 80 BPM.',
        targetNoteOrChord: 'E5',
        bpm: 80,
        repetitionsRequired: 16,
        accuracyThreshold: 0.75,
        order: 1,
      ),
    ],
    xpReward: 130,
    difficulty: 4,
    targetAccuracy: 0.75,
    presetRequired: GuitarPreset.overdrive,
    chordIds: const ['E5'],
    order: 4,
    estimatedMinutes: 12,
  ),
  Lesson(
    id: 'lesson-5-5',
    moduleId: _moduleId,
    title: 'Rhythmus-Game (Backing Track)',
    description:
        'Spiele zu einem Backing Track Power Chords im Takt — die ultimative Rhythmus-Challenge.',
    instructions: [
      'Höre den Backing Track erst einmal komplett durch.',
      'Spiele E5 → A5 → D5 → A5 im Vier-Takt-Schema.',
      'Halte den Takt — auch wenn du dich verspielst, bleib im Groove.',
      'Genauigkeit zählt — jeder Schlag muss auf den Klick fallen.',
    ],
    exercises: [
      Exercise(
        id: 'ex-5-5-1',
        lessonId: 'lesson-5-5',
        type: ExerciseType.rhythm,
        instructions: 'Spiele die Akkordfolge 4 Durchgänge zum Backing Track.',
        targetNoteOrChord: 'E5,A5,D5,A5',
        noteSequence: ['E5', 'A5', 'D5', 'A5'],
        bpm: 90,
        repetitionsRequired: 4,
        accuracyThreshold: 0.78,
        timeoutSeconds: 90,
        order: 1,
      ),
    ],
    xpReward: 180,
    difficulty: 5,
    targetAccuracy: 0.78,
    presetRequired: GuitarPreset.overdrive,
    chordIds: const ['E5', 'A5', 'D5'],
    order: 5,
    estimatedMinutes: 15,
  ),
  Lesson(
    id: 'lesson-5-6',
    moduleId: _moduleId,
    title: 'Taktarten 4/4 vs 3/4',
    description:
        'Erlebe den Unterschied zwischen Rock (4/4) und Walzer (3/4) — Taktarten formen den Charakter eines Songs.',
    instructions: [
      'Zähle 4/4: 1-2-3-4 — der Standard im Rock und Pop.',
      'Zähle 3/4: 1-2-3 — der Walzer-Takt, schwingend und tänzerisch.',
      'Spiele E5 mit Akzent auf der 1 in beiden Taktarten.',
      'Höre, wie sich der Groove komplett verändert.',
    ],
    exercises: [
      Exercise(
        id: 'ex-5-6-1',
        lessonId: 'lesson-5-6',
        type: ExerciseType.rhythm,
        instructions: 'Spiele 8 Takte 4/4, dann 8 Takte 3/4 sauber zum Klick.',
        targetNoteOrChord: 'E5',
        bpm: 80,
        repetitionsRequired: 16,
        accuracyThreshold: 0.78,
        order: 1,
      ),
    ],
    xpReward: 120,
    difficulty: 4,
    targetAccuracy: 0.78,
    presetRequired: GuitarPreset.overdrive,
    chordIds: const ['E5'],
    order: 6,
    estimatedMinutes: 10,
  ),
];

final Module module5 = Module(
  id: _moduleId,
  moduleNumber: 5,
  title: 'Rhythmus & Timing',
  description:
      'Entwickle ein präzises Timing — Achtelnoten, Strumming-Patterns, Palm Muting und Taktarten.',
  weekRange: 'Woche 5-6',
  presetRequired: GuitarPreset.overdrive,
  difficulty: 4,
  isLocked: true,
  unlockedPresets: const [],
  learningGoals:
      'Zählen, Achtelnoten-Wechselschlag, Universal-Strumming, Palm Muting, Backing Track, 4/4 vs 3/4.',
  lessons: module5Lessons,
);
