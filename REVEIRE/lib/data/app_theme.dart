import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color background = Color(0xFF0F0E0C);
  static const Color surface = Color(0xFF1A1917);
  static const Color surfaceElevated = Color(0xFF252320);
  static const Color gold = Color(0xFFD4A853);
  static const Color goldLight = Color(0xFFE8C47A);
  static const Color ivory = Color(0xFFF5F0E8);
  static const Color ivoryDim = Color(0xFFBFB8A8);
  static const Color textPrimary = Color(0xFFF5F0E8);
  static const Color textSecondary = Color(0xFF9A9285);
  static const Color divider = Color(0xFF2E2C28);
  static const Color error = Color(0xFFD4654A);

  static final ThemeData theme = ThemeData(
    scaffoldBackgroundColor: background,
    colorScheme: const ColorScheme.dark(
      background: background,
      surface: surface,
      primary: gold,
      secondary: goldLight,
      error: error,
      onPrimary: background,
      onSurface: textPrimary,
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.cormorantGaramond(
          color: textPrimary, fontSize: 48,
          fontWeight: FontWeight.w300, letterSpacing: -1, height: 1.1),
      displayMedium: GoogleFonts.cormorantGaramond(
          color: textPrimary, fontSize: 36,
          fontWeight: FontWeight.w300, letterSpacing: -0.5, height: 1.2),
      headlineLarge: GoogleFonts.cormorantGaramond(
          color: textPrimary, fontSize: 28, fontWeight: FontWeight.w400),
      headlineMedium: GoogleFonts.cormorantGaramond(
          color: textPrimary, fontSize: 22, fontWeight: FontWeight.w400),
      titleLarge: GoogleFonts.jost(
          color: textPrimary, fontSize: 16,
          fontWeight: FontWeight.w500, letterSpacing: 1.5),
      titleMedium: GoogleFonts.jost(
          color: textSecondary, fontSize: 13,
          fontWeight: FontWeight.w400, letterSpacing: 1.2),
      bodyLarge: GoogleFonts.jost(
          color: textPrimary, fontSize: 16,
          fontWeight: FontWeight.w300, height: 1.6),
      bodyMedium: GoogleFonts.jost(
          color: ivoryDim, fontSize: 14,
          fontWeight: FontWeight.w300, height: 1.5),
      labelLarge: GoogleFonts.jost(
          color: background, fontSize: 13,
          fontWeight: FontWeight.w600, letterSpacing: 1.5),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: background,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.cormorantGaramond(
          color: textPrimary, fontSize: 22,
          fontWeight: FontWeight.w400, letterSpacing: 1),
      iconTheme: const IconThemeData(color: textPrimary),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceElevated,
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: divider),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: divider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: gold, width: 1.5),
      ),
      hintStyle: GoogleFonts.jost(color: textSecondary, fontSize: 14),
      labelStyle: GoogleFonts.jost(
          color: textSecondary, fontSize: 13, letterSpacing: 1),
    ),
    dividerTheme: const DividerThemeData(color: divider, thickness: 1),
    useMaterial3: true,
  );
}

class AppCategories {
  static const List<Map<String, dynamic>> categories = [
    {'name': 'Motivation', 'emoji': '🔥', 'color': 0xFFD4654A},
    {'name': 'Life', 'emoji': '🌿', 'color': 0xFF6B9E7A},
    {'name': 'Study', 'emoji': '📚', 'color': 0xFF5B8CC4},
    {'name': 'Chasing Dreams', 'emoji': '✨', 'color': 0xFFD4A853},
    {'name': 'Wisdom', 'emoji': '🦉', 'color': 0xFF8C7E5B},
    {'name': 'Resilience', 'emoji': '⚡', 'color': 0xFF5B9BB0},
    {'name': 'Success', 'emoji': '🏆', 'color': 0xFFC4A44A},
  ];

  static Color getColor(String categoryName) {
    final cat = categories.firstWhere(
          (c) => c['name'] == categoryName,
      orElse: () => {'color': 0xFFD4A853},
    );
    return Color(cat['color'] as int);
  }

  static String getEmoji(String categoryName) {
    final cat = categories.firstWhere(
          (c) => c['name'] == categoryName,
      orElse: () => {'emoji': '💬'},
    );
    return cat['emoji'] as String;
  }
}