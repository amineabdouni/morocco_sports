import 'package:flutter/material.dart';
import 'dart:convert';
import '../models/models.dart';
import '../cores/storage_service.dart';

/// مزود حالة التحديات (Challenges Provider)
/// يدير جميع التحديات والإنجازات التفاعلية
class ChallengesProvider extends ChangeNotifier {
  static const String _challengesKey = 'user_challenges';
  static const String _completedChallengesKey = 'completed_challenges';
  static const String _dailyProgressKey = 'daily_progress';

  // البيانات الأساسية
  List<ChallengeModel> _allChallenges = [];
  List<ChallengeModel> _activeChallenges = [];
  List<ChallengeModel> _completedChallenges = [];
  Map<String, dynamic> _dailyProgress = {};
  
  // حالة التطبيق
  bool _isLoading = false;
  DateTime _lastUpdateDate = DateTime.now();
  
  // خدمة التخزين
  final StorageService _storageService = StorageService();

  // Getters
  List<ChallengeModel> get allChallenges => _allChallenges;
  List<ChallengeModel> get activeChallenges => _activeChallenges;
  List<ChallengeModel> get completedChallenges => _completedChallenges;
  Map<String, dynamic> get dailyProgress => _dailyProgress;
  bool get isLoading => _isLoading;

  /// التحديات اليومية
  List<ChallengeModel> get dailyChallenges {
    return _activeChallenges.where((c) => c.type == ChallengeType.daily).toList();
  }

  /// التحديات الأسبوعية
  List<ChallengeModel> get weeklyChallenges {
    return _activeChallenges.where((c) => c.type == ChallengeType.weekly).toList();
  }

  /// التحديات الشهرية
  List<ChallengeModel> get monthlyChallenges {
    return _activeChallenges.where((c) => c.type == ChallengeType.monthly).toList();
  }

  /// إجمالي النقاط المكتسبة
  int get totalPointsEarned {
    return _completedChallenges.fold(0, (sum, challenge) => sum + challenge.points);
  }

  /// عدد التحديات المكتملة اليوم
  int get todayCompletedCount {
    final today = DateTime.now();
    return _completedChallenges.where((c) {
      return c.endDate.year == today.year &&
             c.endDate.month == today.month &&
             c.endDate.day == today.day;
    }).length;
  }

  ChallengesProvider() {
    _initializeChallenges();
  }

