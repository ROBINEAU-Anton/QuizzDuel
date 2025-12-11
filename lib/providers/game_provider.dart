import 'package:flutter/material.dart';
import '../models/player.dart';
import '../models/question.dart';
import '../models/game_state.dart';
import '../services/trivia_api_service.dart';
import '../services/leaderboard_service.dart';
import '../utils/constants.dart';

/// Provider for managing game state
class GameProvider extends ChangeNotifier {
  final TriviaApiService _apiService = TriviaApiService();
  final LeaderboardService _leaderboardService = LeaderboardService();

  // Game state
  GameState _gameState = GameState.setup;
  GameMode _gameMode = GameMode.hotseat;
  List<Player> _players = [];
  List<Question> _questions = [];
  int _currentQuestionIndex = 0;
  DateTime? _questionStartTime;
  int _timeRemaining = GameConstants.questionTimerSeconds;

  // Getters
  GameState get gameState => _gameState;
  GameMode get gameMode => _gameMode;
  List<Player> get players => _players;
  Question? get currentQuestion =>
      _questions.isEmpty ? null : _questions[_currentQuestionIndex];
  int get currentQuestionNumber => _currentQuestionIndex + 1;
  int get totalQuestions => _questions.length;
  int get timeRemaining => _timeRemaining;
  Player? get winner => _players.isEmpty
      ? null
      : _players.reduce((a, b) => a.score > b.score ? a : b);

  /// Setup players for the game
  void setupPlayers(List<Player> players) {
    _players = players;
    notifyListeners();
  }

  /// Start a new game with specified settings
  Future<void> startGame({
    int? category,
    String? difficulty,
    String? customCategoryId,
    GameMode mode = GameMode.hotseat,
    String language = 'fr',
  }) async {
    _gameState = GameState.playing;
    _gameMode = mode;
    _currentQuestionIndex = 0;

    // Fetch questions from API
    _questions = await _apiService.fetchQuestions(
      amount: GameConstants.questionsPerGame,
      category: category,
      difficulty: difficulty,
      customCategoryId: customCategoryId,
      language: language,
    );

    // Start first question
    _startQuestion();
    notifyListeners();
  }

  /// Start the current question timer
  void _startQuestion() {
    _questionStartTime = DateTime.now();
    _timeRemaining = GameConstants.questionTimerSeconds;

    // Reset player answered state
    for (var player in _players) {
      player.resetForNewQuestion();
    }
  }

  /// Update timer (call this every second)
  void updateTimer() {
    if (_gameState != GameState.playing) return;

    _timeRemaining--;
    notifyListeners();

    // Auto-advance if time runs out
    if (_timeRemaining <= 0) {
      _showQuestionResult();
    }
  }

  /// Handle player answer
  void submitAnswer(Player player, String answer) {
    if (_gameState != GameState.playing) return;
    if (player.hasAnswered) return;
    if (currentQuestion == null) return;

    player.hasAnswered = true;

    // Calculate response time
    final responseTime =
        DateTime.now().difference(_questionStartTime!).inMilliseconds / 1000;

    // Check if answer is correct
    final isCorrect = currentQuestion!.isCorrect(answer);

    if (isCorrect) {
      // Calculate points with speed bonus
      final speedBonus = _calculateSpeedBonus(responseTime);
      final points = GameConstants.basePoints + speedBonus;
      player.addPoints(points);
      player.recordCorrectAnswer(responseTime);
    } else {
      player.recordIncorrectAnswer(responseTime);
    }

    notifyListeners();

    // Check if all players have answered
    if (_players.every((p) => p.hasAnswered)) {
      _showQuestionResult();
    }
  }

  /// Calculate speed bonus based on response time
  int _calculateSpeedBonus(double responseTime) {
    final maxTime = GameConstants.questionTimerSeconds.toDouble();
    final timeRatio = 1 - (responseTime / maxTime);
    final bonus = (timeRatio * GameConstants.maxSpeedBonus).round();
    return bonus.clamp(0, GameConstants.maxSpeedBonus);
  }

  /// Show question result before moving to next question
  void _showQuestionResult() {
    _gameState = GameState.questionResult;
    notifyListeners();

    // Auto-advance after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      nextQuestion();
    });
  }

  /// Move to next question or end game
  void nextQuestion() {
    _currentQuestionIndex++;

    if (_currentQuestionIndex >= _questions.length) {
      _endGame();
    } else {
      _gameState = GameState.playing;
      _startQuestion();
      notifyListeners();
    }
  }

  /// End the game and save scores
  Future<void> _endGame() async {
    _gameState = GameState.gameOver;
    notifyListeners();

    // Save winner's score to leaderboard
    if (winner != null) {
      final highScore = HighScore(
        playerName: winner!.name,
        score: winner!.score,
        playerCount: _players.length,
        date: DateTime.now(),
      );
      await _leaderboardService.saveScore(highScore);
    }
  }

  /// Reset game to setup state
  void resetGame() {
    _gameState = GameState.setup;
    _players = [];
    _questions = [];
    _currentQuestionIndex = 0;
    _questionStartTime = null;
    _timeRemaining = GameConstants.questionTimerSeconds;
    notifyListeners();
  }

  /// Get leaderboard scores
  Future<List<HighScore>> getLeaderboard({int? playerCount}) async {
    if (playerCount != null) {
      return await _leaderboardService.getHighScoresByPlayerCount(playerCount);
    }
    return await _leaderboardService.getHighScores();
  }
}
