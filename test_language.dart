import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'lib/translations.dart';
import 'lib/modules/settings/models/language_settings.dart';
import 'lib/modules/settings/services/language_service.dart';

void main() {
  runApp(TestLanguageApp());
}

class TestLanguageApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Language Test',
      translations: AppTranslations(),
      locale: const Locale('en', 'US'),
      fallbackLocale: const Locale('en', 'US'),
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('ar', 'SA'),
      ],
      home: TestLanguagePage(),
    );
  }
}

class TestLanguagePage extends StatelessWidget {
  final LanguageService _languageService = LanguageService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Language Test'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Current Language: ${Get.locale?.languageCode ?? 'unknown'}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _languageService.setLanguage(AppLanguage.english);
                print('Language set to English');
              },
              child: Text('Set to English'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                await _languageService.setLanguage(AppLanguage.arabic);
                print('Language set to Arabic');
              },
              child: Text('Set to Arabic'),
            ),
            SizedBox(height: 20),
            Text(
              'Test Translation: ${'Settings & Preferences'.tr}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
