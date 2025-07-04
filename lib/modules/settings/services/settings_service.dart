import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/settings_model.dart';

class SettingsService {
  static const String _settingsKey = 'app_settings';
  static const String _settingsVersion = '1.0';

  /// Load settings from SharedPreferences
  Future<SettingsModel> loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = prefs.getString(_settingsKey);

      if (settingsJson != null) {
        final Map<String, dynamic> data = json.decode(settingsJson);

        // Check if settings version is compatible
        final version = data['version'] ?? '1.0';
        if (version == _settingsVersion) {
          return SettingsModel.fromJson(data['settings'] ?? {});
        } else {
          // Handle version migration if needed
          print('SettingsService: Migrating settings from version $version');
          return _migrateSettings(data);
        }
      }

      // Return default settings if none exist
      return SettingsModel.defaultSettings();
    } catch (e) {
      print('SettingsService: Failed to load settings: $e');
      return SettingsModel.defaultSettings();
    }
  }

  /// Save settings to SharedPreferences
  Future<void> saveSettings(SettingsModel settings) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = {
        'version': _settingsVersion,
        'settings': settings.toJson(),
        'last_updated': DateTime.now().toIso8601String(),
      };

      await prefs.setString(_settingsKey, json.encode(data));
      print('SettingsService: Settings saved successfully');
    } catch (e) {
      print('SettingsService: Failed to save settings: $e');
      throw Exception('Failed to save settings: $e');
    }
  }

  /// Export settings as JSON string
  String exportSettings(Map<String, dynamic> settingsJson) {
    try {
      final exportData = {
        'version': _settingsVersion,
        'exported_at': DateTime.now().toIso8601String(),
        'settings': settingsJson,
      };

      return json.encode(exportData);
    } catch (e) {
      print('SettingsService: Failed to export settings: $e');
      throw Exception('Failed to export settings: $e');
    }
  }

  /// Import settings from JSON string
  Future<SettingsModel> importSettings(String settingsData) async {
    try {
      final Map<String, dynamic> data = json.decode(settingsData);

      // Validate import data
      if (!data.containsKey('settings')) {
        throw Exception('Invalid settings format');
      }

      final version = data['version'] ?? '1.0';
      if (version != _settingsVersion) {
        print('SettingsService: Importing settings from version $version');
        return _migrateSettings(data);
      }

      return SettingsModel.fromJson(data['settings']);
    } catch (e) {
      print('SettingsService: Failed to import settings: $e');
      throw Exception('Failed to import settings: $e');
    }
  }

  /// Clear all settings
  Future<void> clearSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_settingsKey);
      print('SettingsService: Settings cleared successfully');
    } catch (e) {
      print('SettingsService: Failed to clear settings: $e');
      throw Exception('Failed to clear settings: $e');
    }
  }

  /// Get settings info
  Future<Map<String, dynamic>> getSettingsInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = prefs.getString(_settingsKey);

      if (settingsJson != null) {
        final Map<String, dynamic> data = json.decode(settingsJson);
        return {
          'version': data['version'] ?? 'unknown',
          'last_updated': data['last_updated'],
          'size': settingsJson.length,
        };
      }

      return {
        'version': 'none',
        'last_updated': null,
        'size': 0,
      };
    } catch (e) {
      print('SettingsService: Failed to get settings info: $e');
      return {
        'version': 'error',
        'last_updated': null,
        'size': 0,
      };
    }
  }

  /// Migrate settings from older version
  SettingsModel _migrateSettings(Map<String, dynamic> data) {
    // Handle migration logic here if needed
    // For now, just return default settings
    print('SettingsService: Using default settings for migration');
    return SettingsModel.defaultSettings();
  }
}
