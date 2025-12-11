import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Represents a high score entry
class HighScore {
  final String playerName;
  final int score;
  final int playerCount;
  final DateTime date;

  HighScore({
    required this.playerName,
    required this.score,
    required this.playerCount,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
    'playerName': playerName,
    'score': score,
    'playerCount': playerCount,
    'date': date.toIso8601String(),
  };

  factory HighScore.fromJson(Map<String, dynamic> json) => HighScore(
    playerName: json['playerName'] as String,
    score: json['score'] as int,
    playerCount: json['playerCount'] as int,
    date: DateTime.parse(json['date'] as String),
  );
}

/// Service for managing leaderboard with SharedPreferences
class LeaderboardService {
  static const String _highScoresKey = 'high_scores';
  static const int _maxScores = 10;

  /// Save a new high score
  Future<void> saveScore(HighScore score) async {
    final prefs = await SharedPreferences.getInstance();
    final scores = await getHighScores();

    // Add new score
    scores.add(score);

    // Sort by score (descending)
    scores.sort((a, b) => b.score.compareTo(a.score));

    // Keep only top scores
    final topScores = scores.take(_maxScores).toList();

    // Save to SharedPreferences
    final jsonList = topScores.map((s) => s.toJson()).toList();
    await prefs.setString(_highScoresKey, json.encode(jsonList));
  }

  /// Get all high scores
  Future<List<HighScore>> getHighScores() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_highScoresKey);

    if (jsonString == null) return [];

    final jsonList = json.decode(jsonString) as List;
    return jsonList.map((json) => HighScore.fromJson(json)).toList();
  }

  /// Get high scores filtered by player count
  Future<List<HighScore>> getHighScoresByPlayerCount(int playerCount) async {
    final allScores = await getHighScores();
    return allScores.where((s) => s.playerCount == playerCount).toList();
  }

  /// Clear all high scores
  Future<void> clearHighScores() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_highScoresKey);
  }

  /// Check if a score qualifies for the leaderboard
  Future<bool> isHighScore(int score) async {
    final scores = await getHighScores();
    if (scores.length < _maxScores) return true;
    return score > scores.last.score;
  }
}
