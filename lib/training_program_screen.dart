import 'package:flutter/material.dart';

class TrainingProgramScreen extends StatefulWidget {
  const TrainingProgramScreen({super.key});

  @override
  State<TrainingProgramScreen> createState() => _TrainingProgramScreenState();
}

class _TrainingProgramScreenState extends State<TrainingProgramScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;
  int _currentPage = 0;

  // Blue color palette
  static const Color primaryBlue = Color(0xFF1565C0);
  static const Color lightBlue = Color(0xFF42A5F5);
  static const Color darkBlue = Color(0xFF0D47A1);
  static const Color backgroundBlue = Color(0xFFE3F2FD);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _pageController = PageController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundBlue,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryBlue, lightBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),

        title: const Text(
          'برامج التدريب',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.notifications_rounded),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 12,
                      minHeight: 12,
                    ),
                    child: const Text(
                      '3',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () {
              _showNotifications();
            },
            tooltip: 'الإشعارات',
          ),
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            onPressed: () {
              _showFilterDialog();
            },
            tooltip: 'تصفية البرامج',
          ),
        ],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              dividerColor: Colors.transparent,
              tabs: const [
                Tab(text: 'الرياضات الفردية'),
                Tab(text: 'الرياضات الجماعية'),
                Tab(text: 'رياضات المغرب'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTrainingGrid(_getIndividualSportsTraining()),
          _buildTrainingGrid(_getTeamSportsTraining()),
          _buildTrainingGrid(_getMoroccanSportsTraining()),
        ],
      ),
    );
  }

  Widget _buildTrainingGrid(List<TrainingProgram> programs) {
    if (programs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.fitness_center_rounded,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'برامج التدريب قريباً',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return Stack(
      children: [
        PageView.builder(
          controller: _pageController,
          itemCount: programs.length,
          onPageChanged: (index) {
            setState(() {
              _currentPage = index;
            });
          },
          itemBuilder: (context, index) {
            final program = programs[index];
            return _buildFullScreenTrainingCard(program);
          },
        ),
        // Page indicator
        Positioned(
          bottom: 30,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              programs.length,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentPage == index ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentPage == index
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFullScreenTrainingCard(TrainingProgram program) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(_getTrainingImage(program.sportName)),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black.withValues(alpha: 0.7),
              Colors.black.withValues(alpha: 0.3),
              Colors.transparent,
              program.color.withValues(alpha: 0.8),
            ],
            stops: const [0.0, 0.3, 0.7, 1.0],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Back button at the top left
              Positioned(
                top: 20,
                left: 20,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.4),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
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
                        padding: const EdgeInsets.all(14),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Top right buttons
              Positioned(
                top: 20,
                right: 20,
                child: Row(
                  children: [
                    // Share button
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.4),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(25),
                          onTap: () {
                            _shareProgram(program);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            child: const Icon(
                              Icons.share_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Info button
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.4),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(25),
                          onTap: () {
                            _showProgramInfo(program);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            child: const Icon(
                              Icons.info_outline_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Main content
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                const Spacer(flex: 2),
                // Sport Icon
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Icon(
                    program.icon,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 24),
                // Sport Name
                Text(
                  program.sportName,
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black54,
                        offset: Offset(0, 4),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // Description
                Text(
                  program.description,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    height: 1.4,
                    shadows: [
                      Shadow(
                        color: Colors.black54,
                        offset: Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // Program Details
                Row(
                  children: [
                    _buildDetailChip(Icons.schedule_rounded, program.duration),
                    const SizedBox(width: 12),
                    _buildDetailChip(Icons.trending_up_rounded, program.level),
                  ],
                ),
                const SizedBox(height: 16),
                // Rating and Progress
                Row(
                  children: [
                    _buildRatingChip(program.rating),
                    const SizedBox(width: 12),
                    _buildProgressChip(program.completedSessions, program.totalSessions),
                  ],
                ),
                const Spacer(),
                // Start Button with enhanced design
                Container(
                  width: double.infinity,
                  height: 65,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(35),
                    gradient: LinearGradient(
                      colors: [Colors.white, Colors.grey[100]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.8),
                        blurRadius: 10,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(35),
                      onTap: () {
                        _showTrainingDetails(program);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.play_circle_filled_rounded,
                              color: program.color,
                              size: 28,
                            ),
                            const SizedBox(width: 16),
                            Text(
                              'ابدأ التدريب الآن',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: program.color,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: program.color.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Icon(
                                Icons.arrow_forward_rounded,
                                color: program.color,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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

  Widget _buildDetailChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingChip(double rating) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: Colors.amber.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.star_rounded,
            color: Colors.amber,
            size: 18,
          ),
          const SizedBox(width: 6),
          Text(
            rating.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressChip(int completed, int total) {
    double progress = completed / total;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 3,
              backgroundColor: Colors.white.withValues(alpha: 0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$completed/$total',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _getTrainingImage(String sportName) {
    switch (sportName.toLowerCase()) {
      case 'التنس':
        return 'assets/image/nadal.jpg';
      case 'السباحة':
        return 'assets/image/ffffff.jpg';
      case 'ألعاب القوى':
        return 'assets/image/Usain_Bollt__1_-removebg-preview (1).png';
      case 'الملاكمة':
        return 'assets/image/bbbbb.jpg';
      case 'كرة القدم':
        return 'assets/image/messi.jpg';
      case 'كرة السلة':
        return 'assets/image/jjj.jpg';
      case 'كرة القدم المغربية':
        return 'assets/image/messi.jpg';
      default:
        return 'assets/image/messi.jpg';
    }
  }





  void _showTrainingDetails(TrainingProgram program) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TrainingDetailScreen(program: program),
      ),
    );
  }

  void _showNotifications() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Icon(
                    Icons.notifications_rounded,
                    color: primaryBlue,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'إشعارات التدريب',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: primaryBlue,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      // Mark all as read
                    },
                    child: const Text('قراءة الكل'),
                  ),
                ],
              ),
            ),
            // Notifications list
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildNotificationItem(
                    Icons.fitness_center_rounded,
                    'وقت التدريب!',
                    'حان وقت تدريب التنس اليوم',
                    '5 دقائق',
                    Colors.green,
                    true,
                  ),
                  _buildNotificationItem(
                    Icons.star_rounded,
                    'إنجاز جديد!',
                    'لقد أكملت 10 جلسات تدريب',
                    '1 ساعة',
                    Colors.amber,
                    true,
                  ),
                  _buildNotificationItem(
                    Icons.trending_up_rounded,
                    'تحسن في الأداء',
                    'تحسن ملحوظ في برنامج السباحة',
                    '3 ساعات',
                    primaryBlue,
                    false,
                  ),
                  _buildNotificationItem(
                    Icons.schedule_rounded,
                    'تذكير',
                    'لا تنس تدريب الملاكمة غداً',
                    '1 يوم',
                    Colors.orange,
                    false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem(
    IconData icon,
    String title,
    String message,
    String time,
    Color color,
    bool isNew,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isNew ? color.withValues(alpha: 0.1) : Colors.grey[50],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isNew ? color.withValues(alpha: 0.3) : Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                    if (isNew)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'جديد',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _shareProgram(TrainingProgram program) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            // Header
            Row(
              children: [
                Icon(
                  Icons.share_rounded,
                  color: program.color,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  'مشاركة ${program.sportName}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: program.color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Share options
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildShareOption(
                  Icons.message_rounded,
                  'رسالة',
                  Colors.green,
                  () => _shareViaMessage(program),
                ),
                _buildShareOption(
                  Icons.email_rounded,
                  'إيميل',
                  Colors.blue,
                  () => _shareViaEmail(program),
                ),
                _buildShareOption(
                  Icons.copy_rounded,
                  'نسخ',
                  Colors.grey[600]!,
                  () => _copyToClipboard(program),
                ),
                _buildShareOption(
                  Icons.more_horiz_rounded,
                  'المزيد',
                  Colors.orange,
                  () => _shareMore(program),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildShareOption(IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: color.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  void _shareViaMessage(TrainingProgram program) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('مشاركة ${program.sportName} عبر الرسائل'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _shareViaEmail(TrainingProgram program) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('مشاركة ${program.sportName} عبر الإيميل'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _copyToClipboard(TrainingProgram program) {
    Navigator.pop(context);
    String shareText = '''
🏋️ برنامج تدريب ${program.sportName}

📝 الوصف: ${program.description}
⏱️ المدة: ${program.duration}
📊 المستوى: ${program.level}
⭐ التقييم: ${program.rating}/5
💪 التمارين: ${program.totalExercises} تمرين

انضم إلينا في تطبيق Morocco Sports!
    ''';

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم نسخ معلومات البرنامج'),
        backgroundColor: Colors.grey,
      ),
    );
  }

  void _shareMore(TrainingProgram program) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('المزيد من خيارات مشاركة ${program.sportName}'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تصفية البرامج'),
        content: const Text('ميزة التصفية قريباً'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }

  void _showProgramInfo(TrainingProgram program) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(
              program.icon,
              color: program.color,
              size: 28,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'معلومات ${program.sportName}',
                style: TextStyle(
                  color: program.color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(Icons.schedule_rounded, 'المدة', program.duration),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.trending_up_rounded, 'المستوى', program.level),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.fitness_center_rounded, 'التمارين', '24 تمرين'),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.description_rounded, 'الوصف', program.description),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'إغلاق',
              style: TextStyle(color: program.color),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showTrainingDetails(program);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: program.color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: const Text(
              'ابدأ التدريب',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<TrainingProgram> _getIndividualSportsTraining() {
    return [
      TrainingProgram(
        sportName: 'التنس',
        description: 'برنامج تدريب شامل لتحسين مهارات التنس والوصول للاحترافية',
        duration: '8 أسابيع',
        level: 'متوسط',
        icon: Icons.sports_tennis,
        color: const Color(0xFF2E7D32),
        backgroundImage: 'assets/image/nadal.jpg',
        totalExercises: 32,
        rating: 4.8,
        completedSessions: 5,
        totalSessions: 24,
        benefits: ['تحسين التوازن', 'زيادة السرعة', 'تطوير التركيز', 'تقوية العضلات'],
      ),
      TrainingProgram(
        sportName: 'السباحة',
        description: 'تدريب على تقنيات السباحة المختلفة وتحسين اللياقة البدنية',
        duration: '6 أسابيع',
        level: 'مبتدئ',
        icon: Icons.pool,
        color: const Color(0xFF1976D2),
        backgroundImage: 'assets/image/ffffff.jpg',
        totalExercises: 28,
        rating: 4.6,
        completedSessions: 8,
        totalSessions: 18,
        benefits: ['تحسين التنفس', 'تقوية القلب', 'مرونة العضلات', 'حرق السعرات'],
      ),
      TrainingProgram(
        sportName: 'ألعاب القوى',
        description: 'تدريب على الجري والقفز والرمي مع أبطال العالم',
        duration: '10 أسابيع',
        level: 'متقدم',
        icon: Icons.directions_run,
        color: const Color(0xFFE65100),
        backgroundImage: 'assets/image/Usain_Bollt__1_-removebg-preview (1).png',
        totalExercises: 40,
        rating: 4.9,
        completedSessions: 2,
        totalSessions: 30,
        benefits: ['زيادة السرعة', 'تحسين القوة', 'تطوير التحمل', 'تقوية العظام'],
      ),
      TrainingProgram(
        sportName: 'الملاكمة',
        description: 'تدريب على فنون الملاكمة والدفاع عن النفس مع المحترفين',
        duration: '12 أسبوع',
        level: 'متقدم',
        icon: Icons.sports_mma,
        color: const Color(0xFFD32F2F),
        backgroundImage: 'assets/image/bbbbb.jpg',
        totalExercises: 36,
        rating: 4.7,
        completedSessions: 0,
        totalSessions: 36,
        benefits: ['تحسين ردود الأفعال', 'زيادة القوة', 'تطوير التوازن', 'الدفاع عن النفس'],
      ),
      TrainingProgram(
        sportName: 'اليوغا',
        description: 'تدريب على اليوغا لتحسين المرونة والاسترخاء',
        duration: '4 أسابيع',
        level: 'مبتدئ',
        icon: Icons.self_improvement_rounded,
        color: const Color(0xFF7B1FA2),
        backgroundImage: 'assets/image/nadal.jpg',
        totalExercises: 20,
        rating: 4.4,
        completedSessions: 12,
        totalSessions: 16,
        benefits: ['تحسين المرونة', 'تقليل التوتر', 'تحسين التوازن', 'الاسترخاء'],
      ),
    ];
  }

  List<TrainingProgram> _getTeamSportsTraining() {
    return [
      TrainingProgram(
        sportName: 'كرة القدم',
        description: 'برنامج تدريب كرة القدم الاحترافي مع أفضل المدربين',
        duration: '12 أسبوع',
        level: 'جميع المستويات',
        icon: Icons.sports_soccer,
        color: const Color(0xFF2E7D32),
        backgroundImage: 'assets/image/messi.jpg',
        totalExercises: 48,
        rating: 4.9,
        completedSessions: 15,
        totalSessions: 36,
        benefits: ['تحسين اللياقة', 'العمل الجماعي', 'تطوير المهارات', 'التكتيك'],
      ),
      TrainingProgram(
        sportName: 'كرة السلة',
        description: 'تطوير مهارات كرة السلة الأساسية والمتقدمة',
        duration: '8 أسابيع',
        level: 'متوسط',
        icon: Icons.sports_basketball,
        color: const Color(0xFFE65100),
        backgroundImage: 'assets/image/jjj.jpg',
        totalExercises: 35,
        rating: 4.6,
        completedSessions: 6,
        totalSessions: 24,
        benefits: ['تحسين التصويب', 'زيادة الطول', 'تطوير السرعة', 'التنسيق'],
      ),
      TrainingProgram(
        sportName: 'كرة الطائرة',
        description: 'تدريب شامل على كرة الطائرة للمبتدئين والمحترفين',
        duration: '10 أسابيع',
        level: 'متوسط',
        icon: Icons.sports_volleyball,
        color: const Color(0xFF1976D2),
        backgroundImage: 'assets/image/vvv.jpg',
        totalExercises: 30,
        rating: 4.5,
        completedSessions: 4,
        totalSessions: 30,
        benefits: ['تقوية الذراعين', 'تحسين القفز', 'التوازن', 'ردود الأفعال'],
      ),
      TrainingProgram(
        sportName: 'كرة اليد',
        description: 'برنامج تدريب كرة اليد الشامل لتطوير المهارات الفردية والجماعية',
        duration: '9 أسابيع',
        level: 'متوسط',
        icon: Icons.sports_handball,
        color: const Color.fromARGB(255, 24, 4, 80),
        backgroundImage: 'assets/image/hhh.jpg',
        totalExercises: 32,
        rating: 4.7,
        completedSessions: 8,
        totalSessions: 27,
        benefits: ['تقوية اليدين', 'تحسين التصويب', 'السرعة والرشاقة', 'التكتيك الجماعي'],
      ),
    ];
  }

  List<TrainingProgram> _getMoroccanSportsTraining() {
    return [
      TrainingProgram(
        sportName: 'كرة القدم المغربية',
        description: 'تدريب على الطريقة المغربية في كرة القدم',
        duration: '10 أسابيع',
        level: 'متقدم',
        icon: Icons.sports_soccer,
        color: const Color(0xFFD32F2F),
        backgroundImage: 'assets/image/messi.jpg',
      ),
    ];
  }
}

// Data class for Training Program
class TrainingProgram {
  final String sportName;
  final String description;
  final String duration;
  final String level;
  final IconData icon;
  final Color color;
  final String backgroundImage;
  final int totalExercises;
  final double rating;
  final int completedSessions;
  final int totalSessions;
  final bool isBookmarked;
  final List<String> benefits;

  TrainingProgram({
    required this.sportName,
    required this.description,
    required this.duration,
    required this.level,
    required this.icon,
    required this.color,
    required this.backgroundImage,
    this.totalExercises = 24,
    this.rating = 4.5,
    this.completedSessions = 0,
    this.totalSessions = 20,
    this.isBookmarked = false,
    this.benefits = const [],
  });
}

// Training Detail Screen
class TrainingDetailScreen extends StatefulWidget {
  final TrainingProgram program;

  const TrainingDetailScreen({super.key, required this.program});

  @override
  State<TrainingDetailScreen> createState() => _TrainingDetailScreenState();
}

class _TrainingDetailScreenState extends State<TrainingDetailScreen> with TickerProviderStateMixin {
  late TabController _tabController;

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
      backgroundColor: const Color(0xFFE3F2FD),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: widget.program.color,
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [widget.program.color, widget.program.color.withValues(alpha: 0.8)],
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
                    color: widget.program.color.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: widget.program.color,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
        title: Text(
          'تدريب ${widget.program.sportName}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border_rounded),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم حفظ البرنامج')),
              );
            },
            tooltip: 'حفظ البرنامج',
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(200.0),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Program Header
                Row(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        widget.program.icon,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.program.sportName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.program.description,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Program Stats
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatCard('المدة', widget.program.duration, Icons.schedule_rounded),
                    _buildStatCard('المستوى', widget.program.level, Icons.trending_up_rounded),
                    _buildStatCard('التمارين', '24 تمرين', Icons.fitness_center_rounded),
                  ],
                ),
                const SizedBox(height: 20),
                // Tabs
                TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.white,
                  indicatorWeight: 3,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white70,
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                  tabs: const [
                    Tab(text: 'التمارين'),
                    Tab(text: 'الجدول'),
                    Tab(text: 'النصائح'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildExercisesTab(),
                _buildScheduleTab(),
                _buildTipsTab(),
              ],
            ),
          ),
          // Floating back button
          Positioned(
            bottom: 30,
            left: 20,
            child: Container(
              decoration: BoxDecoration(
                color: widget.program.color,
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

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExercisesTab() {
    final exercises = _getExercisesForSport(widget.program.sportName);

    return Column(
      children: [
        // Quick back button at top
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 8.0),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: widget.program.color.withValues(alpha: 0.1),
            border: Border(
              bottom: BorderSide(
                color: widget.program.color.withValues(alpha: 0.2),
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
                    color: widget.program.color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: widget.program.color,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'العودة',
                        style: TextStyle(
                          color: widget.program.color,
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
                '${exercises.length} تمرين',
                style: TextStyle(
                  color: widget.program.color,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        // Exercises list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: exercises.length,
            itemBuilder: (context, index) {
        final exercise = exercises[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: CircleAvatar(
              backgroundColor: widget.program.color.withValues(alpha: 0.2),
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  color: widget.program.color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              exercise.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(exercise.description),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.timer_outlined, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(exercise.duration, style: TextStyle(color: Colors.grey[600])),
                    const SizedBox(width: 16),
                    Icon(Icons.repeat_rounded, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(exercise.reps, style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
              ],
            ),
            trailing: Icon(Icons.play_circle_outline_rounded, color: widget.program.color),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('بدء تمرين ${exercise.name}')),
              );
            },
          ),
        );
      },
            ),
          ),
        ],
      );
    }

  Widget _buildScheduleTab() {
    return Column(
      children: [
        // Quick back button at top
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 8.0),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: widget.program.color.withValues(alpha: 0.1),
            border: Border(
              bottom: BorderSide(
                color: widget.program.color.withValues(alpha: 0.2),
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
                    color: widget.program.color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: widget.program.color,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'العودة',
                        style: TextStyle(
                          color: widget.program.color,
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
                'جدول أسبوعي',
                style: TextStyle(
                  color: widget.program.color,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        // Schedule content
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'الجدول الأسبوعي',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: 7,
              itemBuilder: (context, index) {
                final days = ['الأحد', 'الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت'];
                final isRestDay = index == 5; // Friday is rest day

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isRestDay ? Colors.grey[100] : Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: isRestDay ? Colors.grey[300] : widget.program.color.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          isRestDay ? Icons.hotel_rounded : Icons.fitness_center_rounded,
                          color: isRestDay ? Colors.grey[600] : widget.program.color,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              days[index],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              isRestDay ? 'يوم راحة' : 'تدريب ${widget.program.sportName}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (!isRestDay)
                        Text(
                          '45 دقيقة',
                          style: TextStyle(
                            color: widget.program.color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTipsTab() {
    final tips = _getTipsForSport(widget.program.sportName);

    return Column(
      children: [
        // Quick back button at top
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 8.0),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: widget.program.color.withValues(alpha: 0.1),
            border: Border(
              bottom: BorderSide(
                color: widget.program.color.withValues(alpha: 0.2),
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
                    color: widget.program.color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: widget.program.color,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'العودة',
                        style: TextStyle(
                          color: widget.program.color,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.amber.withValues(alpha: 0.15),
                      Colors.orange.withValues(alpha: 0.15),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.amber.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      children: [
                        Icon(
                          Icons.tips_and_updates_rounded,
                          color: Colors.amber[700],
                          size: 16,
                        ),
                        Positioned(
                          top: -1,
                          right: -1,
                          child: Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.orange.withValues(alpha: 0.5),
                                  blurRadius: 2,
                                  spreadRadius: 0.5,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${tips.length} نصيحة',
                      style: TextStyle(
                        color: Colors.amber[700],
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Tips list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: tips.length,
            itemBuilder: (context, index) {
        final tip = tips[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.grey[50]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.amber.withValues(alpha: 0.2),
                          Colors.orange.withValues(alpha: 0.2),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.amber.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Icon(
                          Icons.tips_and_updates_rounded,
                          color: Colors.amber[700],
                          size: 24,
                        ),
                        Positioned(
                          top: -2,
                          right: -2,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.orange.withValues(alpha: 0.5),
                                  blurRadius: 4,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      tip.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                tip.description,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
            ],
          ),
        );
      },
            ),
          ),
        ],
      );
    }

  List<Exercise> _getExercisesForSport(String sportName) {
    switch (sportName.toLowerCase()) {
      case 'التنس':
        return [
          Exercise('إحماء عام', 'تمارين إحماء للجسم كاملاً', '10 دقائق', '1 مجموعة'),
          Exercise('تمرين الضربة الأمامية', 'تحسين تقنية الضربة الأمامية', '15 دقيقة', '3 مجموعات'),
          Exercise('تمرين الضربة الخلفية', 'تطوير قوة الضربة الخلفية', '15 دقيقة', '3 مجموعات'),
          Exercise('تمرين الإرسال', 'تحسين دقة وقوة الإرسال', '20 دقيقة', '4 مجموعات'),
        ];
      case 'السباحة':
        return [
          Exercise('إحماء في الماء', 'سباحة بطيئة للإحماء', '10 دقائق', '200 متر'),
          Exercise('تمرين السباحة الحرة', 'تحسين تقنية السباحة الحرة', '20 دقيقة', '8x50 متر'),
          Exercise('تمرين سباحة الظهر', 'تطوير عضلات الظهر', '15 دقيقة', '6x50 متر'),
          Exercise('تمرين التنفس', 'تحسين تقنية التنفس', '10 دقائق', '4x25 متر'),
        ];
      default:
        return [
          Exercise('إحماء عام', 'تمارين إحماء أساسية', '10 دقائق', '1 مجموعة'),
          Exercise('تمرين أساسي', 'تمرين أساسي للرياضة', '20 دقيقة', '3 مجموعات'),
          Exercise('تمرين متقدم', 'تمرين متقدم لتطوير المهارات', '15 دقيقة', '2 مجموعة'),
        ];
    }
  }

  List<TrainingTip> _getTipsForSport(String sportName) {
    switch (sportName.toLowerCase()) {
      case 'التنس':
        return [
          TrainingTip('أهمية الإحماء', 'احرص على الإحماء لمدة 10-15 دقيقة قبل بدء التدريب لتجنب الإصابات وتحسين الأداء.'),
          TrainingTip('تقنية الضربة', 'ركز على الحركة الصحيحة للجسم والمضرب بدلاً من القوة فقط.'),
          TrainingTip('التغذية', 'تناول وجبة خفيفة غنية بالكربوهيدرات قبل التدريب بساعتين.'),
        ];
      case 'السباحة':
        return [
          TrainingTip('تقنية التنفس', 'تعلم التنفس الصحيح هو أساس السباحة الجيدة.'),
          TrainingTip('وضعية الجسم', 'حافظ على وضعية أفقية مستقيمة في الماء.'),
          TrainingTip('التدرج في التدريب', 'ابدأ بمسافات قصيرة وزد تدريجياً.'),
        ];
      default:
        return [
          TrainingTip('الانتظام', 'الانتظام في التدريب أهم من شدة التدريب.'),
          TrainingTip('الراحة', 'امنح جسمك وقتاً كافياً للراحة والتعافي.'),
          TrainingTip('التغذية السليمة', 'اتبع نظاماً غذائياً متوازناً يدعم أهدافك التدريبية.'),
        ];
    }
  }
}

// Data classes
class Exercise {
  final String name;
  final String description;
  final String duration;
  final String reps;

  Exercise(this.name, this.description, this.duration, this.reps);
}

class TrainingTip {
  final String title;
  final String description;

  TrainingTip(this.title, this.description);
}
