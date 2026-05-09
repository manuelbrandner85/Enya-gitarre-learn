import 'models/curriculum_models.dart';

/// Eingebaute Offline-Fallback-Kurrikulumdaten, die verwendet werden, wenn
/// Supabase nicht erreichbar ist und kein lokaler Cache vorhanden ist.
class CurriculumFallback {
  CurriculumFallback._();

  static const List<ModuleModel> modules = [
    // Modul 1 — Dein erster Ton (kostenlos, Level 1)
    ModuleModel(
      id: 'module-01',
      titleDe: 'Dein erster Ton',
      titleEn: 'Your First Note',
      descriptionDe:
          'Lerne, einen sauberen Einzelton zu spielen, und schließe mit deinem ersten Riff ab.',
      descriptionEn:
          'Learn to play a clean single note and finish with your first riff.',
      orderIndex: 1,
      iconName: 'music_note',
      requiredLevel: 1,
      isFree: true,
    ),

    // Modul 2 — Das Griffbrett verstehen (Level 3)
    ModuleModel(
      id: 'module-02',
      titleDe: 'Das Griffbrett verstehen',
      titleEn: 'Understanding the Fretboard',
      descriptionDe:
          'Erkenne die Töne auf den tiefen Saiten — die Grundlage für Power Chords.',
      descriptionEn:
          'Recognise notes on the lower strings — the foundation for power chords.',
      orderIndex: 2,
      iconName: 'piano',
      requiredLevel: 3,
    ),

    // Modul 3 — Intervalle (Level 5)
    ModuleModel(
      id: 'module-03',
      titleDe: 'Intervalle',
      titleEn: 'Intervals',
      descriptionDe:
          'Verstehe die Bausteine der Musik: Grundton, Sekunde, Terz, Quinte und ihr Klangcharakter.',
      descriptionEn:
          'Understand the building blocks of music: root, second, third, fifth and their sound character.',
      orderIndex: 3,
      iconName: 'music_note',
      requiredLevel: 5,
    ),

    // Modul 4 — Dein erster Power Chord (Level 7, Overdrive freischalten)
    ModuleModel(
      id: 'module-04',
      titleDe: 'Dein erster Power Chord',
      titleEn: 'Your First Power Chord',
      descriptionDe:
          'Lerne Power Chords und schalte den Overdrive-Sound deiner Enya XMARI frei.',
      descriptionEn:
          'Learn power chords and unlock the overdrive sound of your Enya XMARI.',
      orderIndex: 4,
      iconName: 'bolt',
      requiredLevel: 7,
      xmariPreset: 'overdrive',
    ),

    // Modul 5 — Offene Akkorde (Level 9)
    ModuleModel(
      id: 'module-05',
      titleDe: 'Offene Akkorde',
      titleEn: 'Open Chords',
      descriptionDe:
          'Lerne die wichtigsten offenen Akkorde — Em, Am, D, G, C — und spiele deinen ersten Song.',
      descriptionEn:
          'Learn the most important open chords — Em, Am, D, G, C — and play your first song.',
      orderIndex: 5,
      iconName: 'queue_music',
      requiredLevel: 9,
    ),

    // Modul 6 — Rhythmus & Strumming (Level 11)
    ModuleModel(
      id: 'module-06',
      titleDe: 'Rhythmus & Strumming',
      titleEn: 'Rhythm & Strumming',
      descriptionDe:
          'Entwickle ein sicheres Rhythmusgefühl — Down-Strumming, Up-Strumming, das Pop-Pattern und Dynamik.',
      descriptionEn:
          'Develop a solid sense of rhythm — down strumming, up strumming, the pop pattern and dynamics.',
      orderIndex: 6,
      iconName: 'music_note',
      requiredLevel: 11,
    ),

    // Modul 7 — Pentatonik & erstes Solo (Level 13, Overdrive)
    ModuleModel(
      id: 'module-07',
      titleDe: 'Pentatonik & erstes Solo',
      titleEn: 'Pentatonic & First Solo',
      descriptionDe:
          'Lerne die Moll-Pentatonik und alle wichtigen Solo-Techniken — Hammer-On, Pull-Off, Bending, Vibrato.',
      descriptionEn:
          'Learn the minor pentatonic and all key solo techniques — hammer-on, pull-off, bending, vibrato.',
      orderIndex: 7,
      iconName: 'graphic_eq',
      requiredLevel: 13,
      xmariPreset: 'overdrive',
    ),

    // Modul 8 — Barré-Akkorde & Song-Repertoire (Level 15)
    ModuleModel(
      id: 'module-08',
      titleDe: 'Barré-Akkorde & Song-Repertoire',
      titleEn: 'Barre Chords & Song Repertoire',
      descriptionDe:
          'Meistere Barré-Akkorde, erweitere dein Song-Repertoire mit drei Klassikern und entdecke Fingerpicking.',
      descriptionEn:
          'Master barre chords, expand your song repertoire with three classics and discover fingerpicking.',
      orderIndex: 8,
      iconName: 'library_music',
      requiredLevel: 15,
    ),

    // Modul 9 — Distortion & Rock-Techniken (Level 17, Distortion)
    ModuleModel(
      id: 'module-09',
      titleDe: 'Distortion & Rock-Techniken',
      titleEn: 'Distortion & Rock Techniques',
      descriptionDe:
          'Distortion-Sound, Palm Muting, klassische Riffs, Gallop-Picking und Drop-D — der volle Rock-Werkzeugkasten.',
      descriptionEn:
          'Distortion sound, palm muting, classic riffs, gallop picking and drop D — the full rock toolkit.',
      orderIndex: 9,
      iconName: 'bolt',
      requiredLevel: 17,
      xmariPreset: 'distortion',
    ),

    // Modul 10 — Musiktheorie & Songwriting (Level 19)
    ModuleModel(
      id: 'module-10',
      titleDe: 'Musiktheorie & Songwriting',
      titleEn: 'Music Theory & Songwriting',
      descriptionDe:
          'Verstehe Tonleitern, Stufenakkorde und Akkordfolgen — und schalte den High-Gain-Sound frei.',
      descriptionEn:
          'Understand scales, chord degrees and chord progressions — and unlock the high-gain sound.',
      orderIndex: 10,
      iconName: 'piano',
      requiredLevel: 19,
    ),

    // Modul 11 — High-Gain & Fortgeschritten (Level 21, High-Gain)
    ModuleModel(
      id: 'module-11',
      titleDe: 'High-Gain & Fortgeschritten',
      titleEn: 'High-Gain & Advanced',
      descriptionDe:
          'Schnelles Picking, Tapping, Sweep, Dur-Pentatonik, Blues-Tonleiter — und zwei legendäre Soli.',
      descriptionEn:
          'Fast picking, tapping, sweep, major pentatonic, blues scale — and two legendary solos.',
      orderIndex: 11,
      iconName: 'graphic_eq',
      requiredLevel: 21,
      xmariPreset: 'highGain',
    ),

    // Modul 12 — Dein Weg als Gitarrist (Level 23)
    ModuleModel(
      id: 'module-12',
      titleDe: 'Dein Weg als Gitarrist',
      titleEn: 'Your Journey as a Guitarist',
      descriptionDe:
          'Song-Bibliothek, tägliche Challenges, Recording Studio und drei Style Tracks: Blues, Metal, Funk.',
      descriptionEn:
          'Song library, daily challenges, recording studio and three style tracks: blues, metal, funk.',
      orderIndex: 12,
      iconName: 'star',
      requiredLevel: 23,
    ),
  ];
}
