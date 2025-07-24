import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/providers.dart';
import '../widgets/widgets.dart';

/// الشاشة الرئيسية المحسنة (Enhanced Home Screen)
/// تتضمن النظام الذكي للتخصيص والتفاعل المتقدم
class EnhancedHomeScreen extends StatefulWidget {
  const EnhancedHomeScreen({super.key});

  @override
  State<EnhancedHomeScreen> createState() => _EnhancedHomeScreenState();
}

class _EnhancedHomeScreenState extends State<EnhancedHomeScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _headerController;
  late Animation<double> _headerAnimation;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 4, vsync: this);

    _headerController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _headerAnimation = CurvedAnimation(
      parent: _headerController,
      curve: Curves.easeOutCubic,
    );

    _headerController.forward();

    // إعداد التغذية الراجعة للتحديات
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final challengesProvider = context.read<ChallengesProvider>();
      challengesProvider.onChallengeCompleted = (challenge) {
        InteractiveFeedback.showAchievementNotification(
          context,
          title: 'تحدي مكتمل!',
          description: challenge.titleAr,
          icon: challenge.icon,
          color: challenge.color,
          points: challenge.points,
        );
        InteractiveFeedback.showCelebrationEffect(context);
      };
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _headerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            _buildAnimatedAppBar(innerBoxIsScrolled),
          ];
        },
        body: Column(
          children: [
            // شريط البحث التفاعلي
            Consumer<SportsProvider>(
              builder: (context, sportsProvider, child) {
                return InteractiveSearchBar(
                  onSearchChanged: (query) => sportsProvider.searchSports(query),
                  onCategoryChanged: (category) => sportsProvider.filterByCategory(category),
                  onDifficultyChanged: (difficulty) => sportsProvider.filterByDifficulty(difficulty),
                );
              },
            ),
            
            // التبويبات
            _buildTabBar(),
            
            // محتوى التبويبات
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildHomeTab(),
                  _buildChallengesTab(),
                  _buildAchievementsTab(),
                  _buildProfileTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// بناء شريط التطبيق المتحرك
  Widget _buildAnimatedAppBar(bool innerBoxIsScrolled) {
    return SliverAppBar(
      expandedHeight: 150,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: const Color(0xFF1565C0),
      flexibleSpace: FlexibleSpaceBar(
        background: AnimatedBuilder(
          animation: _headerAnimation,
          builder: (context, child) {
            return Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      // مستوى المستخدم
                      Transform.scale(
                        scale: _headerAnimation.value,
                        child: const UserLevelWidget(
                          showDetails: false,
                          size: 60,
                        ),
                      ),
                      
                      // const SizedBox(width: 16),
                      
                      // // معلومات المستخدم
                      // Expanded(
                      //   child: SlideTransition(
                      //     position: Tween<Offset>(
                      //       begin: const Offset(-1, 0),
                      //       end: Offset.zero,
                      //     ).animate(_headerAnimation),
                      //     child: Consumer<UserProvider>(
                      //       builder: (context, userProvider, child) {
                      //         final user = userProvider.currentUser;
                      //         return Column(
                      //           crossAxisAlignment: CrossAxisAlignment.start,
                      //           mainAxisAlignment: MainAxisAlignment.center,
                      //           children: [
                      //             Text(
                      //               'مرحباً، ${user?.name ?? 'مستخدم'}',
                      //               style: const TextStyle(
                      //                 color: Colors.white,
                      //                 fontSize: 18,
                      //                 fontWeight: FontWeight.bold,
                      //               ),
                      //             ),
                      //             const SizedBox(height: 4),
                      //             Text(
                      //               'اكتشف عالم الرياضة',
                      //               style: TextStyle(
                      //                 color: Colors.white.withValues(alpha: 0.9),
                      //                 fontSize: 14,
                      //               ),
                      //             ),
                      //           ],
                      //         );
                      //       },
                      //     ),
                      //   ),
                      // ),
                      
                      // إشعارات سريعة
                      SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(1, 0),
                          end: Offset.zero,
                        ).animate(_headerAnimation),
                        child: _buildQuickStats(),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// بناء الإحصائيات السريعة
  Widget _buildQuickStats() {
    return Consumer2<UserProvider, ChallengesProvider>(
      builder: (context, userProvider, challengesProvider, child) {
        final user = userProvider.currentUser;
        final activeChallenges = challengesProvider.activeChallenges.length;
        
        return Row(
          children: [
            _buildStatBadge(
              icon: Icons.stars,
              value: '${user?.totalPoints ?? 0}',
              color: Colors.amber,
            ),
            const SizedBox(width: 8),
            _buildStatBadge(
              icon: Icons.emoji_events,
              value: '$activeChallenges',
              color: Colors.orange,
            ),
          ],
        );
      },
    );
  }

  /// بناء شارة إحصائية
  Widget _buildStatBadge({
    required IconData icon,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// بناء شريط التبويبات
  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        indicatorColor: const Color(0xFF1565C0),
        indicatorWeight: 3,
        labelColor: const Color(0xFF1565C0),
        unselectedLabelColor: Colors.grey[600],
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        tabs: const [
          Tab(text: 'الرئيسية', icon: Icon(Icons.home, size: 20)),
          Tab(text: 'التحديات', icon: Icon(Icons.emoji_events, size: 20)),
          Tab(text: 'الإنجازات', icon: Icon(Icons.military_tech, size: 20)),
          Tab(text: 'الملف الشخصي', icon: Icon(Icons.person, size: 20)),
        ],
      ),
    );
  }

  /// بناء تبويب الرئيسية
  Widget _buildHomeTab() {
    return Consumer<SportsProvider>(
      builder: (context, sportsProvider, child) {
        if (sportsProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final filteredSports = sportsProvider.filteredSports;
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // قسم الرياضات المقترحة
              Consumer<UserProvider>(
                builder: (context, userProvider, child) {
                  final user = userProvider.currentUser;
                  if (user == null) return const SizedBox.shrink();

                  final recommendations = sportsProvider.getPersonalizedRecommendations(user, limit: 4);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader('رياضات مقترحة لك', Icons.recommend),
                      const SizedBox(height: 16),
                      _buildSportsGrid(recommendations),
                    ],
                  );
                },
              ),
              
              const SizedBox(height: 24),
              
              // قسم جميع الرياضات
              _buildSectionHeader(
                'جميع الرياضات (${filteredSports.length})',
                Icons.sports_soccer,
              ),
              const SizedBox(height: 16),
              _buildSportsGrid(filteredSports),
            ],
          ),
        );
      },
    );
  }

  /// بناء تبويب التحديات
  Widget _buildChallengesTab() {
    return const SingleChildScrollView(
      child: ChallengesWidget(),
    );
  }

  /// بناء تبويب الإنجازات
  Widget _buildAchievementsTab() {
    return const SingleChildScrollView(
      child: AchievementsWidget(),
    );
  }

  /// بناء تبويب الملف الشخصي
  Widget _buildProfileTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // مستوى المستخدم التفصيلي
          const UserLevelWidget(showDetails: true),
          
          const SizedBox(height: 24),
          
          // إعدادات سريعة
          _buildQuickSettings(),
        ],
      ),
    );
  }

  /// بناء عنوان القسم
  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF1565C0).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF1565C0),
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3748),
          ),
        ),
      ],
    );
  }

  /// بناء شبكة الرياضات
  Widget _buildSportsGrid(List<SportModel> sports) {
    if (sports.isEmpty) {
      return _buildEmptyState();
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.1,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: sports.length,
      itemBuilder: (context, index) {
        return AnimatedSportCard(
          sport: sports[index],
          index: index,
        );
      },
    );
  }

  /// بناء حالة فارغة
  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد رياضات مطابقة',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'جرب تعديل معايير البحث',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  /// بناء الإعدادات السريعة
  Widget _buildQuickSettings() {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'الإعدادات السريعة',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
              const SizedBox(height: 16),
              
              // تبديل الثيم
              ListTile(
                leading: Icon(
                  userProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  color: const Color(0xFF1565C0),
                ),
                title: const Text('الوضع المظلم'),
                trailing: Switch(
                  value: userProvider.isDarkMode,
                  onChanged: (_) => userProvider.toggleTheme(),
                  activeColor: const Color(0xFF1565C0),
                ),
                contentPadding: EdgeInsets.zero,
              ),
              
              // تبديل الأسماء العربية
              ListTile(
                leading: const Icon(
                  Icons.language,
                  color: Color(0xFF1565C0),
                ),
                title: const Text('عرض الأسماء العربية'),
                trailing: Switch(
                  value: userProvider.showArabicNames,
                  onChanged: (_) => userProvider.toggleArabicNames(),
                  activeColor: const Color(0xFF1565C0),
                ),
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ),
        );
      },
    );
  }
}
