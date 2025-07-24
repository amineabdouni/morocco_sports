import 'package:flutter/material.dart';
import 'dart:ui';

class SportDetailsScreen extends StatefulWidget {
  final String sportName;
  final IconData sportIcon;
  final String sportDescription;

  const SportDetailsScreen({
    super.key,
    required this.sportName,
    required this.sportIcon,
    required this.sportDescription,
  });

  @override
  State<SportDetailsScreen> createState() => _SportDetailsScreenState();
}

class _SportDetailsScreenState extends State<SportDetailsScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  // Default blue color palette
  static const Color primaryBlue = Color(0xFF1565C0);
  static const Color lightBlue = Color(0xFF42A5F5);
  static const Color darkBlue = Color(0xFF0D47A1);
  static const Color accentBlue = Color(0xFF2196F3);
  static const Color backgroundBlue = Color(0xFFE3F2FD);

  // Get sport-specific colors
  SportColors get sportColors => _getSportColors(widget.sportName);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: sportColors.background,
      appBar: AppBar(
        elevation: 0,
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [sportColors.primary, sportColors.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: Container(
          margin: const EdgeInsets.only(left: 16),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(
                    color: sportColors.primary.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: sportColors.primary,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
        title: Text(
          widget.sportName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,

        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border_rounded),
            onPressed: () {
              // TODO: Add to favorites
            },
          ),
          IconButton(
            icon: const Icon(Icons.share_rounded),
            onPressed: () {
              // TODO: Share sport
            },
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(250.0),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [sportColors.primary, sportColors.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                // Player background image with blur effect
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(_getSportPlayerImage()),
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                        colorFilter: ColorFilter.mode(
                          Colors.black.withValues(alpha: 0.2),
                          BlendMode.darken,
                        ),
                      ),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
                      child: Container(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                ),
                // Enhanced gradient overlay for better text readability
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          sportColors.primary.withValues(alpha: 0.3),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.4),
                          sportColors.secondary.withValues(alpha: 0.6),
                        ],
                        stops: const [0.0, 0.3, 0.7, 1.0],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
                // Additional side gradient for depth
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment.center,
                        radius: 1.2,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.3),
                        ],
                        stops: const [0.6, 1.0],
                      ),
                    ),
                  ),
                ),
                // Sport-specific background pattern
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          sportColors.primary.withValues(alpha: 0.2),
                          Colors.transparent,
                          sportColors.secondary.withValues(alpha: 0.3),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
                // Sport-specific background elements
                ..._buildSportBackgroundElements(),
                // Player image prominently displayed
                Positioned(
                  right: -20,
                  top: 10,
                  bottom: 20,
                  child: Container(
                    width: 180,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(-5, 5),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(_getSportPlayerImage()),
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                sportColors.primary.withValues(alpha: 0.2),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Sport icon pattern in background (smaller and more subtle)
                Positioned(
                  left: -40,
                  bottom: -30,
                  child: Opacity(
                    opacity: 0.05,
                    child: Icon(
                      widget.sportIcon,
                      size: 120,
                      color: Colors.white,
                    ),
                  ),
                ),
                // Main content
                Column(
                  children: [
                    // Sport Header Info
                    Container(
                      padding: const EdgeInsets.only(left: 20, right: 200, top: 20, bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Sport icon with enhanced design
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white.withValues(alpha: 0.4),
                                  Colors.white.withValues(alpha: 0.2),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.6),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.4),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                                BoxShadow(
                                  color: sportColors.primary.withValues(alpha: 0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                widget.sportIcon,
                                size: 56,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Sport description with enhanced styling
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.3),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              widget.sportDescription,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                height: 1.4,
                                shadows: [
                                  Shadow(
                                    color: Colors.black54,
                                    offset: Offset(0, 2),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                    ),
              
              // Tab Bar
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: sportColors.primary,
                  unselectedLabelColor: Colors.white,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                  dividerColor: Colors.transparent,
                  tabs: const [
                    Tab(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text('دروس الرياضة'),
                      ),
                    ),
                    Tab(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text('قوانين الرياضة'),
                      ),
                    ),
                    Tab(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text('اختبر معلوماتك'),
                      ),
                    ),
                  ],
                ),
              ),
                    const SizedBox(height: 10),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          TabBarView(
            controller: _tabController,
            children: [
              _buildLessonsTab(),
              _buildRulesTab(),
              _buildQuizTab(),
            ],
          ),
          // Floating back button
          Positioned(
            bottom: 30,
            left: 20,
            child: Container(
              decoration: BoxDecoration(
                color: sportColors.primary,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(25),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'العودة',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonsTab() {
    final lessons = _getLessonsForSport(widget.sportName);

    return Column(
      children: [
        // Quick back button at top
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: sportColors.primary.withValues(alpha: 0.1),
            border: Border(
              bottom: BorderSide(
                color: sportColors.primary.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: sportColors.primary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: sportColors.primary,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'العودة',
                        style: TextStyle(
                          color: sportColors.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Text(
                lessons.isEmpty ? 'دروس تفاعلية' : '${lessons.length} درس',
                style: TextStyle(
                  color: sportColors.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        // Content
        Expanded(
          child: lessons.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.school_outlined,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'دروس ${widget.sportName}',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'تعلم أساسيات وتقنيات ${widget.sportName} من خلال دروس تفاعلية',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: lessons.length,
                  itemBuilder: (context, index) {
                    final lesson = lessons[index];
                    return _buildLessonCard(lesson, index + 1);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildRulesTab() {
    final rules = _getRulesForSport(widget.sportName);

    return Column(
      children: [
        // Quick back button at top
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: sportColors.primary.withValues(alpha: 0.1),
            border: Border(
              bottom: BorderSide(
                color: sportColors.primary.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: sportColors.primary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: sportColors.primary,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'العودة',
                        style: TextStyle(
                          color: sportColors.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Text(
                '${rules.length} قانون',
                style: TextStyle(
                  color: sportColors.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        // Rules list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: rules.length,
            itemBuilder: (context, index) {
              final rule = rules[index];
              return _buildRuleCard(rule);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildQuizTab() {
    final quizzes = _getQuizzesForSport(widget.sportName);

    return Column(
      children: [
        // Quick back button at top
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: sportColors.primary.withValues(alpha: 0.1),
            border: Border(
              bottom: BorderSide(
                color: sportColors.primary.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: sportColors.primary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: sportColors.primary,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'العودة',
                        style: TextStyle(
                          color: sportColors.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Text(
                quizzes.isEmpty ? 'اختبارات تفاعلية' : '${quizzes.length} اختبار',
                style: TextStyle(
                  color: sportColors.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        // Content
        Expanded(
          child: quizzes.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.quiz_outlined,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'لا توجد اختبارات متاحة حالياً',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'سيتم إضافة اختبارات قريباً',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: quizzes.length,
                  itemBuilder: (context, index) {
                    final quiz = quizzes[index];
                    return _buildQuizCard(quiz);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildLessonCard(SportLesson lesson, int lessonNumber) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Lesson Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: sportColors.secondary.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: sportColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$lessonNumber',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lesson.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: darkBlue,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            lesson.duration,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(Icons.signal_cellular_alt, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            lesson.level,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  lesson.isCompleted ? Icons.check_circle : Icons.play_circle_outline,
                  color: lesson.isCompleted ? Colors.green : sportColors.primary,
                  size: 28,
                ),
              ],
            ),
          ),
          
          // Lesson Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lesson.description,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),

                // Action Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('بدء درس: ${lesson.title}'),
                          backgroundColor: sportColors.primary,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: lesson.isCompleted ? Colors.green : sportColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      lesson.isCompleted ? 'مراجعة الدرس' : 'بدء الدرس',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRuleCard(SportRule rule) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: sportColors.accent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.rule, color: sportColors.accent, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    rule.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: darkBlue,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              rule.description,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizCard(SportQuiz quiz) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quiz Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  sportColors.primary.withValues(alpha: 0.1),
                  sportColors.secondary.withValues(alpha: 0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: sportColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.quiz,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        quiz.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: darkBlue,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.help_outline, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            '${quiz.questionCount} أسئلة',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(Icons.timer_outlined, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            quiz.duration,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (quiz.isCompleted)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.check, color: Colors.white, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${quiz.score}%',
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

          // Quiz Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  quiz.description,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),

                // Action Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _showQuizDialog(quiz);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: quiz.isCompleted ? Colors.green : sportColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          quiz.isCompleted ? Icons.refresh : Icons.play_arrow,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          quiz.isCompleted ? 'إعادة الاختبار' : 'بدء الاختبار',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getSportPlayerImage() {
    switch (widget.sportName.toLowerCase()) {
      case 'football':
        return 'assets/image/messi.jpg';
      case 'basketball':
        return 'assets/image/jjj.jpg';
      case 'tennis':
        return 'assets/image/nadal.jpg';
      case 'athletics':
      case 'track and field':
        return 'assets/image/Usain_Bollt__1_-removebg-preview (1).png';
      case 'volleyball':
        return 'assets/image/vvv.jpg';
      case 'handball':
        return 'assets/image/hhh.jpg';
      case 'rugby':
        return 'assets/image/rrrr.jpg';
      case 'boxing':
      case 'assets/image/bbbbb.jpg':
        return 'assets/image/jorden.png';
      case 'cycling':
      case 'bicycle racing':
        return 'assets/image/tb.png';
      case 'swimming':
      case 'assets/image/ffffff.jpg':
        return 'assets/image/fb.png'; // يمكن إضافة صورة سباح لاحقاً
      case 'golf':
        return 'assets/image/nadal.jpg'; // يمكن إضافة صورة لاعب جولف لاحقاً
      case 'gymnastics':
        return 'assets/image/Usain_Bollt__1_-removebg-preview (1).png';
      case 'wrestling':
        return 'assets/image/jorden.png';
      case 'archery':
        return 'assets/image/fb.png';
      case 'badminton':
        return 'assets/image/nadal.jpg';
      case 'hockey':
        return 'assets/image/fb.png';
      case 'water polo':
        return 'assets/image/fb.png';
      case 'baseball':
      case 'cricket':
        return 'assets/image/fb.png';
      case 'american football':
        return 'assets/image/fb.png';
      default:
        return 'assets/image/fb.png'; // Default fallback image
    }
  }

  List<Widget> _buildSportBackgroundElements() {
    switch (widget.sportName.toLowerCase()) {
      case 'football':
        return [
          // Football field lines pattern
          Positioned(
            left: -50,
            bottom: -30,
            child: Opacity(
              opacity: 0.1,
              child: Container(
                width: 200,
                height: 120,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 2),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      top: 30,
                      bottom: 30,
                      child: Container(
                        width: 40,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 2),
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ];
      case 'basketball':
        return [
          // Basketball court pattern
          Positioned(
            right: -40,
            bottom: -20,
            child: Opacity(
              opacity: 0.12,
              child: Container(
                width: 150,
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 20,
                      left: 20,
                      right: 20,
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 2),
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 2),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ];
      case 'tennis':
        return [
          // Tennis court net pattern
          Positioned(
            left: -30,
            bottom: 20,
            child: Opacity(
              opacity: 0.15,
              child: Container(
                width: 180,
                height: 80,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  children: List.generate(4, (index) =>
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.white, width: 1),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ];
      case 'swimming':
        return [
          // Swimming pool lanes
          Positioned(
            left: 0,
            right: 0,
            bottom: -10,
            child: Opacity(
              opacity: 0.1,
              child: Column(
                children: List.generate(6, (index) =>
                  Container(
                    height: 8,
                    margin: const EdgeInsets.symmetric(vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ];
      case 'volleyball':
        return [
          // Volleyball net pattern
          Positioned(
            right: -20,
            bottom: 10,
            child: Opacity(
              opacity: 0.12,
              child: SizedBox(
                width: 120,
                height: 80,
                child: Stack(
                  children: List.generate(8, (index) =>
                    Positioned(
                      left: index * 15.0,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        width: 2,
                        color: Colors.white,
                      ),
                    ),
                  )..addAll(
                    List.generate(6, (index) =>
                      Positioned(
                        top: index * 13.0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 2,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ];
      case 'boxing':
        return [
          // Boxing ring pattern
          Positioned(
            left: -30,
            bottom: -10,
            child: Opacity(
              opacity: 0.1,
              child: Container(
                width: 140,
                height: 90,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Stack(
                  children: [
                    // Ring ropes
                    Positioned(
                      left: 10,
                      right: 10,
                      top: 20,
                      child: Container(height: 2, color: Colors.white),
                    ),
                    Positioned(
                      left: 10,
                      right: 10,
                      top: 40,
                      child: Container(height: 2, color: Colors.white),
                    ),
                    Positioned(
                      left: 10,
                      right: 10,
                      top: 60,
                      child: Container(height: 2, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ];
      case 'athletics':
        return [
          // Running track pattern
          Positioned(
            right: -50,
            bottom: -20,
            child: Opacity(
              opacity: 0.1,
              child: SizedBox(
                width: 160,
                height: 100,
                child: Stack(
                  children: [
                    // Outer track lane
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    // Inner track lane
                    Positioned(
                      left: 20,
                      top: 20,
                      right: 20,
                      bottom: 20,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 2),
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    // Lane dividers
                    ...List.generate(3, (index) =>
                      Positioned(
                        left: 10 + (index * 40),
                        top: 10,
                        bottom: 10,
                        child: Container(
                          width: 1,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ];
      case 'cycling':
        return [
          // Bicycle wheel pattern
          Positioned(
            left: -40,
            bottom: -40,
            child: Opacity(
              opacity: 0.08,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  shape: BoxShape.circle,
                ),
                child: Stack(
                  children: [
                    // Spokes
                    ...List.generate(8, (index) {
                      final angle = (index * 45) * (3.14159 / 180);
                      return Positioned(
                        left: 58,
                        top: 58,
                        child: Transform.rotate(
                          angle: angle,
                          child: Container(
                            width: 2,
                            height: 50,
                            color: Colors.white,
                          ),
                        ),
                      );
                    }),
                    // Center hub
                    Center(
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ];
      default:
        return [
          // Generic sport pattern with enhanced design
          Positioned(
            left: -40,
            bottom: -20,
            child: Opacity(
              opacity: 0.08,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.sportIcon,
                  size: 60,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          // Additional decorative elements
          Positioned(
            right: -20,
            top: -10,
            child: Opacity(
              opacity: 0.05,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ];
    }
  }

  void _showQuizDialog(SportQuiz quiz) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: sportColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.quiz, color: sportColors.primary, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  quiz.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: darkBlue,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                quiz.description,
                style: TextStyle(
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: sportColors.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.help_outline, color: sportColors.primary, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'عدد الأسئلة: ${quiz.questionCount}',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: darkBlue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.timer_outlined, color: sportColors.primary, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'المدة المقترحة: ${quiz.duration}',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: darkBlue,
                          ),
                        ),
                      ],
                    ),
                    if (quiz.isCompleted) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.grade, color: Colors.green, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'النتيجة السابقة: ${quiz.score}%',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'إلغاء',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('بدء اختبار: ${quiz.title}'),
                    backgroundColor: sportColors.primary,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: sportColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                quiz.isCompleted ? 'إعادة الاختبار' : 'بدء الاختبار',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  List<SportLesson> _getLessonsForSport(String sportName) {
    // Sample lessons data based on sport
    switch (sportName.toLowerCase()) {
      case 'football':
        return [
          SportLesson(
            'أساسيات كرة القدم',
            'تعلم المهارات الأساسية في كرة القدم',
            '30 دقيقة',
            'مبتدئ',
            false,
          ),
          SportLesson(
            'تقنيات التمرير',
            'إتقان فن التمرير في كرة القدم',
            '25 دقيقة',
            'متوسط',
            true,
          ),
          SportLesson(
            'التسديد على المرمى',
            'تحسين دقة التسديد وقوته',
            '35 دقيقة',
            'متقدم',
            false,
          ),
        ];
      case 'tennis':
        return [
          SportLesson(
            'قبضة المضرب',
            'تعلم الطريقة الصحيحة لمسك المضرب',
            '20 دقيقة',
            'مبتدئ',
            true,
          ),
          SportLesson(
            'الضربة الأمامية',
            'إتقان الضربة الأمامية الأساسية',
            '30 دقيقة',
            'مبتدئ',
            false,
          ),
        ];
      case 'swimming':
        return [
          SportLesson(
            'تقنيات التنفس',
            'تعلم التنفس الصحيح أثناء السباحة',
            '25 دقيقة',
            'مبتدئ',
            false,
          ),
          SportLesson(
            'سباحة الصدر',
            'إتقان سباحة الصدر خطوة بخطوة',
            '40 دقيقة',
            'متوسط',
            false,
          ),
        ];
      case 'basketball':
        return [
          SportLesson(
            'أساسيات كرة السلة',
            'تعلم المهارات الأساسية في كرة السلة والقواعد الأولية',
            '35 دقيقة',
            'مبتدئ',
            false,
          ),
          SportLesson(
            'تقنيات التصويب',
            'إتقان فن التصويب من مسافات مختلفة',
            '30 دقيقة',
            'متوسط',
            false,
          ),
          SportLesson(
            'المراوغة والتمرير',
            'تطوير مهارات المراوغة والتمرير الدقيق',
            '25 دقيقة',
            'متوسط',
            true,
          ),
        ];
      case 'volleyball':
        return [
          SportLesson(
            'أساسيات الكرة الطائرة',
            'تعلم المهارات الأساسية والمواقف في الكرة الطائرة',
            '30 دقيقة',
            'مبتدئ',
            false,
          ),
          SportLesson(
            'تقنيات الإرسال',
            'إتقان أنواع الإرسال المختلفة',
            '25 دقيقة',
            'متوسط',
            false,
          ),
        ];
      default:
        return [
          SportLesson(
            'مقدمة في $sportName',
            'تعرف على أساسيات رياضة $sportName وقواعدها الأساسية',
            '30 دقيقة',
            'مبتدئ',
            false,
          ),
          SportLesson(
            'تقنيات متقدمة في $sportName',
            'تطوير المهارات المتقدمة في رياضة $sportName',
            '45 دقيقة',
            'متقدم',
            false,
          ),
        ];
    }
  }

  List<SportRule> _getRulesForSport(String sportName) {
    switch (sportName.toLowerCase()) {
      case 'football':
        return [
          SportRule('عدد اللاعبين', 'يتكون كل فريق من 11 لاعباً بما في ذلك حارس المرمى'),
          SportRule('مدة المباراة', 'تستغرق المباراة 90 دقيقة مقسمة إلى شوطين بينهما استراحة 15 دقيقة'),
          SportRule('التسلل', 'اللاعب في موضع تسلل إذا كان أقرب لخط المرمى من الكرة واللاعب الثاني للفريق المنافس'),
          SportRule('البطاقات', 'البطاقة الصفراء للإنذار والحمراء للطرد من المباراة'),
          SportRule('ركلة الجزاء', 'تُمنح عند ارتكاب خطأ داخل منطقة الجزاء'),
        ];
      case 'tennis':
        return [
          SportRule('نظام النقاط', 'النقاط تحسب: 15، 30، 40، ثم الفوز بالشوط'),
          SportRule('الإرسال', 'يجب أن تعبر الكرة الشبكة وتسقط في منطقة الإرسال المحددة'),
          SportRule('تبديل الملعب', 'يتم تبديل الملعب بعد كل شوط فردي'),
          SportRule('الشوط المحسوم', 'في حالة التعادل 6-6 يُلعب شوط محسوم'),
        ];
      case 'basketball':
        return [
          SportRule('عدد اللاعبين', 'يتكون كل فريق من 5 لاعبين في الملعب'),
          SportRule('مدة المباراة', 'تتكون من 4 أرباع كل ربع 12 دقيقة في الدوري الأمريكي'),
          SportRule('النقاط', 'السلة العادية نقطتان، من خلف الخط الثلاثي 3 نقاط'),
          SportRule('الأخطاء', 'اللاعب يُطرد بعد 6 أخطاء شخصية'),
        ];
      case 'swimming':
        return [
          SportRule('أنواع السباحة', 'الحرة، الظهر، الصدر، والفراشة'),
          SportRule('البداية', 'يجب البدء من منصة البداية أو من داخل المسبح'),
          SportRule('اللمس', 'يجب لمس الجدار بكلتا اليدين في سباحة الصدر والفراشة'),
        ];
      case 'volleyball':
        return [
          SportRule('عدد اللاعبين', 'يتكون كل فريق من 6 لاعبين في الملعب'),
          SportRule('النقاط', 'الفوز بالشوط يتطلب 25 نقطة بفارق نقطتين على الأقل'),
          SportRule('اللمسات', 'كل فريق له الحق في 3 لمسات قبل إرسال الكرة للفريق الآخر'),
          SportRule('الدوران', 'يجب على اللاعبين الدوران في اتجاه عقارب الساعة'),
        ];
      default:
        return [
          SportRule('القواعد الأساسية', 'قواعد عامة لرياضة $sportName'),
          SportRule('اللعب النظيف', 'احترام الخصم والحكم والقوانين'),
          SportRule('السلامة', 'اتباع قواعد السلامة أثناء ممارسة الرياضة'),
        ];
    }
  }

  List<SportQuiz> _getQuizzesForSport(String sportName) {
    switch (sportName.toLowerCase()) {
      case 'football':
        return [
          SportQuiz(
            'اختبار أساسيات كرة القدم',
            'اختبر معلوماتك حول القواعد الأساسية لكرة القدم',
            10,
            '15 دقيقة',
            false,
            0,
          ),
          SportQuiz(
            'اختبار قوانين كرة القدم',
            'اختبار متقدم حول قوانين كرة القدم المتقدمة',
            15,
            '20 دقيقة',
            true,
            85,
          ),
        ];
      case 'tennis':
        return [
          SportQuiz(
            'اختبار أساسيات التنس',
            'اختبر معلوماتك حول قواعد التنس الأساسية',
            8,
            '10 دقائق',
            false,
            0,
          ),
        ];
      case 'basketball':
        return [
          SportQuiz(
            'اختبار أساسيات كرة السلة',
            'اختبر معلوماتك حول القواعد الأساسية لكرة السلة',
            12,
            '15 دقيقة',
            false,
            0,
          ),
          SportQuiz(
            'اختبار تقنيات كرة السلة',
            'اختبار متقدم حول التقنيات والاستراتيجيات',
            18,
            '25 دقيقة',
            false,
            0,
          ),
        ];
      case 'swimming':
        return [
          SportQuiz(
            'اختبار تقنيات السباحة',
            'اختبر معلوماتك حول تقنيات السباحة المختلفة',
            12,
            '15 دقيقة',
            false,
            0,
          ),
          SportQuiz(
            'اختبار قوانين السباحة',
            'اختبر معرفتك بقوانين المسابقات والسباقات',
            10,
            '12 دقيقة',
            true,
            92,
          ),
        ];
      case 'volleyball':
        return [
          SportQuiz(
            'اختبار أساسيات الكرة الطائرة',
            'اختبر معلوماتك حول قواعد الكرة الطائرة',
            10,
            '12 دقيقة',
            false,
            0,
          ),
        ];
      default:
        return [
          SportQuiz(
            'اختبار عام في $sportName',
            'اختبر معلوماتك العامة حول رياضة $sportName',
            10,
            '15 دقيقة',
            false,
            0,
          ),
        ];
    }
  }

  SportColors _getSportColors(String sportName) {
    switch (sportName.toLowerCase()) {
      case 'football':
        return SportColors(
          primary: const Color(0xFF1B5E20), // Deep Forest Green
          secondary: const Color(0xFF2E7D32),
          accent: const Color(0xFF4CAF50),
          background: const Color(0xFFE8F5E8),
        );
      case 'tennis':
        return SportColors(
          primary: const Color(0xFFE65100), // Tennis Orange
          secondary: const Color(0xFFFF8F00),
          accent: const Color(0xFFFFB74D),
          background: const Color(0xFFFFF8E1),
        );
      case 'swimming':
        return SportColors(
          primary: const Color(0xFF01579B), // Deep Ocean Blue
          secondary: const Color(0xFF0288D1),
          accent: const Color(0xFF4FC3F7),
          background: const Color(0xFFE1F5FE),
        );
      case 'basketball':
        return SportColors(
          primary: const Color(0xFFBF360C), // Basketball Orange
          secondary: const Color(0xFFFF5722),
          accent: const Color(0xFFFF8A65),
          background: const Color(0xFFFBE9E7),
        );
      case 'boxing':
        return SportColors(
          primary: const Color(0xFFB71C1C), // Boxing Red
          secondary: const Color(0xFFD32F2F),
          accent: const Color(0xFFEF5350),
          background: const Color(0xFFFFEBEE),
        );
      case 'athletics':
        return SportColors(
          primary: const Color(0xFF4A148C), // Athletic Purple
          secondary: const Color(0xFF7B1FA2),
          accent: const Color(0xFFBA68C8),
          background: const Color(0xFFF3E5F5),
        );
      case 'cycling':
        return SportColors(
          primary: const Color(0xFF1B5E20), // Cycling Green
          secondary: const Color(0xFF388E3C),
          accent: const Color(0xFF66BB6A),
          background: const Color(0xFFE8F5E8),
        );
      case 'volleyball':
        return SportColors(
          primary: const Color(0xFFE65100), // Volleyball Orange
          secondary: const Color(0xFFFF9800),
          accent: const Color(0xFFFFB74D),
          background: const Color(0xFFFFF3E0),
        );
      case 'handball':
        return SportColors(
          primary: const Color(0xFF0D47A1), // Handball Blue
          secondary: const Color(0xFF1976D2),
          accent: const Color(0xFF64B5F6),
          background: const Color(0xFFE3F2FD),
        );
      case 'golf':
        return SportColors(
          primary: const Color(0xFF2E7D32), // Golf Green
          secondary: const Color(0xFF4CAF50),
          accent: const Color(0xFF81C784),
          background: const Color(0xFFE8F5E8),
        );
      case 'gymnastics':
        return SportColors(
          primary: const Color(0xFFAD1457), // Gymnastics Pink
          secondary: const Color(0xFFE91E63),
          accent: const Color(0xFFF48FB1),
          background: const Color(0xFFFCE4EC),
        );
      case 'wrestling':
        return SportColors(
          primary: const Color(0xFF5D4037), // Wrestling Brown
          secondary: const Color(0xFF8D6E63),
          accent: const Color(0xFFBCAAA4),
          background: const Color(0xFFEFEBE9),
        );
      case 'archery':
        return SportColors(
          primary: const Color(0xFF6A1B9A), // Archery Purple
          secondary: const Color(0xFF9C27B0),
          accent: const Color(0xFFCE93D8),
          background: const Color(0xFFF3E5F5),
        );
      case 'badminton':
        return SportColors(
          primary: const Color(0xFF00695C), // Badminton Teal
          secondary: const Color(0xFF00897B),
          accent: const Color(0xFF4DB6AC),
          background: const Color(0xFFE0F2F1),
        );
      case 'table tennis':
        return SportColors(
          primary: const Color(0xFFD84315), // Table Tennis Red
          secondary: const Color(0xFFFF5722),
          accent: const Color(0xFFFF8A65),
          background: const Color(0xFFFBE9E7),
        );
      case 'weightlifting':
        return SportColors(
          primary: const Color(0xFF424242), // Weightlifting Gray
          secondary: const Color(0xFF616161),
          accent: const Color(0xFF9E9E9E),
          background: const Color(0xFFF5F5F5),
        );
      default:
        return SportColors(
          primary: primaryBlue,
          secondary: lightBlue,
          accent: accentBlue,
          background: backgroundBlue,
        );
    }
  }
}

// Data classes
class SportLesson {
  final String title;
  final String description;
  final String duration;
  final String level;
  final bool isCompleted;

  SportLesson(this.title, this.description, this.duration, this.level, this.isCompleted);
}

class SportRule {
  final String title;
  final String description;

  SportRule(this.title, this.description);
}

class SportQuiz {
  final String title;
  final String description;
  final int questionCount;
  final String duration;
  final bool isCompleted;
  final int score;

  SportQuiz(this.title, this.description, this.questionCount, this.duration, this.isCompleted, this.score);
}

class SportColors {
  final Color primary;
  final Color secondary;
  final Color accent;
  final Color background;

  SportColors({
    required this.primary,
    required this.secondary,
    required this.accent,
    required this.background,
  });
}
