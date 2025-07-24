import 'package:flutter/material.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Blue color palette (matching home_screen.dart)
  static const Color primaryBlue = Color(0xFF1565C0);
  static const Color lightBlue = Color(0xFF42A5F5);
  static const Color darkBlue = Color(0xFF0D47A1);
  static const Color accentBlue = Color(0xFF2196F3);
  static const Color backgroundBlue = Color(0xFFE3F2FD);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // Sample news data
  final List<NewsItem> allNews = [
    NewsItem(
      'Morocco Qualifies for World Cup 2030',
      'The Moroccan national team secures their spot in the upcoming World Cup with a stunning victory.',
      'Football',
      '2 hours ago',
      Icons.sports_soccer,
      true,
    ),
    NewsItem(
      'Tennis Championship in Casablanca',
      'International tennis tournament brings world-class players to Morocco.',
      'Tennis',
      '5 hours ago',
      Icons.sports_tennis,
      false,
    ),
    NewsItem(
      'Swimming Records Broken',
      'Young Moroccan swimmer sets new national record in 200m freestyle.',
      'Swimming',
      '1 day ago',
      Icons.pool,
      true,
    ),
    NewsItem(
      'Basketball League Finals',
      'Exciting finals approach as top teams compete for the championship.',
      'Basketball',
      '2 days ago',
      Icons.sports_basketball,
      false,
    ),
    NewsItem(
      'Athletics Training Camp',
      'National athletics team prepares for upcoming international competitions.',
      'Athletics',
      '3 days ago',
      Icons.directions_run,
      false,
    ),
    NewsItem(
      'Boxing Championship Results',
      'Local boxer wins regional championship, eyes international competition.',
      'Boxing',
      '4 days ago',
      Icons.sports_mma,
      true,
    ),
  ];

  List<NewsItem> get filteredNews {
    if (_searchQuery.isEmpty) return allNews;
    return allNews.where((news) =>
      news.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
      news.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
      news.category.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }

  List<NewsItem> get breakingNews => allNews.where((news) => news.isBreaking).toList();
  List<NewsItem> get footballNews => allNews.where((news) => news.category == 'Football').toList();
  List<NewsItem> get sportsNews => allNews.where((news) => news.category != 'Football').toList();

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
          'Sports News',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_rounded),
            onPressed: () {
              // TODO: Show notifications
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
                      hintText: 'Search news...',
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
                  fontSize: 14,
                ),
                dividerColor: Colors.transparent,
                tabs: const [
                  Tab(text: 'All News'),
                  Tab(text: 'Breaking'),
                  Tab(text: 'Football'),
                  Tab(text: 'Sports'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildNewsList(filteredNews),
          _buildNewsList(breakingNews),
          _buildNewsList(footballNews),
          _buildNewsList(sportsNews),
        ],
      ),
    );
  }

  Widget _buildNewsList(List<NewsItem> news) {
    if (news.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.article_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No news available',
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

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: news.length,
      itemBuilder: (context, index) {
        final newsItem = news[index];
        return _buildNewsCard(newsItem);
      },
    );
  }

  Widget _buildNewsCard(NewsItem news) {
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
          // Header with breaking news badge
          if (news.isBreaking)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.red[600],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.flash_on, color: Colors.white, size: 16),
                  const SizedBox(width: 4),
                  const Text(
                    'BREAKING NEWS',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: lightBlue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(news.icon, color: primaryBlue, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            news.category,
                            style: TextStyle(
                              color: primaryBlue,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            news.timeAgo,
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.bookmark_border, color: Colors.grey[400]),
                      onPressed: () {
                        // TODO: Add to bookmarks
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  news.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: darkBlue,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  news.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        // TODO: Read full article
                      },
                      icon: Icon(Icons.article_outlined, size: 16, color: primaryBlue),
                      label: Text(
                        'Read More',
                        style: TextStyle(color: primaryBlue, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Icon(Icons.share_outlined, color: Colors.grey[400]),
                      onPressed: () {
                        // TODO: Share article
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NewsItem {
  final String title;
  final String description;
  final String category;
  final String timeAgo;
  final IconData icon;
  final bool isBreaking;

  NewsItem(
    this.title,
    this.description,
    this.category,
    this.timeAgo,
    this.icon,
    this.isBreaking,
  );
}