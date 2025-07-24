import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:morocco_sports/obboarding_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// استيراد النظام الجديد
import 'providers/providers.dart';
import 'cores/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة خدمة التخزين
  await StorageService.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // المزودين الأساسيين
        ChangeNotifierProvider(create: (context) => LanguageManager()),
        ChangeNotifierProvider(create: (context) => ThemeManager()),

        // المزودين الجدد
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => SportsProvider()),
        ChangeNotifierProvider(create: (context) => ChallengesProvider()),
      ],
      child: Consumer3<LanguageManager, ThemeManager, UserProvider>(
        builder: (context, languageManager, themeManager, userProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Morocco Sports',
            locale: userProvider.currentLocale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: LanguageManager.supportedLocales,
            theme: ThemeManager.lightTheme,
            darkTheme: ThemeManager.darkTheme,
            themeMode: userProvider.currentThemeMode,
            home: const OnboardingScreen(),
          );
        },
      ),
    );
  }
}


