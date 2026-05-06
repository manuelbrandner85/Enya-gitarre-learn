import 'package:flutter/material.dart';

class XmariConstants {
  XmariConstants._();

  static const List<String> presetNames = ['Clean', 'Overdrive', 'Distortion', 'High-Gain'];
  static const List<Color> presetColors = [
    Color(0xFF4CAF50), // Clean = Grün
    Color(0xFFFF9800), // Overdrive = Orange
    Color(0xFFF44336), // Distortion = Rot
    Color(0xFF9C27B0), // High-Gain = Lila
  ];
  static const List<IconData> presetIcons = [
    Icons.music_note,
    Icons.bolt,
    Icons.whatshot,
    Icons.star,
  ];

  static const List<String> pickupPositions = [
    'Position 1 (Bridge)',
    'Position 2',
    'Position 3 (Mitte)',
    'Position 4',
    'Position 5 (Hals)',
  ];
  static const List<String> pickupDescriptions = [
    'Hell & scharf – ideal für Solo und Lead',
    'Klar mit Biss – vielseitig einsetzbar',
    'Ausgewogen – Bridge + Neck gemischt',
    'Warm & voll – ideal für Anfänger',
    'Weich & rund – Jazz und Clean-Ton',
  ];

  static const int defaultBeginnerPreset = 0;  // Clean
  static const int defaultBeginnerPickup = 3;  // Position 4 (Index 3)
  static const int batteryLowThreshold = 15;

  static const String usbCDescription =
      'USB-C OTG: Digitaler Audio-Stream direkt von der XMARI. '
      'Präziser als Mikrofon und ermöglicht gleichzeitige Sprachsteuerung.';

  static const String headphoneDescription =
      '3.5mm Kopfhörer-Ausgang an der XMARI: '
      'Silent Practice mit DSP-Effekten – ideal für leises Üben.';

  static Color presetColor(int index) =>
      index >= 0 && index < presetColors.length ? presetColors[index] : presetColors[0];

  static String presetName(int index) =>
      index >= 0 && index < presetNames.length ? presetNames[index] : presetNames[0];
}
