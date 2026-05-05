import 'package:enya_gitarre_learn/core/models/exercise.dart';
import 'package:enya_gitarre_learn/core/models/lesson.dart';
import 'package:enya_gitarre_learn/core/models/module.dart';

/// Module 7 — "Pentatonik & erstes Solo" (Wochen 13-16, Schwierigkeit 5).
/// Hauptpreset: OVERDRIVE. Voraussetzung: Level 16.
const String _moduleId = 'module-07';

final List<Lesson> module7Lessons = [
  // 7.1 — Die Moll-Pentatonik – Box 1
  Lesson(
    id: 'lesson-7-1',
    moduleId: _moduleId,
    title: 'Die Moll-Pentatonik – Box 1',
    description:
        'Die A-Moll-Pentatonik in der ersten Lage — das Standard-Pattern für Rock-Soli.',
    instructions: [
      'Beginne am 5. Bund der tiefen E-Saite (Ton A).',
      'Pattern aufwärts: 5-8 / 5-7 / 5-7 / 5-7 / 5-8 / 5-8.',
      'Spiele jede Saite langsam und sauber aufwärts und abwärts.',
      'Lerne das Pattern auswendig — es ist die Basis jedes Blues- und Rock-Solos.',
    ],
    exercises: [
      Exercise(
        id: 'ex-7-1-1',
        lessonId: 'lesson-7-1',
        type: ExerciseType.scale,
        instructions:
            'Spiele die Am-Pentatonik Position 1 aufwärts — langsam bei 60 BPM.',
        targetNoteOrChord: 'A,C,D,E,G',
        noteSequence: ['A2', 'C3', 'D3', 'E3', 'G3', 'A3', 'C4', 'D4', 'E4', 'G4'],
        bpm: 60,
        repetitionsRequired: 3,
        accuracyThreshold: 0.75,
        order: 1,
      ),
      Exercise(
        id: 'ex-7-1-2',
        lessonId: 'lesson-7-1',
        type: ExerciseType.scale,
        instructions:
            'Spiele die Am-Pentatonik Position 1 abwärts — langsam bei 60 BPM.',
        targetNoteOrChord: 'A,C,D,E,G',
        noteSequence: ['G4', 'E4', 'D4', 'C4', 'A3', 'G3', 'E3', 'D3', 'C3', 'A2'],
        bpm: 60,
        repetitionsRequired: 3,
        accuracyThreshold: 0.75,
        order: 2,
      ),
    ],
    xpReward: 80,
    difficulty: 4,
    targetAccuracy: 0.75,
    presetRequired: GuitarPreset.overdrive,
    scaleIds: const ['Am-pent-pos1'],
    order: 1,
    isUnlocked: true,
    estimatedMinutes: 15,
  ),

  // 7.2 — Hammer-Ons und Pull-Offs
  Lesson(
    id: 'lesson-7-2',
    moduleId: _moduleId,
    title: 'Hammer-Ons und Pull-Offs',
    description:
        'Spiele zwei Töne mit nur einem Anschlag — Hammer-On und Pull-Off machen Soli flüssiger.',
    instructions: [
      'Hammer-On: Schlage einen Ton an, hämmere einen Finger zwei Bünde höher drauf.',
      'Pull-Off: Greife zwei Töne, schlage an, ziehe den oberen Finger weg.',
      'Übe zuerst einzelne HO und PO, dann kombiniere sie zu einem Lick.',
      'Ziel: beide Töne klingen gleich laut.',
    ],
    exercises: [
      Exercise(
        id: 'ex-7-2-1',
        lessonId: 'lesson-7-2',
        type: ExerciseType.singleNote,
        instructions:
            'Hammer-On auf einer Saite: G-Saite Bund 5 → 7, 10 Mal sauber.',
        targetNoteOrChord: 'C4',
        bpm: 60,
        repetitionsRequired: 10,
        accuracyThreshold: 0.72,
        order: 1,
      ),
      Exercise(
        id: 'ex-7-2-2',
        lessonId: 'lesson-7-2',
        type: ExerciseType.singleNote,
        instructions:
            'Pull-Off auf einer Saite: G-Saite Bund 7 → 5, 10 Mal sauber.',
        targetNoteOrChord: 'G3',
        bpm: 60,
        repetitionsRequired: 10,
        accuracyThreshold: 0.72,
        order: 2,
      ),
      Exercise(
        id: 'ex-7-2-3',
        lessonId: 'lesson-7-2',
        type: ExerciseType.scale,
        instructions:
            'Kombinierter Lick: Hammer-On und Pull-Off zusammen — 5h7p5 auf G-Saite, 8 Wiederholungen.',
        targetNoteOrChord: 'G3,D4,G3',
        noteSequence: ['G3', 'D4', 'G3'],
        bpm: 70,
        repetitionsRequired: 8,
        accuracyThreshold: 0.72,
        order: 3,
      ),
    ],
    xpReward: 90,
    difficulty: 5,
    targetAccuracy: 0.72,
    presetRequired: GuitarPreset.overdrive,
    order: 2,
    estimatedMinutes: 15,
  ),

  // 7.3 — Bending – Saiten ziehen
  Lesson(
    id: 'lesson-7-3',
    moduleId: _moduleId,
    title: 'Bending – Saiten ziehen',
    description:
        'Das Geheimnis emotionaler Soli: ziehe die Saite und der Ton steigt — der Sound, der Gitarre lebendig macht.',
    instructions: [
      'Greife den Ton mit dem Ringfinger, unterstütze mit Mittel- und Zeigefinger.',
      'Ziehe die G-Saite nach oben — Ganzton-Bend (zwei Halbtöne höher).',
      'Vergleiche den gebendeten Ton mit Bund 9 auf der G-Saite.',
      'Übe auch Bend-and-Release: rauf und wieder zurück.',
    ],
    exercises: [
      Exercise(
        id: 'ex-7-3-1',
        lessonId: 'lesson-7-3',
        type: ExerciseType.singleNote,
        instructions:
            'Ganzton-Bend auf G-Saite Bund 7 — 10 Mal zur Tonhöhe von Bund 9.',
        targetNoteOrChord: 'A3',
        bpm: 60,
        repetitionsRequired: 10,
        accuracyThreshold: 0.72,
        order: 1,
      ),
      Exercise(
        id: 'ex-7-3-2',
        lessonId: 'lesson-7-3',
        type: ExerciseType.singleNote,
        instructions:
            'Bend and Release auf G-Saite Bund 7 — rauf auf Bund 9, dann zurück, 8 Mal.',
        targetNoteOrChord: 'G3',
        bpm: 60,
        repetitionsRequired: 8,
        accuracyThreshold: 0.70,
        order: 2,
      ),
    ],
    xpReward: 90,
    difficulty: 5,
    targetAccuracy: 0.72,
    presetRequired: GuitarPreset.overdrive,
    order: 3,
    estimatedMinutes: 15,
  ),

  // 7.4 — Vibrato – den Ton leben lassen
  Lesson(
    id: 'lesson-7-4',
    moduleId: _moduleId,
    title: 'Vibrato – den Ton leben lassen',
    description:
        'Vibrato verleiht jedem Ton Persönlichkeit — ein gleichmäßiges Wackeln, das den Klang belebt.',
    instructions: [
      'Greife einen Ton fest auf dem Bund.',
      'Bewege die Saite minimal hoch und runter — wie ein Mini-Bending.',
      'Gleichmäßig und kontrolliert — nicht zu schnell.',
      'Starte langsam und fühle den Unterschied zum geraden Ton.',
    ],
    exercises: [
      Exercise(
        id: 'ex-7-4-1',
        lessonId: 'lesson-7-4',
        type: ExerciseType.singleNote,
        instructions:
            'Halte einen Ton auf G-Saite Bund 7 mit langsamem, gleichmäßigem Vibrato — 4 Sekunden.',
        targetNoteOrChord: 'G3',
        bpm: 60,
        repetitionsRequired: 5,
        accuracyThreshold: 0.70,
        timeoutSeconds: 30,
        order: 1,
      ),
      Exercise(
        id: 'ex-7-4-2',
        lessonId: 'lesson-7-4',
        type: ExerciseType.singleNote,
        instructions:
            'Vibrato auf verschiedenen Tönen der Am-Pentatonik — 8 Töne je mit Vibrato.',
        targetNoteOrChord: 'A,C,D,E,G',
        noteSequence: ['A3', 'C4', 'D4', 'E4', 'G4', 'E4', 'D4', 'A3'],
        bpm: 60,
        repetitionsRequired: 8,
        accuracyThreshold: 0.70,
        order: 2,
      ),
    ],
    xpReward: 80,
    difficulty: 4,
    targetAccuracy: 0.70,
    presetRequired: GuitarPreset.overdrive,
    order: 4,
    estimatedMinutes: 12,
  ),

  // 7.5 — Dein erstes Solo zusammenbauen
  Lesson(
    id: 'lesson-7-5',
    moduleId: _moduleId,
    title: 'Dein erstes Solo zusammenbauen',
    description:
        'Kombiniere Pentatonik, Hammer-Ons, Pull-Offs, Bending und Vibrato zu einem 8-Takt-Solo.',
    instructions: [
      'Lauf im Backing Track in A-Moll.',
      'Nutze die Am-Pentatonik Box 1 als Grundlage.',
      'Setze mindestens ein Bend, ein Vibrato und einen Hammer-On ein.',
      'Es gibt keine falschen Töne — experimentiere und hab Spaß!',
    ],
    exercises: [
      Exercise(
        id: 'ex-7-5-1',
        lessonId: 'lesson-7-5',
        type: ExerciseType.scale,
        instructions:
            '8-Takt-Solo über Am-Backing-Track — spiele frei mit allen gelernten Techniken.',
        targetNoteOrChord: 'A,C,D,E,G',
        bpm: 80,
        repetitionsRequired: 2,
        accuracyThreshold: 0.70,
        timeoutSeconds: 120,
        order: 1,
      ),
      Exercise(
        id: 'ex-7-5-2',
        lessonId: 'lesson-7-5',
        type: ExerciseType.scale,
        instructions:
            'Wiederhole das Solo mit etwas mehr Geschwindigkeit — 90 BPM.',
        targetNoteOrChord: 'A,C,D,E,G',
        bpm: 90,
        repetitionsRequired: 2,
        accuracyThreshold: 0.72,
        timeoutSeconds: 120,
        order: 2,
      ),
    ],
    xpReward: 100,
    difficulty: 5,
    targetAccuracy: 0.70,
    presetRequired: GuitarPreset.overdrive,
    scaleIds: const ['Am-pent-pos1'],
    order: 5,
    estimatedMinutes: 20,
  ),

  // 7.6 — Solo-Song: Smoke on the Water (vereinfacht)
  Lesson(
    id: 'lesson-7-6',
    moduleId: _moduleId,
    title: 'Solo-Song: Smoke on the Water (vereinfacht)',
    description:
        'Das berühmteste Gitarren-Riff als vereinfachtes Solo — Deep Purple trifft Pentatonik.',
    instructions: [
      'Das Riff nutzt Töne der D-Moll-Pentatonik auf der D-Saite.',
      'Sequenz: 0 → 3 → 5 — Pause — 0 → 3 → 6 → 5.',
      'Spiele zunächst langsam und steigere das Tempo schrittweise.',
      'Achte auf den Groove — gleichmäßiges Timing macht das Riff aus.',
    ],
    exercises: [
      Exercise(
        id: 'ex-7-6-1',
        lessonId: 'lesson-7-6',
        type: ExerciseType.rhythm,
        instructions:
            'Smoke on the Water Riff — vereinfachtes Solo, 3x bei 70 BPM.',
        targetNoteOrChord: 'D3,F3,G3,D3,F3,G#3,G3',
        noteSequence: ['D3', 'F3', 'G3', 'D3', 'F3', 'G#3', 'G3'],
        bpm: 70,
        repetitionsRequired: 3,
        accuracyThreshold: 0.78,
        timeoutSeconds: 90,
        order: 1,
      ),
      Exercise(
        id: 'ex-7-6-2',
        lessonId: 'lesson-7-6',
        type: ExerciseType.rhythm,
        instructions:
            'Smoke on the Water Riff — Originaltempo, 3x bei 112 BPM.',
        targetNoteOrChord: 'D3,F3,G3,D3,F3,G#3,G3',
        noteSequence: ['D3', 'F3', 'G3', 'D3', 'F3', 'G#3', 'G3'],
        bpm: 112,
        repetitionsRequired: 3,
        accuracyThreshold: 0.78,
        timeoutSeconds: 60,
        order: 2,
      ),
    ],
    xpReward: 120,
    difficulty: 5,
    targetAccuracy: 0.78,
    presetRequired: GuitarPreset.overdrive,
    scaleIds: const ['Am-pent-pos1'],
    order: 6,
    estimatedMinutes: 25,
  ),
];

final Module module7 = Module(
  id: _moduleId,
  moduleNumber: 7,
  title: 'Pentatonik & erstes Solo',
  description:
      'Lerne die Moll-Pentatonik und alle wichtigen Solo-Techniken — Hammer-On, Pull-Off, Bending, Vibrato.',
  weekRange: 'Woche 13-16',
  presetRequired: GuitarPreset.overdrive,
  difficulty: 5,
  isLocked: true,
  unlockedPresets: const [],
  learningGoals:
      'Am-Pentatonik Box 1, Hammer-On, Pull-Off, Bending, Vibrato, erstes Solo, Smoke on the Water.',
  lessons: module7Lessons,
);
