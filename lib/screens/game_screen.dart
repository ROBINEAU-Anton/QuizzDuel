import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../models/game_state.dart';
import '../widgets/question_card.dart';
import '../widgets/player_zone.dart';
import '../widgets/timer_widget.dart';
import 'results_screen.dart';
import '../widgets/zoom_controls.dart';

/// Main game screen with player zones and questions
class GameScreen extends StatefulWidget {
  final int? category;
  final String? customCategoryId;
  final String difficulty;
  final GameMode mode;

  const GameScreen({
    super.key,
    this.category,
    this.customCategoryId,
    required this.difficulty,
    this.mode = GameMode.hotseat,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  Future<void> _startGame() async {
    final gameProvider = context.read<GameProvider>();
    await gameProvider.startGame(
      category: widget.category,
      difficulty: widget.difficulty,
      customCategoryId: widget.customCategoryId,
      mode: widget.mode,
    );

    // Start timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        gameProvider.updateTimer();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        // Navigate to results when game is over
        if (gameProvider.gameState == GameState.gameOver) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ResultsScreen()),
            );
          });
        }

        final question = gameProvider.currentQuestion;
        if (question == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

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
                  // Header with timer and progress
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      _buildHeader(gameProvider),
                      /* Positioned(
                        top: 0,
                        child: ZoomControls(), // Optional placement
                      ), */
                    ],
                  ),

                  // Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: const Align(alignment: Alignment.centerRight, child: ZoomControls())),
                  const SizedBox(height: 8),

                  // Question card
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: QuestionCard(
                        question: question.question,
                        category: question.category,
                        difficulty: question.difficulty,
                        questionNumber: gameProvider.currentQuestionNumber,
                        totalQuestions: gameProvider.totalQuestions,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Player zones
                  Expanded(flex: 3, child: _buildPlayerZones(gameProvider)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(GameProvider gameProvider) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Round counter
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Question ${gameProvider.currentQuestionNumber}/${gameProvider.totalQuestions}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),

          // Timer
          TimerWidget(timeRemaining: gameProvider.timeRemaining, totalTime: 10),

          const SizedBox(width: 8),
          const ZoomControls(),
        ],
      ),
    );
  }

  Widget _buildPlayerZones(GameProvider gameProvider) {
    final players = gameProvider.players;
    final question = gameProvider.currentQuestion!;
    final showResult = gameProvider.gameState == GameState.questionResult;

    // Layout based on player count
    if (players.length == 2) {
      return Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: PlayerZone(
                player: players[0],
                answers: question.allAnswers,
                onAnswerSelected: (answer) =>
                    gameProvider.submitAnswer(players[0], answer),
                isEnabled: gameProvider.gameState == GameState.playing,
                correctAnswer: question.correctAnswer,
                showResult: showResult,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: PlayerZone(
                player: players[1],
                answers: question.allAnswers,
                onAnswerSelected: (answer) =>
                    gameProvider.submitAnswer(players[1], answer),
                isEnabled: gameProvider.gameState == GameState.playing,
                correctAnswer: question.correctAnswer,
                showResult: showResult,
              ),
            ),
          ),
        ],
      );
    } else if (players.length == 3) {
      return Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: PlayerZone(
                      player: players[0],
                      answers: question.allAnswers,
                      onAnswerSelected: (answer) =>
                          gameProvider.submitAnswer(players[0], answer),
                      isEnabled: gameProvider.gameState == GameState.playing,
                      correctAnswer: question.correctAnswer,
                      showResult: showResult,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: PlayerZone(
                      player: players[1],
                      answers: question.allAnswers,
                      onAnswerSelected: (answer) =>
                          gameProvider.submitAnswer(players[1], answer),
                      isEnabled: gameProvider.gameState == GameState.playing,
                      correctAnswer: question.correctAnswer,
                      showResult: showResult,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: PlayerZone(
                player: players[2],
                answers: question.allAnswers,
                onAnswerSelected: (answer) =>
                    gameProvider.submitAnswer(players[2], answer),
                isEnabled: gameProvider.gameState == GameState.playing,
                correctAnswer: question.correctAnswer,
                showResult: showResult,
              ),
            ),
          ),
        ],
      );
    } else {
      // 4 players - 2x2 grid
      return Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: PlayerZone(
                      player: players[0],
                      answers: question.allAnswers,
                      onAnswerSelected: (answer) =>
                          gameProvider.submitAnswer(players[0], answer),
                      isEnabled: gameProvider.gameState == GameState.playing,
                      correctAnswer: question.correctAnswer,
                      showResult: showResult,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: PlayerZone(
                      player: players[1],
                      answers: question.allAnswers,
                      onAnswerSelected: (answer) =>
                          gameProvider.submitAnswer(players[1], answer),
                      isEnabled: gameProvider.gameState == GameState.playing,
                      correctAnswer: question.correctAnswer,
                      showResult: showResult,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: PlayerZone(
                      player: players[2],
                      answers: question.allAnswers,
                      onAnswerSelected: (answer) =>
                          gameProvider.submitAnswer(players[2], answer),
                      isEnabled: gameProvider.gameState == GameState.playing,
                      correctAnswer: question.correctAnswer,
                      showResult: showResult,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: PlayerZone(
                      player: players[3],
                      answers: question.allAnswers,
                      onAnswerSelected: (answer) =>
                          gameProvider.submitAnswer(players[3], answer),
                      isEnabled: gameProvider.gameState == GameState.playing,
                      correctAnswer: question.correctAnswer,
                      showResult: showResult,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
  }
}
