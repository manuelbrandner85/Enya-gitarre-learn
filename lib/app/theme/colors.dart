import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary - Violet
  static const Color primary = Color(0xFF7C3AED);
  static const Color primaryDark = Color(0xFF5B21B6);
  static const Color primaryLight = Color(0xFFA78BFA);
  static const Color primaryMuted = Color(0x307C3AED);

  // Secondary - Electric Blue
  static const Color secondary = Color(0xFF3B82F6);
  static const Color secondaryDark = Color(0xFF1D4ED8);
  static const Color secondaryLight = Color(0xFF60A5FA);

  // Accent - Indigo
  static const Color accent = Color(0xFF818CF8);
  static const Color accentDark = Color(0xFF4F46E5);
  static const Color accentLight = Color(0xFFC7D2FE);

  // Background - Dark
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color cardDark = Color(0xFF252525);
  static const Color surfaceVariantDark = Color(0xFF2A2A2A);

  // Text - Dark mode
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB3B3B3);
  static const Color textTertiary = Color(0xFF737373);
  static const Color textDisabled = Color(0xFF404040);

  // Borders
  static const Color outline = Color(0xFF2E2E2E);
  static const Color outlineVariant = Color(0xFF1E1E1E);

  // Semantic
  static const Color error = Color(0xFFCF6679);
  static const Color warning = Color(0xFFFFC107);
  static const Color success = Color(0xFF4CAF50);
  static const Color info = Color(0xFF2196F3);

  // Finger Colors (Guitar fingering)
  static const Color fingerIndex = Color(0xFF2196F3);   // Blue - Index (1)
  static const Color fingerMiddle = Color(0xFF4CAF50);  // Green - Middle (2)
  static const Color fingerRing = Color(0xFFF44336);    // Red - Ring (3)
  static const Color fingerPinky = Color(0xFFFFC107);   // Yellow - Pinky (4)
  static const Color fingerThumb = Color(0xFF9C27B0);   // Purple - Thumb (T)

  // Fretboard Colors
  static const Color fretboardWood = Color(0xFF2C1810);
  static const Color fretboardFret = Color(0xFFB8B8B8);
  static const Color fretboardInlay = Color(0xFFE8E8E0);
  static const Color stringColor = Color(0xFFC0C0C0);
  static const Color openStringColor = Color(0xFF7C3AED);
  static const Color mutedStringColor = Color(0xFFCF6679);
  static const Color pressedNoteColor = Color(0xFF7C3AED);

  // Preset Colors
  static const Color presetClean = Color(0xFF2196F3);
  static const Color presetOverdrive = Color(0xFFFF9800);
  static const Color presetDistortion = Color(0xFFF44336);
  static const Color presetHighGain = Color(0xFF9C27B0);
  static const Color presetAcoustic = Color(0xFF795548);
  static const Color presetJazz = Color(0xFF607D8B);

  // Level Colors
  static const Color levelBronze = Color(0xFFCD7F32);
  static const Color levelSilver = Color(0xFFC0C0C0);
  static const Color levelGold = Color(0xFFFFD700);
  static const Color levelDiamond = Color(0xFF00B4D8);
  static const Color levelMaster = Color(0xFF9C27B0);

  // XP / Gamification
  static const Color xpColor = Color(0xFFFFD700);
  static const Color streakColor = Color(0xFFFF6B35);
  static const Color achievementColor = Color(0xFF7C3AED);

  // Chart Colors
  static const List<Color> chartColors = [
    Color(0xFF7C3AED),
    Color(0xFF00B4D8),
    Color(0xFFFF6B35),
    Color(0xFFFFD700),
    Color(0xFF9C27B0),
    Color(0xFFF44336),
  ];

  // Gradient Presets
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF7C3AED), Color(0xFF3B82F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF1E1E1E), Color(0xFF121212)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient fireGradient = LinearGradient(
    colors: [Color(0xFFFF6B35), Color(0xFFFFD700)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient electricGradient = LinearGradient(
    colors: [Color(0xFF3B82F6), Color(0xFF7C3AED)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
