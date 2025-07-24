import 'package:flutter/material.dart';
import 'sport_details_screen.dart';
import 'favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int currentIndex = 0;
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Blue color palette
  static const Color primaryBlue = Color(0xFF1565C0);
  static const Color lightBlue = Color(0xFF42A5F5);
  static const Color darkBlue = Color(0xFF0D47A1);
  static const Color backgroundBlue = Color.fromARGB(255, 220, 240, 254);

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

  void _onPressed(index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundBlue,
      appBar: AppBar(
        backgroundColor: primaryBlue,
        elevation: 0,
        title: const Text(
          'Morocco Sports',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FavoritesScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: primaryBlue,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search sports...',
                hintStyle: TextStyle(color: Colors.grey[400]),
                prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
            ),
          ),

          // Tab Bar
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: primaryBlue,
              ),
              labelColor: Colors.white,
              unselectedLabelColor: primaryBlue,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              tabs: const [
                Tab(text: 'Individual'),
                Tab(text: 'Team Sports'),
                Tab(text: 'Morocco'),
              ],
            ),
          ),

          // Tab Bar View
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildSportsGrid(_getFilteredSports(individualSports)),
                _buildSportsGrid(_getFilteredSports(teamSports)),
                _buildSportsGrid(_getFilteredSports(moroccanSports)),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: _onPressed,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: primaryBlue,
          unselectedItemColor: Colors.grey,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.sports),
              label: 'Sports',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.fitness_center),
              label: 'Training',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  List<SportItem> _getFilteredSports(List<SportItem> sports) {
    if (_searchQuery.isEmpty) {
      return sports;
    }
    return sports.where((sport) {
      return sport.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             sport.description.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  Widget _buildSportsGrid(List<SportItem> sports) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: sports.length,
        itemBuilder: (context, index) {
          return _buildSportCard(sports[index]);
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
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: primaryBlue.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                sport.icon,
                size: 40,
                color: primaryBlue,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              sport.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
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

  // Individual Sports Data
  final List<SportItem> individualSports = [
    SportItem('Running', Icons.directions_run, 'Cardiovascular endurance sport'),
    SportItem('Swimming', Icons.pool, 'Full body water sport'),
    SportItem('Cycling', Icons.directions_bike, 'Leg strength and endurance'),
    SportItem('Tennis', Icons.sports_tennis, 'Racket sport for agility'),
    SportItem('Boxing', Icons.sports_mma, 'Combat sport for strength'),
    SportItem('Yoga', Icons.self_improvement, 'Flexibility and mindfulness'),
    SportItem('Weightlifting', Icons.fitness_center, 'Strength training sport'),
    SportItem('Athletics', Icons.track_changes, 'Track and field events'),
  ];

  // Team Sports Data
  final List<SportItem> teamSports = [
    SportItem('Football', Icons.sports_soccer, 'Most popular team sport'),
    SportItem('Basketball', Icons.sports_basketball, 'Fast-paced court sport'),
    SportItem('Volleyball', Icons.sports_volleyball, 'Net-based team sport'),
    SportItem('Handball', Icons.sports_handball, 'Indoor team sport'),
    SportItem('Rugby', Icons.sports_rugby, 'Physical contact team sport'),
    SportItem('Hockey', Icons.sports_hockey, 'Stick and ball team sport'),
    SportItem('Baseball', Icons.sports_baseball, 'Bat and ball team sport'),
    SportItem('Cricket', Icons.sports_cricket, 'Wicket-based team sport'),
  ];

  // Moroccan Sports Data
  final List<SportItem> moroccanSports = [
    SportItem('Fantasia', Icons.sports, 'Traditional Moroccan equestrian art'),
    SportItem('Tbourida', Icons.festival, 'Moroccan cultural horse performance'),
    SportItem('Moroccan Wrestling', Icons.sports_mma, 'Traditional combat sport'),
    SportItem('Gnawa Music Sport', Icons.music_note, 'Cultural rhythmic activity'),
    SportItem('Desert Racing', Icons.terrain, 'Sahara endurance challenges'),
    SportItem('Atlas Hiking', Icons.hiking, 'Mountain trekking adventures'),
    SportItem('Surfing Taghazout', Icons.surfing, 'Atlantic coast surfing'),
    SportItem('Berber Games', Icons.sports, 'Traditional Amazigh competitions'),
  ];
}

// SportItem class to represent individual sports
class SportItem {
  final String name;
  final IconData icon;
  final String description;

  SportItem(this.name, this.icon, this.description);
}