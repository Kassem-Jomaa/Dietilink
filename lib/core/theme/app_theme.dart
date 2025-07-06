import 'package:flutter/material.dart';

class AppTheme {
  // 🌗 Dark Theme Colors (Primary Theme)
  static const Color darkBackground = Color(0xFF0F172A); // Dark Navy
  static const Color darkCardBackground = Color(0xFF1E293B); // Dark Slate
  static const Color darkBorder = Color(0xFF334155); // Slate
  static const Color darkPrimaryAccent = Color(0xFF3B82F6); // Blue
  static const Color darkSuccess = Color(0xFF10B981); // Green
  static const Color darkWarning = Color(0xFFF59E0B); // Orange
  static const Color darkError = Color(0xFFEF4444); // Red
  static const Color darkInfo = Color(0xFF8B5CF6); // Purple
  static const Color darkTextMuted = Color(0xFF9CA3AF); // Gray-400
  static const Color darkTextPrimary = Color(0xFFF1F5F9); // White

  // ☀️ Light Theme Colors
  static const Color lightBackground = Color(0xFFF8FAFC); // Very Light Gray
  static const Color lightCardBackground = Color(0xFFFFFFFF); // White
  static const Color lightBorder = Color(0xFFE2E8F0); // Gray
  static const Color lightTextPrimary = Color(0xFF0F172A); // Slate-900
  static const Color lightTextSecondary = Color(0xFF64748B); // Gray-600
  static const Color lightButtonAccent = Color(0xFF6366F1); // Indigo
  static const Color lightHighlight = Color(0xFFFBBF24); // Orange
  static const Color lightSuccess = Color(0xFF10B981); // Emerald

  // Legacy colors for backward compatibility - Using DARK theme by default
  static const Color background = darkBackground;
  static const Color cardBackground = darkCardBackground;
  static const Color textMain = darkTextPrimary;
  static const Color textMuted = darkTextMuted;
  static const Color border = darkBorder;
  static const Color textPrimary = darkTextPrimary;
  static const Color textSecondary = darkTextMuted;
  static const Color surface = darkCardBackground;
  static const Color rowHover = Color(0xFF475569);

  // Primary Accent & Graph Colors - Advanced Health Palette
  static const Color violetBlue = Color(0xFF3B82F6); // Blue for primary
  static const Color primaryAccent = darkPrimaryAccent;
  static const Color success = darkSuccess;
  static const Color warning = darkWarning;
  static const Color error = darkError;
  static const Color primary = violetBlue;

  // Advanced UI Colors
  static const Color tealCyan = Color(0xFF06B6D4); // Cyan for hydration
  static const Color skyBlue = Color(0xFF3B82F6); // Blue for activity
  static const Color neonPink = Color(0xFFEC4899); // Pink for heart rate
  static const Color orangeYellow = Color(0xFFF59E0B); // Orange for energy
  static const Color brightOrange =
      Color(0xFFEA580C); // Bright orange for calories
  static const Color limeGreen = Color(0xFF84CC16); // Lime for nutrition
  static const Color magentaViolet = Color(0xFF8B5CF6); // Purple for sleep

  // Status & Label Colors - Advanced Health Categories
  static const Color uiUxTag = Color(0xFF3B82F6);
  static const Color ecommerceTag = Color(0xFF8B5CF6);
  static const Color lmsTag = Color(0xFFF59E0B);
  static const Color figmaTag = Color(0xFFEA580C);

  // Performance Dots - Advanced Health Metrics
  static const Color excellent = Color(0xFF10B981); // Emerald for excellent
  static const Color veryGood = Color(0xFF06B6D4); // Cyan for very good
  static const Color good = Color(0xFF3B82F6); // Blue for good
  static const Color poor = Color(0xFFF59E0B); // Amber for poor
  static const Color veryPoor = Color(0xFFEF4444); // Red for very poor

  // Avatar & Profile Colors
  static const Color avatarBackground = Color(0xFF3B82F6); // Avatar background
  static const Color avatarText = Color(0xFFFFFFFF); // Avatar text

