import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/player.dart';
import '../models/game_state.dart';
import '../providers/game_provider.dart';
import '../utils/constants.dart';
import 'game_screen.dart';

/// Player setup screen for configuring game
class PlayerSetupScreen extends StatefulWidget {
  final bool isSolo;

  const PlayerSetupScreen({super.key, this.isSolo = false});

  @override
  State<PlayerSetupScreen> createState() => _PlayerSetupScreenState();
}

class _PlayerSetupScreenState extends State<PlayerSetupScreen> {
  int _playerCount = 2;
  final List<TextEditingController> _nameControllers = [];
  String? _selectedCategory;
  String _selectedDifficulty = 'medium';
  List<Map<String, dynamic>> _customCategories = [];

  @override
  void initState() {
    super.initState();
    if (widget.isSolo) {
      _playerCount = 1;
    }
    _initializeControllers();
    _loadCustomCategories();
  }

  Future<void> _loadCustomCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('custom_categories') ?? [];
    setState(() {
      _customCategories = list
          .map((e) => jsonDecode(e) as Map<String, dynamic>)
          .toList();
    });
  }

  void _initializeControllers() {
    _nameControllers.clear();
    for (int i = 0; i < GameConstants.maxPlayers; i++) {
      _nameControllers.add(TextEditingController(text: 'Joueur ${i + 1}'));
    }
  }

  @override
  void dispose() {
    for (var controller in _nameControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _startGame() {
    // Create players
    final players = <Player>[];
    for (int i = 0; i < _playerCount; i++) {
      players.add(
        Player(
          name: _nameControllers[i].text.trim().isEmpty
              ? 'Joueur ${i + 1}'
              : _nameControllers[i].text.trim(),
          color: GameConstants.playerColors[i],
        ),
      );
    }

    // Setup game
    final gameProvider = context.read<GameProvider>();
    gameProvider.setupPlayers(players);

    // Navigate to game screen
    // Navigate to game screen
    int? categoryId;
    String? customCategoryId;

    if (_selectedCategory != null) {
      if (GameConstants.categories.containsKey(_selectedCategory)) {
        categoryId = GameConstants.categories[_selectedCategory];
      } else {
        // Find in custom categories
        final customCat = _customCategories.firstWhere(
          (c) => c['name'] == _selectedCategory,
          orElse: () => {},
        );
        if (customCat.isNotEmpty) {
          customCategoryId = customCat['id'];
        }
      }
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => GameScreen(
          category: categoryId,
          customCategoryId: customCategoryId,
          difficulty: _selectedDifficulty,
          mode: widget.isSolo ? GameMode.solo : GameMode.hotseat,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isSolo ? 'Mode Solo' : 'Configuration de la Partie'),
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Player count selection
                if (!widget.isSolo) ...[
                  Text(
                    'Nombre de joueurs',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                  _buildPlayerCountSelector(),
                  const SizedBox(height: 32),
                ],

                // Player names
                Text(
                  widget.isSolo ? 'Votre Pseudo' : 'Noms des joueurs',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 16),
                _buildPlayerNameInputs(),
                const SizedBox(height: 32),

                // Category selection
                Text(
                  'Catégorie',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 16),
                _buildCategorySelector(),
                const SizedBox(height: 32),

                // Difficulty selection
                Text(
                  'Difficulté',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 16),
                _buildDifficultySelector(),
                const SizedBox(height: 48),

                // Start button
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: _startGame,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6366F1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Commencer la Partie',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerCountSelector() {
    return Row(
      children: List.generate(3, (index) {
        final count = index + 2;
        final isSelected = _playerCount == count;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: index < 2 ? 8 : 0),
            child: GestureDetector(
              onTap: () => setState(() => _playerCount = count),
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF6366F1)
                      : const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF6366F1)
                        : Colors.white24,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    '$count',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.white60,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildPlayerNameInputs() {
    return Column(
      children: List.generate(_playerCount, (index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: GameConstants.playerColors[index],
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _nameControllers[index],
                  decoration: InputDecoration(
                    hintText: 'Joueur ${index + 1}',
                    filled: true,
                    fillColor: const Color(0xFF1E293B),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildCategorySelector() {
    return DropdownButtonFormField<String>(
      value: _selectedCategory,
      decoration: const InputDecoration(
        hintText: 'Toutes les catégories',
        filled: true,
        fillColor: Color(0xFF1E293B),
      ),
      dropdownColor: const Color(0xFF1E293B),
      items: [
        const DropdownMenuItem<String>(
          value: null,
          child: Text('Toutes les catégories'),
        ),
        ...GameConstants.categories.keys.map((category) {
          return DropdownMenuItem<String>(
            value: category,
            child: Text(category),
          );
        }),
        if (_customCategories.isNotEmpty) ...[
          const DropdownMenuItem<String>(
            enabled: false,
            value: 'divider',
            child: Divider(color: Colors.white24),
          ),
          ..._customCategories.map((c) {
            return DropdownMenuItem<String>(
              value: c['name'],
              child: Text('Custom: ${c['name']}'),
            );
          }),
        ],
      ],
      onChanged: (value) => setState(() => _selectedCategory = value),
    );
  }

  Widget _buildDifficultySelector() {
    return Row(
      children: [
        _buildDifficultyChip('Facile', 'easy', const Color(0xFF10B981)),
        const SizedBox(width: 8),
        _buildDifficultyChip('Moyen', 'medium', const Color(0xFFF59E0B)),
        const SizedBox(width: 8),
        _buildDifficultyChip('Difficile', 'hard', const Color(0xFFEF4444)),
      ],
    );
  }

  Widget _buildDifficultyChip(String label, String value, Color color) {
    final isSelected = _selectedDifficulty == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedDifficulty = value),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: isSelected ? color : const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? color : Colors.white24,
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.white60,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
