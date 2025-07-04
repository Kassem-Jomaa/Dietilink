/// Language settings model
class LanguageSettings {
  final AppLanguage language;
  final bool autoDetect;
  final bool showLanguageName;

  const LanguageSettings({
    this.language = AppLanguage.english,
    this.autoDetect = true,
    this.showLanguageName = true,
  });

  factory LanguageSettings.fromJson(Map<String, dynamic> json) {
    return LanguageSettings(
      language: AppLanguage.values.firstWhere(
        (e) => e.code == json['language'],
        orElse: () => AppLanguage.english,
      ),
      autoDetect: json['auto_detect'] ?? true,
      showLanguageName: json['show_language_name'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'language': language.code,
      'auto_detect': autoDetect,
      'show_language_name': showLanguageName,
    };
  }

  LanguageSettings copyWith({
    AppLanguage? language,
    bool? autoDetect,
    bool? showLanguageName,
  }) {
    return LanguageSettings(
      language: language ?? this.language,
      autoDetect: autoDetect ?? this.autoDetect,
      showLanguageName: showLanguageName ?? this.showLanguageName,
    );
  }

  @override
  String toString() {
    return 'LanguageSettings(language: $language, autoDetect: $autoDetect)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LanguageSettings &&
        other.language == language &&
        other.autoDetect == autoDetect &&
        other.showLanguageName == showLanguageName;
  }

  @override
  int get hashCode {
    return language.hashCode ^ autoDetect.hashCode ^ showLanguageName.hashCode;
  }
}

/// Supported app languages
enum AppLanguage {
  english('en', 'English', 'الإنجليزية'),
  arabic('ar', 'العربية', 'Arabic');

  final String code;
  final String displayName;
  final String nativeName;

  const AppLanguage(this.code, this.displayName, this.nativeName);

  /// Get language by code
  static AppLanguage fromCode(String code) {
    return AppLanguage.values.firstWhere(
      (lang) => lang.code == code,
      orElse: () => AppLanguage.english,
    );
  }

  /// Get locale for this language
  String get locale => code;

  /// Check if this is RTL language
  bool get isRTL => this == AppLanguage.arabic;

  /// Get display name with native name if enabled
  String getDisplayName(bool showNativeName) {
    if (showNativeName) {
      return '$displayName ($nativeName)';
    }
    return displayName;
  }

  /// Get flag emoji for the language
  String get flagEmoji {
    switch (this) {
      case AppLanguage.english:
        return '🇺🇸';
      case AppLanguage.arabic:
        return '🇸🇦';
    }
  }
}
