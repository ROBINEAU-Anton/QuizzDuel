import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'player_setup_screen.dart';
import 'leaderboard_screen.dart';
import 'custom_category_screen.dart';
import '../theme/app_theme.dart';
import '../providers/language_provider.dart';
import '../l10n/gen/app_localizations.dart';

/// Home screen with main menu
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = context.watch<LanguageProvider>();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SafeArea(
          child: Stack(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo and title
                      const Icon(
                        Icons.quiz,
                        size: 100,
                        color: AppTheme.primaryColor,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        AppLocalizations.of(context)!.appTitle,
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppLocalizations.of(context)!.tagline,
                        style: Theme.of(
                          context,
                        ).textTheme.titleLarge?.copyWith(color: Colors.white60),
                      ),
                      const SizedBox(height: 64),

                      // Menu buttons
                      _MenuButton(
                        icon: Icons.play_arrow,
                        label: AppLocalizations.of(context)!.newGame,
                        gradient: AppTheme.primaryGradient,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PlayerSetupScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      _MenuButton(
                        icon: Icons.person,
                        label: AppLocalizations.of(context)!.soloMode,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const PlayerSetupScreen(isSolo: true),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      _MenuButton(
                        icon: Icons.leaderboard,
                        label: AppLocalizations.of(context)!.leaderboard,
                        gradient: const LinearGradient(
                          colors: [Color(0xFFEC4899), Color(0xFFF59E0B)],
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LeaderboardScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      _MenuButton(
                        icon: Icons.edit,
                        label: AppLocalizations.of(context)!.createQuiz,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const CustomCategoryScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      _MenuButton(
                        icon: Icons.info_outline,
                        label: AppLocalizations.of(context)!.howToPlay,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF10B981), Color(0xFF06B6D4)],
                        ),
                        onPressed: () {
                          _showHowToPlay(context);
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Language switcher button in top-right corner
              Positioned(
                top: 16,
                right: 16,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      // Toggle between French and English
                      final newLocale =
                          languageProvider.currentLocale.languageCode == 'fr'
                          ? const Locale('en')
                          : const Locale('fr');
                      languageProvider.setLocale(newLocale);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceColor.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.primaryColor,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.language,
                            color: AppTheme.primaryColor,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            languageProvider.currentLocale.languageCode
                                .toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
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
      ),
    );
  }

  void _showHowToPlay(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Comment Jouer'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '🎮 Mode Hot Seat',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('2 à 4 joueurs sur le même écran'),
              SizedBox(height: 16),
              Text(
                '⚡ Système de Points',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• 100 points par bonne réponse'),
              Text('• Jusqu\'à 50 points bonus de rapidité'),
              SizedBox(height: 16),
              Text(
                '🎯 Objectif',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Répondez correctement et rapidement pour gagner le plus de points !',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Compris !'),
          ),
        ],
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final LinearGradient gradient;
  final VoidCallback onPressed;

  const _MenuButton({
    required this.icon,
    required this.label,
    required this.gradient,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 400),
      height: 70,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: gradient.colors.first.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 32),
                const SizedBox(width: 16),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
