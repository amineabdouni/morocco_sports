import 'package:flutter/material.dart';
import '../models/models.dart';

/// بيانات الرياضات (Sports Data)
/// يحتوي على جميع البيانات الثابتة للرياضات
class SportsData {
  
  /// الحصول على جميع الرياضات
  static List<SportModel> getAllSports() {
    return [
      ..._getIndividualSports(),
      ..._getTeamSports(),
      ..._getMoroccanSports(),
      ..._getCombatSports(),
      ..._getWaterSports(),
      ..._getExtremeSports(),
    ];
  }

  /// الرياضات الفردية
  static List<SportModel> _getIndividualSports() {
    final now = DateTime.now();
    
    return [
      SportModel(
        id: 'tennis',
        name: 'Tennis',
        nameAr: 'التنس',
        description: 'Individual racket sport played on a court',
        descriptionAr: 'رياضة فردية بالمضرب تُلعب على ملعب',
        icon: Icons.sports_tennis,
        category: SportCategory.individual,
        colors: const SportColors(
          primary: Color(0xFF4CAF50),
          secondary: Color(0xFF81C784),
          accent: Color(0xFF2E7D32),
          background: Color(0xFFE8F5E8),
        ),
        rules: [
          'Match consists of sets',
          'First to win 6 games wins a set',
          'Must win by 2 games',
          'Tiebreak at 6-6'
        ],
        equipment: ['Tennis racket', 'Tennis balls', 'Court', 'Net'],
        difficulty: 3,
        isPopularInMorocco: true,
        benefits: [
          'Improves hand-eye coordination',
          'Great cardiovascular workout',
          'Builds mental toughness',
          'Social sport'
        ],
        history: 'Tennis originated in France in the 12th century...',
        relatedAchievements: _getTennisAchievements(),
        createdAt: now,
        updatedAt: now,
      ),
      
      SportModel(
        id: 'swimming',
        name: 'Swimming',
        nameAr: 'السباحة',
        description: 'Water-based individual sport',
        descriptionAr: 'رياضة فردية مائية',
        icon: Icons.pool,
        category: SportCategory.individual,
        colors: const SportColors(
          primary: Color(0xFF2196F3),
          secondary: Color(0xFF64B5F6),
          accent: Color(0xFF1976D2),
          background: Color(0xFFE3F2FD),
        ),
        rules: [
          'Different strokes: freestyle, backstroke, breaststroke, butterfly',
          'No touching pool bottom during race',
          'Proper turns at pool walls',
          'False start disqualification'
        ],
        equipment: ['Swimming pool', 'Swimsuit', 'Goggles', 'Swimming cap'],
        difficulty: 2,
        isPopularInMorocco: true,
        benefits: [
          'Full body workout',
          'Low impact exercise',
          'Improves lung capacity',
          'Builds endurance'
        ],
        history: 'Swimming has been practiced since prehistoric times...',
        relatedAchievements: _getSwimmingAchievements(),
        createdAt: now,
        updatedAt: now,
      ),

      SportModel(
        id: 'athletics',
        name: 'Athletics',
        nameAr: 'ألعاب القوى',
        description: 'Track and field events',
        descriptionAr: 'مسابقات الجري والقفز والرمي',
        icon: Icons.directions_run,
        category: SportCategory.individual,
        colors: const SportColors(
          primary: Color(0xFFFF9800),
          secondary: Color(0xFFFFB74D),
          accent: Color(0xFFF57C00),
          background: Color(0xFFFFF3E0),
        ),
        rules: [
          'Various events: running, jumping, throwing',
          'Specific rules for each event',
          'Olympic standard measurements',
          'Drug testing required'
        ],
        equipment: ['Track', 'Starting blocks', 'Javelins', 'Shot put', 'High jump bar'],
        difficulty: 4,
        isPopularInMorocco: true,
        benefits: [
          'Builds speed and power',
          'Improves coordination',
          'Develops discipline',
          'Competitive spirit'
        ],
        history: 'Athletics is one of the oldest sports...',
        relatedAchievements: _getAthleticsAchievements(),
        createdAt: now,
        updatedAt: now,
      ),

      SportModel(
        id: 'cycling',
        name: 'Cycling',
        nameAr: 'ركوب الدراجات',
        description: 'Bicycle racing and recreational riding',
        descriptionAr: 'سباق الدراجات والركوب الترفيهي',
        icon: Icons.directions_bike,
        category: SportCategory.individual,
        colors: const SportColors(
          primary: Color(0xFF795548),
          secondary: Color(0xFFA1887F),
          accent: Color(0xFF5D4037),
          background: Color(0xFFEFEBE9),
        ),
        difficulty: 3,
        isPopularInMorocco: false,
        createdAt: now,
        updatedAt: now,
      ),

      SportModel(
        id: 'golf',
        name: 'Golf',
        nameAr: 'الجولف',
        description: 'Precision club sport',
        descriptionAr: 'رياضة دقة بالعصا',
        icon: Icons.sports_golf,
        category: SportCategory.individual,
        colors: const SportColors(
          primary: Color(0xFF4CAF50),
          secondary: Color(0xFF81C784),
          accent: Color(0xFF388E3C),
          background: Color(0xFFE8F5E8),
        ),
        difficulty: 4,
        isPopularInMorocco: false,
        createdAt: now,
        updatedAt: now,
      ),
    ];
  }

