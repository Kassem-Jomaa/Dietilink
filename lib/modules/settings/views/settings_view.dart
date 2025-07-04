import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../controllers/settings_controller.dart';
import '../widgets/settings_tile.dart';
import '../widgets/settings_section.dart';
import '../models/theme_settings.dart';
import '../models/language_settings.dart';
import '../services/theme_service.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SettingsController>();
    print('SettingsView: Controller found: ${controller != null}');
    print(
        'SettingsView: Language value: ${controller.language.value.language.displayName}');

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(
          'Settings & Preferences'.tr,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        backgroundColor: AppTheme.cardBackground,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppTheme.textMuted),
            onPressed: () => controller.resetToDefaults(),
            tooltip: 'Reset to Defaults'.tr,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: LoadingIndicator());
        }

        if (controller.error.value.isNotEmpty) {
          return _buildErrorState(controller);
        }

        return _buildSettingsContent(controller);
      }),
    );
  }

  Widget _buildErrorState(SettingsController controller) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.error.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: 48,
                color: AppTheme.error,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Failed to Load Settings'.tr,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              controller.error.value,
              style: TextStyle(
                color: AppTheme.textMuted,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => controller.clearError(),
              icon: const Icon(Icons.refresh),
              label: Text('Try Again'.tr),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsContent(SettingsController controller) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Notifications Section
        SettingsSection(
          title: 'Notifications',
          icon: Icons.notifications,
          children: [
            SettingsTile(
              title: 'Notifications'.tr,
              subtitle: 'Manage your notification preferences'.tr,
              icon: Icons.notifications,
              onTap: () {
                Get.snackbar(
                  'Coming Soon'.tr,
                  'Notification settings will be available soon!'.tr,
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: AppTheme.primary.withOpacity(0.1),
                  colorText: AppTheme.primary,
                );
              },
              trailing: Icon(
                Icons.chevron_right,
                color: AppTheme.textMuted,
              ),
            ),
            Obx(() => SettingsTile(
                  title: 'Enable Notifications',
                  subtitle: 'Turn notifications on or off',
                  icon: Icons.notifications,
                  trailing: Switch(
                    value: controller.notifications.value.enabled,
                    onChanged: (value) {
                      final newSettings =
                          controller.notifications.value.copyWith(
                        enabled: value,
                      );
                      controller.updateNotificationSettings(newSettings);
                    },
                    activeColor: AppTheme.primary,
                  ),
                )),
          ],
        ),

        const SizedBox(height: 24),

        // Language Section
        SettingsSection(
          title: 'Language & Region'.tr,
          icon: Icons.language,
          children: [
            SettingsTile(
              title: 'Current Language'.tr,
              subtitle: controller.language.value.language.displayName,
              icon: Icons.language,
              onTap: () {
                print('Language tile tapped!');
                _showLanguageSelector(controller);
              },
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    controller.language.value.language.flagEmoji,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.arrow_drop_down,
                    color: AppTheme.textMuted,
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Theme Section
        SettingsSection(
          title: 'Appearance'.tr,
          icon: Icons.palette,
          children: [
            SettingsTile(
              title: 'Theme Settings'.tr,
              subtitle: 'Customize app appearance'.tr,
              icon: Icons.palette_outlined,
              onTap: () => _showThemeSelector(controller),
              trailing: Icon(
                Icons.chevron_right,
                color: AppTheme.textMuted,
              ),
            ),
            Obx(() => SettingsTile(
                  title: 'Theme Mode'.tr,
                  subtitle: controller.theme.value.themeMode.description,
                  icon: controller.theme.value.themeMode.icon,
                  trailing: _buildThemeModeSelector(controller),
                )),
            Obx(() => SettingsTile(
                  title: 'Dark Mode'.tr,
                  subtitle: 'Toggle dark/light theme'.tr,
                  icon: Icons.dark_mode,
                  trailing: Switch(
                    value:
                        controller.theme.value.themeMode == AppThemeMode.dark,
                    onChanged: (value) {
                      final newMode =
                          value ? AppThemeMode.dark : AppThemeMode.light;
                      final newSettings = controller.theme.value.copyWith(
                        themeMode: newMode,
                      );
                      controller.updateThemeSettings(newSettings);
                    },
                    activeColor: AppTheme.primary,
                  ),
                )),
          ],
        ),

        const SizedBox(height: 24),

        // Data Management Section
        SettingsSection(
          title: 'Data Management',
          icon: Icons.storage,
          children: [
            SettingsTile(
              title: 'Export Settings',
              subtitle: 'Backup your preferences',
              icon: Icons.file_download,
              onTap: () => _exportSettings(controller),
            ),
            SettingsTile(
              title: 'Import Settings',
              subtitle: 'Restore from backup',
              icon: Icons.file_upload,
              onTap: () => _importSettings(controller),
            ),
            SettingsTile(
              title: 'Reset to Defaults',
              subtitle: 'Clear all custom settings',
              icon: Icons.restore,
              onTap: () => _showResetDialog(controller),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // About Section
        SettingsSection(
          title: 'About',
          icon: Icons.info,
          children: [
            SettingsTile(
              title: 'App Version',
              subtitle: '1.0.0',
              icon: Icons.info_outline,
              trailing: Text(
                'v1.0.0',
                style: TextStyle(
                  color: AppTheme.textMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SettingsTile(
              title: 'Terms of Service',
              subtitle: 'Read our terms and conditions',
              icon: Icons.description,
              onTap: () {
                // TODO: Navigate to terms of service
                Get.snackbar(
                  'Coming Soon',
                  'Terms of service will be available soon!',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
            ),
            SettingsTile(
              title: 'Privacy Policy',
              subtitle: 'Learn about data privacy',
              icon: Icons.privacy_tip,
              onTap: () {
                // TODO: Navigate to privacy policy
                Get.snackbar(
                  'Coming Soon',
                  'Privacy policy will be available soon!',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildThemeModeSelector(SettingsController controller) {
    return GetBuilder<ThemeService>(
      builder: (themeService) {
        return PopupMenuButton<AppThemeMode>(
          icon: Icon(
            Icons.arrow_drop_down,
            color: AppTheme.textMuted,
          ),
          onSelected: (AppThemeMode mode) {
            final newSettings = controller.theme.value.copyWith(
              themeMode: mode,
            );
            controller.updateThemeSettings(newSettings);
          },
          itemBuilder: (BuildContext context) =>
              AppThemeMode.values.map((AppThemeMode mode) {
            return PopupMenuItem<AppThemeMode>(
              value: mode,
              child: Row(
                children: [
                  Icon(
                    mode.icon,
                    color: AppTheme.textMuted,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(mode.displayName),
                  if (themeService.currentThemeMode == mode) ...[
                    const Spacer(),
                    Icon(
                      Icons.check,
                      color: AppTheme.primary,
                      size: 18,
                    ),
                  ],
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }

  void _showLanguageSelector(SettingsController controller) {
    print('_showLanguageSelector called!');
    Get.dialog(
      AlertDialog(
        backgroundColor: AppTheme.cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.language,
              color: AppTheme.primary,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              'Select Language'.tr,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: AppLanguage.values.map((AppLanguage language) {
            final isSelected = controller.language.value.language == language;
            return ListTile(
              leading: Text(
                language.flagEmoji,
                style: const TextStyle(fontSize: 24),
              ),
              title: Text(
                language.displayName,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? AppTheme.primary : AppTheme.textPrimary,
                ),
              ),
              subtitle: Text(
                language.nativeName,
                style: TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 12,
                ),
              ),
              trailing: isSelected
                  ? Icon(
                      Icons.check_circle,
                      color: AppTheme.primary,
                      size: 24,
                    )
                  : null,
              onTap: () {
                Get.back();
                final newSettings = controller.language.value.copyWith(
                  language: language,
                );
                controller.updateLanguageSettings(newSettings);
              },
              tileColor: isSelected
                  ? AppTheme.primary.withOpacity(0.1)
                  : Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'.tr),
          ),
        ],
      ),
    );
  }

  void _exportSettings(SettingsController controller) async {
    try {
      final settingsData = await controller.exportSettings();
      if (settingsData.isNotEmpty) {
        // TODO: Implement file sharing or clipboard copy
        Get.snackbar(
          'Settings Exported'.tr,
          'Settings have been exported successfully'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppTheme.success.withOpacity(0.1),
          colorText: AppTheme.success,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Export Failed'.tr,
        'Failed to export settings: $e'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.error.withOpacity(0.1),
        colorText: AppTheme.error,
      );
    }
  }

  void _importSettings(SettingsController controller) async {
    // TODO: Implement file picker for import
    Get.snackbar(
      'Coming Soon'.tr,
      'Settings import will be available soon!'.tr,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _showResetDialog(SettingsController controller) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppTheme.cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.restore,
              color: AppTheme.warning,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              'Reset Settings'.tr,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to reset all settings to their default values? This action cannot be undone.'
              .tr,
          style: const TextStyle(
            color: AppTheme.textMuted,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'.tr),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.resetToDefaults();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.warning,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Reset'.tr),
          ),
        ],
      ),
    );
  }

  void _showThemeSelector(SettingsController controller) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppTheme.cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.palette,
              color: AppTheme.primary,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              'Select Theme'.tr,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: AppThemeMode.values.map((AppThemeMode mode) {
            final isSelected = controller.theme.value.themeMode == mode;
            return ListTile(
              leading: Icon(
                mode.icon,
                color: isSelected ? AppTheme.primary : AppTheme.textMuted,
              ),
              title: Text(
                mode.displayName,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: AppTheme.textPrimary,
                ),
              ),
              subtitle: Text(
                mode.description,
                style: TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 12,
                ),
              ),
              trailing: isSelected
                  ? Icon(
                      Icons.check,
                      color: AppTheme.primary,
                      size: 20,
                    )
                  : null,
              onTap: () {
                final newSettings = controller.theme.value.copyWith(
                  themeMode: mode,
                );
                controller.updateThemeSettings(newSettings);
                Get.back();
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel'.tr,
              style: TextStyle(color: AppTheme.textMuted),
            ),
          ),
        ],
      ),
    );
  }
}
