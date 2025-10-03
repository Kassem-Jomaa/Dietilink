import 'notification_settings.dart';
import 'theme_settings.dart';

/// Main settings model that contains all user preferences
class SettingsModel {
  final NotificationSettings notifications;
  final ThemeSettings theme;
  final Map<String, dynamic> additionalSettings;

  const SettingsModel({
    required this.notifications,
    required this.theme,
    this.additionalSettings = const {},
  });

  /// Create settings from JSON
  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      notifications: NotificationSettings.fromJson(
        json['notifications'] ?? {},
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
      'theme': theme.toJson(),
      'additional_settings': additionalSettings,
    };
  }

  /// Create a copy with updated values
  SettingsModel copyWith({
    NotificationSettings? notifications,
    ThemeSettings? theme,
    Map<String, dynamic>? additionalSettings,
  }) {
    return SettingsModel(
      notifications: notifications ?? this.notifications,
      theme: theme ?? this.theme,
      additionalSettings: additionalSettings ?? this.additionalSettings,
    );
  }

  /// Default settings
  factory SettingsModel.defaultSettings() {
    return const SettingsModel(
      notifications: NotificationSettings(),
      theme: ThemeSettings(),
    );
  }

  @override
  String toString() {
    return 'SettingsModel(notifications: $notifications, theme: $theme)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SettingsModel &&
        other.notifications == notifications &&
        other.theme == theme;
  }

  @override
  int get hashCode {
    return notifications.hashCode ^ theme.hashCode;
  }
}
