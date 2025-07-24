import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/providers.dart';

/// واجهة التحديات التفاعلية (Interactive Challenges Widget)
/// تعرض التحديات النشطة مع تفاعل حي ومتحرك
class ChallengesWidget extends StatefulWidget {
  const ChallengesWidget({super.key});

  @override
  State<ChallengesWidget> createState() => _ChallengesWidgetState();
}

class _ChallengesWidgetState extends State<ChallengesWidget>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _pulseController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    // إعداد الحركات
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // بدء الحركات
    _slideController.forward();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _slideController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChallengesProvider>(
      builder: (context, challengesProvider, child) {
        if (challengesProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final activeChallenges = challengesProvider.activeChallenges;
        
        if (activeChallenges.isEmpty) {
          return _buildEmptyState();
        }

        return SlideTransition(
          position: _slideAnimation,
          child: Container(
            margin: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(challengesProvider),
                const SizedBox(height: 16),
                _buildChallengesList(activeChallenges),
              ],
            ),
          ),
        );
      },
    );
  }

  /// بناء العنوان الرئيسي
  Widget _buildHeader(ChallengesProvider provider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha:0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          ScaleTransition(
            scale: _pulseAnimation,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha:0.2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(
                Icons.emoji_events,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'التحديات النشطة',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${provider.activeChallenges.length} تحديات متاحة',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha:0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha:0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${provider.totalPointsEarned} نقطة',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// بناء قائمة التحديات
  Widget _buildChallengesList(List<ChallengeModel> challenges) {
    return Column(
      children: challenges.asMap().entries.map((entry) {
        final index = entry.key;
        final challenge = entry.value;
        
        return AnimatedContainer(
          duration: Duration(milliseconds: 300 + (index * 100)),
          curve: Curves.easeOutBack,
          margin: const EdgeInsets.only(bottom: 16),
          child: _buildChallengeCard(challenge, index),
        );
      }).toList(),
    );
  }

  /// بناء بطاقة التحدي
  Widget _buildChallengeCard(ChallengeModel challenge, int index) {
    final progress = _calculateProgress(challenge);
    final isCompleted = challenge.status == ChallengeStatus.completed;
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: challenge.color.withValues(alpha:0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: challenge.color.withValues(alpha:0.2),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            // شريط التقدم العلوي
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(challenge.color),
              minHeight: 4,
            ),
            
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // العنوان والأيقونة
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: challenge.color.withValues(alpha:0.1),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Icon(
                          challenge.icon,
                          color: challenge.color,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              challenge.titleAr,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2D3748),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              challenge.descriptionAr,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      _buildChallengeType(challenge.type),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // شريط التقدم التفصيلي
                  _buildProgressBar(challenge, progress),
                  
                  const SizedBox(height: 16),
                  
                  // المكافأة والوقت المتبقي
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildRewardInfo(challenge.reward),
                      _buildTimeRemaining(challenge),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// بناء نوع التحدي
  Widget _buildChallengeType(ChallengeType type) {
    Color color;
    String text;
    
    switch (type) {
      case ChallengeType.daily:
        color = const Color(0xFF4CAF50);
        text = 'يومي';
        break;
      case ChallengeType.weekly:
        color = const Color(0xFFFF9800);
        text = 'أسبوعي';
        break;
      case ChallengeType.monthly:
        color = const Color(0xFF9C27B0);
        text = 'شهري';
        break;
      default:
        color = const Color(0xFF2196F3);
        text = 'خاص';
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha:0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha:0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// بناء شريط التقدم التفصيلي
  Widget _buildProgressBar(ChallengeModel challenge, double progress) {
    final currentCount = challenge.criteria['currentCount'] ?? 0;
    final targetCount = challenge.criteria['sportsToExplore'] ?? 
                       challenge.criteria['favoritesToAdd'] ?? 1;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'التقدم',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            Text(
              '$currentCount / $targetCount',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: challenge.color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [challenge.color, challenge.color.withValues(alpha:0.7)],
                ),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// بناء معلومات المكافأة
  Widget _buildRewardInfo(ChallengeReward reward) {
    return Row(
      children: [
        Icon(
          Icons.stars,
          color: Colors.amber,
          size: 20,
        ),
        const SizedBox(width: 4),
        Text(
          '${reward.points} نقطة',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.amber,
          ),
        ),
      ],
    );
  }

  /// بناء الوقت المتبقي
  Widget _buildTimeRemaining(ChallengeModel challenge) {
    final timeRemaining = challenge.timeRemaining;
    final hours = timeRemaining.inHours;
    final minutes = timeRemaining.inMinutes % 60;
    
    return Row(
      children: [
        Icon(
          Icons.access_time,
          color: Colors.grey[600],
          size: 16,
        ),
        const SizedBox(width: 4),
        Text(
          hours > 0 ? '${hours}س ${minutes}د' : '${minutes}د',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  /// حساب التقدم
  double _calculateProgress(ChallengeModel challenge) {
    final currentCount = challenge.criteria['currentCount'] ?? 0;
    final targetCount = challenge.criteria['sportsToExplore'] ?? 
                       challenge.criteria['favoritesToAdd'] ?? 1;
    
    if (targetCount == 0) return 0.0;
    return (currentCount / targetCount).clamp(0.0, 1.0);
  }

  /// بناء حالة فارغة
  Widget _buildEmptyState() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha:0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.emoji_events_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد تحديات نشطة',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'ستظهر التحديات الجديدة قريباً',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}
