import 'package:flutter/material.dart';

import 'colors.dart';

class AppTypography {
  AppTypography._();

  static TextTheme get darkTextTheme => _buildTextTheme(
        primaryColor: AppColors.textPrimary,
        secondaryColor: AppColors.textSecondary,
      );

  static TextTheme get lightTextTheme => _buildTextTheme(
        primaryColor: const Color(0xFF1A1A1A),
        secondaryColor: const Color(0xFF555555),
      );

  static TextTheme _buildTextTheme({
    required Color primaryColor,
    required Color secondaryColor,
  }) {
    return TextTheme(
      // Display - Poppins Bold, large titles
      displayLarge: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 57,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.25,
        color: primaryColor,
        height: 1.12,
      ),
      displayMedium: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 45,
        fontWeight: FontWeight.w700,
        letterSpacing: 0,
        color: primaryColor,
        height: 1.16,
      ),
      displaySmall: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 36,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: primaryColor,
        height: 1.22,
      ),

      // Headline - Poppins SemiBold
      headlineLarge: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 32,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: primaryColor,
        height: 1.25,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 28,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: primaryColor,
        height: 1.29,
      ),
      headlineSmall: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: primaryColor,
        height: 1.33,
      ),

      // Title - Poppins Medium/SemiBold
      titleLarge: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 22,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: primaryColor,
        height: 1.27,
      ),
      titleMedium: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
        color: primaryColor,
        height: 1.50,
      ),
      titleSmall: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: primaryColor,
        height: 1.43,
      ),

      // Body - Inter for readability
      bodyLarge: TextStyle(
        fontFamily: 'Inter',
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        color: primaryColor,
        height: 1.50,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        color: secondaryColor,
        height: 1.43,
      ),
      bodySmall: TextStyle(
        fontFamily: 'Inter',
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        color: secondaryColor,
        height: 1.33,
      ),

      // Label - Inter for UI elements
      labelLarge: TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: primaryColor,
        height: 1.43,
      ),
      labelMedium: TextStyle(
        fontFamily: 'Inter',
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: secondaryColor,
        height: 1.33,
      ),
      labelSmall: TextStyle(
        fontFamily: 'Inter',
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: secondaryColor,
        height: 1.45,
      ),
    );
  }

  // Convenience styles
  static const TextStyle monoLarge = TextStyle(
    fontFamily: 'JetBrainsMono',
    fontSize: 48,
    fontWeight: FontWeight.w700,
    letterSpacing: -1,
  );

  static const TextStyle monoMedium = TextStyle(
    fontFamily: 'JetBrainsMono',
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
  );

  static const TextStyle monoSmall = TextStyle(
    fontFamily: 'JetBrainsMono',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  );

  static const TextStyle tabLabel = TextStyle(
    fontFamily: 'JetBrainsMono',
    fontSize: 16,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
  );

  static const TextStyle xpDisplay = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: Color(0xFFFFD700),
    letterSpacing: -0.5,
  );

  static const TextStyle noteDisplay = TextStyle(
    fontFamily: 'JetBrainsMono',
    fontSize: 64,
    fontWeight: FontWeight.w700,
    letterSpacing: -2,
  );

  static const TextStyle bpmDisplay = TextStyle(
    fontFamily: 'JetBrainsMono',
    fontSize: 80,
    fontWeight: FontWeight.w700,
    letterSpacing: -3,
  );
}
