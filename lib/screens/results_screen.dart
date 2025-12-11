import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../widgets/victory_animation.dart';
import 'home_screen.dart';
import 'player_setup_screen.dart';

/// Results screen showing winner and final scores
class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        final players = gameProvider.players;
        final winner = gameProvider.winner;

        // Sort players by score
        final sortedPlayers = List.from(players)
          ..sort((a, b) => b.score.compareTo(a.score));

        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Victory animation
                  if (winner != null)
                    Expanded(
                      flex: 2,
                      child: VictoryAnimation(
                        winnerName: winner.name,
                        winnerColor: winner.color,
                      ),
                    ),

                  // Podium/Scores
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Text(
                            'Résultats Finaux',
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                          const SizedBox(height: 24),

                          // Player scores
                          Expanded(
                            child: ListView.builder(
                              itemCount: sortedPlayers.length,
                              itemBuilder: (context, index) {
                                final player = sortedPlayers[index];
                                return _buildPlayerCard(
                                  context,
                                  player,
                                  index + 1,
                                );
                              },
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Action buttons
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    gameProvider.resetGame();
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const PlayerSetupScreen(),
                                      ),
                                      (route) => false,
                                    );
                                  },
                                  icon: const Icon(Icons.replay),
                                  label: const Text('Rejouer'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF6366F1),
                                    padding: const EdgeInsets.all(16),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    gameProvider.resetGame();
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const HomeScreen(),
                                      ),
                                      (route) => false,
                                    );
                                  },
                                  icon: const Icon(Icons.home),
                                  label: const Text('Menu'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF1E293B),
                                    padding: const EdgeInsets.all(16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlayerCard(BuildContext context, player, int position) {
    IconData medal;
    Color medalColor;

    switch (position) {
      case 1:
        medal = Icons.emoji_events;
        medalColor = const Color(0xFFFFD700); // Gold
        break;
      case 2:
        medal = Icons.emoji_events;
        medalColor = const Color(0xFFC0C0C0); // Silver
        break;
      case 3:
        medal = Icons.emoji_events;
        medalColor = const Color(0xFFCD7F32); // Bronze
        break;
      default:
        medal = Icons.person;
        medalColor = Colors.white60;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              player.color.withOpacity(0.2),
              player.color.withOpacity(0.05),
            ],
          ),
        ),
        child: Row(
          children: [
            // Position medal
            Icon(medal, color: medalColor, size: 32),
            const SizedBox(width: 16),

            // Player info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    player.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: player.color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${player.correctAnswers} bonnes réponses • ${player.accuracy.toStringAsFixed(0)}% précision',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),

            // Score
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: player.color,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${player.score}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
