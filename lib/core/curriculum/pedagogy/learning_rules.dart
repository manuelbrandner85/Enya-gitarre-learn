import 'lesson_pedagogy_info.dart';

// Re-export der Pädagogik-Typen für Abwärtskompatibilität bestehender Imports.
export 'lesson_pedagogy_info.dart';

/// Globale Lern-Regeln und pädagogische Metadaten der gesamten App.
///
/// Die Map [lessonPedagogy] dient als zentraler Fallback, falls eine
/// Lektion (`Lesson`) selbst kein eingebettetes [LessonPedagogyInfo] mitliefert.
/// Damit bekommt JEDE Lektion über alle 12 Module ein definiertes XMARI-Setup
/// und sinnvolle Voraussetzungen.
class LearningRules {
  LearningRules._();

  /// Maximale Anzahl wirklich neuer Lerninhalte pro Lektion.
  static const int maxNewElementsPerLesson = 1;

  /// Lookup nach Lesson-ID. Reihenfolge: zuerst echte ID (z. B. `lesson-1-1`),
  /// dann der historische Kurzform-Schlüssel (`lesson-01` etc.).
  static const Map<String, LessonPedagogyInfo> lessonPedagogy = {
    // ── Alte Kurzform-Keys (historisch, bleiben als Fallback) ─────────────
    'lesson-01': LessonPedagogyInfo(
      primaryElement: NewElement.newNote,
      prerequisites: [],
      maxFingers: 0,
      requiresPreviousLessonComplete: false,
      xmariSetup: XmariSetup.beginnerDefault,
    ),
    'lesson-02': LessonPedagogyInfo(
      primaryElement: NewElement.newString,
      prerequisites: ['lesson-01'],
      maxFingers: 0,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.beginnerDefault,
    ),
    'lesson-03': LessonPedagogyInfo(
      primaryElement: NewElement.newString,
      prerequisites: ['lesson-02'],
      maxFingers: 0,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.beginnerDefault,
    ),
    'lesson-04': LessonPedagogyInfo(
      primaryElement: NewElement.newFinger,
      prerequisites: ['lesson-03'],
      maxFingers: 1,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.beginnerDefault,
    ),
    'lesson-05': LessonPedagogyInfo(
      primaryElement: NewElement.newNote,
      prerequisites: ['lesson-04'],
      maxFingers: 1,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.beginnerDefault,
    ),
    'lesson-06': LessonPedagogyInfo(
      primaryElement: NewElement.newFinger,
      prerequisites: ['lesson-05'],
      maxFingers: 2,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.beginnerDefault,
    ),
    'lesson-07': LessonPedagogyInfo(
      primaryElement: NewElement.newRhythm,
      prerequisites: ['lesson-06'],
      maxFingers: 2,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.beginnerDefault,
    ),
    'lesson-08': LessonPedagogyInfo(
      primaryElement: NewElement.newTechnique,
      prerequisites: ['lesson-07'],
      maxFingers: 2,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.beginnerDefault,
    ),
    'lesson-09': LessonPedagogyInfo(
      primaryElement: NewElement.newChord,
      prerequisites: ['lesson-08'],
      maxFingers: 3,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.beginnerDefault,
    ),
    'lesson-10': LessonPedagogyInfo(
      primaryElement: NewElement.newChord,
      prerequisites: ['lesson-09'],
      maxFingers: 3,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.beginnerDefault,
    ),

    // ── Modul 1 – Erste Töne (Clean, 0–1 Finger) ──────────────────────────
    'lesson-1-1': LessonPedagogyInfo(
      primaryElement: NewElement.newNote,
      prerequisites: [],
      maxFingers: 1,
      requiresPreviousLessonComplete: false,
      xmariSetup: XmariSetup.beginnerDefault,
    ),
    'lesson-1-2': LessonPedagogyInfo(
      primaryElement: NewElement.newString,
      prerequisites: ['lesson-1-1'],
      maxFingers: 1,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.beginnerDefault,
    ),
    'lesson-1-3': LessonPedagogyInfo(
      primaryElement: NewElement.newString,
      prerequisites: ['lesson-1-2'],
      maxFingers: 1,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.beginnerDefault,
    ),
    'lesson-1-4': LessonPedagogyInfo(
      primaryElement: NewElement.newRhythm,
      prerequisites: ['lesson-1-3'],
      maxFingers: 1,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.beginnerDefault,
    ),
    'lesson-1-5': LessonPedagogyInfo(
      primaryElement: NewElement.newTechnique,
      prerequisites: ['lesson-1-4'],
      maxFingers: 1,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.beginnerDefault,
    ),

    // ── Modul 2 – Erste Akkorde / Power-Chords (Clean → Overdrive) ─────────
    'lesson-2-1': LessonPedagogyInfo(
      primaryElement: NewElement.newChord,
      prerequisites: ['lesson-1-5'],
      maxFingers: 2,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.beginnerDefault,
    ),
    'lesson-2-2': LessonPedagogyInfo(
      primaryElement: NewElement.newChord,
      prerequisites: ['lesson-2-1'],
      maxFingers: 2,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.beginnerDefault,
    ),
    'lesson-2-3': LessonPedagogyInfo(
      primaryElement: NewElement.newRhythm,
      prerequisites: ['lesson-2-2'],
      maxFingers: 2,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.beginnerDefault,
    ),
    'lesson-2-4': LessonPedagogyInfo(
      primaryElement: NewElement.newTechnique,
      prerequisites: ['lesson-2-3'],
      maxFingers: 2,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.overdriveRock,
    ),
    'lesson-2-5': LessonPedagogyInfo(
      primaryElement: NewElement.newChord,
      prerequisites: ['lesson-2-4'],
      maxFingers: 2,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.overdriveRock,
    ),

    // ── Modul 3 – Offene Akkorde / Strumming (Clean) ───────────────────────
    'lesson-3-1': LessonPedagogyInfo(
      primaryElement: NewElement.newChord,
      prerequisites: ['lesson-2-5'],
      maxFingers: 3,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.beginnerDefault,
    ),
    'lesson-3-2': LessonPedagogyInfo(
      primaryElement: NewElement.newChord,
      prerequisites: ['lesson-3-1'],
      maxFingers: 3,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.beginnerDefault,
    ),
    'lesson-3-3': LessonPedagogyInfo(
      primaryElement: NewElement.newChord,
      prerequisites: ['lesson-3-2'],
      maxFingers: 3,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.beginnerDefault,
    ),
    'lesson-3-4': LessonPedagogyInfo(
      primaryElement: NewElement.newRhythm,
      prerequisites: ['lesson-3-3'],
      maxFingers: 3,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.beginnerDefault,
    ),
    'lesson-3-5': LessonPedagogyInfo(
      primaryElement: NewElement.newTechnique,
      prerequisites: ['lesson-3-4'],
      maxFingers: 3,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.beginnerDefault,
    ),

    // ── Modul 4 – Moll-Akkorde / Wechsel (Clean) ──────────────────────────
    'lesson-4-1': LessonPedagogyInfo(
      primaryElement: NewElement.newChord,
      prerequisites: ['lesson-3-5'],
      maxFingers: 3,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.beginnerDefault,
    ),
    'lesson-4-2': LessonPedagogyInfo(
      primaryElement: NewElement.newChord,
      prerequisites: ['lesson-4-1'],
      maxFingers: 3,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.beginnerDefault,
    ),
    'lesson-4-3': LessonPedagogyInfo(
      primaryElement: NewElement.newChord,
      prerequisites: ['lesson-4-2'],
      maxFingers: 3,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.beginnerDefault,
    ),
    'lesson-4-4': LessonPedagogyInfo(
      primaryElement: NewElement.newTechnique,
      prerequisites: ['lesson-4-3'],
      maxFingers: 3,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.beginnerDefault,
    ),
    'lesson-4-5': LessonPedagogyInfo(
      primaryElement: NewElement.newRhythm,
      prerequisites: ['lesson-4-4'],
      maxFingers: 3,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.beginnerDefault,
    ),
    'lesson-4-6': LessonPedagogyInfo(
      primaryElement: NewElement.newChord,
      prerequisites: ['lesson-4-5'],
      maxFingers: 3,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.beginnerDefault,
    ),

    // ── Modul 5 – Pentatonik / Erste Riffs (Overdrive, Fingerpicking=Clean) ─
    'lesson-5-1': LessonPedagogyInfo(
      primaryElement: NewElement.newNote,
      prerequisites: ['lesson-4-6'],
      maxFingers: 3,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.overdriveRock,
    ),
    'lesson-5-2': LessonPedagogyInfo(
      primaryElement: NewElement.newTechnique,
      prerequisites: ['lesson-5-1'],
      maxFingers: 3,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.overdriveRock,
    ),
    'lesson-5-3': LessonPedagogyInfo(
      primaryElement: NewElement.newRhythm,
      prerequisites: ['lesson-5-2'],
      maxFingers: 3,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.overdriveRock,
    ),
    'lesson-5-4': LessonPedagogyInfo(
      primaryElement: NewElement.newTechnique,
      prerequisites: ['lesson-5-3'],
      maxFingers: 3,
      requiresPreviousLessonComplete: true,
      // Fingerpicking → Clean
      xmariSetup: XmariSetup.cleanFingerpicking,
    ),
    'lesson-5-5': LessonPedagogyInfo(
      primaryElement: NewElement.newNote,
      prerequisites: ['lesson-5-4'],
      maxFingers: 3,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.overdriveRock,
    ),
    'lesson-5-6': LessonPedagogyInfo(
      primaryElement: NewElement.newTechnique,
      prerequisites: ['lesson-5-5'],
      maxFingers: 3,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.overdriveRock,
    ),

    // ── Modul 6 – Fingerpicking & Arpeggios (Clean) ───────────────────────
    'lesson-6-1': LessonPedagogyInfo(
      primaryElement: NewElement.newTechnique,
      prerequisites: ['lesson-5-6'],
      maxFingers: 4,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.cleanFingerpicking,
    ),
    'lesson-6-2': LessonPedagogyInfo(
      primaryElement: NewElement.newRhythm,
      prerequisites: ['lesson-6-1'],
      maxFingers: 4,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.cleanFingerpicking,
    ),
    'lesson-6-3': LessonPedagogyInfo(
      primaryElement: NewElement.newTechnique,
      prerequisites: ['lesson-6-2'],
      maxFingers: 4,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.cleanFingerpicking,
    ),
    'lesson-6-4': LessonPedagogyInfo(
      primaryElement: NewElement.newRhythm,
      prerequisites: ['lesson-6-3'],
      maxFingers: 4,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.cleanFingerpicking,
    ),
    'lesson-6-5': LessonPedagogyInfo(
      primaryElement: NewElement.newTechnique,
      prerequisites: ['lesson-6-4'],
      maxFingers: 4,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.cleanFingerpicking,
    ),
    'lesson-6-6': LessonPedagogyInfo(
      primaryElement: NewElement.newChord,
      prerequisites: ['lesson-6-5'],
      maxFingers: 4,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.cleanFingerpicking,
    ),

    // ── Modul 7 – Barré-Akkorde (Overdrive, später Distortion) ────────────
    'lesson-7-1': LessonPedagogyInfo(
      primaryElement: NewElement.newTechnique,
      prerequisites: ['lesson-6-6'],
      maxFingers: 4,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.overdriveRhythm,
    ),
    'lesson-7-2': LessonPedagogyInfo(
      primaryElement: NewElement.newChord,
      prerequisites: ['lesson-7-1'],
      maxFingers: 4,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.overdriveRhythm,
    ),
    'lesson-7-3': LessonPedagogyInfo(
      primaryElement: NewElement.newChord,
      prerequisites: ['lesson-7-2'],
      maxFingers: 4,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.overdriveRhythm,
    ),
    'lesson-7-4': LessonPedagogyInfo(
      primaryElement: NewElement.newChord,
      prerequisites: ['lesson-7-3'],
      maxFingers: 4,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.overdriveRhythm,
    ),
    'lesson-7-5': LessonPedagogyInfo(
      primaryElement: NewElement.newTechnique,
      prerequisites: ['lesson-7-4'],
      maxFingers: 4,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.distortionMetal,
    ),
    'lesson-7-6': LessonPedagogyInfo(
      primaryElement: NewElement.newRhythm,
      prerequisites: ['lesson-7-5'],
      maxFingers: 4,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.overdriveRhythm,
    ),

    // ── Modul 8 – Riffs & Solo-Basics (Distortion / Overdrive) ────────────
    'lesson-8-1': LessonPedagogyInfo(
      primaryElement: NewElement.newTechnique,
      prerequisites: ['lesson-7-6'],
      maxFingers: 4,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.distortionMetal,
    ),
    'lesson-8-2': LessonPedagogyInfo(
      primaryElement: NewElement.newRhythm,
      prerequisites: ['lesson-8-1'],
      maxFingers: 4,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.distortionMetal,
    ),
    'lesson-8-3': LessonPedagogyInfo(
      primaryElement: NewElement.newTechnique,
      prerequisites: ['lesson-8-2'],
      maxFingers: 4,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.distortionLead,
    ),
    'lesson-8-4': LessonPedagogyInfo(
      primaryElement: NewElement.newTechnique,
      prerequisites: ['lesson-8-3'],
      maxFingers: 4,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.distortionLead,
    ),
    'lesson-8-5': LessonPedagogyInfo(
      primaryElement: NewElement.newRhythm,
      prerequisites: ['lesson-8-4'],
      maxFingers: 4,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.overdriveRock,
    ),
    'lesson-8-6': LessonPedagogyInfo(
      primaryElement: NewElement.newTechnique,
      prerequisites: ['lesson-8-5'],
      maxFingers: 4,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.distortionLead,
    ),

    // ── Modul 9 – Erweiterte Akkorde 7/sus/add9 (Clean / Overdrive) ───────
    'lesson-9-1': LessonPedagogyInfo(
      primaryElement: NewElement.newChord,
      prerequisites: ['lesson-8-6'],
      maxFingers: 4,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.beginnerDefault,
    ),
    'lesson-9-2': LessonPedagogyInfo(
      primaryElement: NewElement.newChord,
      prerequisites: ['lesson-9-1'],
      maxFingers: 4,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.beginnerDefault,
    ),
    'lesson-9-3': LessonPedagogyInfo(
      primaryElement: NewElement.newChord,
      prerequisites: ['lesson-9-2'],
      maxFingers: 4,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.cleanFunk,
    ),
    'lesson-9-4': LessonPedagogyInfo(
      primaryElement: NewElement.newChord,
      prerequisites: ['lesson-9-3'],
      maxFingers: 4,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.overdriveRock,
    ),
    'lesson-9-5': LessonPedagogyInfo(
      primaryElement: NewElement.newRhythm,
      prerequisites: ['lesson-9-4'],
      maxFingers: 4,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.cleanFunk,
    ),

    // ── Modul 10 – Lead-Techniken: Bending, Slides, Vibrato (Distortion) ──
    'lesson-10-1': LessonPedagogyInfo(
      primaryElement: NewElement.newTechnique,
      prerequisites: ['lesson-9-5'],
      maxFingers: 4,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.distortionLead,
    ),
    'lesson-10-2': LessonPedagogyInfo(
      primaryElement: NewElement.newTechnique,
      prerequisites: ['lesson-10-1'],
      maxFingers: 4,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.distortionLead,
    ),
    'lesson-10-3': LessonPedagogyInfo(
      primaryElement: NewElement.newTechnique,
      prerequisites: ['lesson-10-2'],
      maxFingers: 4,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.distortionLead,
    ),
    'lesson-10-4': LessonPedagogyInfo(
      primaryElement: NewElement.newTechnique,
      prerequisites: ['lesson-10-3'],
      maxFingers: 4,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.distortionMetal,
    ),
    'lesson-10-5': LessonPedagogyInfo(
      primaryElement: NewElement.newRhythm,
      prerequisites: ['lesson-10-4'],
      maxFingers: 4,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.distortionLead,
    ),

    // ── Modul 11 – Stilistik: Blues, Funk, Fingerpicking, Jazz ────────────
    'lesson-11-1': LessonPedagogyInfo(
      primaryElement: NewElement.newRhythm,
      prerequisites: ['lesson-10-5'],
      maxFingers: 4,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.overdriveRock,
    ),
    'lesson-11-2': LessonPedagogyInfo(
      primaryElement: NewElement.newTechnique,
      prerequisites: ['lesson-11-1'],
      maxFingers: 4,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.overdriveRock,
    ),
    'lesson-11-3': LessonPedagogyInfo(
      primaryElement: NewElement.newRhythm,
      prerequisites: ['lesson-11-2'],
      maxFingers: 4,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.cleanFunk,
    ),
    'lesson-11-4': LessonPedagogyInfo(
      primaryElement: NewElement.newTechnique,
      prerequisites: ['lesson-11-3'],
      maxFingers: 4,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.cleanFunk,
    ),
    'lesson-11-5': LessonPedagogyInfo(
      primaryElement: NewElement.newTechnique,
      prerequisites: ['lesson-11-4'],
      maxFingers: 4,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.cleanFingerpicking,
    ),
    'lesson-11-6': LessonPedagogyInfo(
      primaryElement: NewElement.newRhythm,
      prerequisites: ['lesson-11-5'],
      maxFingers: 4,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.cleanFingerpicking,
    ),
    'lesson-11-7': LessonPedagogyInfo(
      primaryElement: NewElement.newChord,
      prerequisites: ['lesson-11-6'],
      maxFingers: 4,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.beginnerDefault,
    ),
    'lesson-11-8': LessonPedagogyInfo(
      primaryElement: NewElement.newTechnique,
      prerequisites: ['lesson-11-7'],
      maxFingers: 4,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.beginnerDefault,
    ),
    'lesson-11-9': LessonPedagogyInfo(
      primaryElement: NewElement.newRhythm,
      prerequisites: ['lesson-11-8'],
      maxFingers: 4,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.overdriveRock,
    ),

    // ── Modul 12 – Performance & Improvisation (gemischt) ─────────────────
    'lesson-12-1': LessonPedagogyInfo(
      primaryElement: NewElement.newTechnique,
      prerequisites: ['lesson-11-9'],
      maxFingers: 4,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.distortionLead,
    ),
    'lesson-12-2': LessonPedagogyInfo(
      primaryElement: NewElement.newRhythm,
      prerequisites: ['lesson-12-1'],
      maxFingers: 4,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.overdriveRock,
    ),
    'lesson-12-3': LessonPedagogyInfo(
      primaryElement: NewElement.newTechnique,
      prerequisites: ['lesson-12-2'],
      maxFingers: 4,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.distortionLead,
    ),
    'lesson-12-4': LessonPedagogyInfo(
      primaryElement: NewElement.newRhythm,
      prerequisites: ['lesson-12-3'],
      maxFingers: 4,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.cleanFingerpicking,
    ),
    'lesson-12-5': LessonPedagogyInfo(
      primaryElement: NewElement.newTechnique,
      prerequisites: ['lesson-12-4'],
      maxFingers: 4,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.distortionMetal,
    ),
    'lesson-12-6': LessonPedagogyInfo(
      primaryElement: NewElement.newRhythm,
      prerequisites: ['lesson-12-5'],
      maxFingers: 4,
      requiresPreviousLessonComplete: true,
      xmariSetup: XmariSetup.overdriveRock,
    ),
  };

  /// Liefert die Pädagogik-Info zu einer Lesson-ID inkl. Fallback auf
  /// [XmariSetup.beginnerDefault], damit niemals `null` zurückkommt.
  static LessonPedagogyInfo lookupOrDefault(String lessonId) {
    final hit = lessonPedagogy[lessonId];
    if (hit != null) return hit;
    return const LessonPedagogyInfo(
      primaryElement: NewElement.newNote,
      prerequisites: [],
      maxFingers: 4,
      requiresPreviousLessonComplete: false,
      xmariSetup: XmariSetup.beginnerDefault,
    );
  }
}
