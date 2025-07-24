import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageManager extends ChangeNotifier {
  static const String _languageKey = 'selected_language';
  
  Locale _currentLocale = const Locale('ar'); // Default to Arabic
  
  Locale get currentLocale => _currentLocale;
  
  // Supported languages
  static const List<Locale> supportedLocales = [
    Locale('ar'), // Arabic
    Locale('en'), // English
    Locale('fr'), // French
  ];
  
  // Language names for display
  static const Map<String, String> languageNames = {
    'ar': 'العربية',
    'en': 'English',
    'fr': 'Français',
  };
  
  // Language flags/icons
  static const Map<String, String> languageFlags = {
    'ar': '🇲🇦',
    'en': '🇺🇸',
    'fr': '🇫🇷',
  };
  
  LanguageManager() {
    _loadLanguage();
  }
  
  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_languageKey) ?? 'ar';
    _currentLocale = Locale(languageCode);
    notifyListeners();
  }
  
  Future<void> changeLanguage(String languageCode) async {
    if (supportedLocales.any((locale) => locale.languageCode == languageCode)) {
      _currentLocale = Locale(languageCode);
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, languageCode);
      
      notifyListeners();
    }
  }
  
  String getLanguageName(String languageCode) {
    return languageNames[languageCode] ?? languageCode;
  }
  
  String getLanguageFlag(String languageCode) {
    return languageFlags[languageCode] ?? '🌐';
  }
  
  bool isRTL() {
    return _currentLocale.languageCode == 'ar';
  }
}
