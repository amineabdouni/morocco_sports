import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/models.dart';
import '../cores/storage_service.dart';

/// مزود حالة المستخدم (User Provider)
/// يدير جميع بيانات المستخدم وتفضيلاته
class UserProvider extends ChangeNotifier {
  static const String _userDataKey = 'user_data';
  static const String _preferencesKey = 'user_preferences';
  static const String _statsKey = 'user_stats';
  static const String _levelKey = 'user_level';

  // بيانات المستخدم
  UserModel? _currentUser;
  bool _isLoading = false;
  bool _isFirstTime = true;

  // خدمة التخزين
  final StorageService _storageService = StorageService();

  // Getters
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isFirstTime => _isFirstTime;
  bool get isLoggedIn => _currentUser != null;

  // تفضيلات سريعة
  Locale get currentLocale => _currentUser?.preferences.language ?? const Locale('ar');
  ThemeMode get currentThemeMode => _currentUser?.preferences.themeMode ?? ThemeMode.light;
  bool get isDarkMode => currentThemeMode == ThemeMode.dark;
  bool get showArabicNames => _currentUser?.preferences.showArabicNames ?? true;

  UserProvider() {
    _initializeUser();
  }

  /// تهيئة المستخدم
  Future<void> _initializeUser() async {
    _setLoading(true);
    
    try {
      await _loadUserData();
      
      // إذا لم يكن هناك مستخدم، إنشاء مستخدم افتراضي
      if (_currentUser == null) {
        await _createDefaultUser();
      }
      
      // تحديث آخر نشاط
      await _updateLastActive();
      
    } catch (e) {
      debugPrint('Error initializing user: $e');
      await _createDefaultUser();
    } finally {
      _setLoading(false);
    }
  }

  /// تحميل بيانات المستخدم
  Future<void> _loadUserData() async {
    try {
      final userData = await _storageService.getString(_userDataKey);
      if (userData != null) {
        final userJson = json.decode(userData);
        _currentUser = UserModel.fromJson(userJson);
        _isFirstTime = false;
      }
    } catch (e) {
      debugPrint('Error loading user data: $e');
    }
  }

  /// إنشاء مستخدم افتراضي
  Future<void> _createDefaultUser() async {
    _currentUser = UserModel.defaultUser();
    await _saveUserData();
    _isFirstTime = true;
  }

  /// حفظ بيانات المستخدم
  Future<void> _saveUserData() async {
    if (_currentUser != null) {
      final userJson = json.encode(_currentUser!.toJson());
      await _storageService.setString(_userDataKey, userJson);
    }
  }

  /// تعيين حالة التحميل
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// تحديث معلومات المستخدم الأساسية
  Future<void> updateUserInfo({
    String? name,
    String? email,
    String? avatarUrl,
  }) async {
    if (_currentUser == null) return;

    _currentUser = _currentUser!.copyWith(
      name: name ?? _currentUser!.name,
      email: email ?? _currentUser!.email,
      avatarUrl: avatarUrl ?? _currentUser!.avatarUrl,
    );

    await _saveUserData();
    notifyListeners();
  }

  /// تحديث التفضيلات
  Future<void> updatePreferences({
    Locale? language,
    ThemeMode? themeMode,
    bool? notificationsEnabled,
    bool? soundEnabled,
    List<SportCategory>? preferredCategories,
    int? difficultyPreference,
    bool? showArabicNames,
  }) async {
    if (_currentUser == null) return;

    final newPreferences = _currentUser!.preferences.copyWith(
      language: language,
      themeMode: themeMode,
      notificationsEnabled: notificationsEnabled,
      soundEnabled: soundEnabled,
      preferredCategories: preferredCategories,
      difficultyPreference: difficultyPreference,
      showArabicNames: showArabicNames,
    );

    _currentUser = _currentUser!.copyWith(preferences: newPreferences);
    await _saveUserData();
    notifyListeners();
  }

  /// تغيير اللغة
  Future<void> changeLanguage(Locale locale) async {
    await updatePreferences(language: locale);
  }

  /// تغيير الثيم
  Future<void> changeTheme(ThemeMode themeMode) async {
    await updatePreferences(themeMode: themeMode);
  }

  /// تبديل الثيم
  Future<void> toggleTheme() async {
    final newTheme = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    await changeTheme(newTheme);
  }

  /// تبديل الأسماء العربية
  Future<void> toggleArabicNames() async {
    await updatePreferences(showArabicNames: !showArabicNames);
  }

  /// إضافة نقاط
  Future<void> addPoints(int points) async {
    if (_currentUser == null) return;

    final newTotalPoints = _currentUser!.totalPoints + points;
    final newStats = _currentUser!.stats.copyWith(
      totalInteractions: _currentUser!.stats.totalInteractions + 1,
    );

    _currentUser = _currentUser!.copyWith(
      totalPoints: newTotalPoints,
      stats: newStats,
    );

    // التحقق من ترقية المستوى
    await _checkLevelUp();
    
    await _saveUserData();
    notifyListeners();
  }