  /// تهيئة التحديات
  Future<void> _initializeChallenges() async {
    _setLoading(true);
    
    try {
      // تحميل البيانات المحفوظة
      await _loadSavedData();
      
      // إنشاء التحديات الافتراضية
      _generateDefaultChallenges();
      
      // تحديث حالة التحديات
      _updateChallengesStatus();
      
    } catch (e) {
      debugPrint('Error initializing challenges: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// تحميل البيانات المحفوظة
  Future<void> _loadSavedData() async {
    try {
      // تحميل التحديات النشطة
      final challengesData = await _storageService.getJsonList(_challengesKey);
      if (challengesData != null) {
        _allChallenges = challengesData.map((data) => ChallengeModel.fromJson(data)).toList();
      }

      // تحميل التحديات المكتملة
      final completedData = await _storageService.getJsonList(_completedChallengesKey);
      if (completedData != null) {
        _completedChallenges = completedData.map((data) => ChallengeModel.fromJson(data)).toList();
      }

      // تحميل التقدم اليومي
      _dailyProgress = await _storageService.getJson(_dailyProgressKey) ?? {};
      
    } catch (e) {
      debugPrint('Error loading challenges data: $e');
    }
  }

  /// تعيين حالة التحميل
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// إنشاء التحديات الافتراضية
  void _generateDefaultChallenges() {
    final now = DateTime.now();
    
    // التحديات اليومية
    _allChallenges.addAll([
      ChallengeModel(
        id: 'daily_explorer_${now.day}',
        title: 'Daily Explorer',
        titleAr: 'المستكشف اليومي',
        description: 'Explore 3 different sports today',
        descriptionAr: 'استكشف 3 رياضات مختلفة اليوم',
        icon: Icons.explore,
        color: const Color(0xFF4CAF50),
        type: ChallengeType.daily,
        difficulty: ChallengeDifficulty.easy,
        points: 50,
        duration: const Duration(days: 1),
        criteria: {'sportsToExplore': 3, 'currentCount': 0},
        status: ChallengeStatus.active,
        startDate: DateTime(now.year, now.month, now.day),
        endDate: DateTime(now.year, now.month, now.day, 23, 59, 59),
        steps: [
          ChallengeStep(
            id: 'step1',
            title: 'First Sport',
            titleAr: 'الرياضة الأولى',
            description: 'Explore your first sport',
            descriptionAr: 'استكشف رياضتك الأولى',
            icon: Icons.sports_soccer,
            order: 1,
          ),
          ChallengeStep(
            id: 'step2',
            title: 'Second Sport',
            titleAr: 'الرياضة الثانية',
            description: 'Explore your second sport',
            descriptionAr: 'استكشف رياضتك الثانية',
            icon: Icons.sports_basketball,
            order: 2,
          ),
          ChallengeStep(
            id: 'step3',
            title: 'Third Sport',
            titleAr: 'الرياضة الثالثة',
            description: 'Explore your third sport',
            descriptionAr: 'استكشف رياضتك الثالثة',
            icon: Icons.sports_tennis,
            order: 3,
          ),
        ],
        reward: const ChallengeReward(
          points: 50,
          title: 'Explorer Badge',
          titleAr: 'شارة المستكشف',
          icon: Icons.explore,
          color: Color(0xFF4CAF50),
        ),
      ),

      ChallengeModel(
        id: 'daily_favorite_${now.day}',
        title: 'Favorite Collector',
        titleAr: 'جامع المفضلات',
        description: 'Add 2 sports to your favorites',
        descriptionAr: 'أضف رياضتين إلى مفضلاتك',
        icon: Icons.favorite,
        color: const Color(0xFFE91E63),
        type: ChallengeType.daily,
        difficulty: ChallengeDifficulty.easy,
        points: 30,
        duration: const Duration(days: 1),
        criteria: {'favoritesToAdd': 2, 'currentCount': 0},
        status: ChallengeStatus.active,
        startDate: DateTime(now.year, now.month, now.day),
        endDate: DateTime(now.year, now.month, now.day, 23, 59, 59),
        steps: [],
        reward: const ChallengeReward(
          points: 30,
          title: 'Favorite Badge',
          titleAr: 'شارة المفضلات',
          icon: Icons.favorite,
          color: Color(0xFFE91E63),
        ),
      ),
    ]);

    // التحديات الأسبوعية
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    _allChallenges.add(
      ChallengeModel(
        id: 'weekly_master_${weekStart.day}',
        title: 'Weekly Sports Master',
        titleAr: 'سيد الرياضة الأسبوعي',
        description: 'Explore 10 different sports this week',
        descriptionAr: 'استكشف 10 رياضات مختلفة هذا الأسبوع',
        icon: Icons.emoji_events,
        color: const Color(0xFFFF9800),
        type: ChallengeType.weekly,
        difficulty: ChallengeDifficulty.medium,
        points: 200,
        duration: const Duration(days: 7),
        criteria: {'sportsToExplore': 10, 'currentCount': 0},
        status: ChallengeStatus.active,
        startDate: weekStart,
        endDate: weekStart.add(const Duration(days: 7)),
        steps: [],
        reward: const ChallengeReward(
          points: 200,
          title: 'Master Badge',
          titleAr: 'شارة السيد',
          icon: Icons.emoji_events,
          color: Color(0xFFFF9800),
        ),
      ),
    );

    _updateChallengesStatus();
  }

  /// تحديث حالة التحديات
  void _updateChallengesStatus() {
    final now = DateTime.now();
    
    _activeChallenges = _allChallenges.where((challenge) {
      // التحقق من انتهاء صلاحية التحدي
      if (now.isAfter(challenge.endDate)) {
        challenge = challenge.copyWith(status: ChallengeStatus.expired);
        return false;
      }
      
      return challenge.status == ChallengeStatus.active;
    }).toList();

    notifyListeners();
  }

  /// تحديث تقدم التحدي
  Future<void> updateChallengeProgress(String challengeId, Map<String, dynamic> progress) async {
    final challengeIndex = _activeChallenges.indexWhere((c) => c.id == challengeId);
    if (challengeIndex == -1) return;

    final challenge = _activeChallenges[challengeIndex];
    final updatedCriteria = Map<String, dynamic>.from(challenge.criteria);
    
    // تحديث المعايير
    progress.forEach((key, value) {
      updatedCriteria[key] = value;
    });

    // التحقق من اكتمال التحدي
    bool isCompleted = _checkChallengeCompletion(challenge, updatedCriteria);
    
    final updatedChallenge = challenge.copyWith(
      criteria: updatedCriteria,
      status: isCompleted ? ChallengeStatus.completed : challenge.status,
    );

    _activeChallenges[challengeIndex] = updatedChallenge;

    // إذا اكتمل التحدي، نقله إلى المكتملة
    if (isCompleted) {
      _activeChallenges.removeAt(challengeIndex);
      _completedChallenges.add(updatedChallenge);
      
      // إشعار بالإنجاز
      _notifyAchievement(updatedChallenge);
    }

    await _saveChallengesData();
    notifyListeners();
  }

  /// التحقق من اكتمال التحدي
  bool _checkChallengeCompletion(ChallengeModel challenge, Map<String, dynamic> criteria) {
    switch (challenge.id.split('_')[1]) {
      case 'explorer':
        return (criteria['currentCount'] ?? 0) >= (criteria['sportsToExplore'] ?? 0);
      case 'favorite':
        return (criteria['currentCount'] ?? 0) >= (criteria['favoritesToAdd'] ?? 0);
      case 'master':
        return (criteria['currentCount'] ?? 0) >= (criteria['sportsToExplore'] ?? 0);
      default:
        return false;
    }
  }

  /// إشعار بالإنجاز
  void _notifyAchievement(ChallengeModel challenge) {
    // سيتم استخدام نظام التغذية الراجعة التفاعلية
    debugPrint('Challenge completed: ${challenge.title}');
    // يمكن إضافة callback للواجهة هنا
    onChallengeCompleted?.call(challenge);
  }

  /// callback لإكمال التحدي
  Function(ChallengeModel)? onChallengeCompleted;

  /// حفظ بيانات التحديات
  Future<void> _saveChallengesData() async {
    try {
      // حفظ التحديات النشطة
      final challengesData = _allChallenges.map((c) => c.toJson()).toList();
      await _storageService.setJsonList(_challengesKey, challengesData);

      // حفظ التحديات المكتملة
      final completedData = _completedChallenges.map((c) => c.toJson()).toList();
      await _storageService.setJsonList(_completedChallengesKey, completedData);

      // حفظ التقدم اليومي
      await _storageService.setJson(_dailyProgressKey, _dailyProgress);
      
    } catch (e) {
      debugPrint('Error saving challenges data: $e');
    }
  }

  /// تسجيل استكشاف رياضة
  Future<void> recordSportExploration(String sportId) async {
    // تحديث التحديات المتعلقة بالاستكشاف
    for (var challenge in _activeChallenges) {
      if (challenge.id.contains('explorer') || challenge.id.contains('master')) {
        final currentCount = challenge.criteria['currentCount'] ?? 0;
        await updateChallengeProgress(challenge.id, {
          'currentCount': currentCount + 1,
        });
      }
    }
  }

  /// تسجيل إضافة مفضلة
  Future<void> recordFavoriteAdded(String sportId) async {
    // تحديث التحديات المتعلقة بالمفضلات
    for (var challenge in _activeChallenges) {
      if (challenge.id.contains('favorite')) {
        final currentCount = challenge.criteria['currentCount'] ?? 0;
        await updateChallengeProgress(challenge.id, {
          'currentCount': currentCount + 1,
        });
      }
    }
  }

  /// إعادة تعيين التحديات اليومية
  Future<void> resetDailyChallenges() async {
    final today = DateTime.now();
    final todayKey = '${today.year}-${today.month}-${today.day}';
    
    // التحقق من آخر إعادة تعيين
    if (_dailyProgress['lastReset'] == todayKey) return;

    // إزالة التحديات اليومية المنتهية الصلاحية
    _allChallenges.removeWhere((c) => 
      c.type == ChallengeType.daily && 
      today.isAfter(c.endDate)
    );

    // إنشاء تحديات يومية جديدة
    _generateDefaultChallenges();

    // تحديث التقدم اليومي
    _dailyProgress['lastReset'] = todayKey;
    
    await _saveChallengesData();
    notifyListeners();
  }

  /// الحصول على تحدي بالمعرف
  ChallengeModel? getChallengeById(String id) {
    try {
      return _allChallenges.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  /// إحصائيات التحديات
  Map<String, dynamic> getChallengeStats() {
    return {
      'totalChallenges': _allChallenges.length,
      'activeChallenges': _activeChallenges.length,
      'completedChallenges': _completedChallenges.length,
      'totalPointsEarned': totalPointsEarned,
      'todayCompleted': todayCompletedCount,
      'dailyChallenges': dailyChallenges.length,
      'weeklyChallenges': weeklyChallenges.length,
      'monthlyChallenges': monthlyChallenges.length,
    };
  }

  /// تصدير بيانات التحديات
  Map<String, dynamic> exportChallengesData() {
    return {
      'allChallenges': _allChallenges.map((c) => c.toJson()).toList(),
      'completedChallenges': _completedChallenges.map((c) => c.toJson()).toList(),
      'dailyProgress': _dailyProgress,
      'exportDate': DateTime.now().toIso8601String(),
    };
  }
}
