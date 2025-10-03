import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_theme.dart';
import '../../modules/settings/services/theme_service.dart';
import '../../modules/settings/models/theme_settings.dart';

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
