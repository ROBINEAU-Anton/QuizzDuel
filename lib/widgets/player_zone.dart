import 'package:flutter/material.dart';
import '../models/player.dart';

/// Individual player zone widget
class PlayerZone extends StatefulWidget {
  final Player player;
  final List<String> answers;
  final Function(String) onAnswerSelected;
  final bool isEnabled;
  final String? correctAnswer;
  final bool showResult;

  const PlayerZone({
    super.key,
    required this.player,
    required this.answers,
    required this.onAnswerSelected,
    this.isEnabled = true,
    this.correctAnswer,
    this.showResult = false,
  });

  @override
  State<PlayerZone> createState() => _PlayerZoneState();
}

class _PlayerZoneState extends State<PlayerZone>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  String? _selectedAnswer;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(PlayerZone oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reset selected answer when question changes
    if (oldWidget.answers != widget.answers) {
      _selectedAnswer = null;
    }
  }

  void _handleAnswerTap(String answer) {
    if (!widget.isEnabled || widget.player.hasAnswered) return;

    setState(() {
      _selectedAnswer = answer;
    });

    widget.onAnswerSelected(answer);

    // Trigger animation
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: widget.player.color.withOpacity(0.1),
        border: Border.all(color: widget.player.color, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Player header
          _buildHeader(),
          const SizedBox(height: 8),

          // Answer buttons
          Expanded(child: _buildAnswerButtons()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: widget.player.color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              widget.player.name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            '${widget.player.score}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerButtons() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1.5,
      ),
      itemCount: widget.answers.length,
      itemBuilder: (context, index) {
        final answer = widget.answers[index];
        final isSelected = _selectedAnswer == answer;
        final isCorrect = widget.showResult && answer == widget.correctAnswer;
        final isWrong =
            widget.showResult && isSelected && answer != widget.correctAnswer;

        Color buttonColor;
        if (widget.showResult) {
          if (isCorrect) {
            buttonColor = const Color(0xFF10B981); // Green
          } else if (isWrong) {
            buttonColor = const Color(0xFFEF4444); // Red
          } else {
            buttonColor = Colors.white12;
          }
        } else if (isSelected) {
          buttonColor = widget.player.color;
        } else {
          buttonColor = Colors.white12;
        }

        return AnimatedScale(
          scale: isSelected && !widget.showResult ? 0.95 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: ElevatedButton(
            onPressed: widget.player.hasAnswered || !widget.isEnabled
                ? null
                : () => _handleAnswerTap(answer),
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
              disabledBackgroundColor: buttonColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(8),
            ),
            child: Text(
              answer,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      },
    );
  }
}
