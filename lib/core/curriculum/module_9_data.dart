import 'package:enya_gitarre_learn/core/models/exercise.dart';
import 'package:enya_gitarre_learn/core/models/lesson.dart';
import 'package:enya_gitarre_learn/core/models/module.dart';

/// Module 9 — "Distortion & Rock-Techniken" (Wochen 19-22, Schwierigkeit 7).
/// Hauptpreset: DISTORTION.
const String _moduleId = 'module-09';

final List<Lesson> module9Lessons = [
  Lesson(
    id: 'lesson-9-1',
    moduleId: _moduleId,
    title: 'Distortion richtig nutzen',
    description:
        'Distortion ist mächtig — aber zu viel davon klingt matschig. Lerne, sie kontrolliert einzusetzen.',
    instructions: [
      'Aktiviere das DISTORTION-Preset deiner Enya XMARI.',
      'Spiele einzelne Töne und höre, wie sie "singen".',
      'Achte auf saubere Greiftechnik — Distortion verstärkt jeden Fehler.',
      'Dämpfe ungenutzte Saiten mit der rechten Handkante.',
    ],
    exercises: [
      Exercise(
        id: 'ex-9-1-1',
        lessonId: 'lesson-9-1',
        type: ExerciseType.singleNote,
        instructions: 'Spiele 8 saubere Einzeltöne mit Distortion.',
        targetNoteOrChord: 'A3',
        bpm: 70,
        repetitionsRequired: 8,
        accuracyThreshold: 0.74,
        order: 1,
      ),
    ],
    xpReward: 100,
    difficulty: 6,
    targetAccuracy: 0.74,
    presetRequired: GuitarPreset.distortion,
    order: 1,
    isUnlocked: true,
    estimatedMinutes: 10,
  ),
  Lesson(
    id: 'lesson-9-2',
    moduleId: _moduleId,
    title: 'Palm Muting mit Distortion',
    description:
        'Mit Distortion wird Palm Muting zur Heavy-Rhythm-Maschine — der "Chug"-Sound von Metal.',
    instructions: [
      'Lege die Handkante auf die Saiten an der Brücke.',
      'Spiele E5 als palm-muted Achtelnoten.',
      'Variiere den Druck — finde den perfekten "Chug".',
      'Setze regelmäßig offene Akzente, um Spannung aufzubauen.',
    ],
    exercises: [
      Exercise(
        id: 'ex-9-2-1',
        lessonId: 'lesson-9-2',
        type: ExerciseType.rhythm,
        instructions: 'Spiele 32 palm-muted E5 Achtel mit 2 offenen Akzenten alle 8 Beats.',
        targetNoteOrChord: 'E5',
        bpm: 100,
        repetitionsRequired: 32,
        accuracyThreshold: 0.74,
        order: 1,
      ),
    ],
    xpReward: 160,
    difficulty: 7,
    targetAccuracy: 0.74,
    presetRequired: GuitarPreset.distortion,
    chordIds: const ['E5'],
    order: 2,
    estimatedMinutes: 12,
  ),
  Lesson(
    id: 'lesson-9-3',
    moduleId: _moduleId,
    title: 'Riff-Werkstatt: 4 Klassiker',
    description:
        'Spiele die ikonischen Riffs: Enter Sandman, Iron Man, Back in Black, Paranoid.',
    instructions: [
      'Enter Sandman: E5 - G5 - A5 mit palm-muted Pulses.',
      'Iron Man: F#5 - G5 - C#5 - E5 - F#5.',
      'Back in Black: E5 - D5 - A5 mit Triolen-Feel.',
      'Paranoid: E5 mit Pull-Off-Trills auf G-Saite.',
    ],
    exercises: [
      Exercise(
        id: 'ex-9-3-1',
        lessonId: 'lesson-9-3',
        type: ExerciseType.chord,
        instructions: 'Spiele jedes Riff einmal komplett durch.',
        targetNoteOrChord: 'E5,G5,A5,F#5',
        noteSequence: ['E5', 'G5', 'A5', 'F#5', 'C#5', 'D5'],
        bpm: 110,
        repetitionsRequired: 1,
        accuracyThreshold: 0.74,
        timeoutSeconds: 240,
        order: 1,
      ),
    ],
    xpReward: 280,
    difficulty: 7,
    targetAccuracy: 0.74,
    presetRequired: GuitarPreset.distortion,
    chordIds: const ['E5', 'G5', 'A5', 'F#5', 'C#5', 'D5'],
    order: 3,
    estimatedMinutes: 22,
  ),
  Lesson(
    id: 'lesson-9-4',
    moduleId: _moduleId,
    title: 'Gallop-Picking',
    description:
        'Der typische Metal-Galopp: eine Achtel + zwei Sechzehntel — das pulsierende Herz von Iron Maiden.',
    instructions: [
      'Pattern: ↓ ↓↑ — eine Achtel down, dann zwei Sechzehntel down/up.',
      'Übe zunächst ohne Distortion auf einer Saite.',
      'Mit Distortion und Palm Muting wird der Galopp aggressiv.',
      'Tempo schrittweise von 90 auf 130 BPM steigern.',
    ],
    exercises: [
      Exercise(
        id: 'ex-9-4-1',
        lessonId: 'lesson-9-4',
        type: ExerciseType.rhythm,
        instructions: 'Spiele 16 Galopp-Patterns auf E-Saite bei 110 BPM.',
        targetNoteOrChord: 'E2',
        bpm: 110,
        repetitionsRequired: 16,
        accuracyThreshold: 0.72,
        order: 1,
      ),
    ],
    xpReward: 200,
    difficulty: 7,
    targetAccuracy: 0.72,
    presetRequired: GuitarPreset.distortion,
    order: 4,
    estimatedMinutes: 14,
  ),
  Lesson(
    id: 'lesson-9-5',
    moduleId: _moduleId,
    title: 'Drop-D Tuning',
    description:
        'Stimme die tiefe E-Saite auf D — eröffnet ein-Finger-Power-Chords und tiefe, fette Riffs.',
    instructions: [
      'Stimme die tiefe E-Saite einen Ganzton tiefer auf D.',
      'Power Chords lassen sich jetzt mit nur einem Finger als Barré über die unteren drei Saiten greifen.',
      'Probiere D5 (Bund 0) - F5 (Bund 3) - G5 (Bund 5).',
      'Drop-D klingt sofort schwerer und tiefer.',
    ],
    exercises: [
      Exercise(
        id: 'ex-9-5-1',
        lessonId: 'lesson-9-5',
        type: ExerciseType.chord,
        instructions: 'Spiele D5 - F5 - G5 - F5 in Drop-D, 4 Durchgänge.',
        targetNoteOrChord: 'D5,F5,G5',
        noteSequence: ['D5', 'F5', 'G5', 'F5'],
        bpm: 100,
        repetitionsRequired: 4,
        accuracyThreshold: 0.74,
        timeoutSeconds: 90,
        order: 1,
      ),
    ],
    xpReward: 220,
    difficulty: 7,
    targetAccuracy: 0.74,
    presetRequired: GuitarPreset.distortion,
    chordIds: const ['D5', 'F5', 'G5'],
    order: 5,
    estimatedMinutes: 16,
  ),
];

final Module module9 = Module(
  id: _moduleId,
  moduleNumber: 9,
  title: 'Distortion & Rock-Techniken',
  description:
      'Distortion-Sound, Palm Muting, klassische Riffs, Gallop-Picking und Drop-D — der volle Rock-Werkzeugkasten.',
  weekRange: 'Woche 19-22',
  presetRequired: GuitarPreset.distortion,
  difficulty: 7,
  isLocked: true,
  unlockedPresets: const [],
  learningGoals:
      'Distortion-Kontrolle, Palm Muting, vier Klassiker-Riffs, Gallop-Picking, Drop-D Tuning.',
  lessons: module9Lessons,
);
