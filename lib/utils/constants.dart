import 'package:flutter/material.dart';

/// Game configuration constants
class GameConstants {
  // Game settings
  static const int questionsPerGame = 10;
  static const int questionTimerSeconds = 15;
  static const int minPlayers = 2;
  static const int maxPlayers = 4;

  // Scoring
  static const int basePoints = 100;
  static const int maxSpeedBonus = 50;

  // API
  static const String triviaApiBaseUrl = 'https://opentdb.com/api.php';

  // Player colors
  static const List<Color> playerColors = [
    Color(0xFF6366F1), // Indigo
    Color(0xFFEC4899), // Pink
    Color(0xFF10B981), // Green
    Color(0xFFF59E0B), // Amber
  ];

  // Categories from Open Trivia DB
  static const Map<String, int> categories = {
    'Général': 9,
    'Science & Nature': 17,
    'Histoire': 23,
    'Géographie': 22,
    'Sport': 21,
    'Divertissement': 11,
    'Musique': 12,
    'Cinéma': 11,
  };

  // Difficulty levels
  static const List<String> difficulties = ['easy', 'medium', 'hard'];
}
