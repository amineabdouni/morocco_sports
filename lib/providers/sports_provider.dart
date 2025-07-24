import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/models.dart';
import '../cores/storage_service.dart';
import '../cores/sports_data.dart';
import '../cores/recommendation_engine.dart';

/// مزود حالة الرياضات (Sports Provider)
/// يدير جميع البيانات المتعلقة بالرياضات والتفاعل معها
class SportsProvider extends ChangeNotifier {
  static const String _favoritesKey = 'favorite_sports';
  static const String _viewedSportsKey = 'viewed_sports';
  static const String _searchHistoryKey = 'search_history';

  // البيانات الأساسية
  List<SportModel> _allSports = [];
  List<SportModel> _filteredSports = [];
  List<String> _favoriteSports = [];
  List<String> _viewedSports = [];
  List<String> _searchHistory = [];
  
  // حالة التطبيق
  bool _isLoading = false;
  String _searchQuery = '';
  SportCategory? _selectedCategory;
  int _selectedDifficulty = 0; // 0 = all, 1-5 = specific difficulty
  
  // خدمة التخزين
  final StorageService _storageService = StorageService();

  // Getters
  List<SportModel> get allSports => _allSports;
  List<SportModel> get filteredSports => _filteredSports;
  List<String> get favoriteSports => _favoriteSports;
  List<String> get viewedSports => _viewedSports;
  List<String> get searchHistory => _searchHistory;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  SportCategory? get selectedCategory => _selectedCategory;
  int get selectedDifficulty => _selectedDifficulty;

  /// الرياضات المفضلة كنماذج
  List<SportModel> get favoriteSportsModels {
    return _allSports.where((sport) => _favoriteSports.contains(sport.id)).toList();
  }

  /// الرياضات المشاهدة مؤخراً
  List<SportModel> get recentlyViewedSports {
    return _viewedSports
        .map((id) => _allSports.firstWhere(
              (sport) => sport.id == id,
              orElse: () => _allSports.first,
            ))
        .toList();
  }

  /// الرياضات الشائعة في المغرب
  List<SportModel> get popularInMorocco {
    return _allSports.where((sport) => sport.isPopularInMorocco).toList();
  }

  /// إحصائيات سريعة
  Map<String, int> get quickStats {
    return {
      'total': _allSports.length,
      'favorites': _favoriteSports.length,
      'viewed': _viewedSports.length,
      'individual': _allSports.where((s) => s.category == SportCategory.individual).length,
      'team': _allSports.where((s) => s.category == SportCategory.team).length,
      'moroccan': _allSports.where((s) => s.isPopularInMorocco).length,
    };
  }

  SportsProvider() {
    _initializeData();
  }

