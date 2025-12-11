import 'package:flutter/material.dart';
import 'dart:math';

/// Victory animation widget with custom confetti
class VictoryAnimation extends StatefulWidget {
  final String winnerName;
  final Color winnerColor;

  const VictoryAnimation({
    super.key,
    required this.winnerName,
    required this.winnerColor,
  });

  @override
  State<VictoryAnimation> createState() => _VictoryAnimationState();
}

class _VictoryAnimationState extends State<VictoryAnimation>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _confettiController;
  late Animation<double> _scaleAnimation;
  final List<_ConfettiParticle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    // Create confetti particles
    for (int i = 0; i < 50; i++) {
      _particles.add(
        _ConfettiParticle(
          x: _random.nextDouble(),
          y: -0.1,
          color: _getRandomColor(),
          speed: 0.3 + _random.nextDouble() * 0.5,
        ),
      );
    }

    _scaleController.forward();
    _confettiController.forward();
  }

  Color _getRandomColor() {
    final colors = [
      Colors.green,
      Colors.blue,
      Colors.pink,
      Colors.orange,
      Colors.purple,
      Colors.yellow,
    ];
    return colors[_random.nextInt(colors.length)];
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Confetti particles
        AnimatedBuilder(
          animation: _confettiController,
          builder: (context, child) {
            return CustomPaint(
              painter: _ConfettiPainter(
                particles: _particles,
                progress: _confettiController.value,
              ),
              size: Size.infinite,
            );
          },
        ),

        // Trophy and winner text
        Center(
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.emoji_events, size: 120, color: widget.winnerColor),
                const SizedBox(height: 16),
                Text(
                  '${widget.winnerName} gagne !',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: widget.winnerColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ConfettiParticle {
  double x;
  double y;
  final Color color;
  final double speed;

  _ConfettiParticle({
    required this.x,
    required this.y,
    required this.color,
    required this.speed,
  });
}

class _ConfettiPainter extends CustomPainter {
  final List<_ConfettiParticle> particles;
  final double progress;

  _ConfettiPainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      particle.y = progress * particle.speed;

      final paint = Paint()
        ..color = particle.color
        ..style = PaintingStyle.fill;

      final x = particle.x * size.width;
      final y = particle.y * size.height;

      canvas.drawCircle(Offset(x, y), 4, paint);
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter oldDelegate) => true;
}
