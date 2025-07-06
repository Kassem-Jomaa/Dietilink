import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/settings_model.dart';
import '../models/notification_settings.dart';
import '../models/theme_settings.dart';
import '../services/settings_service.dart';
import '../services/notification_service.dart';
import '../services/theme_service.dart';

class SettingsController extends GetxController {
  final SettingsService _settingsService = Get.find<SettingsService>();
  final NotificationService _notificationService =
      Get.find<NotificationService>();
  final ThemeService _themeService = Get.find<ThemeService>();

  // Observable settings
  final Rx<SettingsModel> settings = SettingsModel.defaultSettings().obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  // Individual settings observables for easy access
  late Rx<NotificationSettings> notifications;
  late Rx<ThemeSettings> theme;

  @override
  void onInit() {
    super.onInit();
    _initializeSettings();
  }

  /// Initialize settings from storage
  Future<void> _initializeSettings() async {
    try {
      isLoading.value = true;
      error.value = '';

      // Load settings from storage
      final loadedSettings = await _settingsService.loadSettings();
      settings.value = loadedSettings;

      // Initialize individual observables
      notifications = settings.value.notifications.obs;
      theme = settings.value.theme.obs;

      // Apply settings
      await _applySettings(loadedSettings);

      print('SettingsController: Settings loaded successfully');
    } catch (e) {
      print('SettingsController: Failed to load settings: $e');
      error.value = 'Failed to load settings: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Apply settings to the app
  Future<void> _applySettings(SettingsModel newSettings) async {
    try {
      // Apply theme settings
      await _themeService.setThemeMode(newSettings.theme.themeMode);

      // Apply notification settings
      await _notificationService
          .updateNotificationSettings(newSettings.notifications);

      print('SettingsController: Settings applied successfully');
    } catch (e) {
      print('SettingsController: Failed to apply settings: $e');
      error.value = 'Failed to apply settings: $e';
    }
  }

  /// Update notification settings
  Future<void> updateNotificationSettings(
      NotificationSettings newSettings) async {
    try {
      notifications.value = newSettings;
      await _notificationService.updateNotificationSettings(newSettings);
      await _saveSettings();
      print('SettingsController: Notification settings updated');
    } catch (e) {
      print('SettingsController: Failed to update notification settings: $e');
      error.value = 'Failed to update notification settings: $e';
    }
  }

  /// Update theme settings
  Future<void> updateThemeSettings(ThemeSettings newSettings) async {
    try {
      theme.value = newSettings;
      await _themeService.setThemeMode(newSettings.themeMode);
      await _saveSettings();
      print('SettingsController: Theme settings updated');
    } catch (e) {
      print('SettingsController: Failed to update theme settings: $e');
      error.value = 'Failed to update theme settings: $e';
    }
  }

  /// Save all settings to storage
  Future<void> _saveSettings() async {
    try {
      final currentSettings = settings.value.copyWith(
        notifications: notifications.value,
        theme: theme.value,
      );

      await _settingsService.saveSettings(currentSettings);
      settings.value = currentSettings;
      print('SettingsController: Settings saved successfully');
    } catch (e) {
      print('SettingsController: Failed to save settings: $e');
      error.value = 'Failed to save settings: $e';
    }
  }

  /// Reset settings to defaults
  Future<void> resetToDefaults() async {
    try {
      isLoading.value = true;
      error.value = '';

      final defaultSettings = SettingsModel.defaultSettings();
      settings.value = defaultSettings;
      notifications.value = defaultSettings.notifications;
      theme.value = defaultSettings.theme;

      await _applySettings(defaultSettings);
      await _saveSettings();

      print('SettingsController: Settings reset to defaults');
    } catch (e) {
      print('SettingsController: Failed to reset settings: $e');
      error.value = 'Failed to reset settings: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Export settings
  Future<String> exportSettings() async {
    try {
      final settingsJson = settings.value.toJson();
      return _settingsService.exportSettings(settingsJson);
    } catch (e) {
      print('SettingsController: Failed to export settings: $e');
      error.value = 'Failed to export settings: $e';
      return '';
    }
  }

  /// Import settings
  Future<bool> importSettings(String settingsData) async {
    try {
      isLoading.value = true;
      error.value = '';

      final importedSettings =
          await _settingsService.importSettings(settingsData);
      settings.value = importedSettings;
      notifications.value = importedSettings.notifications;
      theme.value = importedSettings.theme;

      await _applySettings(importedSettings);
      await _saveSettings();

      print('SettingsController: Settings imported successfully');
      return true;
    } catch (e) {
      print('SettingsController: Failed to import settings: $e');
      error.value = 'Failed to import settings: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Clear error message
  void clearError() {
    error.value = '';
  }

  /// Check if settings have been modified
  bool get hasUnsavedChanges {
    return settings.value != SettingsModel.defaultSettings();
  }
}
