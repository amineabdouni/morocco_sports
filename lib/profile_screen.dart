import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:morocco_sports/language_manager.dart';
import 'package:morocco_sports/theme_manager.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Simple color palette
  static const Color primaryBlue = Color(0xFF1565C0);
  static const Color lightBlue = Color(0xFF42A5F5);
  static const Color darkBlue = Color(0xFF0D47A1);
  static const Color backgroundBlue = Color(0xFFE3F2FD);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundBlue,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        title: Text(
          AppLocalizations.of(context)!.profile,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: () {
              _showSettings();
            },
            tooltip: 'الإعدادات',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile Header
            _buildProfileHeader(),
            const SizedBox(height: 24),

            // Stats Section
            _buildStatsSection(),
            const SizedBox(height: 24),

            // Enthusiasm Section
            _buildEnthusiasmSection(),
            const SizedBox(height: 24),

            // Menu Section
            _buildMenuSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Profile Picture
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [primaryBlue, lightBlue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Icon(
              Icons.person_rounded,
              size: 50,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),

          // Name
          Text(
            AppLocalizations.of(context)!.aminAbdouni,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: darkBlue,
            ),
          ),
          const SizedBox(height: 8),

          // Location
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on_rounded,
                color: Colors.grey[600],
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                AppLocalizations.of(context)!.rabatMorocco,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Level Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: primaryBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: primaryBlue.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.emoji_events_rounded,
                  color: primaryBlue,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  AppLocalizations.of(context)!.professionalAthlete,
                  style: TextStyle(
                    color: primaryBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
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
          Text(
            AppLocalizations.of(context)!.statistics,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: darkBlue,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildStatCard(AppLocalizations.of(context)!.favoriteSports, '8', Icons.favorite_rounded)),
              const SizedBox(width: 12),
              Expanded(child: _buildStatCard(AppLocalizations.of(context)!.trainings, '24', Icons.fitness_center_rounded)),
              const SizedBox(width: 12),
              Expanded(child: _buildStatCard(AppLocalizations.of(context)!.achievements, '12', Icons.emoji_events_rounded)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Theme.of(context).primaryColor, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEnthusiasmSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.orange, Colors.red],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.local_fire_department_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                AppLocalizations.of(context)!.enthusiasm,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Enthusiasm Level Indicator
          Row(
            children: [
              Text(
                AppLocalizations.of(context)!.motivationLevel,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).textTheme.titleMedium?.color,
                ),
              ),
              const Spacer(),
              Text(
                '85%',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Progress Bar
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: 0.85,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.orange, Colors.red],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Enthusiasm Indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildEnthusiasmIndicator(
                '🔥',
                'نشاط عالي',
                'High Activity',
                'Activité Élevée',
                Colors.red,
              ),
              _buildEnthusiasmIndicator(
                '⚡',
                'طاقة إيجابية',
                'Positive Energy',
                'Énergie Positive',
                Colors.orange,
              ),
              _buildEnthusiasmIndicator(
                '🎯',
                'تركيز قوي',
                'Strong Focus',
                'Concentration Forte',
                Colors.blue,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEnthusiasmIndicator(String emoji, String titleAr, String titleEn, String titleFr, Color color) {
    String title;
    final languageCode = Localizations.localeOf(context).languageCode;

    switch (languageCode) {
      case 'ar':
        title = titleAr;
        break;
      case 'en':
        title = titleEn;
        break;
      case 'fr':
        title = titleFr;
        break;
      default:
        title = titleAr;
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: color.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Text(
            emoji,
            style: const TextStyle(fontSize: 24),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildMenuSection() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildMenuItem(AppLocalizations.of(context)!.favorites, Icons.favorite_rounded, () {}),
          _buildMenuItem(AppLocalizations.of(context)!.achievements, Icons.emoji_events_rounded, () {}),
          _buildMenuItem(AppLocalizations.of(context)!.activityHistory, Icons.history_rounded, () {}),
          _buildMenuItem(AppLocalizations.of(context)!.notifications, Icons.notifications_rounded, () {}),
          _buildMenuItem(AppLocalizations.of(context)!.settings, Icons.settings_rounded, () => _showSettings()),
          _buildMenuItem(AppLocalizations.of(context)!.help, Icons.help_rounded, () {}),
          _buildMenuItem(AppLocalizations.of(context)!.about, Icons.info_rounded, () {}),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Theme.of(context).primaryColor, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: Theme.of(context).textTheme.titleMedium?.color,
          fontSize: 16,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        size: 16,
        color: Colors.grey[400],
      ),
      onTap: onTap,
    );
  }

  void _showSettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Consumer2<LanguageManager, ThemeManager>(
        builder: (context, languageManager, themeManager, child) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  AppLocalizations.of(context)!.settings,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.titleLarge?.color,
                  ),
                ),
                const SizedBox(height: 20),

                // Language Selection
                ListTile(
                  leading: Icon(Icons.language_rounded, color: Theme.of(context).primaryColor),
                  title: Text(AppLocalizations.of(context)!.language),
                  subtitle: Text(languageManager.getLanguageName(languageManager.currentLocale.languageCode)),
                  trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey[400]),
                  onTap: () {
                    Navigator.pop(context);
                    _showLanguageDialog();
                  },
                ),

                // Theme Selection
                ListTile(
                  leading: Icon(
                    themeManager.isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Text(AppLocalizations.of(context)!.theme),
                  subtitle: Text(
                    themeManager.isDarkMode
                        ? AppLocalizations.of(context)!.dark
                        : AppLocalizations.of(context)!.light
                  ),
                  trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey[400]),
                  onTap: () {
                    Navigator.pop(context);
                    _showThemeDialog();
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.logout_rounded, color: Colors.red),
                  title: Text(AppLocalizations.of(context)!.logout),
                  onTap: () {},
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showLanguageDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Consumer<LanguageManager>(
        builder: (context, languageManager, child) {
          return Container(
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
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  AppLocalizations.of(context)!.language,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: darkBlue,
                  ),
                ),
                const SizedBox(height: 20),

                // Language Options
                ...LanguageManager.supportedLocales.map((locale) {
                  final isSelected = languageManager.currentLocale.languageCode == locale.languageCode;
                  return ListTile(
                    leading: Text(
                      languageManager.getLanguageFlag(locale.languageCode),
                      style: const TextStyle(fontSize: 24),
                    ),
                    title: Text(
                      languageManager.getLanguageName(locale.languageCode),
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? primaryBlue : Colors.black,
                      ),
                    ),
                    trailing: isSelected
                        ? Icon(Icons.check_circle_rounded, color: primaryBlue)
                        : null,
                    onTap: () {
                      languageManager.changeLanguage(locale.languageCode);
                      Navigator.pop(context);
                    },
                  );
                }),

                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showThemeDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Consumer<ThemeManager>(
        builder: (context, themeManager, child) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  AppLocalizations.of(context)!.theme,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.titleLarge?.color,
                  ),
                ),
                const SizedBox(height: 20),

                // Light Mode Option
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.light_mode_rounded,
                      color: Colors.orange,
                      size: 24,
                    ),
                  ),
                  title: Text(
                    AppLocalizations.of(context)!.lightMode,
                    style: TextStyle(
                      fontWeight: !themeManager.isDarkMode ? FontWeight.bold : FontWeight.normal,
                      color: !themeManager.isDarkMode ? Theme.of(context).primaryColor : null,
                    ),
                  ),
                  trailing: !themeManager.isDarkMode
                      ? Icon(Icons.check_circle_rounded, color: Theme.of(context).primaryColor)
                      : null,
                  onTap: () {
                    themeManager.setTheme(ThemeMode.light);
                    Navigator.pop(context);
                  },
                ),

                // Dark Mode Option
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.indigo.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.dark_mode_rounded,
                      color: Colors.indigo,
                      size: 24,
                    ),
                  ),
                  title: Text(
                    AppLocalizations.of(context)!.darkMode,
                    style: TextStyle(
                      fontWeight: themeManager.isDarkMode ? FontWeight.bold : FontWeight.normal,
                      color: themeManager.isDarkMode ? Theme.of(context).primaryColor : null,
                    ),
                  ),
                  trailing: themeManager.isDarkMode
                      ? Icon(Icons.check_circle_rounded, color: Theme.of(context).primaryColor)
                      : null,
                  onTap: () {
                    themeManager.setTheme(ThemeMode.dark);
                    Navigator.pop(context);
                  },
                ),

                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}