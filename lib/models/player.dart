import 'package:flutter/material.dart';

/// Represents a player in the quiz game
class Player {
  final String name;
  final Color color;
  int score;
  int correctAnswers;
  List<double> responseTimes;
  bool hasAnswered;

  Player({
    required this.name,
    required this.color,
    this.score = 0,
    this.correctAnswers = 0,
    List<double>? responseTimes,
    this.hasAnswered = false,
  }) : responseTimes = responseTimes ?? [];

  /// Calculate average response time in seconds
  double get averageResponseTime {
    if (responseTimes.isEmpty) return 0;
    return responseTimes.reduce((a, b) => a + b) / responseTimes.length;
  }

  /// Calculate accuracy percentage
  double get accuracy {
    if (responseTimes.isEmpty) return 0;
    return (correctAnswers / responseTimes.length) * 100;
  }

  /// Add points to the player's score
  void addPoints(int points) {
    score += points;
  }

  /// Record a correct answer with response time
  void recordCorrectAnswer(double responseTime) {
    correctAnswers++;
    responseTimes.add(responseTime);
  }

  /// Record an incorrect answer with response time
  void recordIncorrectAnswer(double responseTime) {
    responseTimes.add(responseTime);
  }

  /// Reset player state for new question
  void resetForNewQuestion() {
    hasAnswered = false;
  }

  /// Create a copy of the player with updated values
  Player copyWith({
    String? name,
    Color? color,
    int? score,
    int? correctAnswers,
    List<double>? responseTimes,
    bool? hasAnswered,
  }) {
    return Player(
      name: name ?? this.name,
      color: color ?? this.color,
      score: score ?? this.score,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      responseTimes: responseTimes ?? this.responseTimes,
      hasAnswered: hasAnswered ?? this.hasAnswered,
    );
  }
}
