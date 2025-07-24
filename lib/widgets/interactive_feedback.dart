import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// نظام التغذية الراجعة التفاعلية (Interactive Feedback System)
/// يوفر إشعارات وتأثيرات بصرية متقدمة
class InteractiveFeedback {
  
  /// عرض إشعار إنجاز متحرك
  static void showAchievementNotification(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    int points = 0,
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;
    
    overlayEntry = OverlayEntry(
      builder: (context) => _AchievementNotification(
        title: title,
        description: description,
        icon: icon,
        color: color,
        points: points,
        onDismiss: () => overlayEntry.remove(),
      ),
    );
    
    overlay.insert(overlayEntry);
    
    // إزالة تلقائية بعد 4 ثوان
    Future.delayed(const Duration(seconds: 4), () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }

  /// عرض تأثير الاحتفال
  static void showCelebrationEffect(BuildContext context) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;
    
    overlayEntry = OverlayEntry(
      builder: (context) => _CelebrationEffect(
        onComplete: () => overlayEntry.remove(),
      ),
    );
    
    overlay.insert(overlayEntry);
  }

  /// تشغيل اهتزاز تفاعلي
  static void hapticFeedback(HapticFeedbackType type) {
    switch (type) {
      case HapticFeedbackType.light:
        HapticFeedback.lightImpact();
        break;
      case HapticFeedbackType.medium:
        HapticFeedback.mediumImpact();
        break;
      case HapticFeedbackType.heavy:
        HapticFeedback.heavyImpact();
        break;
      case HapticFeedbackType.selection:
        HapticFeedback.selectionClick();
        break;
    }
  }

  /// عرض رسالة تفاعلية
  static void showInteractiveSnackBar(
    BuildContext context, {
    required String message,
    IconData? icon,
    Color? backgroundColor,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor ?? const Color(0xFF1565C0),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        action: actionLabel != null
            ? SnackBarAction(
                label: actionLabel,
                textColor: Colors.white,
                onPressed: onAction ?? () {},
              )
            : null,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

/// إشعار الإنجاز المتحرك
class _AchievementNotification extends StatefulWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final int points;
  final VoidCallback onDismiss;

  const _AchievementNotification({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.points,
    required this.onDismiss,
  });

  @override
  State<_AchievementNotification> createState() => _AchievementNotificationState();
}

class _AchievementNotificationState extends State<_AchievementNotification>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeOutBack,
    ));

    _slideController.forward();
    _scaleController.forward();

    // اهتزاز تفاعلي
    InteractiveFeedback.hapticFeedback(HapticFeedbackType.medium);
  }

  @override
  void dispose() {
    _slideController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 20,
      left: 20,
      right: 20,
      child: SlideTransition(
        position: _slideAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [widget.color, widget.color.withValues(alpha: 0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // أيقونة الإنجاز
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      widget.icon,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  
                  const SizedBox(width: 16),
                  
                  // النص
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.description,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // النقاط
                  if (widget.points > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.stars,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '+${widget.points}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// تأثير الاحتفال
class _CelebrationEffect extends StatefulWidget {
  final VoidCallback onComplete;

  const _CelebrationEffect({required this.onComplete});

  @override
  State<_CelebrationEffect> createState() => _CelebrationEffectState();
}

class _CelebrationEffectState extends State<_CelebrationEffect>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<_Particle> _particles;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _particles = List.generate(50, (index) => _Particle());
    
    _controller.forward().then((_) => widget.onComplete());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _CelebrationPainter(_particles, _controller.value),
          size: MediaQuery.of(context).size,
        );
      },
    );
  }
}

/// جسيم الاحتفال
class _Particle {
  late double x;
  late double y;
  late double vx;
  late double vy;
  late Color color;
  late double size;

  _Particle() {
    x = 0.5;
    y = 0.5;
    vx = (0.5 - (0.5 + 0.5 * (0.5 - 0.5))) * 2;
    vy = -1 - (0.5 * 2);
    color = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
    ][(6 * 0.5).floor()];
    size = 3 + (0.5 * 4);
  }
}

/// رسام تأثير الاحتفال
class _CelebrationPainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;

  _CelebrationPainter(this.particles, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    
    for (final particle in particles) {
      final x = size.width * (particle.x + particle.vx * progress);
      final y = size.height * (particle.y + particle.vy * progress + 0.5 * progress * progress);
      
      paint.color = particle.color.withValues(alpha: 1 - progress);
      canvas.drawCircle(
        Offset(x, y),
        particle.size * (1 - progress * 0.5),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// أنواع الاهتزاز التفاعلي
enum HapticFeedbackType {
  light,
  medium,
  heavy,
  selection,
}
