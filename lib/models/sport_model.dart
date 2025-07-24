import 'package:flutter/material.dart';

/// نموذج الرياضة الأساسي (Sport Model)
/// يحتوي على جميع المعلومات المتعلقة بالرياضة
class SportModel {
  final String id;
  final String name;
  final String nameAr;
  final String description;
  final String descriptionAr;
  final IconData icon;
  final SportCategory category;
  final SportColors colors;
  final List<String> rules;
  final List<String> equipment;
  final int difficulty; // 1-5
  final bool isPopularInMorocco;
  final List<String> benefits;
  final String history;
  final List<Achievement> relatedAchievements;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SportModel({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.description,
    required this.descriptionAr,
    required this.icon,
    required this.category,
    required this.colors,
    this.rules = const [],
    this.equipment = const [],
    this.difficulty = 1,
    this.isPopularInMorocco = false,
    this.benefits = const [],
    this.history = '',
    this.relatedAchievements = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  /// إنشاء نسخة محدثة من النموذج
  SportModel copyWith({
    String? id,
    String? name,
    String? nameAr,
    String? description,
    String? descriptionAr,
    IconData? icon,
    SportCategory? category,
    SportColors? colors,
    List<String>? rules,
    List<String>? equipment,
    int? difficulty,
    bool? isPopularInMorocco,
    List<String>? benefits,
    String? history,
    List<Achievement>? relatedAchievements,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SportModel(
      id: id ?? this.id,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      description: description ?? this.description,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      icon: icon ?? this.icon,
      category: category ?? this.category,
      colors: colors ?? this.colors,
      rules: rules ?? this.rules,
      equipment: equipment ?? this.equipment,
      difficulty: difficulty ?? this.difficulty,
      isPopularInMorocco: isPopularInMorocco ?? this.isPopularInMorocco,
      benefits: benefits ?? this.benefits,
      history: history ?? this.history,
      relatedAchievements: relatedAchievements ?? this.relatedAchievements,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// تحويل إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nameAr': nameAr,
      'description': description,
      'descriptionAr': descriptionAr,
      'icon': icon.codePoint,
      'category': category.name,
      'colors': colors.toJson(),
      'rules': rules,
      'equipment': equipment,
      'difficulty': difficulty,
      'isPopularInMorocco': isPopularInMorocco,
      'benefits': benefits,
      'history': history,
      'relatedAchievements': relatedAchievements.map((a) => a.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// إنشاء من JSON
  factory SportModel.fromJson(Map<String, dynamic> json) {
    return SportModel(
      id: json['id'],
      name: json['name'],
      nameAr: json['nameAr'],
      description: json['description'],
      descriptionAr: json['descriptionAr'],
      icon: IconData(json['icon'], fontFamily: 'MaterialIcons'),
      category: SportCategory.values.firstWhere((c) => c.name == json['category']),
      colors: SportColors.fromJson(json['colors']),
      rules: List<String>.from(json['rules'] ?? []),
      equipment: List<String>.from(json['equipment'] ?? []),
      difficulty: json['difficulty'] ?? 1,
      isPopularInMorocco: json['isPopularInMorocco'] ?? false,
      benefits: List<String>.from(json['benefits'] ?? []),
      history: json['history'] ?? '',
      relatedAchievements: (json['relatedAchievements'] as List?)
          ?.map((a) => Achievement.fromJson(a))
          .toList() ?? [],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SportModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'SportModel(id: $id, name: $name, category: $category)';
}

/// تصنيفات الرياضة (Sport Categories)
enum SportCategory {
  individual('Individual', 'فردية'),
  team('Team', 'جماعية'),
  moroccan('Moroccan Popular', 'شعبية مغربية'),
  combat('Combat', 'قتالية'),
  water('Water Sports', 'رياضات مائية'),
  extreme('Extreme Sports', 'رياضات متطرفة');

  const SportCategory(this.nameEn, this.nameAr);
  final String nameEn;
  final String nameAr;
}

/// ألوان الرياضة (Sport Colors)
class SportColors {
  final Color primary;
  final Color secondary;
  final Color accent;
  final Color background;

  const SportColors({
    required this.primary,
    required this.secondary,
    required this.accent,
    required this.background,
  });

  /// تحويل إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'primary': primary.value,
      'secondary': secondary.value,
      'accent': accent.value,
      'background': background.value,
    };
  }

  /// إنشاء من JSON
  factory SportColors.fromJson(Map<String, dynamic> json) {
    return SportColors(
      primary: Color(json['primary']),
      secondary: Color(json['secondary']),
      accent: Color(json['accent']),
      background: Color(json['background']),
    );
  }

  /// ألوان افتراضية
  static const SportColors defaultBlue = SportColors(
    primary: Color(0xFF1565C0),
    secondary: Color(0xFF42A5F5),
    accent: Color(0xFF2196F3),
    background: Color(0xFFE3F2FD),
  );
}

/// نموذج الإنجاز (Achievement Model)
class Achievement {
  final String id;
  final String title;
  final String titleAr;
  final String description;
  final String descriptionAr;
  final IconData icon;
  final Color color;
  final int points;
  final AchievementType type;
  final Map<String, dynamic> criteria;
  final bool isUnlocked;
  final DateTime? unlockedAt;

  const Achievement({
    required this.id,
    required this.title,
    required this.titleAr,
    required this.description,
    required this.descriptionAr,
    required this.icon,
    required this.color,
    required this.points,
    required this.type,
    required this.criteria,
    this.isUnlocked = false,
    this.unlockedAt,
  });

  /// تحويل إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'titleAr': titleAr,
      'description': description,
      'descriptionAr': descriptionAr,
      'icon': icon.codePoint,
      'color': color.value,
      'points': points,
      'type': type.name,
      'criteria': criteria,
      'isUnlocked': isUnlocked,
      'unlockedAt': unlockedAt?.toIso8601String(),
    };
  }

  /// إنشاء من JSON
  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'],
      title: json['title'],
      titleAr: json['titleAr'],
      description: json['description'],
      descriptionAr: json['descriptionAr'],
      icon: IconData(json['icon'], fontFamily: 'MaterialIcons'),
      color: Color(json['color']),
      points: json['points'],
      type: AchievementType.values.firstWhere((t) => t.name == json['type']),
      criteria: json['criteria'],
      isUnlocked: json['isUnlocked'] ?? false,
      unlockedAt: json['unlockedAt'] != null 
          ? DateTime.parse(json['unlockedAt']) 
          : null,
    );
  }
}

/// أنواع الإنجازات (Achievement Types)
enum AchievementType {
  exploration('Exploration', 'استكشاف'),
  knowledge('Knowledge', 'معرفة'),
  engagement('Engagement', 'تفاعل'),
  milestone('Milestone', 'إنجاز'),
  special('Special', 'خاص');

  const AchievementType(this.nameEn, this.nameAr);
  final String nameEn;
  final String nameAr;
}
