import 'package:flutter/material.dart';
import 'package:morocco_sports/sport_details_screen.dart';
import 'package:morocco_sports/training_program_screen.dart';
import 'favorites_screen.dart';
import 'news_screen.dart';
import 'profile_screen.dart';
import 'screens/enhanced_home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  // Blue color palette (matching other screens)
  static const Color primaryBlue = Color(0xFF1565C0);

  final List<Widget> screens = [
    const EnhancedHomeScreen(),
    const FavoritesScreen(),
    const NewsScreen(),
    const ProfileScreen(),
  ];

  void _onPressed(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedItemColor: primaryBlue,
          unselectedItemColor: Colors.grey[600],
          currentIndex: currentIndex,
          onTap: _onPressed,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_rounded),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_rounded),
              label: 'News',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

// Extract the content part of HomeScreen to avoid navigation conflicts
class HomeScreenContent extends StatefulWidget {
  const HomeScreenContent({super.key});

  @override
  State<HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Blue color palette
  static const Color primaryBlue = Color(0xFF1565C0);
  static const Color lightBlue = Color(0xFF42A5F5);
  static const Color darkBlue = Color(0xFF0D47A1);
  static const Color accentBlue = Color(0xFF2196F3);
  static const Color backgroundBlue = Color(0xFFE3F2FD);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // Individual Sports Data
  final List<SportItem> individualSports = [
    SportItem('Tennis', Icons.sports_tennis, 'Individual racket sport'),
    SportItem('Swimming', Icons.pool, 'Water-based individual sport'),
    SportItem('Athletics', Icons.directions_run, 'Track and field events'),
    SportItem('Boxing', Icons.sports_mma, 'Combat sport'),
    SportItem('Cycling', Icons.directions_bike, 'Bicycle racing'),
    SportItem('Golf', Icons.sports_golf, 'Precision club sport'),
    SportItem('Gymnastics', Icons.accessibility_new, 'Artistic movement sport'),
    SportItem('Wrestling', Icons.sports_kabaddi, 'Grappling combat sport'),
    SportItem('Archery', Icons.my_location, 'Bow and arrow sport'),
    SportItem('Badminton', Icons.sports_tennis, 'Racket sport with shuttlecock'),
    SportItem('Table Tennis', Icons.sports_tennis, 'Indoor racket sport'),
    SportItem('Weightlifting', Icons.fitness_center, 'Strength sport'),
  ];

  // Team Sports Data
  final List<SportItem> teamSports = [
    SportItem('Football', Icons.sports_soccer, 'Most popular team sport'),
    SportItem('Basketball', Icons.sports_basketball, '5v5 court sport'),
    SportItem('Volleyball', Icons.sports_volleyball, 'Net-based team sport'),
    SportItem('Handball', Icons.sports_handball, 'Indoor team sport'),
    SportItem('Rugby', Icons.sports_rugby, 'Contact team sport'),
    SportItem('Hockey', Icons.sports_hockey, 'Stick and ball sport'),
    SportItem('Water Polo', Icons.pool, 'Aquatic team sport'),
    SportItem('Baseball', Icons.sports_baseball, 'Bat and ball sport'),
    SportItem('Cricket', Icons.sports_cricket, 'Bat and ball team sport'),
    SportItem('American Football', Icons.sports_football, 'Gridiron sport'),
  ];

  // Popular Sports in Morocco
  final List<SportItem> moroccanSports = [
    SportItem('Football', Icons.sports_soccer, 'National passion'),
    SportItem('Athletics', Icons.directions_run, 'Olympic tradition'),
    SportItem('Boxing', Icons.sports_mma, 'Strong heritage'),
    SportItem('Tennis', Icons.sports_tennis, 'Growing popularity'),
    SportItem('Basketball', Icons.sports_basketball, 'Youth favorite'),
    SportItem('Swimming', Icons.pool, 'Coastal advantage'),
  ];

  List<SportItem> _getFilteredSports(List<SportItem> sports) {
    if (_searchQuery.isEmpty) return sports;
    return sports.where((sport) => 
      sport.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
      sport.description.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundBlue,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
        title: const Text(
          'Morocco Sports',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.person_rounded, 
              color: primaryBlue, 
              size: 24
            ),
          ),
        ],
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.fitness_center_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TrainingProgramScreen(),
              ),
            );
          },
          tooltip: 'برامج التدريب',
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(120.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Search sports...',
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      prefixIcon: Icon(Icons.search, color: primaryBlue),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear, color: Colors.grey[600]),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _searchQuery = '';
                                });
                              },
                            )
                          : null,
                    ),
                  ),
                ),
              ),
              TabBar(
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
                  Tab(text: 'Individual'),
                  Tab(text: 'Team Sports'),
                  Tab(text: 'Morocco'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSportsGrid(_getFilteredSports(individualSports)),
          _buildSportsGrid(_getFilteredSports(teamSports)),
          _buildSportsGrid(_getFilteredSports(moroccanSports)),
        ],
      ),
    );
  }

  Widget _buildSportsGrid(List<SportItem> sports) {
    if (sports.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No sports found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.1,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: sports.length,
        itemBuilder: (context, index) {
          final sport = sports[index];
          return _buildSportCard(sport);
        },
      ),
    );
  }

  Widget _buildSportCard(SportItem sport) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SportDetailsScreen(
              sportName: sport.name,
              sportIcon: sport.icon,
              sportDescription: sport.description,
            ),
          ),
        );
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('${sport.name} selected'),
        //     backgroundColor: primaryBlue,
        //     behavior: SnackBarBehavior.floating,
        //     shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(10),
        //     ),
        //   ),
        // );
      },
      child: Container(
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: lightBlue.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                sport.icon,
                size: 32,
                color: primaryBlue,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              sport.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: darkBlue,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                sport.description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// SportItem class to represent individual sports
class SportItem {
  final String name;
  final IconData icon;
  final String description;

  SportItem(this.name, this.icon, this.description);
}
