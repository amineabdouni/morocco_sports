import 'dart:math';
import '../models/models.dart';

/// محرك التوصيات الذكي (Smart Recommendation Engine)
/// يحلل سلوك المستخدم ويقدم توصيات مخصصة
class RecommendationEngine {
  static const double _categoryWeight = 0.4;
  static const double _difficultyWeight = 0.3;
  static const double _popularityWeight = 0.2;
  static const double _historyWeight = 0.1;

  /// الحصول على توصيات مخصصة للمستخدم
  static List<SportModel> getPersonalizedRecommendations({
    required List<SportModel> allSports,
    required UserModel user,
    required List<String> viewedSports,
    required List<String> favoriteSports,
    int limit = 10,
  }) {
    // حساب نقاط التوصية لكل رياضة
    final sportScores = <String, double>{};
    
    for (final sport in allSports) {
      double score = 0.0;
      
      // نقاط التصنيف المفضل
      score += _calculateCategoryScore(sport, user.preferences.preferredCategories);
      
      // نقاط الصعوبة المناسبة
      score += _calculateDifficultyScore(sport, user.preferences.difficultyPreference);
      
      // نقاط الشعبية
      score += _calculatePopularityScore(sport);
      
      // نقاط التاريخ (تقليل النقاط للرياضات المشاهدة مؤخراً)
      score += _calculateHistoryScore(sport.id, viewedSports, favoriteSports);
      
      // نقاط إضافية للرياضات المغربية إذا كان المستخدم مهتماً
      if (sport.isPopularInMorocco && _isInterestedInMoroccanSports(user)) {
        score += 0.2;
      }
      
      sportScores[sport.id] = score;
    }
    
    // ترتيب الرياضات حسب النقاط
    final sortedSports = allSports.toList()
      ..sort((a, b) => sportScores[b.id]!.compareTo(sportScores[a.id]!));
    
    return sortedSports.take(limit).toList();
  }

  /// حساب نقاط التصنيف
  static double _calculateCategoryScore(
    SportModel sport,
    List<SportCategory> preferredCategories,
  ) {
    if (preferredCategories.isEmpty) return 0.0;
    
    final isPreferred = preferredCategories.contains(sport.category);
    return isPreferred ? _categoryWeight : 0.0;
  }

  /// حساب نقاط الصعوبة
  static double _calculateDifficultyScore(
    SportModel sport,
    int preferredDifficulty,
  ) {
    final difficultyDifference = (sport.difficulty - preferredDifficulty).abs();
    final normalizedScore = max(0, 5 - difficultyDifference) / 5.0;
    return normalizedScore * _difficultyWeight;
  }

  /// حساب نقاط الشعبية
  static double _calculatePopularityScore(SportModel sport) {
    // الرياضات الشائعة في المغرب تحصل على نقاط إضافية
    return sport.isPopularInMorocco ? _popularityWeight : _popularityWeight * 0.5;
  }

  /// حساب نقاط التاريخ
  static double _calculateHistoryScore(
    String sportId,
    List<String> viewedSports,
    List<String> favoriteSports,
  ) {
    double score = 0.0;
    
    // تقليل النقاط للرياضات المشاهدة مؤخراً
    final viewIndex = viewedSports.indexOf(sportId);
    if (viewIndex != -1) {
      // كلما كانت الرياضة أحدث في التاريخ، كلما قلت النقاط
      final recencyPenalty = (viewIndex + 1) / viewedSports.length;
      score -= _historyWeight * recencyPenalty;
    }
    
    // زيادة النقاط للرياضات المشابهة للمفضلة
    if (favoriteSports.isNotEmpty) {
      // هذا يتطلب تحليل أعمق للتشابه
      score += _calculateSimilarityBonus(sportId, favoriteSports);
    }
    
    return score;
  }

  /// حساب مكافأة التشابه
  static double _calculateSimilarityBonus(
    String sportId,
    List<String> favoriteSports,
  ) {
    // تنفيذ بسيط - يمكن تحسينه لاحقاً
    return favoriteSports.contains(sportId) ? 0.1 : 0.0;
  }

  /// التحقق من الاهتمام بالرياضات المغربية
  static bool _isInterestedInMoroccanSports(UserModel user) {
    return user.preferences.preferredCategories.contains(SportCategory.moroccan) ||
           user.favoriteSports.any((id) => id.contains('moroccan'));
  }

  /// الحصول على رياضات مقترحة بناءً على رياضة معينة
  static List<SportModel> getSimilarSports({
    required SportModel baseSport,
    required List<SportModel> allSports,
    int limit = 5,
  }) {
    final similarSports = <SportModel>[];
    
    for (final sport in allSports) {
      if (sport.id == baseSport.id) continue;
      
      double similarity = 0.0;
      
      // تشابه التصنيف
      if (sport.category == baseSport.category) {
        similarity += 0.5;
      }
      
      // تشابه الصعوبة
      final difficultyDiff = (sport.difficulty - baseSport.difficulty).abs();
      similarity += (5 - difficultyDiff) / 5.0 * 0.3;
      
      // تشابه الشعبية في المغرب
      if (sport.isPopularInMorocco == baseSport.isPopularInMorocco) {
        similarity += 0.2;
      }
      
      if (similarity > 0.3) {
        similarSports.add(sport);
      }
    }
    
    // ترتيب حسب التشابه
    similarSports.sort((a, b) {
      final aScore = _calculateSimilarityScore(a, baseSport);
      final bScore = _calculateSimilarityScore(b, baseSport);
      return bScore.compareTo(aScore);
    });
    
    return similarSports.take(limit).toList();
  }

