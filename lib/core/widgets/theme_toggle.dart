import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_theme.dart';
import '../../modules/settings/services/theme_service.dart';
import '../../modules/settings/models/theme_settings.dart';
import '../../modules/settings/services/language_service.dart';
import '../../modules/settings/models/language_settings.dart';

class ThemeToggle extends StatelessWidget {
  final double? size;
  final Color? color;
  final bool showTooltip;

  const ThemeToggle({
    super.key,
    this.size,
    this.color,
    this.showTooltip = true,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeService>(
      builder: (themeService) {
        final isDark = themeService.isDarkMode();

        return IconButton(
          onPressed: () async {
            await themeService.toggleTheme();
          },
          icon: Icon(
            isDark ? Icons.light_mode : Icons.dark_mode,
            color: color ?? AppTheme.textMuted,
            size: size ?? 24,
          ),
          tooltip: showTooltip
              ? (isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode')
              : null,
        );
      },
    );
  }
}

class ThemeModeSelector extends StatelessWidget {
  final double? size;
  final Color? color;
  final bool showTooltip;

  const ThemeModeSelector({
    super.key,
    this.size,
    this.color,
    this.showTooltip = true,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeService>(
      builder: (themeService) {
        return PopupMenuButton<AppThemeMode>(
          icon: Icon(
            Icons.brightness_6,
            color: color ?? AppTheme.textMuted,
            size: size ?? 24,
          ),
          tooltip: showTooltip ? 'Select Theme Mode' : null,
          onSelected: (AppThemeMode mode) async {
            await themeService.setThemeMode(mode);
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
                  const Spacer(),
                  if (themeService.currentThemeMode == mode)
                    Icon(
                      Icons.check,
                      color: AppTheme.primary,
                      size: 18,
                    ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class LanguageToggle extends StatelessWidget {
  const LanguageToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        onPressed: () {
          // Toggle between English and Arabic
          final currentLocale = Get.locale;
          final newLocale = currentLocale?.languageCode == 'ar'
              ? const Locale('en', 'US')
              : const Locale('ar', 'SA');
          Get.updateLocale(newLocale);
        },
        icon: Text(
          Get.locale?.languageCode == 'ar' ? '🇺🇸' : '🇸🇦',
          style: const TextStyle(fontSize: 16),
        ),
        style: IconButton.styleFrom(
          padding: const EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
