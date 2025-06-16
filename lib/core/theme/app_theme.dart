import 'package:flutter/material.dart';

class AppTheme {
  // Colors
  static const Color background = Color(0xFF171F34);
  static const Color cardBackground = Color(0xFF202846);
  static const Color rowHover = Color(0xFF232B4D);
  static const Color primaryAccent = Color(0xFF775DF6);
  static const Color success = Color(0xFF19D18D);
  static const Color textMain = Color(0xFFF7F9FA);
  static const Color textMuted = Color(0xFFA5AEC8);
  static const Color border = Color(0xFF273056);

  // Primary Accent & Graph Colors
  static const Color tealCyan = Color(0xFF00D6C3);
  static const Color skyBlue = Color(0xFF18B2FF);
  static const Color violetBlue = Color(0xFF8554FF);
  static const Color neonPink = Color(0xFFE91ED2);
  static const Color orangeYellow = Color(0xFFFFA31D);
  static const Color brightOrange = Color(0xFFF9801D);
  static const Color limeGreen = Color(0xFF2ED573);
  static const Color magentaViolet = Color(0xFFBC42F0);

  // Status & Label Colors
  static const Color uiUxTag = Color(0xFF196CFF);
  static const Color ecommerceTag = Color(0xFFBC42F0);
  static const Color lmsTag = Color(0xFFFFB120);
  static const Color figmaTag = Color(0xFFF9801D);

  // Performance Dots
  static const Color excellent = Color(0xFF8554FF);
  static const Color veryGood = Color(0xFF00D6C3);
  static const Color good = Color(0xFF18B2FF);
  static const Color poor = Color(0xFFFFA31D);
  static const Color veryPoor = Color(0xFFFF4B5C);

  static final ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: background,
    colorScheme: const ColorScheme.dark(
      primary: primaryAccent,
      secondary: success,
      surface: cardBackground,
      background: background,
      error: Colors.red,
    ),
    cardTheme: CardThemeData(
      color: cardBackground,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: border, width: 1),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: background,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: textMain),
      titleTextStyle: TextStyle(
        color: textMain,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: textMain),
      displayMedium: TextStyle(color: textMain),
      displaySmall: TextStyle(color: textMain),
      headlineLarge: TextStyle(color: textMain),
      headlineMedium: TextStyle(color: textMain),
      headlineSmall: TextStyle(color: textMain),
      titleLarge: TextStyle(color: textMain),
      titleMedium: TextStyle(color: textMain),
      titleSmall: TextStyle(color: textMain),
      bodyLarge: TextStyle(color: textMain),
      bodyMedium: TextStyle(color: textMain),
      bodySmall: TextStyle(color: textMuted),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: cardBackground,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primaryAccent),
      ),
      labelStyle: const TextStyle(color: textMuted),
      hintStyle: const TextStyle(color: textMuted),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryAccent,
        foregroundColor: textMain,
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
    iconTheme: const IconThemeData(
      color: textMuted,
    ),
    dividerTheme: const DividerThemeData(
      color: border,
      thickness: 1,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: rowHover,
      labelStyle: const TextStyle(color: textMain),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: border),
      ),
    ),
  );
}