  /// الرياضات الجماعية
  static List<SportModel> _getTeamSports() {
    final now = DateTime.now();
    
    return [
      SportModel(
        id: 'football',
        name: 'Football',
        nameAr: 'كرة القدم',
        description: 'Most popular team sport worldwide',
        descriptionAr: 'أشهر رياضة جماعية في العالم',
        icon: Icons.sports_soccer,
        category: SportCategory.team,
        colors: const SportColors(
          primary: Color(0xFF4CAF50),
          secondary: Color(0xFF81C784),
          accent: Color(0xFF2E7D32),
          background: Color(0xFFE8F5E8),
        ),
        rules: [
          '11 players per team',
          '90 minutes game time',
          'No hands except goalkeeper',
          'Offside rule applies'
        ],
        equipment: ['Football', 'Goals', 'Field', 'Jerseys'],
        difficulty: 2,
        isPopularInMorocco: true,
        benefits: [
          'Teamwork skills',
          'Cardiovascular fitness',
          'Leg strength',
          'Strategic thinking'
        ],
        history: 'Modern football originated in England...',
        relatedAchievements: _getFootballAchievements(),
        createdAt: now,
        updatedAt: now,
      ),

      SportModel(
        id: 'basketball',
        name: 'Basketball',
        nameAr: 'كرة السلة',
        description: '5v5 court sport with hoops',
        descriptionAr: 'رياضة ملعب 5 ضد 5 بالأطواق',
        icon: Icons.sports_basketball,
        category: SportCategory.team,
        colors: const SportColors(
          primary: Color(0xFFFF9800),
          secondary: Color(0xFFFFB74D),
          accent: Color(0xFFF57C00),
          background: Color(0xFFFFF3E0),
        ),
        difficulty: 3,
        isPopularInMorocco: true,
        createdAt: now,
        updatedAt: now,
      ),

      SportModel(
        id: 'volleyball',
        name: 'Volleyball',
        nameAr: 'الكرة الطائرة',
        description: 'Net-based team sport',
        descriptionAr: 'رياضة جماعية بالشبكة',
        icon: Icons.sports_volleyball,
        category: SportCategory.team,
        colors: const SportColors(
          primary: Color(0xFF2196F3),
          secondary: Color(0xFF64B5F6),
          accent: Color(0xFF1976D2),
          background: Color(0xFFE3F2FD),
        ),
        difficulty: 3,
        isPopularInMorocco: false,
        createdAt: now,
        updatedAt: now,
      ),
    ];
  }

  /// الرياضات المغربية الشعبية
  static List<SportModel> _getMoroccanSports() {
    final now = DateTime.now();
    
    return [
      SportModel(
        id: 'moroccan_football',
        name: 'Moroccan Football',
        nameAr: 'كرة القدم المغربية',
        description: 'Football with Moroccan passion and style',
        descriptionAr: 'كرة القدم بالشغف والأسلوب المغربي',
        icon: Icons.sports_soccer,
        category: SportCategory.moroccan,
        colors: const SportColors(
          primary: Color(0xFFD32F2F),
          secondary: Color(0xFFEF5350),
          accent: Color(0xFFB71C1C),
          background: Color(0xFFFFEBEE),
        ),
        difficulty: 2,
        isPopularInMorocco: true,
        createdAt: now,
        updatedAt: now,
      ),
    ];
  }

