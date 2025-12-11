import 'package:flutter/material.dart';

/// Animated timer widget with circular progress
class TimerWidget extends StatelessWidget {
  final int timeRemaining;
  final int totalTime;

  const TimerWidget({
    super.key,
    required this.timeRemaining,
    required this.totalTime,
  });

  @override
  Widget build(BuildContext context) {
    final progress = timeRemaining / totalTime;
    final color = _getColorForProgress(progress);

    return SizedBox(
      width: 80,
      height: 80,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Circular progress indicator
          SizedBox(
            width: 80,
            height: 80,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 6,
              backgroundColor: Colors.white12,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          // Time text
          Text(
            '$timeRemaining',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Color _getColorForProgress(double progress) {
    if (progress > 0.5) {
      return const Color(0xFF10B981); // Green
    } else if (progress > 0.25) {
      return const Color(0xFFF59E0B); // Amber
    } else {
      return const Color(0xFFEF4444); // Red
    }
  }
}

/// Speed bonus indicator
class SpeedBonusIndicator extends StatelessWidget {
  final int bonus;

  const SpeedBonusIndicator({super.key, required this.bonus});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF59E0B), Color(0xFFEF4444)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.flash_on, color: Colors.white, size: 16),
          const SizedBox(width: 4),
          Text(
            '+$bonus pts',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