  // Advanced Light Theme
  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: lightBackground,
        colorScheme: ColorScheme.light(
          primary: lightButtonAccent,
          secondary: lightSuccess,
          surface: lightCardBackground,
          background: lightBackground,
          error: error,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: lightTextPrimary,
          onBackground: lightTextPrimary,
          onError: Colors.white,
          outline: lightBorder,
          outlineVariant: lightBorder.withValues(alpha: 0.5),
        ),
        cardTheme: CardThemeData(
          color: lightCardBackground,
          elevation: 0,
          shadowColor: Colors.black.withValues(alpha: 0.05),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: lightBorder, width: 1),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: lightBackground,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: lightTextPrimary),
          titleTextStyle: TextStyle(
            color: lightTextPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
          surfaceTintColor: Colors.transparent,
        ),
        textTheme: TextTheme(
          displayLarge: TextStyle(
            color: lightTextPrimary,
            fontWeight: FontWeight.w700,
            letterSpacing: -1.0,
          ),
          displayMedium: TextStyle(
            color: lightTextPrimary,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
          displaySmall: TextStyle(
            color: lightTextPrimary,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.25,
          ),
          headlineLarge: TextStyle(
            color: lightTextPrimary,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
          headlineMedium: TextStyle(
            color: lightTextPrimary,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.25,
          ),
          headlineSmall: TextStyle(
            color: lightTextPrimary,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.25,
          ),
          titleLarge: TextStyle(
            color: lightTextPrimary,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.25,
          ),
          titleMedium: TextStyle(
            color: lightTextPrimary,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.25,
          ),
          titleSmall: TextStyle(
            color: lightTextPrimary,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.25,
          ),
          bodyLarge: TextStyle(
            color: lightTextPrimary,
            fontWeight: FontWeight.w400,
            letterSpacing: -0.25,
          ),
          bodyMedium: TextStyle(
            color: lightTextPrimary,
            fontWeight: FontWeight.w400,
            letterSpacing: -0.25,
          ),
          bodySmall: TextStyle(
            color: lightTextSecondary,
            fontWeight: FontWeight.w400,
            letterSpacing: -0.25,
          ),
          labelLarge: TextStyle(
            color: lightTextPrimary,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.25,
          ),
          labelMedium: TextStyle(
            color: lightTextSecondary,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.25,
          ),
          labelSmall: TextStyle(
            color: lightTextSecondary,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.25,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: lightCardBackground,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: lightBorder, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: lightBorder, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: lightButtonAccent, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: error, width: 1.5),
          ),
          labelStyle: TextStyle(
            color: lightTextSecondary,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.25,
          ),
          hintStyle: TextStyle(
            color: lightTextSecondary,
            fontWeight: FontWeight.w400,
            letterSpacing: -0.25,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: lightButtonAccent,
            foregroundColor: Colors.white,
            elevation: 0,
            shadowColor: Colors.black.withValues(alpha: 0.1),
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: TextStyle(
              fontWeight: FontWeight.w600,
              letterSpacing: -0.25,
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: lightButtonAccent,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: TextStyle(
              fontWeight: FontWeight.w600,
              letterSpacing: -0.25,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: lightTextPrimary,
            side: BorderSide(color: lightBorder, width: 1.5),
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: TextStyle(
              fontWeight: FontWeight.w600,
              letterSpacing: -0.25,
            ),
          ),
        ),
        iconTheme: IconThemeData(
          color: lightTextSecondary,
          size: 24,
        ),
        dividerTheme: DividerThemeData(
          color: lightBorder.withValues(alpha: 0.5),
          thickness: 1,
          space: 1,
        ),
        chipTheme: ChipThemeData(
          backgroundColor: lightCardBackground,
          labelStyle: TextStyle(
            color: lightTextPrimary,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.25,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(color: lightBorder, width: 1),
          ),
          elevation: 0,
        ),
        switchTheme: SwitchThemeData(
          thumbColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return Colors.white;
            }
            return lightTextSecondary;
          }),
          trackColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return lightButtonAccent;
            }
            return lightBorder;
          }),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return lightButtonAccent;
            }
            return Colors.transparent;
          }),
          checkColor: MaterialStateProperty.all(Colors.white),
          side: BorderSide(color: lightBorder, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        radioTheme: RadioThemeData(
          fillColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return lightButtonAccent;
            }
            return lightBorder;
          }),
        ),
        sliderTheme: SliderThemeData(
          activeTrackColor: lightButtonAccent,
          inactiveTrackColor: lightBorder,
          thumbColor: lightButtonAccent,
          overlayColor: lightButtonAccent.withValues(alpha: 0.1),
        ),
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: lightButtonAccent,
          linearTrackColor: lightBorder,
          circularTrackColor: lightBorder,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: lightCardBackground,
          selectedItemColor: lightButtonAccent,
          unselectedItemColor: lightTextSecondary,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
          selectedLabelStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
            letterSpacing: -0.25,
          ),
          unselectedLabelStyle: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 12,
            letterSpacing: -0.25,
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: lightButtonAccent,
          foregroundColor: Colors.white,
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: lightCardBackground,
          contentTextStyle: TextStyle(
            color: lightTextPrimary,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.25,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 6,
        ),
        dialogTheme: DialogThemeData(
          backgroundColor: lightCardBackground,
          elevation: 12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          titleTextStyle: TextStyle(
            color: lightTextPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
          contentTextStyle: TextStyle(
            color: lightTextSecondary,
            fontSize: 16,
            fontWeight: FontWeight.w400,
            letterSpacing: -0.25,
          ),
        ),
        popupMenuTheme: PopupMenuThemeData(
          color: lightCardBackground,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: TextStyle(
            color: lightTextPrimary,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.25,
          ),
        ),
        listTileTheme: ListTileThemeData(
          tileColor: lightCardBackground,
          textColor: lightTextPrimary,
          iconColor: lightTextSecondary,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          titleTextStyle: TextStyle(
            color: lightTextPrimary,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.25,
          ),
          subtitleTextStyle: TextStyle(
            color: lightTextSecondary,
            fontWeight: FontWeight.w400,
            letterSpacing: -0.25,
          ),
        ),
      );

  // Advanced Dark Theme
  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: darkBackground,
        colorScheme: ColorScheme.dark(
          primary: darkPrimaryAccent,
          secondary: darkSuccess,
          surface: darkCardBackground,
          background: darkBackground,
          error: darkError,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: darkTextPrimary,
          onBackground: darkTextPrimary,
          onError: Colors.white,
          outline: darkBorder,
          outlineVariant: darkBorder.withValues(alpha: 0.5),
        ),
        cardTheme: CardThemeData(
          color: darkCardBackground,
          elevation: 0,
          shadowColor: Colors.black.withValues(alpha: 0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: darkBorder, width: 1),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: darkBackground,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: darkTextPrimary),
          titleTextStyle: TextStyle(
            color: darkTextPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
          surfaceTintColor: Colors.transparent,
        ),
        textTheme: TextTheme(
          displayLarge: TextStyle(
            color: darkTextPrimary,
            fontWeight: FontWeight.w700,
            letterSpacing: -1.0,
          ),
          displayMedium: TextStyle(
            color: darkTextPrimary,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
          displaySmall: TextStyle(
            color: darkTextPrimary,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.25,
          ),
          headlineLarge: TextStyle(
            color: darkTextPrimary,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
          headlineMedium: TextStyle(
            color: darkTextPrimary,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.25,
          ),
          headlineSmall: TextStyle(
            color: darkTextPrimary,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.25,
          ),
          titleLarge: TextStyle(
            color: darkTextPrimary,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.25,
          ),
          titleMedium: TextStyle(
            color: darkTextPrimary,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.25,
          ),
          titleSmall: TextStyle(
            color: darkTextPrimary,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.25,
          ),
          bodyLarge: TextStyle(
            color: darkTextPrimary,
            fontWeight: FontWeight.w400,
            letterSpacing: -0.25,
          ),
          bodyMedium: TextStyle(
            color: darkTextPrimary,
            fontWeight: FontWeight.w400,
            letterSpacing: -0.25,
          ),
          bodySmall: TextStyle(
            color: darkTextMuted,
            fontWeight: FontWeight.w400,
            letterSpacing: -0.25,
          ),
          labelLarge: TextStyle(
            color: darkTextPrimary,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.25,
          ),
          labelMedium: TextStyle(
            color: darkTextMuted,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.25,
          ),
          labelSmall: TextStyle(
            color: darkTextMuted,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.25,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: darkCardBackground,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: darkBorder, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: darkBorder, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: darkPrimaryAccent, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: darkError, width: 1.5),
          ),
          labelStyle: TextStyle(
            color: darkTextMuted,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.25,
          ),
          hintStyle: TextStyle(
            color: darkTextMuted,
            fontWeight: FontWeight.w400,
            letterSpacing: -0.25,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: darkPrimaryAccent,
            foregroundColor: Colors.white,
            elevation: 0,
            shadowColor: Colors.black.withValues(alpha: 0.2),
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: TextStyle(
              fontWeight: FontWeight.w600,
              letterSpacing: -0.25,
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: darkPrimaryAccent,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: TextStyle(
              fontWeight: FontWeight.w600,
              letterSpacing: -0.25,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: darkTextPrimary,
            side: BorderSide(color: darkBorder, width: 1.5),
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: TextStyle(
              fontWeight: FontWeight.w600,
              letterSpacing: -0.25,
            ),
          ),
        ),
        iconTheme: IconThemeData(
          color: darkTextMuted,
          size: 24,
        ),
        dividerTheme: DividerThemeData(
          color: darkBorder.withValues(alpha: 0.5),
          thickness: 1,
          space: 1,
        ),
        chipTheme: ChipThemeData(
          backgroundColor: darkCardBackground,
          labelStyle: TextStyle(
            color: darkTextPrimary,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.25,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(color: darkBorder, width: 1),
          ),
          elevation: 0,
        ),
        switchTheme: SwitchThemeData(
          thumbColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return Colors.white;
            }
            return darkTextMuted;
          }),
          trackColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return darkPrimaryAccent;
            }
            return darkBorder;
          }),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return darkPrimaryAccent;
            }
            return Colors.transparent;
          }),
          checkColor: MaterialStateProperty.all(Colors.white),
          side: BorderSide(color: darkBorder, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        radioTheme: RadioThemeData(
          fillColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return darkPrimaryAccent;
            }
            return darkBorder;
          }),
        ),
        sliderTheme: SliderThemeData(
          activeTrackColor: darkPrimaryAccent,
          inactiveTrackColor: darkBorder,
          thumbColor: darkPrimaryAccent,
          overlayColor: darkPrimaryAccent.withValues(alpha: 0.1),
        ),
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: darkPrimaryAccent,
          linearTrackColor: darkBorder,
          circularTrackColor: darkBorder,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: darkCardBackground,
          selectedItemColor: darkPrimaryAccent,
          unselectedItemColor: darkTextMuted,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
          selectedLabelStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
            letterSpacing: -0.25,
          ),
          unselectedLabelStyle: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 12,
            letterSpacing: -0.25,
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: darkPrimaryAccent,
          foregroundColor: Colors.white,
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: darkCardBackground,
          contentTextStyle: TextStyle(
            color: darkTextPrimary,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.25,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 6,
        ),
        dialogTheme: DialogThemeData(
          backgroundColor: darkCardBackground,
          elevation: 12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          titleTextStyle: TextStyle(
            color: darkTextPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
          contentTextStyle: TextStyle(
            color: darkTextMuted,
            fontSize: 16,
            fontWeight: FontWeight.w400,
            letterSpacing: -0.25,
          ),
        ),
        popupMenuTheme: PopupMenuThemeData(
          color: darkCardBackground,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: TextStyle(
            color: darkTextPrimary,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.25,
          ),
        ),
        listTileTheme: ListTileThemeData(
          tileColor: darkCardBackground,
          textColor: darkTextPrimary,
          iconColor: darkTextMuted,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          titleTextStyle: TextStyle(
            color: darkTextPrimary,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.25,
          ),
          subtitleTextStyle: TextStyle(
            color: darkTextMuted,
            fontWeight: FontWeight.w400,
            letterSpacing: -0.25,
          ),
        ),
      );

  // Legacy getter for backward compatibility
  static ThemeData get light => darkTheme;
}