  /// الرياضات القتالية
  static List<SportModel> _getCombatSports() {
    final now = DateTime.now();
    
    return [
      SportModel(
        id: 'boxing',
        name: 'Boxing',
        nameAr: 'الملاكمة',
        description: 'Combat sport with gloves',
        descriptionAr: 'رياضة قتالية بالقفازات',
        icon: Icons.sports_mma,
        category: SportCategory.combat,
        colors: const SportColors(
          primary: Color(0xFFD32F2F),
          secondary: Color(0xFFEF5350),
          accent: Color(0xFFB71C1C),
          background: Color(0xFFFFEBEE),
        ),
        difficulty: 4,
        isPopularInMorocco: true,
        createdAt: now,
        updatedAt: now,
      ),
    ];
  }

  /// الرياضات المائية
  static List<SportModel> _getWaterSports() {
    return []; // سيتم إضافتها لاحقاً
  }

  /// الرياضات المتطرفة
  static List<SportModel> _getExtremeSports() {
    return []; // سيتم إضافتها لاحقاً
  }

  // إنجازات التنس
  static List<Achievement> _getTennisAchievements() {
    return [
      Achievement(
        id: 'tennis_explorer',
        title: 'Tennis Explorer',
        titleAr: 'مستكشف التنس',
        description: 'Explored tennis for the first time',
        descriptionAr: 'استكشف التنس لأول مرة',
        icon: Icons.sports_tennis,
        color: const Color(0xFF4CAF50),
        points: 10,
        type: AchievementType.exploration,
        criteria: {'sport': 'tennis', 'action': 'view'},
      ),
    ];
  }

  // إنجازات السباحة
  static List<Achievement> _getSwimmingAchievements() {
    return [
      Achievement(
        id: 'swimming_explorer',
        title: 'Swimming Explorer',
        titleAr: 'مستكشف السباحة',
        description: 'Explored swimming for the first time',
        descriptionAr: 'استكشف السباحة لأول مرة',
        icon: Icons.pool,
        color: const Color(0xFF2196F3),
        points: 10,
        type: AchievementType.exploration,
        criteria: {'sport': 'swimming', 'action': 'view'},
      ),
    ];
  }

  // إنجازات ألعاب القوى
  static List<Achievement> _getAthleticsAchievements() {
    return [
      Achievement(
        id: 'athletics_explorer',
        title: 'Athletics Explorer',
        titleAr: 'مستكشف ألعاب القوى',
        description: 'Explored athletics for the first time',
        descriptionAr: 'استكشف ألعاب القوى لأول مرة',
        icon: Icons.directions_run,
        color: const Color(0xFFFF9800),
        points: 10,
        type: AchievementType.exploration,
        criteria: {'sport': 'athletics', 'action': 'view'},
      ),
    ];
  }

  // إنجازات كرة القدم
  static List<Achievement> _getFootballAchievements() {
    return [
      Achievement(
        id: 'football_explorer',
        title: 'Football Explorer',
        titleAr: 'مستكشف كرة القدم',
        description: 'Explored football for the first time',
        descriptionAr: 'استكشف كرة القدم لأول مرة',
        icon: Icons.sports_soccer,
        color: const Color(0xFF4CAF50),
        points: 10,
        type: AchievementType.exploration,
        criteria: {'sport': 'football', 'action': 'view'},
      ),
    ];
  }

  /// الحصول على رياضة بالمعرف
  static SportModel? getSportById(String id) {
    try {
      return getAllSports().firstWhere((sport) => sport.id == id);
    } catch (e) {
      return null;
    }
  }

  /// الحصول على الرياضات حسب التصنيف
  static List<SportModel> getSportsByCategory(SportCategory category) {
    return getAllSports().where((sport) => sport.category == category).toList();
  }

  /// الحصول على الرياضات الشائعة في المغرب
  static List<SportModel> getPopularInMorocco() {
    return getAllSports().where((sport) => sport.isPopularInMorocco).toList();
  }

  /// البحث في الرياضات
  static List<SportModel> searchSports(String query) {
    if (query.isEmpty) return getAllSports();
    
    final lowerQuery = query.toLowerCase();
    return getAllSports().where((sport) {
      return sport.name.toLowerCase().contains(lowerQuery) ||
             sport.nameAr.contains(query) ||
             sport.description.toLowerCase().contains(lowerQuery) ||
             sport.descriptionAr.contains(query);
    }).toList();
  }
}
