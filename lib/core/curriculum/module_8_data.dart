import 'package:enya_gitarre_learn/core/models/exercise.dart';
import 'package:enya_gitarre_learn/core/models/lesson.dart';
import 'package:enya_gitarre_learn/core/models/module.dart';

/// Module 8 — "Barré-Akkorde & Song-Repertoire" (Wochen 17-20, Schwierigkeit 6).
/// Hauptpreset: CLEAN. Voraussetzung: Level 20.
const String _moduleId = 'module-08';

final List<Lesson> module8Lessons = [
  // 8.1 — Der F-Dur Barré – die große Hürde
  Lesson(
    id: 'lesson-8-1',
    moduleId: _moduleId,
    title: 'Der F-Dur Barré – die große Hürde',
    description:
        'F-Dur ist der berüchtigte erste Barré-Akkord — meistere ihn und du meisterst die Gitarre.',
    instructions: [
      'Zeigefinger Barré über alle 6 Saiten am 1. Bund.',
      'Mittelfinger auf G-Saite, Bund 2.',
      'Ringfinger auf A-Saite, Bund 3.',
      'Kleiner Finger auf D-Saite, Bund 3.',
      'Zupfe jede Saite einzeln — alle müssen klar klingen.',
    ],
    exercises: [
      Exercise(
        id: 'ex-8-1-1',
        lessonId: 'lesson-8-1',
        type: ExerciseType.singleNote,
        instructions:
            'Barré-Finger-Training: Lege den Zeigefinger flach über alle 6 Saiten am 1. Bund und zupfe jede einzeln.',
        targetNoteOrChord: 'F',
        bpm: 50,
        repetitionsRequired: 6,
        accuracyThreshold: 0.68,
        order: 1,
      ),
      Exercise(
        id: 'ex-8-1-2',
        lessonId: 'lesson-8-1',
        type: ExerciseType.chord,
        instructions:
            'Greife F-Dur vollständig und halte den Akkord 5 Sekunden — 5 Mal.',
        targetNoteOrChord: 'F',
        bpm: 50,
        repetitionsRequired: 5,
        accuracyThreshold: 0.68,
        timeoutSeconds: 60,
        order: 2,
      ),
      Exercise(
        id: 'ex-8-1-3',
        lessonId: 'lesson-8-1',
        type: ExerciseType.singleNote,
        instructions:
            'Einzelsaiten-Check: Zupfe jede der 6 Saiten im F-Dur Barré einzeln — alle müssen klingen.',
        targetNoteOrChord: 'F',
        bpm: 50,
        repetitionsRequired: 3,
        accuracyThreshold: 0.70,
        order: 3,
      ),
    ],
    xpReward: 100,
    difficulty: 6,
    targetAccuracy: 0.68,
    presetRequired: GuitarPreset.clean,
    chordIds: const ['F'],
    order: 1,
    isUnlocked: true,
    estimatedMinutes: 20,
  ),

  // 8.2 — B-Moll (Bm) – zweiter Barré
  Lesson(
    id: 'lesson-8-2',
    moduleId: _moduleId,
    title: 'B-Moll (Bm) – zweiter Barré',
    description:
        'Bm ist der zweite große Barré — unverzichtbar für Songs in D-Dur und andere Tonarten.',
    instructions: [
      'Zeigefinger Barré am 2. Bund über alle 6 Saiten.',
      'Ringfinger auf D-Saite, Bund 4.',
      'Kleiner Finger auf G-Saite, Bund 4.',
      'Mittelfinger auf A-Saite, Bund 3 — tiefe E-Saite stumm oder mitgespielt.',
      'Übe den Wechsel F → Bm: beide Akkorde sind Barré-Formen.',
    ],
    exercises: [
      Exercise(
        id: 'ex-8-2-1',
        lessonId: 'lesson-8-2',
        type: ExerciseType.chord,
        instructions: 'Greife Bm fünfmal sauber — alle Saiten müssen klingen.',
        targetNoteOrChord: 'Bm',
        bpm: 50,
        repetitionsRequired: 5,
        accuracyThreshold: 0.68,
        order: 1,
      ),
      Exercise(
        id: 'ex-8-2-2',
        lessonId: 'lesson-8-2',
        type: ExerciseType.chord,
        instructions:
            'Wechsel F → Bm — 6 Wechsel bei 50 BPM.',
        targetNoteOrChord: 'F,Bm',
        noteSequence: ['F', 'Bm', 'F', 'Bm', 'F', 'Bm'],
        bpm: 50,
        repetitionsRequired: 6,
        accuracyThreshold: 0.68,
        timeoutSeconds: 90,
        order: 2,
      ),
    ],
    xpReward: 100,
    difficulty: 6,
    targetAccuracy: 0.68,
    presetRequired: GuitarPreset.clean,
    chordIds: const ['Bm', 'F'],
    order: 2,
    estimatedMinutes: 20,
  ),

  // 8.3 — Barré-Akkorde verschieben
  Lesson(
    id: 'lesson-8-3',
    moduleId: _moduleId,
    title: 'Barré-Akkorde verschieben',
    description:
        'Die E-Form als mobiler Barré: eine Form, alle Dur-Akkorde — F am 1. Bund, G am 3. Bund, A am 5. Bund.',
    instructions: [
      'Greife F-Dur in der E-Form am 1. Bund.',
      'Verschiebe die ganze Form Bund für Bund nach oben.',
      '3. Bund = G-Dur, 5. Bund = A-Dur.',
      'Der Grundton liegt immer auf der tiefen E-Saite.',
      'Übe alle Dur-Akkorde durch Verschieben der E-Form.',
    ],
    exercises: [
      Exercise(
        id: 'ex-8-3-1',
        lessonId: 'lesson-8-3',
        type: ExerciseType.chord,
        instructions:
            'E-Form Barré: F (Bund 1) → G (Bund 3) — 4 Wechsel bei 60 BPM.',
        targetNoteOrChord: 'F,G',
        noteSequence: ['F', 'G', 'F', 'G'],
        bpm: 60,
        repetitionsRequired: 4,
        accuracyThreshold: 0.70,
        timeoutSeconds: 60,
        order: 1,
      ),
      Exercise(
        id: 'ex-8-3-2',
        lessonId: 'lesson-8-3',
        type: ExerciseType.chord,
        instructions:
            'E-Form Barré: F → G (Bund 3) → A (Bund 5) — alle Dur-Akkorde der E-Form, 3 Durchgänge.',
        targetNoteOrChord: 'F,G,A',
        noteSequence: ['F', 'G', 'A', 'G', 'F'],
        bpm: 60,
        repetitionsRequired: 3,
        accuracyThreshold: 0.70,
        timeoutSeconds: 90,
        order: 2,
      ),
    ],
    xpReward: 100,
    difficulty: 6,
    targetAccuracy: 0.70,
    presetRequired: GuitarPreset.clean,
    chordIds: const ['F', 'G', 'A'],
    order: 3,
    estimatedMinutes: 20,
  ),

  // 8.4 — Song-Medley: 3 Songs mit Barré
  Lesson(
    id: 'lesson-8-4',
    moduleId: _moduleId,
    title: 'Song-Medley: 3 Songs mit Barré',
    description:
        'Drei Klassiker mit Barré-Akkorden — No Woman No Cry, Zombie und Wonderwall.',
    instructions: [
      'No Woman No Cry (Bob Marley): C-G-Am-F — F ist Barré!',
      'Zombie (The Cranberries): Em-C-G-D/F# — der D/F# nutzt einen Teil-Barré.',
      'Wonderwall (Oasis): Em7-G-Dsus4-A7sus4 — viele Varianten bekannter Formen.',
      'Starte langsam und steigere das Tempo, bis es sich natürlich anfühlt.',
    ],
    exercises: [
      Exercise(
        id: 'ex-8-4-1',
        lessonId: 'lesson-8-4',
        type: ExerciseType.chord,
        instructions:
            'No Woman No Cry: C-G-Am-F — 4 Durchgänge bei 65 BPM.',
        targetNoteOrChord: 'C,G,Am,F',
        noteSequence: ['C', 'G', 'Am', 'F'],
        bpm: 65,
        repetitionsRequired: 4,
        accuracyThreshold: 0.72,
        timeoutSeconds: 120,
        order: 1,
      ),
      Exercise(
        id: 'ex-8-4-2',
        lessonId: 'lesson-8-4',
        type: ExerciseType.chord,
        instructions:
            'Zombie: Em-C-G-D — 4 Durchgänge bei 80 BPM.',
        targetNoteOrChord: 'Em,C,G,D',
        noteSequence: ['Em', 'C', 'G', 'D'],
        bpm: 80,
        repetitionsRequired: 4,
        accuracyThreshold: 0.72,
        timeoutSeconds: 120,
        order: 2,
      ),
      Exercise(
        id: 'ex-8-4-3',
        lessonId: 'lesson-8-4',
        type: ExerciseType.chord,
        instructions:
            'Wonderwall: Em7-G-Dsus4-A7sus4 — 4 Durchgänge bei 87 BPM.',
        targetNoteOrChord: 'Em7,G,Dsus4,A7sus4',
        noteSequence: ['Em7', 'G', 'Dsus4', 'A7sus4'],
        bpm: 87,
        repetitionsRequired: 4,
        accuracyThreshold: 0.72,
        timeoutSeconds: 120,
        order: 3,
      ),
    ],
    xpReward: 120,
    difficulty: 6,
    targetAccuracy: 0.72,
    presetRequired: GuitarPreset.clean,
    chordIds: const ['C', 'G', 'Am', 'F', 'Em', 'D', 'Em7', 'Dsus4', 'A7sus4'],
    order: 4,
    estimatedMinutes: 25,
  ),

  // 8.5 — Fingerpicking-Intro
  Lesson(
    id: 'lesson-8-5',
    moduleId: _moduleId,
    title: 'Fingerpicking-Intro',
    description:
        'Entdecke Fingerpicking — Daumen-Bass plus p-i-m-a-Pattern und Travis-Picking-Grundlagen.',
    instructions: [
      'p = Daumen (Basssaiten), i = Zeigefinger, m = Mittelfinger, a = Ringfinger.',
      'Muster: p-i-m-a — Daumen schlägt Bass, Finger zupfen die hohen Saiten.',
      'Travis Picking: Daumen wechselt zwischen zwei Basssaiten (alternierend).',
      'Starte mit Am und halte die Form ruhig, während die rechte Hand zupft.',
    ],
    exercises: [
      Exercise(
        id: 'ex-8-5-1',
        lessonId: 'lesson-8-5',
        type: ExerciseType.rhythm,
        instructions:
            'p-i-m-a Pattern auf Am — Daumen auf A-Saite, Finger auf D-G-H, 8 Takte bei 60 BPM.',
        targetNoteOrChord: 'Am',
        pattern: 'p-i-m-a',
        bpm: 60,
        repetitionsRequired: 8,
        accuracyThreshold: 0.72,
        order: 1,
      ),
      Exercise(
        id: 'ex-8-5-2',
        lessonId: 'lesson-8-5',
        type: ExerciseType.rhythm,
        instructions:
            'Travis Picking Grundmuster auf C-Dur — Daumen wechselt A- und D-Saite, 8 Takte bei 60 BPM.',
        targetNoteOrChord: 'C',
        pattern: 'travis',
        bpm: 60,
        repetitionsRequired: 8,
        accuracyThreshold: 0.70,
        timeoutSeconds: 90,
        order: 2,
      ),
    ],
    xpReward: 100,
    difficulty: 5,
    targetAccuracy: 0.70,
    presetRequired: GuitarPreset.clean,
    chordIds: const ['Am', 'C'],
    order: 5,
    estimatedMinutes: 20,
  ),

  // 8.6 — Abschlussprojekt Modul 8
  Lesson(
    id: 'lesson-8-6',
    moduleId: _moduleId,
    title: 'Abschlussprojekt Modul 8',
    description:
        'Das große Finale: spiele einen vollständigen Song aus der Song-Bibliothek mit Akkorden und Strumming.',
    instructions: [
      'Wähle einen Song aus der Bibliothek, der Barré-Akkorde enthält.',
      'Spiele den Song von Anfang bis Ende durch — Intro, Verse, Chorus.',
      'Nutze das gelernte Strumming-Pattern und sorge für Dynamik.',
      'Wiederhole, bis du mit dem Ergebnis zufrieden bist.',
    ],
    exercises: [
      Exercise(
        id: 'ex-8-6-1',
        lessonId: 'lesson-8-6',
        type: ExerciseType.chord,
        instructions:
            'Vollständiger Song (Wahl: No Woman No Cry oder Wonderwall) — Akkordfolge mit Strumming, 2 Durchgänge bei 70 BPM.',
        targetNoteOrChord: 'C,G,Am,F',
        noteSequence: ['C', 'G', 'Am', 'F'],
        pattern: 'D-DU-UDU',
        bpm: 70,
        repetitionsRequired: 2,
        accuracyThreshold: 0.75,
        timeoutSeconds: 180,
        order: 1,
      ),
      Exercise(
        id: 'ex-8-6-2',
        lessonId: 'lesson-8-6',
        type: ExerciseType.strumming,
        instructions:
            'Song mit Dynamik: Verse leise, Chorus laut — vollständige Performance, Originaltempo.',
        targetNoteOrChord: 'C,G,Am,F',
        noteSequence: ['C', 'G', 'Am', 'F'],
        pattern: 'D-DU-UDU',
        bpm: 75,
        repetitionsRequired: 2,
        accuracyThreshold: 0.75,
        timeoutSeconds: 180,
        order: 2,
      ),
    ],
    xpReward: 150,
    difficulty: 6,
    targetAccuracy: 0.75,
    presetRequired: GuitarPreset.clean,
    chordIds: const ['C', 'G', 'Am', 'F'],
    order: 6,
    estimatedMinutes: 30,
  ),
];

final Module module8 = Module(
  id: _moduleId,
  moduleNumber: 8,
  title: 'Barré-Akkorde & Song-Repertoire',
  description:
      'Meistere Barré-Akkorde, erweitere dein Song-Repertoire mit drei Klassikern und entdecke Fingerpicking.',
  weekRange: 'Woche 17-20',
  presetRequired: GuitarPreset.clean,
  difficulty: 6,
  isLocked: true,
  unlockedPresets: const [],
  learningGoals:
      'F-Dur Barré, Bm Barré, verschiebbare E-Form, No Woman No Cry, Zombie, Wonderwall, Fingerpicking, Abschlussprojekt.',
  lessons: module8Lessons,
);
