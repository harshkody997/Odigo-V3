import 'package:flutter/material.dart';
import 'dart:math';

import 'package:odigov3/ui/utils/theme/app_colors.dart';

class SemiCircleProgress extends StatelessWidget {
  final double radius;
  final double strokeWidth;
  final double percentage;
  final Color fillColor;
  final Color backgroundColor;

  const SemiCircleProgress({Key? key, required this.radius, required this.strokeWidth, required this.percentage, required this.fillColor, this.backgroundColor = AppColors.dividerColor})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(radius * 2, radius), // Full width, half height
      painter: _SemiCirclePainter(radius: radius, strokeWidth: strokeWidth, percentage: percentage, fillColor: fillColor, backgroundColor: backgroundColor),
    );
  }
}

class _SemiCirclePainter extends CustomPainter {
  final double radius;
  final double strokeWidth;
  final double percentage;
  final Color fillColor;
  final Color backgroundColor;

  _SemiCirclePainter({required this.radius, required this.strokeWidth, required this.percentage, required this.fillColor, required this.backgroundColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final rect = Rect.fromCircle(center: center, radius: radius);

    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    // ..strokeCap = StrokeCap.round;

    final foregroundPaint = Paint()
      ..color = fillColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    // ..strokeCap = StrokeCap.round;

    // Background arc (full semi-circle)
    canvas.drawArc(
      rect,
      pi, // Start from 180 degrees
      pi, // Sweep 180 degrees
      false,
      backgroundPaint,
    );

    // Foreground arc (based on percentage, fill from right to left)
    canvas.drawArc(rect, 0, -pi * percentage.clamp(0.0, 1.0), false, foregroundPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
