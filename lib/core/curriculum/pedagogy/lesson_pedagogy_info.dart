/// Pädagogik-Datentypen für Lektionen.
///
/// Diese Datei enthält die Kerntypen [NewElement], [XmariSetup] und
/// [LessonPedagogyInfo]. Sie wurde aus `learning_rules.dart` extrahiert,
/// damit andere Curriculum-Module (z. B. die Modul-Daten in
/// `module_*_data.dart`) die Typen importieren können, ohne den Map-Inhalt
/// laden zu müssen.

/// Klassifikation des neuen Lerninhalts einer Lektion.
enum NewElement {
  newNote,
  newFinger,
  newString,
  newRhythm,
  newTechnique,
  newChord,
}

/// Empfohlene Hardware-Konfiguration der XMARI für eine Lektion.
class XmariSetup {
  final String presetName;
  final int presetIndex;
  final String pickupPosition;
  final int pickupIndex;
  final String? toneKnobSuggestion;
  final String explanation;
  final bool requiresHeadphones;

  const XmariSetup({
    required this.presetName,
    required this.presetIndex,
    required this.pickupPosition,
    required this.pickupIndex,
    this.toneKnobSuggestion,
    required this.explanation,
    this.requiresHeadphones = false,
  });

  // ── Anfänger / Cleane Sounds ───────────────────────────────────────────────

  /// Standard-Setup für Anfänger: Clean, Hals-Pickup (Position 4).
  static const XmariSetup beginnerDefault = XmariSetup(
    presetName: 'Clean',
    presetIndex: 0,
    pickupPosition: 'Position 4',
    pickupIndex: 4,
    toneKnobSuggestion: 'Tone-Regler auf ca. 7',
    explanation:
        'Clean-Sound am Hals-Pickup – der weichste, freundlichste Ton für Anfänger.',
    requiresHeadphones: false,
  );

  /// Cleaner Klang für Fingerpicking (heller Steg-Pickup).
  static const XmariSetup cleanFingerpicking = XmariSetup(
    presetName: 'Clean',
    presetIndex: 0,
    pickupPosition: 'Position 5',
    pickupIndex: 5,
    toneKnobSuggestion: 'Tone-Regler auf ca. 8',
    explanation:
        'Clean-Sound am Steg-Pickup – heller und perkussiver Ton, ideal für Fingerpicking.',
  );

  /// Funk-Setup: Clean mit Mittelposition (knackig).
  static const XmariSetup cleanFunk = XmariSetup(
    presetName: 'Clean',
    presetIndex: 0,
    pickupPosition: 'Position 3',
    pickupIndex: 3,
    toneKnobSuggestion: 'Tone-Regler auf ca. 6',
    explanation:
        'Clean-Sound am Mittel-Pickup – funky und perkussiv für rhythmische Akkordarbeit.',
  );

  // ── Overdrive / Rock ───────────────────────────────────────────────────────

  /// Overdrive-Setup für Rock und Blues (Mittelposition).
  static const XmariSetup overdriveRock = XmariSetup(
    presetName: 'Overdrive',
    presetIndex: 1,
    pickupPosition: 'Position 3',
    pickupIndex: 3,
    explanation:
        'Overdrive-Sound für Rock und Blues – warm mit leichter Verzerrung.',
  );

  /// Overdrive-Setup für klassischen Rhythm-Rock (Bridge).
  static const XmariSetup overdriveRhythm = XmariSetup(
    presetName: 'Overdrive',
    presetIndex: 1,
    pickupPosition: 'Position 1',
    pickupIndex: 1,
    explanation:
        'Overdrive am Bridge-Pickup – knackiger Rhythm-Rock-Sound mit Biss.',
  );

  // ── Distortion / Metal / Lead ──────────────────────────────────────────────

  /// Distortion-Setup für Lead und Metal.
  static const XmariSetup distortionMetal = XmariSetup(
    presetName: 'Distortion',
    presetIndex: 2,
    pickupPosition: 'Position 1',
    pickupIndex: 1,
    explanation:
        'Distortion am Bridge-Pickup – aggressiver Sound für Metal und Hard Rock.',
  );

  /// Distortion-Setup für Lead-Lines (singende Mitten).
  static const XmariSetup distortionLead = XmariSetup(
    presetName: 'Distortion',
    presetIndex: 2,
    pickupPosition: 'Position 2',
    pickupIndex: 2,
    toneKnobSuggestion: 'Tone-Regler auf ca. 6',
    explanation:
        'Distortion in Position 2 – singend und durchsetzungsfähig für Solo-Lines.',
  );

  // ── High-Gain ──────────────────────────────────────────────────────────────

  /// High-Gain-Setup für extremes Metal.
  static const XmariSetup highGainMetal = XmariSetup(
    presetName: 'High Gain',
    presetIndex: 3,
    pickupPosition: 'Position 1',
    pickupIndex: 1,
    toneKnobSuggestion: 'Tone-Regler auf ca. 5',
    explanation:
        'High-Gain am Bridge-Pickup – maximale Verzerrung für moderne Metal-Riffs.',
    requiresHeadphones: true,
  );
}

/// Pädagogische Metadaten zu einer Lektion: welcher neue Lerninhalt,
/// welche Vorbedingungen, wieviele Finger benötigt werden, sowie das
/// empfohlene XMARI-Setup.
class LessonPedagogyInfo {
  final NewElement primaryElement;
  final List<String> prerequisites;
  final int maxFingers;
  final bool requiresPreviousLessonComplete;
  final XmariSetup xmariSetup;

  const LessonPedagogyInfo({
    required this.primaryElement,
    required this.prerequisites,
    required this.maxFingers,
    required this.requiresPreviousLessonComplete,
    required this.xmariSetup,
  });
}
