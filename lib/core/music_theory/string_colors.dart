import 'package:flutter/material.dart';

/// Color assignments for each guitar string.
///
/// String numbering follows guitar convention: string 1 = high e, string 6 = low E.
class StringColors {
  StringColors._();

  /// Low E string (string 6)
  static const Color string6E = Color(0xFFEF5350); // red

  /// A string (string 5)
  static const Color string5A = Color(0xFFFF9800); // orange

  /// D string (string 4)
  static const Color string4D = Color(0xFFFFEB3B); // yellow

  /// G string (string 3)
  static const Color string3G = Color(0xFF4CAF50); // green

  /// B string (string 2)
  static const Color string2B = Color(0xFF2196F3); // blue

  /// High e string (string 1)
  static const Color string1E = Color(0xFF9C27B0); // purple

  /// All string colors indexed by string 1 position:
  /// index 0 = string 1 (high e, purple), index 5 = string 6 (low E, red).
  static const List<Color> all = [
    string1E, // index 0 → string 1 (high e)
    string2B, // index 1 → string 2 (B)
    string3G, // index 2 → string 3 (G)
    string4D, // index 3 → string 4 (D)
    string5A, // index 4 → string 5 (A)
    string6E, // index 5 → string 6 (low E)
  ];

  /// Returns the color for the given [stringNum] (1–6, 1 = high e, 6 = low E).
  static Color forString(int stringNum) {
    assert(stringNum >= 1 && stringNum <= 6,
        'stringNum must be between 1 and 6, got $stringNum');
    // all list is indexed 0=string1, so subtract 1.
    return all[stringNum - 1];
  }
}
