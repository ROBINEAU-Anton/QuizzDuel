import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../services/leaderboard_service.dart';
import 'package:intl/intl.dart';

/// Leaderboard screen showing high scores
class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  int? _filterPlayerCount;

  @override
  Widget build(BuildContext context) {
    final gameProvider = context.read<GameProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Classement'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
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
              // Filter chips
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    _buildFilterChip('Tous', null),
                    const SizedBox(width: 8),
                    _buildFilterChip('2 joueurs', 2),
                    const SizedBox(width: 8),
                    _buildFilterChip('3 joueurs', 3),
                    const SizedBox(width: 8),
                    _buildFilterChip('4 joueurs', 4),
                  ],
                ),
              ),

              // Leaderboard list
              Expanded(
                child: FutureBuilder<List<HighScore>>(
                  future: gameProvider.getLeaderboard(
                    playerCount: _filterPlayerCount,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.emoji_events_outlined,
                              size: 80,
                              color: Colors.white24,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Aucun score enregistré',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(color: Colors.white60),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Jouez une partie pour apparaître ici !',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      );
                    }

                    final scores = snapshot.data!;
                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: scores.length,
                      itemBuilder: (context, index) {
                        return _buildScoreCard(scores[index], index + 1);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, int? playerCount) {
    final isSelected = _filterPlayerCount == playerCount;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _filterPlayerCount = playerCount),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF6366F1)
                : const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? const Color(0xFF6366F1) : Colors.white24,
              width: 2,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.white60,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScoreCard(HighScore score, int position) {
    Color positionColor;
    switch (position) {
      case 1:
        positionColor = const Color(0xFFFFD700); // Gold
        break;
      case 2:
        positionColor = const Color(0xFFC0C0C0); // Silver
        break;
      case 3:
        positionColor = const Color(0xFFCD7F32); // Bronze
        break;
      default:
        positionColor = Colors.white60;
    }

    final dateFormat = DateFormat('dd/MM/yyyy');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Position
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: positionColor.withOpacity(0.2),
                shape: BoxShape.circle,
                border: Border.all(color: positionColor, width: 2),
              ),
              child: Center(
                child: Text(
                  '$position',
                  style: TextStyle(
                    color: positionColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Player info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    score.playerName,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${score.playerCount} joueurs • ${dateFormat.format(score.date)}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),

            // Score
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${score.score}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
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
