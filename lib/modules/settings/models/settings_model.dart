import 'notification_settings.dart';
import 'language_settings.dart';
import 'theme_settings.dart';

/// Main settings model that contains all user preferences
class SettingsModel {
  final NotificationSettings notifications;
  final LanguageSettings language;
  final ThemeSettings theme;
  final Map<String, dynamic> additionalSettings;

  const SettingsModel({
    required this.notifications,
    required this.language,
    required this.theme,
    this.additionalSettings = const {},
  });

  /// Create settings from JSON
  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      notifications: NotificationSettings.fromJson(
        json['notifications'] ?? {},
      ),
      language: LanguageSettings.fromJson(
        json['language'] ?? {},
      ),
      theme: ThemeSettings.fromJson(
        json['theme'] ?? {},
      ),
      additionalSettings: json['additional_settings'] ?? {},
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'notifications': notifications.toJson(),
      'language': language.toJson(),
      'theme': theme.toJson(),
      'additional_settings': additionalSettings,
    };
  }

  /// Create a copy with updated values
  SettingsModel copyWith({
    NotificationSettings? notifications,
    LanguageSettings? language,
    ThemeSettings? theme,
    Map<String, dynamic>? additionalSettings,
  }) {
    return SettingsModel(
      notifications: notifications ?? this.notifications,
      language: language ?? this.language,
      theme: theme ?? this.theme,
      additionalSettings: additionalSettings ?? this.additionalSettings,
    );
  }

  /// Default settings
  factory SettingsModel.defaultSettings() {
    return const SettingsModel(
      notifications: NotificationSettings(),
      language: LanguageSettings(),
      theme: ThemeSettings(),
    );
  }

  @override
  String toString() {
    return 'SettingsModel(notifications: $notifications, language: $language, theme: $theme)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SettingsModel &&
        other.notifications == notifications &&
        other.language == language &&
        other.theme == theme;
  }

  @override
  int get hashCode {
    return notifications.hashCode ^ language.hashCode ^ theme.hashCode;
  }
}
