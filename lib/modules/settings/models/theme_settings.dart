import 'package:flutter/material.dart';

/// Theme settings model
class ThemeSettings {
  final AppThemeMode themeMode;
  final bool useSystemTheme;
  final bool useAmoledBlack;
  final bool useDynamicColors;
  final double textScaleFactor;

  const ThemeSettings({
    this.themeMode = AppThemeMode.system,
    this.useSystemTheme = true,
    this.useAmoledBlack = false,
    this.useDynamicColors = true,
    this.textScaleFactor = 1.0,
  });

  factory ThemeSettings.fromJson(Map<String, dynamic> json) {
    return ThemeSettings(
      themeMode: AppThemeMode.values.firstWhere(
        (e) => e.name == json['theme_mode'],
        orElse: () => AppThemeMode.system,
      ),
      useSystemTheme: json['use_system_theme'] ?? true,
      useAmoledBlack: json['use_amoled_black'] ?? false,
      useDynamicColors: json['use_dynamic_colors'] ?? true,
      textScaleFactor: (json['text_scale_factor'] ?? 1.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'theme_mode': themeMode.name,
      'use_system_theme': useSystemTheme,
      'use_amoled_black': useAmoledBlack,
      'use_dynamic_colors': useDynamicColors,
      'text_scale_factor': textScaleFactor,
    };
  }

  ThemeSettings copyWith({
    AppThemeMode? themeMode,
    bool? useSystemTheme,
    bool? useAmoledBlack,
    bool? useDynamicColors,
    double? textScaleFactor,
  }) {
    return ThemeSettings(
      themeMode: themeMode ?? this.themeMode,
      useSystemTheme: useSystemTheme ?? this.useSystemTheme,
      useAmoledBlack: useAmoledBlack ?? this.useAmoledBlack,
      useDynamicColors: useDynamicColors ?? this.useDynamicColors,
      textScaleFactor: textScaleFactor ?? this.textScaleFactor,
    );
  }

  /// Get the effective theme mode (considers system theme)
  AppThemeMode get effectiveThemeMode {
    if (useSystemTheme && themeMode == AppThemeMode.system) {
      // This would be determined by the system brightness
      return AppThemeMode.system;
    }
    return themeMode;
  }

  @override
  String toString() {
    return 'ThemeSettings(themeMode: $themeMode, useSystemTheme: $useSystemTheme)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ThemeSettings &&
        other.themeMode == themeMode &&
        other.useSystemTheme == useSystemTheme &&
        other.useAmoledBlack == useAmoledBlack &&
        other.useDynamicColors == useDynamicColors &&
        other.textScaleFactor == textScaleFactor;
  }

  @override
  int get hashCode {
    return themeMode.hashCode ^
        useSystemTheme.hashCode ^
        useAmoledBlack.hashCode ^
        useDynamicColors.hashCode ^
        textScaleFactor.hashCode;
  }
}

/// App theme modes
enum AppThemeMode {
  light,
  dark,
  system;

  String get displayName {
    switch (this) {
      case AppThemeMode.light:
        return 'Light';
      case AppThemeMode.dark:
        return 'Dark';
      case AppThemeMode.system:
        return 'System';
    }
  }

  String get description {
    switch (this) {
      case AppThemeMode.light:
        return 'Use light theme';
      case AppThemeMode.dark:
        return 'Use dark theme';
      case AppThemeMode.system:
        return 'Follow system settings';
    }
  }

  IconData get icon {
    switch (this) {
      case AppThemeMode.light:
        return Icons.light_mode;
      case AppThemeMode.dark:
        return Icons.dark_mode;
      case AppThemeMode.system:
        return Icons.brightness_auto;
    }
  }
}
