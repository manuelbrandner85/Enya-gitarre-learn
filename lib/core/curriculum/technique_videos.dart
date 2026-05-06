enum GuitarTechnique {
  openStringPluck,
  frettedNotePick,
  downStrum,
  upStrum,
  alternatingPick,
  hammerOn,
  pullOff,
  bend,
  vibrato,
  palmMute,
  powerChord,
  barreChord,
  fingerPicking,
  slide,
  tremoloBarDive,   // XMARI-spezifisch
  pickupSwitch,     // XMARI-spezifisch
  presetChange,     // XMARI-spezifisch
  volumeKnob,       // XMARI-spezifisch
  usbConnect,       // XMARI-spezifisch
  headphoneConnect, // XMARI-spezifisch
}

class TechniqueVideo {
  final GuitarTechnique technique;
  final String assetPath;
  final String titleDe;
  final String titleEn;
  final String descriptionDe;
  final String descriptionEn;
  final Duration duration;
  final bool isLottie;
  final bool isXmariSpecific;

  const TechniqueVideo({
    required this.technique,
    required this.assetPath,
    required this.titleDe,
    required this.titleEn,
    required this.descriptionDe,
    required this.descriptionEn,
    required this.duration,
    this.isLottie = true,
    this.isXmariSpecific = false,
  });
}

class TechniqueVideos {
  TechniqueVideos._();

  static const Map<GuitarTechnique, TechniqueVideo> videos = {
    GuitarTechnique.openStringPluck: TechniqueVideo(
      technique: GuitarTechnique.openStringPluck,
      assetPath: 'assets/animations/techniques/open_string.json',
      titleDe: 'Leere Saite zupfen',
      titleEn: 'Open String Pluck',
      descriptionDe: 'Zupfe die Saite mit dem Daumen oder Zeigefinger der Anschlaghand. '
          'Auf der XMARI: Du hörst den Clean-Sound direkt im Kopfhörer.',
      descriptionEn: 'Pluck the string with your thumb or index finger.',
      duration: Duration(seconds: 3),
    ),
    GuitarTechnique.downStrum: TechniqueVideo(
      technique: GuitarTechnique.downStrum,
      assetPath: 'assets/animations/techniques/down_strum.json',
      titleDe: 'Abschlag (Down Strum)',
      titleEn: 'Down Strum',
      descriptionDe: 'Streiche von der dicksten zur dünnsten Saite. '
          'Lockeres Handgelenk! Auf der XMARI klingt das im Clean-Sound sehr ausgewogen.',
      descriptionEn: 'Strum downward from thick to thin strings.',
      duration: Duration(seconds: 3),
    ),
    GuitarTechnique.hammerOn: TechniqueVideo(
      technique: GuitarTechnique.hammerOn,
      assetPath: 'assets/animations/techniques/hammer_on.json',
      titleDe: 'Hammer-On',
      titleEn: 'Hammer-On',
      descriptionDe: 'Schlage einen Finger auf den Bund ohne die Saite anzuzupfen. '
          'Dank USB-C erkennt die XMARI-App auch diese leisen Töne präzise.',
      descriptionEn: 'Hammer a finger onto a fret without picking.',
      duration: Duration(seconds: 4),
    ),
    GuitarTechnique.presetChange: TechniqueVideo(
      technique: GuitarTechnique.presetChange,
      assetPath: 'assets/animations/techniques/preset_change.json',
      titleDe: 'XMARI Preset wechseln',
      titleEn: 'XMARI Preset Change',
      descriptionDe: 'Halte den Power-Button 1 Sekunde gedrückt. '
          'Du hörst den nächsten Sound: Clean → Overdrive → Distortion → High-Gain. '
          'Oder wechsle direkt in dieser App per Bluetooth.',
      descriptionEn: 'Hold the power button for 1 second to cycle presets.',
      duration: Duration(seconds: 4),
      isXmariSpecific: true,
    ),
    GuitarTechnique.pickupSwitch: TechniqueVideo(
      technique: GuitarTechnique.pickupSwitch,
      assetPath: 'assets/animations/techniques/pickup_switch.json',
      titleDe: 'XMARI 5-Wege-Pickup-Schalter',
      titleEn: 'XMARI Pickup Switch',
      descriptionDe: 'Position 1 (Bridge) = hell & scharf für Solo. '
          'Position 4 oder 5 (Hals) = warm & weich für Anfänger. '
          'Probiere alle Positionen aus – jede klingt völlig anders!',
      descriptionEn: 'Position 1 (bridge) = bright, position 5 (neck) = warm.',
      duration: Duration(seconds: 5),
      isXmariSpecific: true,
    ),
    GuitarTechnique.usbConnect: TechniqueVideo(
      technique: GuitarTechnique.usbConnect,
      assetPath: 'assets/animations/techniques/usb_connect.json',
      titleDe: 'XMARI per USB-C verbinden',
      titleEn: 'Connect XMARI via USB-C',
      descriptionDe: 'Stecke ein USB-C-Kabel in die XMARI und in dein Smartphone. '
          'Das Smartphone erkennt die XMARI als Audiogerät. '
          'Öffne die App – sie wechselt automatisch auf USB-Audio.',
      descriptionEn: 'Connect USB-C cable from XMARI to your phone for digital audio.',
      duration: Duration(seconds: 6),
      isXmariSpecific: true,
    ),
    GuitarTechnique.tremoloBarDive: TechniqueVideo(
      technique: GuitarTechnique.tremoloBarDive,
      assetPath: 'assets/animations/techniques/tremolo_dive.json',
      titleDe: 'XMARI Tremolo-Hebel',
      titleEn: 'XMARI Tremolo Dive',
      descriptionDe: 'Der patentierte Tremolo-Hebel der XMARI: Drücke ihn sanft nach unten '
          'um den Ton tiefer zu ziehen. Lasse langsam los für den "Dive Bomb"-Effekt.',
      descriptionEn: 'Press the tremolo bar down to lower pitch.',
      duration: Duration(seconds: 5),
      isXmariSpecific: true,
    ),
  };

  static TechniqueVideo? forTechnique(GuitarTechnique t) => videos[t];
}
