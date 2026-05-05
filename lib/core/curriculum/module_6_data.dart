import 'package:enya_gitarre_learn/core/models/exercise.dart';
import 'package:enya_gitarre_learn/core/models/lesson.dart';
import 'package:enya_gitarre_learn/core/models/module.dart';

/// Module 6 — "Rhythmus & Strumming" (Wochen 9-12, Schwierigkeit 3).
/// Hauptpreset: CLEAN. Voraussetzung: Level 12.
const String _moduleId = 'module-06';

final List<Lesson> module6Lessons = [
  // 6.1 — Down-Strumming im 4/4-Takt
  Lesson(
    id: 'lesson-6-1',
    moduleId: _moduleId,
    title: 'Down-Strumming im 4/4-Takt',
    description:
        'Die Grundlage des Rhythmusspiels: reine Abschläge gleichmäßig auf jeden Beat.',
    instructions: [
      'Greife G-Dur und halte ihn die ganze Übung.',
      'Schlage nur nach unten — auf 1, 2, 3, 4.',
      'Halte die Hand locker und lass sie gleichmäßig schwingen.',
      'Steigere das Tempo schrittweise von 60 auf 100 BPM.',
    ],
    exercises: [
      Exercise(
        id: 'ex-6-1-1',
        lessonId: 'lesson-6-1',
        type: ExerciseType.strumming,
        instructions: 'G-Dur, nur Abschläge, 60 BPM — 8 Takte gleichmäßig.',
        targetNoteOrChord: 'G',
        pattern: 'D-D-D-D',
        bpm: 60,
        repetitionsRequired: 8,
        accuracyThreshold: 0.78,
        order: 1,
      ),
      Exercise(
        id: 'ex-6-1-2',
        lessonId: 'lesson-6-1',
        type: ExerciseType.strumming,
        instructions: 'G-Dur, nur Abschläge, 80 BPM — 8 Takte.',
        targetNoteOrChord: 'G',
        pattern: 'D-D-D-D',
        bpm: 80,
        repetitionsRequired: 8,
        accuracyThreshold: 0.78,
        order: 2,
      ),
      Exercise(
        id: 'ex-6-1-3',
        lessonId: 'lesson-6-1',
        type: ExerciseType.strumming,
        instructions: 'G-Dur, nur Abschläge, 100 BPM — 8 Takte.',
        targetNoteOrChord: 'G',
        pattern: 'D-D-D-D',
        bpm: 100,
        repetitionsRequired: 8,
        accuracyThreshold: 0.78,
        order: 3,
      ),
    ],
    xpReward: 60,
    difficulty: 2,
    targetAccuracy: 0.78,
    presetRequired: GuitarPreset.clean,
    chordIds: const ['G'],
    order: 1,
    isUnlocked: true,
    estimatedMinutes: 10,
  ),

  // 6.2 — Up-Strumming einführen
  Lesson(
    id: 'lesson-6-2',
    moduleId: _moduleId,
    title: 'Up-Strumming einführen',
    description:
        'Füge den Aufschlag hinzu und lerne das Down-Up-Muster auf Achtelnoten.',
    instructions: [
      'Halte Em und schwinge die Hand gleichmäßig auf und ab.',
      'Down auf die Zahl (1, 2, 3, 4), Up auf das "und".',
      'Wichtig: auch auf dem Aufschlag ruhig bleiben.',
      'Lass die Bewegung aus dem Handgelenk kommen.',
    ],
    exercises: [
      Exercise(
        id: 'ex-6-2-1',
        lessonId: 'lesson-6-2',
        type: ExerciseType.strumming,
        instructions:
            'Em, Down-Up auf Achtelnoten — 8 Takte bei 70 BPM.',
        targetNoteOrChord: 'Em',
        pattern: 'D-U-D-U-D-U-D-U',
        bpm: 70,
        repetitionsRequired: 8,
        accuracyThreshold: 0.75,
        order: 1,
      ),
      Exercise(
        id: 'ex-6-2-2',
        lessonId: 'lesson-6-2',
        type: ExerciseType.strumming,
        instructions:
            'Em, Down-Up auf Achtelnoten — 8 Takte bei 90 BPM.',
        targetNoteOrChord: 'Em',
        pattern: 'D-U-D-U-D-U-D-U',
        bpm: 90,
        repetitionsRequired: 8,
        accuracyThreshold: 0.75,
        order: 2,
      ),
    ],
    xpReward: 70,
    difficulty: 2,
    targetAccuracy: 0.75,
    presetRequired: GuitarPreset.clean,
    chordIds: const ['Em'],
    order: 2,
    estimatedMinutes: 12,
  ),

  // 6.3 — Das Pop-Strumming-Pattern
  Lesson(
    id: 'lesson-6-3',
    moduleId: _moduleId,
    title: 'Das Pop-Strumming-Pattern',
    description:
        'Das universelle Pattern D-DU-UDU steckt in tausenden Pop- und Rock-Songs.',
    instructions: [
      'Zähle "1 und 2 und 3 und 4 und".',
      'Pattern: D - D-U - U-D-U (Schläge auf 1, 2, und2, und3, 4, und4).',
      'Bei Lücken schwingt die Hand weiter — nur kein Anschlag.',
      'Übe erst mit G, dann wechsle zu G → C.',
    ],
    exercises: [
      Exercise(
        id: 'ex-6-3-1',
        lessonId: 'lesson-6-3',
        type: ExerciseType.strumming,
        instructions: 'G-Akkord, Pattern D-DU-UDU, 8 Takte bei 70 BPM.',
        targetNoteOrChord: 'G',
        pattern: 'D-DU-UDU',
        bpm: 70,
        repetitionsRequired: 8,
        accuracyThreshold: 0.75,
        order: 1,
      ),
      Exercise(
        id: 'ex-6-3-2',
        lessonId: 'lesson-6-3',
        type: ExerciseType.strumming,
        instructions: 'G → C mit Pattern D-DU-UDU, je 2 Takte, 4 Wechsel bei 80 BPM.',
        targetNoteOrChord: 'G,C',
        noteSequence: ['G', 'C', 'G', 'C'],
        pattern: 'D-DU-UDU',
        bpm: 80,
        repetitionsRequired: 4,
        accuracyThreshold: 0.75,
        timeoutSeconds: 90,
        order: 2,
      ),
    ],
    xpReward: 80,
    difficulty: 3,
    targetAccuracy: 0.75,
    presetRequired: GuitarPreset.clean,
    chordIds: const ['G', 'C'],
    order: 3,
    estimatedMinutes: 15,
  ),

  // 6.4 — Pausen und Deadnotes
  Lesson(
    id: 'lesson-6-4',
    moduleId: _moduleId,
    title: 'Pausen und Deadnotes',
    description:
        'Chuck-Technik: die Saiten kurz abwürgen erzeugt perkussive Deadnotes und gibt dem Groove Spannung.',
    instructions: [
      'Lege die Greifhand locker auf die Saiten — kein Druck.',
      'Schlage die gedämpften Saiten an: das ergibt ein "Chuck" (x).',
      'Pattern: D-x-DU-xU — die x-Schläge sind Deadnotes.',
      'Übe erst langsam, bis das Pattern sitzt.',
    ],
    exercises: [
      Exercise(
        id: 'ex-6-4-1',
        lessonId: 'lesson-6-4',
        type: ExerciseType.strumming,
        instructions:
            'D-x-DU-xU Pattern auf G-Akkord, 8 Takte bei 70 BPM.',
        targetNoteOrChord: 'G',
        pattern: 'D-x-DU-xU',
        bpm: 70,
        repetitionsRequired: 8,
        accuracyThreshold: 0.72,
        order: 1,
      ),
      Exercise(
        id: 'ex-6-4-2',
        lessonId: 'lesson-6-4',
        type: ExerciseType.strumming,
        instructions:
            'D-x-DU-xU Pattern auf G-Akkord, 8 Takte bei 90 BPM.',
        targetNoteOrChord: 'G',
        pattern: 'D-x-DU-xU',
        bpm: 90,
        repetitionsRequired: 8,
        accuracyThreshold: 0.72,
        order: 2,
      ),
    ],
    xpReward: 80,
    difficulty: 3,
    targetAccuracy: 0.72,
    presetRequired: GuitarPreset.clean,
    chordIds: const ['G'],
    order: 4,
    estimatedMinutes: 15,
  ),

  // 6.5 — Dynamik – laut und leise
  Lesson(
    id: 'lesson-6-5',
    moduleId: _moduleId,
    title: 'Dynamik – laut und leise',
    description:
        'Musikalisches Ausdrucksmittel: Verse leise (piano), Chorus laut (forte) — das macht Songs lebendig.',
    instructions: [
      'Verse (G-C): spielst du leise — wenig Anschlagsdruck.',
      'Chorus (Em-D): spielst du laut — kraftvoller Anschlag.',
      'Fühl den Unterschied: Energie kommt aus der Dynamik.',
      'Gleiche Akkordfolge G-C-Em-D, nur die Lautstärke ändert sich.',
    ],
    exercises: [
      Exercise(
        id: 'ex-6-5-1',
        lessonId: 'lesson-6-5',
        type: ExerciseType.strumming,
        instructions:
            'Verse: G-C leise (piano), Down-Strumming bei 80 BPM.',
        targetNoteOrChord: 'G,C',
        noteSequence: ['G', 'C'],
        pattern: 'D-D-D-D',
        bpm: 80,
        repetitionsRequired: 4,
        accuracyThreshold: 0.75,
        order: 1,
      ),
      Exercise(
        id: 'ex-6-5-2',
        lessonId: 'lesson-6-5',
        type: ExerciseType.strumming,
        instructions:
            'Chorus: Em-D laut (forte), kraftvoller Anschlag bei 80 BPM.',
        targetNoteOrChord: 'Em,D',
        noteSequence: ['Em', 'D'],
        pattern: 'D-DU-UDU',
        bpm: 80,
        repetitionsRequired: 4,
        accuracyThreshold: 0.75,
        order: 2,
      ),
      Exercise(
        id: 'ex-6-5-3',
        lessonId: 'lesson-6-5',
        type: ExerciseType.strumming,
        instructions:
            'Komplette Progression G-C-Em-D mit Dynamikwechsel, 4 Durchgänge.',
        targetNoteOrChord: 'G,C,Em,D',
        noteSequence: ['G', 'C', 'Em', 'D'],
        pattern: 'D-DU-UDU',
        bpm: 80,
        repetitionsRequired: 4,
        accuracyThreshold: 0.75,
        timeoutSeconds: 90,
        order: 3,
      ),
    ],
    xpReward: 80,
    difficulty: 3,
    targetAccuracy: 0.75,
    presetRequired: GuitarPreset.clean,
    chordIds: const ['G', 'C', 'Em', 'D'],
    order: 5,
    estimatedMinutes: 15,
  ),

  // 6.6 — Song: Wish You Were Here Strumming
  Lesson(
    id: 'lesson-6-6',
    moduleId: _moduleId,
    title: 'Song: Wish You Were Here – Strumming',
    description:
        'Pink Floyds Klassiker mit Em und G — die perfekte Übung für Dynamik und Strumming-Pattern.',
    instructions: [
      'Akkordfolge: Em → G, immer wiederholen.',
      'Verse: leise mit einfachem Down-Strumming.',
      'Steigere die Lautstärke im Laufe des Songs.',
      'Halte das Timing — Groove ist wichtiger als Perfektion.',
    ],
    exercises: [
      Exercise(
        id: 'ex-6-6-1',
        lessonId: 'lesson-6-6',
        type: ExerciseType.strumming,
        instructions:
            'Em → G, leise, Down-Strumming, 4 Takte je Akkord bei 68 BPM.',
        targetNoteOrChord: 'Em,G',
        noteSequence: ['Em', 'G', 'Em', 'G'],
        pattern: 'D-D-D-D',
        bpm: 68,
        repetitionsRequired: 4,
        accuracyThreshold: 0.75,
        timeoutSeconds: 90,
        order: 1,
      ),
      Exercise(
        id: 'ex-6-6-2',
        lessonId: 'lesson-6-6',
        type: ExerciseType.strumming,
        instructions:
            'Em → G, laut, D-DU-UDU Pattern, Dynamik aufbauen bei 68 BPM.',
        targetNoteOrChord: 'Em,G',
        noteSequence: ['Em', 'G', 'Em', 'G', 'Em', 'G'],
        pattern: 'D-DU-UDU',
        bpm: 68,
        repetitionsRequired: 6,
        accuracyThreshold: 0.75,
        timeoutSeconds: 120,
        order: 2,
      ),
    ],
    xpReward: 100,
    difficulty: 3,
    targetAccuracy: 0.75,
    presetRequired: GuitarPreset.clean,
    chordIds: const ['Em', 'G'],
    order: 6,
    estimatedMinutes: 20,
  ),
];

final Module module6 = Module(
  id: _moduleId,
  moduleNumber: 6,
  title: 'Rhythmus & Strumming',
  description:
      'Entwickle ein sicheres Rhythmusgefühl — Down-Strumming, Up-Strumming, das Pop-Pattern und Dynamik.',
  weekRange: 'Woche 9-12',
  presetRequired: GuitarPreset.clean,
  difficulty: 3,
  isLocked: true,
  unlockedPresets: const [],
  learningGoals:
      'Down-Strumming, Up-Strumming, Pop-Pattern D-DU-UDU, Deadnotes, Dynamik, Wish You Were Here spielen.',
  lessons: module6Lessons,
);
