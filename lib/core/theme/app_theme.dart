import 'package:flutter/material.dart';

class AppTheme {
  // Light Theme Colors - Fresh Health-focused Palette
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightCardBackground = Color(0xFFFFFFFF);
  static const Color lightTextPrimary = Color(0xFF1E293B);
  static const Color lightTextSecondary = Color(0xFF64748B);
  static const Color lightTextMuted = Color(0xFF94A3B8);
  static const Color lightBorder = Color(0xFFE2E8F0);

  // Dark Theme Colors - Modern Dark Health Theme
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkCardBackground = Color(0xFF1E293B);
  static const Color darkTextPrimary = Color(0xFFF1F5F9);
  static const Color darkTextSecondary = Color(0xFFCBD5E1);
  static const Color darkTextMuted = Color(0xFF94A3B8);
  static const Color darkBorder = Color(0xFF334155);

  // Common Colors - Health & Wellness Focused
  static const Color violetBlue = Color(0xFF059669); // Emerald Green for health
  static const Color primaryAccent = Color(0xFF10B981); // Fresh green accent
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color primary = violetBlue;

  // Legacy colors for backward compatibility
  static const Color background = darkBackground;
  static const Color cardBackground = darkCardBackground;
  static const Color textMain = darkTextPrimary;
  static const Color textMuted = darkTextMuted;
  static const Color border = darkBorder;
  static const Color textPrimary = darkTextPrimary;
  static const Color textSecondary = darkTextSecondary;
  static const Color surface = darkCardBackground;
  static const Color rowHover = Color(0xFF475569);

  // Primary Accent & Graph Colors - Health & Wellness Palette
  static const Color tealCyan = Color(0xFF06B6D4); // Cyan for hydration
  static const Color skyBlue = Color(0xFF3B82F6); // Blue for activity
  static const Color neonPink = Color(0xFFEC4899); // Pink for heart rate
  static const Color orangeYellow = Color(0xFFF59E0B); // Orange for energy
  static const Color brightOrange =
      Color(0xFFEA580C); // Bright orange for calories
  static const Color limeGreen = Color(0xFF84CC16); // Lime for nutrition
  static const Color magentaViolet = Color(0xFF8B5CF6); // Purple for sleep

  // Status & Label Colors - Health Categories
  static const Color uiUxTag = Color(0xFF3B82F6);
  static const Color ecommerceTag = Color(0xFF8B5CF6);
  static const Color lmsTag = Color(0xFFF59E0B);
  static const Color figmaTag = Color(0xFFEA580C);

  // Performance Dots - Health Metrics
  static const Color excellent = Color(0xFF059669); // Emerald for excellent
  static const Color veryGood = Color(0xFF06B6D4); // Cyan for very good
  static const Color good = Color(0xFF3B82F6); // Blue for good
  static const Color poor = Color(0xFFF59E0B); // Amber for poor
  static const Color veryPoor = Color(0xFFEF4444); // Red for very poor

  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: lightBackground,
        colorScheme: ColorScheme.light(
          primary: primaryAccent,
          secondary: success,
          surface: lightCardBackground,
          error: error,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: lightTextPrimary,
          onError: Colors.white,
        ),
        cardTheme: CardThemeData(
          color: lightCardBackground,
          elevation: 2,
          shadowColor: Colors.black.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: lightBackground,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: lightTextPrimary),
          titleTextStyle: TextStyle(
            color: lightTextPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        textTheme: TextTheme(
          displayLarge: TextStyle(color: lightTextPrimary),
          displayMedium: TextStyle(color: lightTextPrimary),
          displaySmall: TextStyle(color: lightTextPrimary),
          headlineLarge: TextStyle(color: lightTextPrimary),
          headlineMedium: TextStyle(color: lightTextPrimary),
          headlineSmall: TextStyle(color: lightTextPrimary),
          titleLarge: TextStyle(color: lightTextPrimary),
          titleMedium: TextStyle(color: lightTextPrimary),
          titleSmall: TextStyle(color: lightTextPrimary),
          bodyLarge: TextStyle(color: lightTextPrimary),
          bodyMedium: TextStyle(color: lightTextPrimary),
          bodySmall: TextStyle(color: lightTextMuted),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: lightCardBackground,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: lightBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: lightBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: primaryAccent),
          ),
          labelStyle: TextStyle(color: lightTextMuted),
          hintStyle: TextStyle(color: lightTextMuted),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryAccent,
            foregroundColor: Colors.white,
            elevation: 2,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: primaryAccent,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
        ),
        iconTheme: IconThemeData(color: lightTextMuted),
        dividerTheme: DividerThemeData(color: lightBorder, thickness: 1),
      );

  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: darkBackground,
        colorScheme: ColorScheme.dark(
          primary: primaryAccent,
          secondary: success,
          surface: darkCardBackground,
          error: error,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: darkTextPrimary,
          onError: Colors.white,
        ),
        cardTheme: CardThemeData(
          color: darkCardBackground,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: darkBorder, width: 1),
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: darkBackground,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: darkTextPrimary),
          titleTextStyle: TextStyle(
            color: darkTextPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        textTheme: TextTheme(
          displayLarge: TextStyle(color: darkTextPrimary),
          displayMedium: TextStyle(color: darkTextPrimary),
          displaySmall: TextStyle(color: darkTextPrimary),
          headlineLarge: TextStyle(color: darkTextPrimary),
          headlineMedium: TextStyle(color: darkTextPrimary),
          headlineSmall: TextStyle(color: darkTextPrimary),
          titleLarge: TextStyle(color: darkTextPrimary),
          titleMedium: TextStyle(color: darkTextPrimary),
          titleSmall: TextStyle(color: darkTextPrimary),
          bodyLarge: TextStyle(color: darkTextPrimary),
          bodyMedium: TextStyle(color: darkTextPrimary),
          bodySmall: TextStyle(color: darkTextMuted),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: darkCardBackground,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: darkBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: darkBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: primaryAccent),
          ),
          labelStyle: TextStyle(color: darkTextMuted),
          hintStyle: TextStyle(color: darkTextMuted),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryAccent,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: primaryAccent,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
        ),
        iconTheme: IconThemeData(color: darkTextMuted),
        dividerTheme: DividerThemeData(color: darkBorder, thickness: 1),
        chipTheme: ChipThemeData(
          backgroundColor: rowHover,
          labelStyle: TextStyle(color: darkTextPrimary),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: darkBorder),
          ),
        ),
      );

  // Legacy getter for backward compatibility
  static ThemeData get light => darkTheme;
}
