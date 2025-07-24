import 'package:flutter/material.dart';
import 'sport_model.dart';

/// نموذج التحدي (Challenge Model)
/// يمثل التحديات الرياضية التفاعلية
class ChallengeModel {
  final String id;
  final String title;
  final String titleAr;
  final String description;
  final String descriptionAr;
  final IconData icon;
  final Color color;
  final ChallengeType type;
  final ChallengeDifficulty difficulty;
  final int points;
  final Duration duration;
  final List<String> relatedSports;
  final Map<String, dynamic> criteria;
  final ChallengeStatus status;
  final DateTime startDate;
  final DateTime endDate;
  final int participantsCount;
  final List<ChallengeStep> steps;
  final ChallengeReward reward;

  const ChallengeModel({
    required this.id,
    required this.title,
    required this.titleAr,
    required this.description,
    required this.descriptionAr,
    required this.icon,
    required this.color,
    required this.type,
    required this.difficulty,
    required this.points,
    required this.duration,
    this.relatedSports = const [],
    this.criteria = const {},
    required this.status,
    required this.startDate,
    required this.endDate,
    this.participantsCount = 0,
    this.steps = const [],
    required this.reward,
  });

  /// إنشاء نسخة محدثة
  ChallengeModel copyWith({
    String? id,
    String? title,
    String? titleAr,
    String? description,
    String? descriptionAr,
    IconData? icon,
    Color? color,
    ChallengeType? type,
    ChallengeDifficulty? difficulty,
    int? points,
    Duration? duration,
    List<String>? relatedSports,
    Map<String, dynamic>? criteria,
    ChallengeStatus? status,
    DateTime? startDate,
    DateTime? endDate,
    int? participantsCount,
    List<ChallengeStep>? steps,
    ChallengeReward? reward,
  }) {
    return ChallengeModel(
      id: id ?? this.id,
      title: title ?? this.title,
      titleAr: titleAr ?? this.titleAr,
      description: description ?? this.description,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      type: type ?? this.type,
      difficulty: difficulty ?? this.difficulty,
      points: points ?? this.points,
      duration: duration ?? this.duration,
      relatedSports: relatedSports ?? this.relatedSports,
      criteria: criteria ?? this.criteria,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      participantsCount: participantsCount ?? this.participantsCount,
      steps: steps ?? this.steps,
      reward: reward ?? this.reward,
    );
  }

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
      'type': type.name,
      'difficulty': difficulty.name,
      'points': points,
      'duration': duration.inMinutes,
      'relatedSports': relatedSports,
      'criteria': criteria,
      'status': status.name,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'participantsCount': participantsCount,
      'steps': steps.map((s) => s.toJson()).toList(),
      'reward': reward.toJson(),
    };
  }

  /// إنشاء من JSON
  factory ChallengeModel.fromJson(Map<String, dynamic> json) {
    return ChallengeModel(
      id: json['id'],
      title: json['title'],
      titleAr: json['titleAr'],
      description: json['description'],
      descriptionAr: json['descriptionAr'],
      icon: IconData(json['icon'], fontFamily: 'MaterialIcons'),
      color: Color(json['color']),
      type: ChallengeType.values.firstWhere((t) => t.name == json['type']),
      difficulty: ChallengeDifficulty.values.firstWhere((d) => d.name == json['difficulty']),
      points: json['points'],
      duration: Duration(minutes: json['duration']),
      relatedSports: List<String>.from(json['relatedSports'] ?? []),
      criteria: json['criteria'] ?? {},
      status: ChallengeStatus.values.firstWhere((s) => s.name == json['status']),
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      participantsCount: json['participantsCount'] ?? 0,
      steps: (json['steps'] as List?)
          ?.map((s) => ChallengeStep.fromJson(s))
          .toList() ?? [],
      reward: ChallengeReward.fromJson(json['reward']),
    );
  }

  /// هل التحدي نشط؟
  bool get isActive => status == ChallengeStatus.active;

  /// هل التحدي مكتمل؟
  bool get isCompleted => status == ChallengeStatus.completed;

  /// الوقت المتبقي
  Duration get timeRemaining {
    final now = DateTime.now();
    if (now.isAfter(endDate)) return Duration.zero;
    return endDate.difference(now);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChallengeModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// أنواع التحديات (Challenge Types)
enum ChallengeType {
  daily('Daily', 'يومي'),
  weekly('Weekly', 'أسبوعي'),
  monthly('Monthly', 'شهري'),
  special('Special Event', 'حدث خاص'),
  exploration('Exploration', 'استكشاف'),
  knowledge('Knowledge', 'معرفة');

  const ChallengeType(this.nameEn, this.nameAr);
  final String nameEn;
  final String nameAr;
}

/// صعوبة التحدي (Challenge Difficulty)
enum ChallengeDifficulty {
  easy('Easy', 'سهل', Color(0xFF4CAF50), 1),
  medium('Medium', 'متوسط', Color(0xFFFF9800), 2),
  hard('Hard', 'صعب', Color(0xFFF44336), 3),
  expert('Expert', 'خبير', Color(0xFF9C27B0), 4);

  const ChallengeDifficulty(this.nameEn, this.nameAr, this.color, this.level);
  final String nameEn;
  final String nameAr;
  final Color color;
  final int level;
}

/// حالة التحدي (Challenge Status)
enum ChallengeStatus {
  upcoming('Upcoming', 'قادم'),
  active('Active', 'نشط'),
  completed('Completed', 'مكتمل'),
  expired('Expired', 'منتهي الصلاحية'),
  paused('Paused', 'متوقف');

  const ChallengeStatus(this.nameEn, this.nameAr);
  final String nameEn;
  final String nameAr;
}

/// خطوة التحدي (Challenge Step)
class ChallengeStep {
  final String id;
  final String title;
  final String titleAr;
  final String description;
  final String descriptionAr;
  final IconData icon;
  final bool isCompleted;
  final int order;
  final Map<String, dynamic> data;

  const ChallengeStep({
    required this.id,
    required this.title,
    required this.titleAr,
    required this.description,
    required this.descriptionAr,
    required this.icon,
    this.isCompleted = false,
    required this.order,
    this.data = const {},
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
      'isCompleted': isCompleted,
      'order': order,
      'data': data,
    };
  }

  /// إنشاء من JSON
  factory ChallengeStep.fromJson(Map<String, dynamic> json) {
    return ChallengeStep(
      id: json['id'],
      title: json['title'],
      titleAr: json['titleAr'],
      description: json['description'],
      descriptionAr: json['descriptionAr'],
      icon: IconData(json['icon'], fontFamily: 'MaterialIcons'),
      isCompleted: json['isCompleted'] ?? false,
      order: json['order'],
      data: json['data'] ?? {},
    );
  }
}

/// مكافأة التحدي (Challenge Reward)
class ChallengeReward {
  final int points;
  final List<Achievement> achievements;
  final String title;
  final String titleAr;
  final IconData icon;
  final Color color;

  const ChallengeReward({
    required this.points,
    this.achievements = const [],
    required this.title,
    required this.titleAr,
    required this.icon,
    required this.color,
  });

  /// تحويل إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'points': points,
      'achievements': achievements.map((a) => a.toJson()).toList(),
      'title': title,
      'titleAr': titleAr,
      'icon': icon.codePoint,
      'color': color.value,
    };
  }

  /// إنشاء من JSON
  factory ChallengeReward.fromJson(Map<String, dynamic> json) {
    return ChallengeReward(
      points: json['points'],
      achievements: (json['achievements'] as List?)
          ?.map((a) => Achievement.fromJson(a))
          .toList() ?? [],
      title: json['title'],
      titleAr: json['titleAr'],
      icon: IconData(json['icon'], fontFamily: 'MaterialIcons'),
      color: Color(json['color']),
    );
  }
}
