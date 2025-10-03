import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/theme_settings.dart';
import '../../../core/theme/app_theme.dart';

class ThemeService extends GetxController {
  static const String _themeKey = 'app_theme';
  static const String _themeModeKey = 'theme_mode';

  // Observable theme mode
  final Rx<AppThemeMode> _currentThemeMode = AppThemeMode.system.obs;

  @override
  void onInit() {
    super.onInit();
    _loadThemeMode();
  }

  /// Load theme mode from storage
  Future<void> _loadThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeModeName = prefs.getString(_themeModeKey);

      if (themeModeName != null) {
        final themeMode = AppThemeMode.values.firstWhere(
          (e) => e.name == themeModeName,
          orElse: () => AppThemeMode.system,
        );
        _currentThemeMode.value = themeMode;
      }
    } catch (e) {
      print('ThemeService: Failed to load theme mode: $e');
    }
  }

  /// Set the app theme mode
  Future<void> setThemeMode(AppThemeMode themeMode) async {
    try {
      // Save theme preference
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeModeKey, themeMode.name);

      // Update observable
      _currentThemeMode.value = themeMode;

      // Update GetX theme
      final theme = _getTheme(themeMode);
      Get.changeTheme(theme);

      // Update UI
      update();

      print('ThemeService: Theme set to ${themeMode.displayName}');
    } catch (e) {
      print('ThemeService: Failed to set theme: $e');
    }
  }

  /// Get current theme mode
  Future<AppThemeMode> getCurrentThemeMode() async {
    return _currentThemeMode.value;
  }

  /// Get current theme mode synchronously
  AppThemeMode get currentThemeMode => _currentThemeMode.value;

  /// Get theme data for the theme mode
  ThemeData _getTheme(AppThemeMode themeMode) {
    switch (themeMode) {
      case AppThemeMode.light:
        return AppTheme.lightTheme;
      case AppThemeMode.dark:
        return AppTheme.darkTheme;
      case AppThemeMode.system:
        // Use system brightness to determine theme
        final brightness =
            WidgetsBinding.instance.platformDispatcher.platformBrightness;
        return brightness == Brightness.light
            ? AppTheme.lightTheme
            : AppTheme.darkTheme;
    }
  }

  /// Get all available theme modes
  List<AppThemeMode> getAvailableThemeModes() {
    return AppThemeMode.values;
  }

  /// Check if current theme is dark
  bool isDarkMode() {
    if (_currentThemeMode.value == AppThemeMode.system) {
      final brightness = Get.mediaQuery.platformBrightness;
      return brightness == Brightness.dark;
    }
    return _currentThemeMode.value == AppThemeMode.dark;
  }

  /// Toggle between light and dark themes
  Future<void> toggleTheme() async {
    try {
      final currentMode = _currentThemeMode.value;
      final newMode = currentMode == AppThemeMode.light
          ? AppThemeMode.dark
          : AppThemeMode.light;

      await setThemeMode(newMode);
    } catch (e) {
      print('ThemeService: Failed to toggle theme: $e');
    }
  }

  /// Get theme mode display name
  String getThemeModeDisplayName(AppThemeMode themeMode) {
    return themeMode.displayName;
  }

  /// Get theme mode description
  String getThemeModeDescription(AppThemeMode themeMode) {
    return themeMode.description;
  }

  /// Get theme mode icon
  IconData getThemeModeIcon(AppThemeMode themeMode) {
    return themeMode.icon;
  }
}
