import 'package:flutter/material.dart';
import 'sport_model.dart';

/// نموذج المستخدم (User Model)
/// يحتوي على جميع بيانات المستخدم وتفضيلاته
class UserModel {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final UserPreferences preferences;
  final UserStats stats;
  final List<String> favoriteSports;
  final List<Achievement> unlockedAchievements;
  final int totalPoints;
  final UserLevel level;
  final DateTime createdAt;
  final DateTime lastActiveAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    required this.preferences,
    required this.stats,
    this.favoriteSports = const [],
    this.unlockedAchievements = const [],
    this.totalPoints = 0,
    required this.level,
    required this.createdAt,
    required this.lastActiveAt,
  });

  /// إنشاء نسخة محدثة من النموذج
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarUrl,
    UserPreferences? preferences,
    UserStats? stats,
    List<String>? favoriteSports,
    List<Achievement>? unlockedAchievements,
    int? totalPoints,
    UserLevel? level,
    DateTime? createdAt,
    DateTime? lastActiveAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      preferences: preferences ?? this.preferences,
      stats: stats ?? this.stats,
      favoriteSports: favoriteSports ?? this.favoriteSports,
      unlockedAchievements: unlockedAchievements ?? this.unlockedAchievements,
      totalPoints: totalPoints ?? this.totalPoints,
      level: level ?? this.level,
      createdAt: createdAt ?? this.createdAt,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
    );
  }

  /// تحويل إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'preferences': preferences.toJson(),
      'stats': stats.toJson(),
      'favoriteSports': favoriteSports,
      'unlockedAchievements': unlockedAchievements.map((a) => a.toJson()).toList(),
      'totalPoints': totalPoints,
      'level': level.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'lastActiveAt': lastActiveAt.toIso8601String(),
    };
  }

  /// إنشاء من JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      avatarUrl: json['avatarUrl'],
      preferences: UserPreferences.fromJson(json['preferences']),
      stats: UserStats.fromJson(json['stats']),
      favoriteSports: List<String>.from(json['favoriteSports'] ?? []),
      unlockedAchievements: (json['unlockedAchievements'] as List?)
          ?.map((a) => Achievement.fromJson(a))
          .toList() ?? [],
      totalPoints: json['totalPoints'] ?? 0,
      level: UserLevel.fromJson(json['level']),
      createdAt: DateTime.parse(json['createdAt']),
      lastActiveAt: DateTime.parse(json['lastActiveAt']),
    );
  }

  /// إنشاء مستخدم افتراضي
  factory UserModel.defaultUser() {
    final now = DateTime.now();
    return UserModel(
      id: 'default_user',
      name: 'مستخدم جديد',
      email: 'user@example.com',
      preferences: UserPreferences.defaultPreferences(),
      stats: UserStats.initial(),
      level: UserLevel.beginner(),
      createdAt: now,
      lastActiveAt: now,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// تفضيلات المستخدم (User Preferences)
class UserPreferences {
  final Locale language;
  final ThemeMode themeMode;
  final bool notificationsEnabled;
  final bool soundEnabled;
  final List<SportCategory> preferredCategories;
  final int difficultyPreference; // 1-5
  final bool showArabicNames;

  const UserPreferences({
    required this.language,
    required this.themeMode,
    this.notificationsEnabled = true,
    this.soundEnabled = true,
    this.preferredCategories = const [],
    this.difficultyPreference = 3,
    this.showArabicNames = false,
  });

  /// إنشاء نسخة محدثة
  UserPreferences copyWith({
    Locale? language,
    ThemeMode? themeMode,
    bool? notificationsEnabled,
    bool? soundEnabled,
    List<SportCategory>? preferredCategories,
    int? difficultyPreference,
    bool? showArabicNames,
  }) {
    return UserPreferences(
      language: language ?? this.language,
      themeMode: themeMode ?? this.themeMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      preferredCategories: preferredCategories ?? this.preferredCategories,
      difficultyPreference: difficultyPreference ?? this.difficultyPreference,
      showArabicNames: showArabicNames ?? this.showArabicNames,
    );
  }

  /// تحويل إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'language': language.languageCode,
      'themeMode': themeMode.name,
      'notificationsEnabled': notificationsEnabled,
      'soundEnabled': soundEnabled,
      'preferredCategories': preferredCategories.map((c) => c.name).toList(),
      'difficultyPreference': difficultyPreference,
      'showArabicNames': showArabicNames,
    };
  }

  /// إنشاء من JSON
  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      language: Locale(json['language'] ?? 'en'),
      themeMode: ThemeMode.values.firstWhere(
        (t) => t.name == json['themeMode'],
        orElse: () => ThemeMode.light,
      ),
      notificationsEnabled: json['notificationsEnabled'] ?? true,
      soundEnabled: json['soundEnabled'] ?? true,
      preferredCategories: (json['preferredCategories'] as List?)
          ?.map((c) => SportCategory.values.firstWhere((cat) => cat.name == c))
          .toList() ?? [],
      difficultyPreference: json['difficultyPreference'] ?? 3,
      showArabicNames: json['showArabicNames'] ?? false,
    );
  }

  /// تفضيلات افتراضية
  factory UserPreferences.defaultPreferences() {
    return const UserPreferences(
      language: Locale('ar'),
      themeMode: ThemeMode.light,
      notificationsEnabled: true,
      soundEnabled: true,
      preferredCategories: [],
      difficultyPreference: 3,
      showArabicNames: true,
    );
  }
}