  /// تهيئة البيانات
  Future<void> _initializeData() async {
    _setLoading(true);
    
    try {
      // تحميل البيانات الأساسية
      _allSports = SportsData.getAllSports();
      _filteredSports = List.from(_allSports);
      
      // تحميل البيانات المحفوظة
      await _loadSavedData();
      
      // تطبيق الفلاتر
      _applyFilters();
      
    } catch (e) {
      debugPrint('Error initializing sports data: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// تحميل البيانات المحفوظة
  Future<void> _loadSavedData() async {
    try {
      _favoriteSports = await _storageService.getStringList(_favoritesKey) ?? [];
      _viewedSports = await _storageService.getStringList(_viewedSportsKey) ?? [];
      _searchHistory = await _storageService.getStringList(_searchHistoryKey) ?? [];
    } catch (e) {
      debugPrint('Error loading saved data: $e');
    }
  }

  /// تعيين حالة التحميل
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// البحث في الرياضات
  void searchSports(String query) {
    _searchQuery = query.trim();
    
    // إضافة إلى تاريخ البحث إذا لم يكن فارغاً
    if (_searchQuery.isNotEmpty && !_searchHistory.contains(_searchQuery)) {
      _searchHistory.insert(0, _searchQuery);
      if (_searchHistory.length > 10) {
        _searchHistory = _searchHistory.take(10).toList();
      }
      _saveSearchHistory();
    }
    
    _applyFilters();
  }

  /// تطبيق فلتر التصنيف
  void filterByCategory(SportCategory? category) {
    _selectedCategory = category;
    _applyFilters();
  }

  /// تطبيق فلتر الصعوبة
  void filterByDifficulty(int difficulty) {
    _selectedDifficulty = difficulty;
    _applyFilters();
  }

  /// مسح جميع الفلاتر
  void clearFilters() {
    _searchQuery = '';
    _selectedCategory = null;
    _selectedDifficulty = 0;
    _applyFilters();
  }

  /// تطبيق جميع الفلاتر
  void _applyFilters() {
    _filteredSports = _allSports.where((sport) {
      // فلتر البحث
      bool matchesSearch = _searchQuery.isEmpty ||
          sport.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          sport.nameAr.contains(_searchQuery) ||
          sport.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          sport.descriptionAr.contains(_searchQuery);

      // فلتر التصنيف
      bool matchesCategory = _selectedCategory == null || sport.category == _selectedCategory;

      // فلتر الصعوبة
      bool matchesDifficulty = _selectedDifficulty == 0 || sport.difficulty == _selectedDifficulty;

      return matchesSearch && matchesCategory && matchesDifficulty;
    }).toList();

    notifyListeners();
  }

  /// إضافة/إزالة من المفضلة
  Future<void> toggleFavorite(String sportId) async {
    if (_favoriteSports.contains(sportId)) {
      _favoriteSports.remove(sportId);
    } else {
      _favoriteSports.add(sportId);
    }
    
    await _saveFavorites();
    notifyListeners();
  }

  /// التحقق من كون الرياضة مفضلة
  bool isFavorite(String sportId) {
    return _favoriteSports.contains(sportId);
  }

  /// إضافة رياضة إلى المشاهدة مؤخراً
  Future<void> markAsViewed(String sportId) async {
    _viewedSports.remove(sportId); // إزالة إذا كانت موجودة
    _viewedSports.insert(0, sportId); // إضافة في المقدمة
    
    // الاحتفاظ بآخر 20 رياضة فقط
    if (_viewedSports.length > 20) {
      _viewedSports = _viewedSports.take(20).toList();
    }
    
    await _saveViewedSports();
    notifyListeners();
  }

  /// الحصول على رياضة بالمعرف
  SportModel? getSportById(String id) {
    try {
      return _allSports.firstWhere((sport) => sport.id == id);
    } catch (e) {
      return null;
    }
  }

  /// الحصول على رياضات مشابهة
  List<SportModel> getSimilarSports(String sportId, {int limit = 5}) {
    final sport = getSportById(sportId);
    if (sport == null) return [];

    return _allSports
        .where((s) => s.id != sportId && s.category == sport.category)
        .take(limit)
        .toList();
  }

  /// حفظ المفضلة
  Future<void> _saveFavorites() async {
    await _storageService.setStringList(_favoritesKey, _favoriteSports);
  }

  /// حفظ المشاهدة مؤخراً
  Future<void> _saveViewedSports() async {
    await _storageService.setStringList(_viewedSportsKey, _viewedSports);
  }

  /// حفظ تاريخ البحث
  Future<void> _saveSearchHistory() async {
    await _storageService.setStringList(_searchHistoryKey, _searchHistory);
  }

  /// مسح تاريخ البحث
  Future<void> clearSearchHistory() async {
    _searchHistory.clear();
    await _storageService.remove(_searchHistoryKey);
    notifyListeners();
  }

  /// الحصول على توصيات مخصصة
  List<SportModel> getPersonalizedRecommendations(UserModel user, {int limit = 10}) {
    return RecommendationEngine.getPersonalizedRecommendations(
      allSports: _allSports,
      user: user,
      viewedSports: _viewedSports,
      favoriteSports: _favoriteSports,
      limit: limit,
    );
  }

  /// الحصول على رياضات مشابهة
  List<SportModel> getSimilarSportsTo(String sportId, {int limit = 5}) {
    final sport = getSportById(sportId);
    if (sport == null) return [];

    return RecommendationEngine.getSimilarSports(
      baseSport: sport,
      allSports: _allSports,
      limit: limit,
    );
  }

  /// الحصول على اتجاهات الاستخدام
  Map<String, dynamic> getUsageTrends() {
    return RecommendationEngine.getUsageTrends(
      viewedSports: _viewedSports,
      favoriteSports: _favoriteSports,
      categoryInteractions: {}, // يمكن تحسينه لاحقاً
    );
  }

  /// إعادة تحميل البيانات
  Future<void> refresh() async {
    await _initializeData();
  }

  /// تصدير البيانات
  Map<String, dynamic> exportData() {
    return {
      'favorites': _favoriteSports,
      'viewed': _viewedSports,
      'searchHistory': _searchHistory,
      'exportDate': DateTime.now().toIso8601String(),
    };
  }

  /// استيراد البيانات
  Future<void> importData(Map<String, dynamic> data) async {
    try {
      _favoriteSports = List<String>.from(data['favorites'] ?? []);
      _viewedSports = List<String>.from(data['viewed'] ?? []);
      _searchHistory = List<String>.from(data['searchHistory'] ?? []);
      
      await _saveFavorites();
      await _saveViewedSports();
      await _saveSearchHistory();
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error importing data: $e');
    }
  }
}
