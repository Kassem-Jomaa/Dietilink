import 'package:flutter/material.dart';

class AppTheme {
  // Dark Theme Colors - Modern Dark Health Theme (Primary)
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkCardBackground = Color(0xFF1E293B);
  static const Color darkTextPrimary = Color(0xFFF1F5F9);
  static const Color darkTextSecondary = Color(0xFFCBD5E1);
  static const Color darkTextMuted = Color(0xFF94A3B8);
  static const Color darkBorder = Color(0xFF334155);

  // Light Theme Colors - Modern Clean Health Theme
  static const Color lightBackground = Color(0xFFFAFBFC);
  static const Color lightCardBackground = Color(0xFFFFFFFF);
  static const Color lightSurfaceBackground = Color(0xFFF8F9FA);
  static const Color lightTextPrimary = Color(0xFF1A1D1F);
  static const Color lightTextSecondary = Color(0xFF6C7275);
  static const Color lightTextMuted = Color(0xFF9CA3AF);
  static const Color lightBorder = Color(0xFFE5E7EB);
  static const Color lightDivider = Color(0xFFF3F4F6);
  static const Color lightShadow = Color(0x0A000000);

  // Common Colors - Health & Wellness Focused
  static const Color violetBlue = Color(0xFF059669); // Emerald Green for health
  static const Color primaryAccent = Color(0xFF10B981); // Fresh green accent
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color primary = violetBlue;

  // Legacy colors for backward compatibility - Using DARK theme by default
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

  // Avatar & Profile Colors
  static const Color avatarBackground = Color(0xFF0EA5E9); // Avatar background
  static const Color avatarText = Color(0xFFFFFFFF); // Avatar text

  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: lightBackground,
        colorScheme: ColorScheme.light(
          primary: primaryAccent,
          secondary: success,
          surface: lightCardBackground,
          background: lightBackground,
          error: error,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: lightTextPrimary,
          onBackground: lightTextPrimary,
          onError: Colors.white,
          outline: lightBorder,
          outlineVariant: lightDivider,
        ),
        cardTheme: CardThemeData(
          color: lightCardBackground,
          elevation: 0,
          shadowColor: lightShadow,
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
            color: lightTextMuted,
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
            color: lightTextMuted,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.25,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: lightSurfaceBackground,
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
            borderSide: BorderSide(color: primaryAccent, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: error, width: 1.5),
          ),
          labelStyle: TextStyle(
            color: lightTextMuted,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.25,
          ),
          hintStyle: TextStyle(
            color: lightTextMuted,
            fontWeight: FontWeight.w400,
            letterSpacing: -0.25,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryAccent,
            foregroundColor: Colors.white,
            elevation: 0,
            shadowColor: lightShadow,
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
            foregroundColor: primaryAccent,
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
          color: lightTextMuted,
          size: 24,
        ),
        dividerTheme: DividerThemeData(
          color: lightDivider,
          thickness: 1,
          space: 1,
        ),
        chipTheme: ChipThemeData(
          backgroundColor: lightSurfaceBackground,
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
            return lightTextMuted;
          }),
          trackColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return primaryAccent;
            }
            return lightBorder;
          }),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return primaryAccent;
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
              return primaryAccent;
            }
            return lightBorder;
          }),
        ),
        sliderTheme: SliderThemeData(
          activeTrackColor: primaryAccent,
          inactiveTrackColor: lightBorder,
          thumbColor: primaryAccent,
          overlayColor: primaryAccent.withOpacity(0.1),
        ),
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: primaryAccent,
          linearTrackColor: lightBorder,
          circularTrackColor: lightBorder,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: lightCardBackground,
          selectedItemColor: primaryAccent,
          unselectedItemColor: lightTextMuted,
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
          backgroundColor: primaryAccent,
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
          iconColor: lightTextMuted,
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
