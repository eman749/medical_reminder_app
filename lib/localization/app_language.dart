import 'package:flutter/material.dart';

class AppLanguage extends ChangeNotifier {
  // Singleton pattern for easy global access
  static final AppLanguage instance = AppLanguage._internal();
  AppLanguage._internal();

  // Default to Arabic (as requested by user to have it all switch to Arabic)
  Locale _locale = const Locale('ar');

  Locale get locale => _locale;
  bool get isArabic => _locale.languageCode == 'ar';
  String get currentCode => _locale.languageCode;

  void setLocale(Locale newLocale) {
    if (_locale == newLocale) return;
    _locale = newLocale;
    notifyListeners();
  }

  void toggleLanguage() {
    if (_locale.languageCode == 'ar') {
      _locale = const Locale('en');
    } else {
      _locale = const Locale('ar');
    }
    notifyListeners();
  }

  void switchToArabic() {
    _locale = const Locale('ar');
    notifyListeners();
  }

  void switchToEnglish() {
    _locale = const Locale('en');
    notifyListeners();
  }
}
