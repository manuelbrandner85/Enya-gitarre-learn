import 'package:flutter/material.dart';

class NoteColors {
  NoteColors._();

  static const Map<String, Color> _colors = {
    'C': Color(0xFFEF5350),  // Rot
    'D': Color(0xFFFF9800),  // Orange
    'E': Color(0xFFFFEB3B),  // Gelb
    'F': Color(0xFF4CAF50),  // Grün
    'G': Color(0xFF2196F3),  // Blau
    'A': Color(0xFF3F51B5),  // Indigo
    'B': Color(0xFF9C27B0),  // Violett
  };

  static Color forNote(String noteName) {
    if (noteName.isEmpty) return Colors.white;
    final base = noteName[0].toUpperCase();
    return _colors[base] ?? Colors.white;
  }

  static Color forNoteWithOpacity(String noteName, double opacity) =>
      forNote(noteName).withOpacity(opacity);
}
