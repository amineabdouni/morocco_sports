import 'package:flutter/material.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Filter states
  String _selectedSportCategory = 'All';
  String _selectedTeamSport = 'All';
  String _selectedAthleteSport = 'All';
  bool _showActiveOnly = false;

  // Blue color palette (matching home_screen.dart)
  static const Color primaryBlue = Color(0xFF1565C0);
  static const Color lightBlue = Color(0xFF42A5F5);
  static const Color darkBlue = Color(0xFF0D47A1);
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

  // Sample favorite sports data
  final List<FavoriteSport> favoriteSports = [
    FavoriteSport('Football', Icons.sports_soccer, 'Team Sport', 'Most popular sport in Morocco', true),
    FavoriteSport('Tennis', Icons.sports_tennis, 'Individual Sport', 'Racket sport with growing popularity', false),
    FavoriteSport('Basketball', Icons.sports_basketball, 'Team Sport', 'Fast-paced court sport', true),
    FavoriteSport('Swimming', Icons.pool, 'Individual Sport', 'Water-based fitness activity', false),
    FavoriteSport('Athletics', Icons.directions_run, 'Individual Sport', 'Track and field events', true),
    FavoriteSport('Boxing', Icons.sports_mma, 'Individual Sport', 'Combat sport with rich history', false),
  ];

  // Sample favorite teams data
  final List<FavoriteTeam> favoriteTeams = [
    FavoriteTeam('Raja Casablanca', Icons.sports_soccer, 'Football', 'Moroccan football club', Colors.green),
    FavoriteTeam('Wydad Casablanca', Icons.sports_soccer, 'Football', 'Historic Moroccan club', Colors.red),
    FavoriteTeam('Morocco National Team', Icons.flag, 'Football', 'National football team', Colors.red),
    FavoriteTeam('AS Salé', Icons.sports_basketball, 'Basketball', 'Professional basketball team', Colors.blue),
  ];

  // Sample favorite athletes data
  final List<FavoriteAthlete> favoriteAthletes = [
    FavoriteAthlete('Achraf Hakimi', Icons.sports_soccer, 'Football', 'Moroccan defender', 'PSG'),
    FavoriteAthlete('Soufiane El Bakkali', Icons.directions_run, 'Athletics', '3000m steeplechase champion', 'Morocco'),
    FavoriteAthlete('Youssef En-Nesyri', Icons.sports_soccer, 'Football', 'Moroccan striker', 'Fenerbahçe'),
    FavoriteAthlete('Abdelhak Nouri', Icons.sports_tennis, 'Tennis', 'Rising tennis star', 'Morocco'),
  ];

  List<FavoriteSport> get filteredSports {
    var filtered = favoriteSports.where((sport) {
      // Search filter
      bool matchesSearch = _searchQuery.isEmpty ||
          sport.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          sport.category.toLowerCase().contains(_searchQuery.toLowerCase());

      // Category filter
      bool matchesCategory = _selectedSportCategory == 'All' ||
          sport.category == _selectedSportCategory;

      // Active filter
      bool matchesActive = !_showActiveOnly || sport.isActive;

      return matchesSearch && matchesCategory && matchesActive;
    }).toList();

    return filtered;
  }

  List<FavoriteTeam> get filteredTeams {
    var filtered = favoriteTeams.where((team) {
      // Search filter
      bool matchesSearch = _searchQuery.isEmpty ||
          team.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          team.sport.toLowerCase().contains(_searchQuery.toLowerCase());

      // Sport filter
      bool matchesSport = _selectedTeamSport == 'All' ||
          team.sport == _selectedTeamSport;

      return matchesSearch && matchesSport;
    }).toList();

    return filtered;
  }

  List<FavoriteAthlete> get filteredAthletes {
    var filtered = favoriteAthletes.where((athlete) {
      // Search filter
      bool matchesSearch = _searchQuery.isEmpty ||
          athlete.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          athlete.sport.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          athlete.team.toLowerCase().contains(_searchQuery.toLowerCase());

      // Sport filter
      bool matchesSport = _selectedAthleteSport == 'All' ||
          athlete.sport == _selectedAthleteSport;

      return matchesSearch && matchesSport;
    }).toList();

    return filtered;
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  Icon(Icons.filter_list_rounded, color: primaryBlue),
                  const SizedBox(width: 8),
                  const Text(
                    'Filter Options',
                    style: TextStyle(
                      color: darkBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildFilterContent(setDialogState),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedSportCategory = 'All';
                      _selectedTeamSport = 'All';
                      _selectedAthleteSport = 'All';
                      _showActiveOnly = false;
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Clear All',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Apply'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildFilterContent(StateSetter setDialogState) {
    int currentTab = _tabController.index;

    switch (currentTab) {
      case 0: // Sports tab
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Category',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: darkBlue,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: ['All', 'Team Sport', 'Individual Sport'].map((category) {
                bool isSelected = _selectedSportCategory == category;
                return FilterChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (selected) {
                    setDialogState(() {
                      _selectedSportCategory = category;
                    });
                    setState(() {
                      _selectedSportCategory = category;
                    });
                  },
                  selectedColor: lightBlue.withValues(alpha: 0.3),
                  checkmarkColor: primaryBlue,
                  labelStyle: TextStyle(
                    color: isSelected ? primaryBlue : Colors.grey[700],
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text(
                  'Show Active Only',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: darkBlue,
                  ),
                ),
                const Spacer(),
                Switch(
                  value: _showActiveOnly,
                  onChanged: (value) {
                    setDialogState(() {
                      _showActiveOnly = value;
                    });
                    setState(() {
                      _showActiveOnly = value;
                    });
                  },
                  activeColor: primaryBlue,
                ),
              ],
            ),
          ],
        );
      case 1: // Teams tab
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sport',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: darkBlue,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: ['All', 'Football', 'Basketball'].map((sport) {
                bool isSelected = _selectedTeamSport == sport;
                return FilterChip(
                  label: Text(sport),
                  selected: isSelected,
                  onSelected: (selected) {
                    setDialogState(() {
                      _selectedTeamSport = sport;
                    });
                    setState(() {
                      _selectedTeamSport = sport;
                    });
                  },
                  selectedColor: lightBlue.withValues(alpha: 0.3),
                  checkmarkColor: primaryBlue,
                  labelStyle: TextStyle(
                    color: isSelected ? primaryBlue : Colors.grey[700],
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                );
              }).toList(),
            ),
          ],
        );
      case 2: // Athletes tab
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sport',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: darkBlue,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: ['All', 'Football', 'Athletics', 'Tennis'].map((sport) {
                bool isSelected = _selectedAthleteSport == sport;
                return FilterChip(
                  label: Text(sport),
                  selected: isSelected,
                  onSelected: (selected) {
                    setDialogState(() {
                      _selectedAthleteSport = sport;
                    });
                    setState(() {
                      _selectedAthleteSport = sport;
                    });
                  },
                  selectedColor: lightBlue.withValues(alpha: 0.3),
                  checkmarkColor: primaryBlue,
                  labelStyle: TextStyle(
                    color: isSelected ? primaryBlue : Colors.grey[700],
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                );
              }).toList(),
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
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
          'My Favorites',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            onPressed: () {
              _showFilterDialog();
            },
          ),
        ],
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
                      hintText: 'Search favorites...',
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
                  Tab(text: 'Sports'),
                  Tab(text: 'Teams'),
                  Tab(text: 'Athletes'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSportsList(filteredSports),
          _buildTeamsList(filteredTeams),
          _buildAthletesList(filteredAthletes),
        ],
      ),
    );
  }

  Widget _buildSportsList(List<FavoriteSport> sports) {
    if (sports.isEmpty) {
      return _buildEmptyState('No favorite sports', Icons.sports_soccer);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sports.length,
      itemBuilder: (context, index) {
        final sport = sports[index];
        return _buildSportCard(sport);
      },
    );
  }

  Widget _buildTeamsList(List<FavoriteTeam> teams) {
    if (teams.isEmpty) {
      return _buildEmptyState('No favorite teams', Icons.groups);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: teams.length,
      itemBuilder: (context, index) {
        final team = teams[index];
        return _buildTeamCard(team);
      },
    );
  }

  Widget _buildAthletesList(List<FavoriteAthlete> athletes) {
    if (athletes.isEmpty) {
      return _buildEmptyState('No favorite athletes', Icons.person);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: athletes.length,
      itemBuilder: (context, index) {
        final athlete = athletes[index];
        return _buildAthleteCard(athlete);
      },
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add some favorites to see them here',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSportCard(FavoriteSport sport) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: sport.isActive ? lightBlue.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            sport.icon,
            color: sport.isActive ? primaryBlue : Colors.grey[600],
            size: 24,
          ),
        ),
        title: Text(
          sport.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: darkBlue,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              sport.category,
              style: TextStyle(
                color: primaryBlue,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              sport.description,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 13,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(
            sport.isActive ? Icons.favorite : Icons.favorite_border,
            color: sport.isActive ? Colors.red : Colors.grey[400],
          ),
          onPressed: () {
            setState(() {
              sport.isActive = !sport.isActive;
            });
          },
        ),
      ),
    );
  }

  Widget _buildTeamCard(FavoriteTeam team) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: team.color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            team.icon,
            color: team.color,
            size: 24,
          ),
        ),
        title: Text(
          team.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: darkBlue,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              team.sport,
              style: TextStyle(
                color: primaryBlue,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              team.description,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 13,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.favorite, color: Colors.red),
          onPressed: () {
            // Remove from favorites functionality
          },
        ),
      ),
    );
  }

  Widget _buildAthleteCard(FavoriteAthlete athlete) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: lightBlue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            athlete.icon,
            color: primaryBlue,
            size: 24,
          ),
        ),
        title: Text(
          athlete.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: darkBlue,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              '${athlete.sport} • ${athlete.team}',
              style: TextStyle(
                color: primaryBlue,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              athlete.description,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 13,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.favorite, color: Colors.red),
          onPressed: () {
            // Remove from favorites functionality
          },
        ),
      ),
    );
  }
}

// Data classes
class FavoriteSport {
  final String name;
  final IconData icon;
  final String category;
  final String description;
  bool isActive;

  FavoriteSport(this.name, this.icon, this.category, this.description, this.isActive);
}

class FavoriteTeam {
  final String name;
  final IconData icon;
  final String sport;
  final String description;
  final Color color;

  FavoriteTeam(this.name, this.icon, this.sport, this.description, this.color);
}

class FavoriteAthlete {
  final String name;
  final IconData icon;
  final String sport;
  final String description;
  final String team;

  FavoriteAthlete(this.name, this.icon, this.sport, this.description, this.team);
}