  /// حساب نقاط التشابه
  static double _calculateSimilarityScore(SportModel sport, SportModel baseSport) {
    double score = 0.0;
    
    if (sport.category == baseSport.category) score += 0.5;
    
    final difficultyDiff = (sport.difficulty - baseSport.difficulty).abs();
    score += (5 - difficultyDiff) / 5.0 * 0.3;
    
    if (sport.isPopularInMorocco == baseSport.isPopularInMorocco) score += 0.2;
    
    return score;
  }

  /// الحصول على اتجاهات الاستخدام
  static Map<String, dynamic> getUsageTrends({
    required List<String> viewedSports,
    required List<String> favoriteSports,
    required Map<String, int> categoryInteractions,
  }) {
    // تحليل الأنماط
    final trends = <String, dynamic>{};
    
    // التصنيف الأكثر استخداماً
    if (categoryInteractions.isNotEmpty) {
      final mostUsedCategory = categoryInteractions.entries
          .reduce((a, b) => a.value > b.value ? a : b);
      trends['mostUsedCategory'] = mostUsedCategory.key;
      trends['mostUsedCategoryCount'] = mostUsedCategory.value;
    }
    
    // معدل الاستكشاف
    trends['explorationRate'] = viewedSports.length;
    trends['favoriteRate'] = favoriteSports.length;
    trends['conversionRate'] = viewedSports.isNotEmpty 
        ? favoriteSports.length / viewedSports.length 
        : 0.0;
    
    // اقتراحات للتحسين
    trends['suggestions'] = _generateImprovementSuggestions(
      viewedSports.length,
      favoriteSports.length,
      categoryInteractions,
    );
    
    return trends;
  }

  /// إنتاج اقتراحات للتحسين
  static List<String> _generateImprovementSuggestions(
    int viewedCount,
    int favoriteCount,
    Map<String, int> categoryInteractions,
  ) {
    final suggestions = <String>[];
    
    if (viewedCount < 5) {
      suggestions.add('جرب استكشاف المزيد من الرياضات');
    }
    
    if (favoriteCount == 0) {
      suggestions.add('أضف بعض الرياضات إلى مفضلاتك');
    }
    
    if (categoryInteractions.length < 3) {
      suggestions.add('استكشف تصنيفات رياضية جديدة');
    }
    
    final totalInteractions = categoryInteractions.values.fold(0, (a, b) => a + b);
    if (totalInteractions > 20) {
      suggestions.add('أنت مستخدم نشط! جرب التحديات المتقدمة');
    }
    
    return suggestions;
  }

  /// الحصول على توصيات للتحديات
  static List<String> getChallengeRecommendations({
    required UserModel user,
    required List<String> completedChallenges,
  }) {
    final recommendations = <String>[];
    
    // بناءً على مستوى المستخدم
    if (user.level.level < 5) {
      recommendations.add('ابدأ بالتحديات اليومية السهلة');
    } else if (user.level.level < 15) {
      recommendations.add('جرب التحديات الأسبوعية');
    } else {
      recommendations.add('أنت جاهز للتحديات الشهرية!');
    }
    
    // بناءً على الاهتمامات
    if (user.preferences.preferredCategories.isNotEmpty) {
      final category = user.preferences.preferredCategories.first;
      recommendations.add('تحديات خاصة بـ${category.nameAr}');
    }
    
    return recommendations;
  }

  /// تحليل أداء المستخدم
  static Map<String, dynamic> analyzeUserPerformance(UserModel user) {
    final analysis = <String, dynamic>{};
    
    // تحليل النشاط
    final daysActive = user.stats.daysActive;
    if (daysActive > 30) {
      analysis['activityLevel'] = 'عالي';
    } else if (daysActive > 7) {
      analysis['activityLevel'] = 'متوسط';
    } else {
      analysis['activityLevel'] = 'منخفض';
    }
    
    // تحليل التقدم
    final achievementRate = user.stats.achievementsUnlocked / max(1, user.stats.sportsExplored);
    analysis['achievementRate'] = achievementRate;
    
    if (achievementRate > 0.5) {
      analysis['performanceLevel'] = 'ممتاز';
    } else if (achievementRate > 0.3) {
      analysis['performanceLevel'] = 'جيد';
    } else {
      analysis['performanceLevel'] = 'يحتاج تحسين';
    }
    
    // اقتراحات شخصية
    analysis['personalSuggestions'] = _generatePersonalSuggestions(user);
    
    return analysis;
  }

  /// إنتاج اقتراحات شخصية
  static List<String> _generatePersonalSuggestions(UserModel user) {
    final suggestions = <String>[];
    
    if (user.stats.sportsExplored < 10) {
      suggestions.add('استكشف المزيد من الرياضات لفتح إنجازات جديدة');
    }
    
    if (user.favoriteSports.length < 3) {
      suggestions.add('أضف المزيد من الرياضات لمفضلاتك');
    }
    
    if (user.level.level < 10) {
      suggestions.add('شارك في التحديات اليومية لرفع مستواك');
    }
    
    final daysSinceLastAchievement = DateTime.now()
        .difference(user.stats.lastAchievementDate)
        .inDays;
    
    if (daysSinceLastAchievement > 7) {
      suggestions.add('حان وقت إنجاز جديد! جرب تحدياً صعباً');
    }
    
    return suggestions;
  }
}
