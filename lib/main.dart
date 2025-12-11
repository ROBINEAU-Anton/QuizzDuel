import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/game_provider.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:projetquizzia/l10n/gen/app_localizations.dart';
import 'providers/language_provider.dart';

import 'providers/zoom_provider.dart';

void main() {
  runApp(const QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GameProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => ZoomProvider()),
      ],
      child: Consumer2<LanguageProvider, ZoomProvider>(
        builder: (context, languageProvider, zoomProvider, child) {
          return MaterialApp(
            title: 'Quiz Duel',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.theme,
            locale: languageProvider.currentLocale,
            builder: (context, child) {
              final mediaQuery = MediaQuery.of(context);
              return MediaQuery(
                data: mediaQuery.copyWith(
                  textScaleFactor: zoomProvider.textScaleFactor,
                ),
                child: child!,
              );
            },
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en'), Locale('fr')],
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
