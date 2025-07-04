import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/language_settings.dart';

class LanguageService {
  static const String _languageKey = 'app_language';

  /// Set the app language
  Future<void> setLanguage(AppLanguage language) async {
    try {
      // Save language preference
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, language.code);

      // Update GetX locale
      final locale = _getLocale(language);
      Get.updateLocale(locale);

      print('LanguageService: Language set to ${language.displayName}');
    } catch (e) {
      print('LanguageService: Failed to set language: $e');
    }
  }

  /// Get current language
  Future<AppLanguage> getCurrentLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString(_languageKey);

      if (languageCode != null) {
        return AppLanguage.fromCode(languageCode);
      }

      return AppLanguage.english; // Default language
    } catch (e) {
      print('LanguageService: Failed to get current language: $e');
      return AppLanguage.english;
    }
  }

  /// Get locale for the language
  Locale _getLocale(AppLanguage language) {
    switch (language) {
      case AppLanguage.english:
        return const Locale('en', 'US');
      case AppLanguage.arabic:
        return const Locale('ar', 'SA');
    }
  }

  /// Get supported locales
  List<Locale> getSupportedLocales() {
    return [
      const Locale('en', 'US'),
      const Locale('ar', 'SA'),
    ];
  }

  /// Check if language is RTL
  bool isRTL(AppLanguage language) {
    return language.isRTL;
  }

  /// Get language display name
  String getLanguageDisplayName(AppLanguage language, bool showNativeName) {
    return language.getDisplayName(showNativeName);
  }

  /// Get all available languages
  List<AppLanguage> getAvailableLanguages() {
    return AppLanguage.values;
  }
}
