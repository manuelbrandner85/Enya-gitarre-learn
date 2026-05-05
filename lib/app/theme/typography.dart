import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      displayLarge: GoogleFonts.poppins(
        fontSize: 57,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.25,
        color: primaryColor,
        height: 1.12,
      ),
      displayMedium: GoogleFonts.poppins(
        fontSize: 45,
        fontWeight: FontWeight.w700,
        letterSpacing: 0,
        color: primaryColor,
        height: 1.16,
      ),
      displaySmall: GoogleFonts.poppins(
        fontSize: 36,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: primaryColor,
        height: 1.22,
      ),

      // Headline - Poppins SemiBold
      headlineLarge: GoogleFonts.poppins(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: primaryColor,
        height: 1.25,
      ),
      headlineMedium: GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: primaryColor,
        height: 1.29,
      ),
      headlineSmall: GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: primaryColor,
        height: 1.33,
      ),

      // Title - Poppins Medium/SemiBold
      titleLarge: GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: primaryColor,
        height: 1.27,
      ),
      titleMedium: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
        color: primaryColor,
        height: 1.50,
      ),
      titleSmall: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: primaryColor,
        height: 1.43,
      ),

      // Body - Inter for readability
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        color: primaryColor,
        height: 1.50,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        color: secondaryColor,
        height: 1.43,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        color: secondaryColor,
        height: 1.33,
      ),

      // Label - Inter for UI elements
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: primaryColor,
        height: 1.43,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: secondaryColor,
        height: 1.33,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: secondaryColor,
        height: 1.45,
      ),
    );
  }

  // Convenience styles
  static TextStyle get monoLarge => GoogleFonts.jetBrainsMono(
        fontSize: 48,
        fontWeight: FontWeight.w700,
        letterSpacing: -1,
      );

  static TextStyle get monoMedium => GoogleFonts.jetBrainsMono(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      );

  static TextStyle get monoSmall => GoogleFonts.jetBrainsMono(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
      );

  static TextStyle get tabLabel => GoogleFonts.jetBrainsMono(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        letterSpacing: 0,
      );

  static TextStyle get xpDisplay => GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: const Color(0xFFFFD700),
        letterSpacing: -0.5,
      );

  static TextStyle get noteDisplay => GoogleFonts.jetBrainsMono(
        fontSize: 64,
        fontWeight: FontWeight.w700,
        letterSpacing: -2,
      );

  static TextStyle get bpmDisplay => GoogleFonts.jetBrainsMono(
        fontSize: 80,
        fontWeight: FontWeight.w700,
        letterSpacing: -3,
      );
}
