import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/providers.dart';
import '../sport_details_screen.dart';

/// بطاقة رياضة متحركة وتفاعلية (Animated Interactive Sport Card)
/// تعرض معلومات الرياضة مع تأثيرات بصرية وتفاعل متقدم
class AnimatedSportCard extends StatefulWidget {
  final SportModel sport;
  final int index;
  final VoidCallback? onTap;

  const AnimatedSportCard({
    super.key,
    required this.sport,
    this.index = 0,
    this.onTap,
  });

  @override
  State<AnimatedSportCard> createState() => _AnimatedSportCardState();
}

class _AnimatedSportCardState extends State<AnimatedSportCard>
    with TickerProviderStateMixin {
  late AnimationController _hoverController;
  late AnimationController _favoriteController;
  late AnimationController _slideController;
  
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  late Animation<double> _favoriteAnimation;
  late Animation<Offset> _slideAnimation;
  
  bool _isHovered = false;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    
    // إعداد الحركات
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _favoriteController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOutCubic,
    ));

    _elevationAnimation = Tween<double>(
      begin: 4.0,
      end: 12.0,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOutCubic,
    ));

    _favoriteAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _favoriteController,
      curve: Curves.elasticOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutBack,
    ));

    // بدء حركة الدخول مع تأخير حسب الفهرس
    Future.delayed(Duration(milliseconds: widget.index * 100), () {
      if (mounted) {
        _slideController.forward();
      }
    });
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _favoriteController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SportsProvider>(
      builder: (context, sportsProvider, child) {
        _isFavorite = sportsProvider.isFavorite(widget.sport.id);
        
        return SlideTransition(
          position: _slideAnimation,
          child: AnimatedBuilder(
            animation: Listenable.merge([_scaleAnimation, _elevationAnimation]),
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: GestureDetector(
                  onTap: () => _handleTap(context, sportsProvider),
                  child: MouseRegion(
                    onEnter: (_) => _setHovered(true),
                    onExit: (_) => _setHovered(false),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: widget.sport.colors.primary.withValues(alpha:0.1),
                            blurRadius: _elevationAnimation.value,
                            offset: Offset(0, _elevationAnimation.value / 2),
                          ),
                        ],
                        border: Border.all(
                          color: _isHovered 
                              ? widget.sport.colors.primary.withValues(alpha:0.3)
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Stack(
                        children: [
                          // خلفية متدرجة
                          _buildGradientBackground(),
                          
                          // المحتوى الرئيسي
                          _buildMainContent(),
                          
                          // زر المفضلة
                          _buildFavoriteButton(sportsProvider),
                          
                          // مؤشر الصعوبة
                          _buildDifficultyIndicator(),
                          
                          // تأثير الضوء عند التمرير
                          if (_isHovered) _buildHoverEffect(),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  /// بناء الخلفية المتدرجة
  Widget _buildGradientBackground() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              widget.sport.colors.background.withValues(alpha:0.3),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }

  /// بناء المحتوى الرئيسي
  Widget _buildMainContent() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // أيقونة الرياضة
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 800),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Transform.rotate(
                  angle: (1 - value) * 0.5,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: widget.sport.colors.primary.withValues(alpha:0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: widget.sport.colors.primary.withValues(alpha:0.2),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      widget.sport.icon,
                      size: 32,
                      color: widget.sport.colors.primary,
                    ),
                  ),
                ),
              );
            },
          ),
          
          const SizedBox(height: 12),
          
          // اسم الرياضة
          Text(
            widget.sport.nameAr,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          
          const SizedBox(height: 4),
          
          // وصف الرياضة
          Text(
            widget.sport.descriptionAr,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          
          const SizedBox(height: 12),
          
          // تصنيف الرياضة
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: widget.sport.colors.primary.withValues(alpha:0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: widget.sport.colors.primary.withValues(alpha:0.3),
                width: 1,
              ),
            ),
            child: Text(
              widget.sport.category.nameAr,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: widget.sport.colors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// بناء زر المفضلة
  Widget _buildFavoriteButton(SportsProvider sportsProvider) {
    return Positioned(
      top: 8,
      right: 8,
      child: ScaleTransition(
        scale: _favoriteAnimation,
        child: GestureDetector(
          onTap: () => _toggleFavorite(sportsProvider),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha:0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.red : Colors.grey[400],
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  /// بناء مؤشر الصعوبة
  Widget _buildDifficultyIndicator() {
    return Positioned(
      top: 8,
      left: 8,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(5, (index) {
          return Container(
            margin: const EdgeInsets.only(right: 2),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: index < widget.sport.difficulty
                  ? widget.sport.colors.primary
                  : Colors.grey[300],
              shape: BoxShape.circle,
            ),
          );
        }),
      ),
    );
  }

  /// بناء تأثير التمرير
  Widget _buildHoverEffect() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              widget.sport.colors.primary.withValues(alpha:0.1),
              Colors.transparent,
              widget.sport.colors.secondary.withValues(alpha:0.1),
            ],
          ),
        ),
      ),
    );
  }

  /// تعيين حالة التمرير
  void _setHovered(bool hovered) {
    setState(() {
      _isHovered = hovered;
    });
    
    if (hovered) {
      _hoverController.forward();
    } else {
      _hoverController.reverse();
    }
  }

  /// التعامل مع النقر
  void _handleTap(BuildContext context, SportsProvider sportsProvider) {
    // تسجيل المشاهدة
    sportsProvider.markAsViewed(widget.sport.id);
    
    // تسجيل الاستكشاف في التحديات
    context.read<ChallengesProvider>().recordSportExploration(widget.sport.id);
    context.read<UserProvider>().exploreSport(widget.sport.id);
    
    // الانتقال لصفحة التفاصيل
    if (widget.onTap != null) {
      widget.onTap!();
    } else {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return SportDetailsScreen(
              sportName: widget.sport.name,
              sportIcon: widget.sport.icon,
              sportDescription: widget.sport.description,
            );
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              )),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 300),
        ),
      );
    }
  }

  /// تبديل المفضلة
  void _toggleFavorite(SportsProvider sportsProvider) {
    _favoriteController.forward().then((_) {
      _favoriteController.reverse();
    });
    
    sportsProvider.toggleFavorite(widget.sport.id);
    
    // تسجيل في التحديات إذا تم الإضافة
    if (!_isFavorite) {
      context.read<ChallengesProvider>().recordFavoriteAdded(widget.sport.id);
      context.read<UserProvider>().addFavoriteSport(widget.sport.id);
    } else {
      context.read<UserProvider>().removeFavoriteSport(widget.sport.id);
    }
  }
}
