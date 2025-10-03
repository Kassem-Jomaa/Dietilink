import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'routes/app_pages.dart';
import 'core/theme/app_theme.dart';
import 'core/services/api_service.dart';
import 'modules/auth/controllers/auth_controller.dart';
import 'modules/settings/services/theme_service.dart';
import 'modules/settings/models/theme_settings.dart';
import 'translations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  await Get.putAsync(() => ApiService().init());

  // Initialize settings services
  final themeService = Get.put(ThemeService());

  // Initialize controllers
  Get.put(AuthController(), permanent: true);

  // Initialize theme
  await _initializeTheme(themeService);

  runApp(const DietiLinkApp());
}

Future<void> _initializeTheme(ThemeService themeService) async {
  try {
    final currentThemeMode = await themeService.getCurrentThemeMode();
    await themeService.setThemeMode(currentThemeMode);
  } catch (e) {
    print('Failed to initialize theme: $e');
  }
}

class DietiLinkApp extends StatelessWidget {
  const DietiLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'DietiLink',
      debugShowCheckedModeBanner: false,

      // Theme configuration
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Will be controlled by ThemeService

      // Localization configuration
      locale: const Locale('en', 'US'),
      fallbackLocale: const Locale('en', 'US'),
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('ar', 'SA'),
      ],
      translations: AppTranslations(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // Navigation configuration
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      defaultTransition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
