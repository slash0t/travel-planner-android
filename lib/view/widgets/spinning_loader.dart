import 'package:flutter/material.dart';
import 'package:putevod/model/app_colors.dart';

/// A widget that displays a spinning animation for the loading screen
class SpinningLoader extends StatefulWidget {
  /// Creates a spinning loader widget with the specified [size]
  const SpinningLoader({
    super.key,
    this.size = 40,
  });

  /// The size of the loader in logical pixels
  final double size;

  @override
  State<SpinningLoader> createState() => _SpinningLoaderState();
}

class _SpinningLoaderState extends State<SpinningLoader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: CustomPaint(
            painter: _SpinningLoaderPainter(
              animation: _controller,
              color: AppColors.accent,
            ),
          ),
        );
      },
    );
  }
}

class _SpinningLoaderPainter extends CustomPainter {
  _SpinningLoaderPainter({
    required this.animation,
    required this.color,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final outerCirclePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final innerCirclePaint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width / 2;
    final innerRadius = size.width / 2 - 3.33;

    // Draw inner circle
    canvas.drawCircle(center, innerRadius, innerCirclePaint);

    // Draw spinning arc
    final rect = Rect.fromCircle(center: center, radius: outerRadius - 1);
    final startAngle = 0.0;
    final sweepAngle = 1.8 * animation.value;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(animation.value * 6.28);
    canvas.translate(-center.dx, -center.dy);

    canvas.drawArc(
      rect,
      startAngle,
      sweepAngle,
      false,
      outerCirclePaint,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(_SpinningLoaderPainter oldDelegate) => true;
} 