  /// إضافة رياضة مفضلة
  Future<void> addFavoriteSport(String sportId) async {
    if (_currentUser == null) return;

    final favorites = List<String>.from(_currentUser!.favoriteSports);
    if (!favorites.contains(sportId)) {
      favorites.add(sportId);
      _currentUser = _currentUser!.copyWith(favoriteSports: favorites);
      await _saveUserData();
      notifyListeners();
    }
  }

  /// إزالة رياضة مفضلة
  Future<void> removeFavoriteSport(String sportId) async {
    if (_currentUser == null) return;

    final favorites = List<String>.from(_currentUser!.favoriteSports);
    if (favorites.contains(sportId)) {
      favorites.remove(sportId);
      _currentUser = _currentUser!.copyWith(favoriteSports: favorites);
      await _saveUserData();
      notifyListeners();
    }
  }

  /// إضافة إنجاز
  Future<void> unlockAchievement(Achievement achievement) async {
    if (_currentUser == null) return;

    final achievements = List<Achievement>.from(_currentUser!.unlockedAchievements);
    
    // التحقق من عدم وجود الإنجاز مسبقاً
    if (!achievements.any((a) => a.id == achievement.id)) {
      achievements.add(achievement);
      
      final newStats = _currentUser!.stats.copyWith(
        achievementsUnlocked: achievements.length,
        lastAchievementDate: DateTime.now(),
      );

      _currentUser = _currentUser!.copyWith(
        unlockedAchievements: achievements,
        totalPoints: _currentUser!.totalPoints + achievement.points,
        stats: newStats,
      );

      await _checkLevelUp();
      await _saveUserData();
      notifyListeners();
    }
  }

  /// تسجيل استكشاف رياضة جديدة
  Future<void> exploreSport(String sportId) async {
    if (_currentUser == null) return;

    final newStats = _currentUser!.stats.copyWith(
      sportsExplored: _currentUser!.stats.sportsExplored + 1,
      totalInteractions: _currentUser!.stats.totalInteractions + 1,
    );

    _currentUser = _currentUser!.copyWith(stats: newStats);
    
    // إضافة نقاط للاستكشاف
    await addPoints(10);
  }

  /// تحديث آخر نشاط
  Future<void> _updateLastActive() async {
    if (_currentUser == null) return;

    _currentUser = _currentUser!.copyWith(lastActiveAt: DateTime.now());
    await _saveUserData();
  }

  /// التحقق من ترقية المستوى
  Future<void> _checkLevelUp() async {
    if (_currentUser == null) return;

    final currentLevel = _currentUser!.level;
    final totalPoints = _currentUser!.totalPoints;

    // حساب المستوى الجديد بناءً على النقاط
    int newLevelNumber = (totalPoints / 100).floor() + 1;
    
    if (newLevelNumber > currentLevel.level) {
      final newLevel = _calculateNewLevel(newLevelNumber, totalPoints);
      _currentUser = _currentUser!.copyWith(level: newLevel);
      
      // يمكن إضافة إشعار ترقية المستوى هنا
      debugPrint('Level up! New level: ${newLevel.level}');
    }
  }

  /// حساب المستوى الجديد
  UserLevel _calculateNewLevel(int levelNumber, int totalPoints) {
    final currentXP = totalPoints % 100;
    final requiredXP = 100;
    
    // تحديد اللقب والأيقونة حسب المستوى
    String title, titleAr;
    IconData icon;
    Color color;

    if (levelNumber <= 5) {
      title = 'Beginner';
      titleAr = 'مبتدئ';
      icon = Icons.sports_rounded;
      color = const Color(0xFF4CAF50);
    } else if (levelNumber <= 15) {
      title = 'Intermediate';
      titleAr = 'متوسط';
      icon = Icons.sports_soccer;
      color = const Color(0xFF2196F3);
    } else if (levelNumber <= 30) {
      title = 'Advanced';
      titleAr = 'متقدم';
      icon = Icons.emoji_events;
      color = const Color(0xFFFF9800);
    } else {
      title = 'Expert';
      titleAr = 'خبير';
      icon = Icons.military_tech;
      color = const Color(0xFF9C27B0);
    }

    return UserLevel(
      level: levelNumber,
      title: title,
      titleAr: titleAr,
      currentXP: currentXP,
      requiredXP: requiredXP,
      color: color,
      icon: icon,
    );
  }

  /// إعادة تعيين البيانات
  Future<void> resetUserData() async {
    await _storageService.remove(_userDataKey);
    await _createDefaultUser();
    notifyListeners();
  }

  /// تصدير بيانات المستخدم
  Map<String, dynamic> exportUserData() {
    if (_currentUser == null) return {};
    
    return {
      'user': _currentUser!.toJson(),
      'exportDate': DateTime.now().toIso8601String(),
      'version': '1.0',
    };
  }

  /// استيراد بيانات المستخدم
  Future<void> importUserData(Map<String, dynamic> data) async {
    try {
      if (data['user'] != null) {
        _currentUser = UserModel.fromJson(data['user']);
        await _saveUserData();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error importing user data: $e');
    }
  }

  /// إنهاء الجلسة الأولى
  Future<void> completeFirstTime() async {
    _isFirstTime = false;
    await _storageService.setBool('first_time_completed', true);
    notifyListeners();
  }
}
