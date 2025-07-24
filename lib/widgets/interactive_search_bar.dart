import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/providers.dart';

/// شريط البحث التفاعلي (Interactive Search Bar)
/// يوفر بحث متقدم مع اقتراحات وفلاتر تفاعلية
class InteractiveSearchBar extends StatefulWidget {
  final Function(String)? onSearchChanged;
  final Function(SportCategory?)? onCategoryChanged;
  final Function(int)? onDifficultyChanged;

  const InteractiveSearchBar({
    super.key,
    this.onSearchChanged,
    this.onCategoryChanged,
    this.onDifficultyChanged,
  });

  @override
  State<InteractiveSearchBar> createState() => _InteractiveSearchBarState();
}

class _InteractiveSearchBarState extends State<InteractiveSearchBar>
    with TickerProviderStateMixin {
  late AnimationController _expandController;
  late AnimationController _pulseController;
  late Animation<double> _expandAnimation;
  late Animation<double> _pulseAnimation;
  
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  
  bool _isExpanded = false;
  bool _showSuggestions = false;
  List<String> _suggestions = [];

  @override
  void initState() {
    super.initState();
    
    _expandController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _expandAnimation = CurvedAnimation(
      parent: _expandController,
      curve: Curves.easeOutCubic,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _focusNode.addListener(_onFocusChanged);
    _searchController.addListener(_onSearchChanged);
    
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _expandController.dispose();
    _pulseController.dispose();
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    setState(() {
      _isExpanded = _focusNode.hasFocus;
      _showSuggestions = _focusNode.hasFocus && _searchController.text.isNotEmpty;
    });
    
    if (_isExpanded) {
      _expandController.forward();
    } else {
      _expandController.reverse();
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text;
    
    if (widget.onSearchChanged != null) {
      widget.onSearchChanged!(query);
    }
    
    // تحديث الاقتراحات
    _updateSuggestions(query);
    
    setState(() {
      _showSuggestions = query.isNotEmpty && _focusNode.hasFocus;
    });
  }

  void _updateSuggestions(String query) {
    if (query.isEmpty) {
      _suggestions = [];
      return;
    }
    
    final sportsProvider = context.read<SportsProvider>();
    final searchHistory = sportsProvider.searchHistory;
    final allSports = sportsProvider.allSports;
    
    // اقتراحات من التاريخ
    final historySuggestions = searchHistory
        .where((term) => term.toLowerCase().contains(query.toLowerCase()))
        .take(3)
        .toList();
    
    // اقتراحات من أسماء الرياضات
    final sportSuggestions = allSports
        .where((sport) => 
            sport.name.toLowerCase().contains(query.toLowerCase()) ||
            sport.nameAr.contains(query))
        .map((sport) => sport.nameAr)
        .take(5)
        .toList();
    
    _suggestions = [...historySuggestions, ...sportSuggestions]
        .toSet()
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SportsProvider>(
      builder: (context, sportsProvider, child) {
        return Column(
          children: [
            _buildSearchBar(sportsProvider),
            if (_showSuggestions) _buildSuggestions(),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              child: _isExpanded ? _buildFilters(sportsProvider) : const SizedBox.shrink(),
            ),
          ],
        );
      },
    );
  }

  /// بناء شريط البحث الرئيسي
  Widget _buildSearchBar(SportsProvider sportsProvider) {
    return ScaleTransition(
      scale: _pulseAnimation,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha:0.1),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
          border: Border.all(
            color: _isExpanded 
                ? const Color(0xFF1565C0).withValues(alpha:0.3)
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            // أيقونة البحث
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 12),
              child: Icon(
                Icons.search,
                color: _isExpanded 
                    ? const Color(0xFF1565C0)
                    : Colors.grey[600],
                size: 24,
              ),
            ),
            
            // حقل النص
            Expanded(
              child: TextField(
                controller: _searchController,
                focusNode: _focusNode,
                decoration: InputDecoration(
                  hintText: 'ابحث عن رياضة...',
                  hintStyle: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 16,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF2D3748),
                ),
              ),
            ),
            
            // أزرار الإجراءات
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_searchController.text.isNotEmpty)
                  IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: Colors.grey[600],
                      size: 20,
                    ),
                    onPressed: () {
                      _searchController.clear();
                      _focusNode.unfocus();
                    },
                  ),
                
                IconButton(
                  icon: AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      Icons.tune,
                      color: _isExpanded 
                          ? const Color(0xFF1565C0)
                          : Colors.grey[600],
                      size: 20,
                    ),
                  ),
                  onPressed: () {
                    if (_isExpanded) {
                      _focusNode.unfocus();
                    } else {
                      _focusNode.requestFocus();
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// بناء الاقتراحات
  Widget _buildSuggestions() {
    if (_suggestions.isEmpty) return const SizedBox.shrink();
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: _suggestions.map((suggestion) {
          return ListTile(
            leading: const Icon(
              Icons.history,
              color: Colors.grey,
              size: 20,
            ),
            title: Text(
              suggestion,
              style: const TextStyle(fontSize: 14),
            ),
            onTap: () {
              _searchController.text = suggestion;
              _focusNode.unfocus();
            },
            dense: true,
          );
        }).toList(),
      ),
    );
  }

  /// بناء الفلاتر
  Widget _buildFilters(SportsProvider sportsProvider) {
    return SizeTransition(
      sizeFactor: _expandAnimation,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha:0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // فلتر التصنيف
            _buildCategoryFilter(sportsProvider),
            
            const SizedBox(height: 16),
            
            // فلتر الصعوبة
            _buildDifficultyFilter(sportsProvider),
            
            const SizedBox(height: 16),
            
            // أزرار الإجراءات
            _buildFilterActions(sportsProvider),
          ],
        ),
      ),
    );
  }

  /// بناء فلتر التصنيف
  Widget _buildCategoryFilter(SportsProvider sportsProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'التصنيف',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3748),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            _buildCategoryChip(null, 'الكل', sportsProvider.selectedCategory == null),
            ...SportCategory.values.map((category) {
              return _buildCategoryChip(
                category,
                category.nameAr,
                sportsProvider.selectedCategory == category,
              );
            }),
          ],
        ),
      ],
    );
  }

  /// بناء رقاقة التصنيف
  Widget _buildCategoryChip(SportCategory? category, String label, bool isSelected) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (widget.onCategoryChanged != null) {
          widget.onCategoryChanged!(selected ? category : null);
        }
      },
      selectedColor: const Color(0xFF1565C0).withValues(alpha:0.2),
      checkmarkColor: const Color(0xFF1565C0),
      labelStyle: TextStyle(
        color: isSelected ? const Color(0xFF1565C0) : Colors.grey[700],
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  /// بناء فلتر الصعوبة
  Widget _buildDifficultyFilter(SportsProvider sportsProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'مستوى الصعوبة',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3748),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Text('سهل'),
            Expanded(
              child: Slider(
                value: sportsProvider.selectedDifficulty.toDouble(),
                min: 0,
                max: 5,
                divisions: 5,
                activeColor: const Color(0xFF1565C0),
                onChanged: (value) {
                  if (widget.onDifficultyChanged != null) {
                    widget.onDifficultyChanged!(value.toInt());
                  }
                },
              ),
            ),
            const Text('صعب'),
          ],
        ),
      ],
    );
  }

  /// بناء أزرار الإجراءات
  Widget _buildFilterActions(SportsProvider sportsProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () {
            sportsProvider.clearFilters();
            _searchController.clear();
          },
          child: const Text(
            'مسح الفلاتر',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        
        ElevatedButton(
          onPressed: () {
            _focusNode.unfocus();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1565C0),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: const Text('تطبيق'),
        ),
      ],
    );
  }
}
