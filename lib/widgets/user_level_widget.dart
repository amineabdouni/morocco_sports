import 'package:flutter/material.dart';
import 'package:morocco_sports/training_program_screen.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import '../models/models.dart';
import '../providers/providers.dart';

/// واجهة مستوى المستخدم التفاعلية (Interactive User Level Widget)
/// تعرض مستوى المستخدم مع شريط تقدم دائري متحرك
class UserLevelWidget extends StatefulWidget {
  final bool showDetails;
  final double size;

  const UserLevelWidget({
    super.key,
    this.showDetails = true,
    this.size = 120,
  });

  @override
  State<UserLevelWidget> createState() => _UserLevelWidgetState();
}

class _UserLevelWidgetState extends State<UserLevelWidget>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  
  late Animation<double> _progressAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    
    // إعداد الحركات
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _rotationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeOutCubic,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.linear,
    ));

    // بدء الحركات
    _progressController.forward();
    _pulseController.repeat(reverse: true);
    _rotationController.repeat();
  }

  @override
  void dispose() {
    _progressController.dispose();
    _pulseController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final user = userProvider.currentUser;
        if (user == null) return const SizedBox.shrink();

        final level = user.level;

        return Container(
          padding: const EdgeInsets.all(16),
          child: widget.showDetails
              ? _buildDetailedView(level)
              : _buildCompactView(level),
        );
      },
    );
  }

  /// بناء العرض التفصيلي
  Widget _buildDetailedView(UserLevel level) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            level.color.withValues(alpha:0.1),
            level.color.withValues(alpha:0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: level.color.withValues(alpha:0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: level.color.withValues(alpha:0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // العنوان
          Text(
            'مستواك الحالي',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // الدائرة التفاعلية
          _buildLevelCircle(level),
          
          const SizedBox(height: 20),
          
          // معلومات المستوى
          _buildLevelInfo(level),
          
          const SizedBox(height: 16),
          
          // شريط التقدم الخطي
          _buildLinearProgress(level),
        ],
      ),
    );
  }

  /// بناء العرض المضغوط
  Widget _buildCompactView(UserLevel level) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: widget.size * 0.6,
            height: widget.size * 0.6,
            child: _buildLevelCircle(level),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  level.titleAr,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(height: 4),
                Text(
                  'المستوى ${level.level}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                _buildLinearProgress(level),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// بناء الدائرة التفاعلية
  Widget _buildLevelCircle(UserLevel level) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TrainingProgramScreen(),
          ),
        );
      },
      child: ScaleTransition(
        scale: _pulseAnimation,
        child: SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // الدائرة الخارجية المتحركة
              AnimatedBuilder(
                animation: _rotationAnimation,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _rotationAnimation.value,
                    child: Container(
                      width: widget.size,
                      height: widget.size,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: SweepGradient(
                          colors: [
                            level.color.withValues(alpha:0.1),
                            level.color.withValues(alpha:0.3),
                            level.color.withValues(alpha:0.1),
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                      ),
                    ),
                  );
                },
              ),
              
              // شريط التقدم الدائري
              AnimatedBuilder(
                animation: _progressAnimation,
                builder: (context, child) {
                  return CustomPaint(
                    size: Size(widget.size, widget.size),
                    painter: CircularProgressPainter(
                      progress: level.progress * _progressAnimation.value,
                      color: level.color,
                      strokeWidth: 8,
                    ),
                  );
                },
              ),
              
              // المحتوى الداخلي
              Container(
                width: widget.size * 0.7,
                height: widget.size * 0.7,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: level.color.withValues(alpha:0.2),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      level.icon,
                      color: level.color,
                      size: widget.size * 0.25,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${level.level}',
                      style: TextStyle(
                        fontSize: widget.size * 0.15,
                        fontWeight: FontWeight.bold,
                        color: level.color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// بناء معلومات المستوى
  Widget _buildLevelInfo(UserLevel level) {
    return Column(
      children: [
        Text(
          level.titleAr,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: level.color,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'المستوى ${level.level}',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildStatItem(
              icon: Icons.stars,
              label: 'النقاط الحالية',
              value: '${level.currentXP}',
              color: Colors.amber,
            ),
            const SizedBox(width: 24),
            _buildStatItem(
              icon: Icons.flag,
              label: 'للمستوى التالي',
              value: '${level.requiredXP - level.currentXP}',
              color: level.color,
            ),
          ],
        ),
      ],
    );
  }

  /// بناء عنصر إحصائي
  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  /// بناء شريط التقدم الخطي
  Widget _buildLinearProgress(UserLevel level) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Flexible(
              child: Text(
                'التقدم للمستوى التالي',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              '${(level.progress * 100).toInt()}%',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: level.color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        AnimatedBuilder(
          animation: _progressAnimation,
          builder: (context, child) {
            return LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  height: 8,
                  width: constraints.maxWidth,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: level.progress * _progressAnimation.value,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            level.color,
                            level.color.withValues(alpha:0.7),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}

/// رسام شريط التقدم الدائري
class CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  CircularProgressPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // رسم الخلفية
    final backgroundPaint = Paint()
      ..color = color.withValues(alpha:0.2)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // رسم التقدم
    final progressPaint = Paint()
      ..shader = SweepGradient(
        colors: [color.withValues(alpha:0.5), color],
        stops: const [0.0, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