/// إحصائيات المستخدم (User Stats)
class UserStats {
  final int sportsExplored;
  final int achievementsUnlocked;
  final int daysActive;
  final int totalInteractions;
  final Map<String, int> categoryInteractions;
  final DateTime lastAchievementDate;

  const UserStats({
    this.sportsExplored = 0,
    this.achievementsUnlocked = 0,
    this.daysActive = 0,
    this.totalInteractions = 0,
    this.categoryInteractions = const {},
    required this.lastAchievementDate,
  });

  /// إنشاء نسخة محدثة
  UserStats copyWith({
    int? sportsExplored,
    int? achievementsUnlocked,
    int? daysActive,
    int? totalInteractions,
    Map<String, int>? categoryInteractions,
    DateTime? lastAchievementDate,
  }) {
    return UserStats(
      sportsExplored: sportsExplored ?? this.sportsExplored,
      achievementsUnlocked: achievementsUnlocked ?? this.achievementsUnlocked,
      daysActive: daysActive ?? this.daysActive,
      totalInteractions: totalInteractions ?? this.totalInteractions,
      categoryInteractions: categoryInteractions ?? this.categoryInteractions,
      lastAchievementDate: lastAchievementDate ?? this.lastAchievementDate,
    );
  }

  /// تحويل إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'sportsExplored': sportsExplored,
      'achievementsUnlocked': achievementsUnlocked,
      'daysActive': daysActive,
      'totalInteractions': totalInteractions,
      'categoryInteractions': categoryInteractions,
      'lastAchievementDate': lastAchievementDate.toIso8601String(),
    };
  }

  /// إنشاء من JSON
  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      sportsExplored: json['sportsExplored'] ?? 0,
      achievementsUnlocked: json['achievementsUnlocked'] ?? 0,
      daysActive: json['daysActive'] ?? 0,
      totalInteractions: json['totalInteractions'] ?? 0,
      categoryInteractions: Map<String, int>.from(json['categoryInteractions'] ?? {}),
      lastAchievementDate: DateTime.parse(json['lastAchievementDate']),
    );
  }

  /// إحصائيات أولية
  factory UserStats.initial() {
    return UserStats(
      lastAchievementDate: DateTime.now(),
    );
  }
}

/// مستوى المستخدم (User Level)
class UserLevel {
  final int level;
  final String title;
  final String titleAr;
  final int currentXP;
  final int requiredXP;
  final Color color;
  final IconData icon;

  const UserLevel({
    required this.level,
    required this.title,
    required this.titleAr,
    required this.currentXP,
    required this.requiredXP,
    required this.color,
    required this.icon,
  });

  /// نسبة التقدم
  double get progress => currentXP / requiredXP;

  /// تحويل إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'level': level,
      'title': title,
      'titleAr': titleAr,
      'currentXP': currentXP,
      'requiredXP': requiredXP,
      'color': color.value,
      'icon': icon.codePoint,
    };
  }

  /// إنشاء من JSON
  factory UserLevel.fromJson(Map<String, dynamic> json) {
    return UserLevel(
      level: json['level'],
      title: json['title'],
      titleAr: json['titleAr'],
      currentXP: json['currentXP'],
      requiredXP: json['requiredXP'],
      color: Color(json['color']),
      icon: IconData(json['icon'], fontFamily: 'MaterialIcons'),
    );
  }

  /// مستوى المبتدئ
  factory UserLevel.beginner() {
    return const UserLevel(
      level: 1,
      title: 'Beginner',
      titleAr: 'مبتدئ',
      currentXP: 0,
      requiredXP: 100,
      color: Color(0xFF4CAF50),
      icon: Icons.sports_rounded,
    );
  }
}
