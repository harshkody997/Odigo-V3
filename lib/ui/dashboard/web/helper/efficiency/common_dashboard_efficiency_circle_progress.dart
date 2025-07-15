import 'package:flutter/material.dart';
import 'dart:math';

import 'package:odigov3/ui/utils/theme/app_colors.dart';

class CommonDashboardEfficiencyCircleProgress extends StatelessWidget {
  final double radius;
  final double strokeWidth;
  final double percentage;
  final Color fillColor;
  final Color backgroundColor;

  const CommonDashboardEfficiencyCircleProgress({Key? key, required this.radius, required this.strokeWidth, required this.percentage, required this.fillColor, this.backgroundColor = AppColors.dividerColor})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(radius * 2, radius * 2), // Full width, half height
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
    final center = Offset(size.width / 2, size.height / 2);
    final rect = Rect.fromCircle(center: center, radius: radius);

    const double startAngle = 3 * pi / 4; // 135°
    const double sweepAngle = 3 * pi / 2; // 270°

    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;

    final foregroundPaint = Paint()
      ..shader = SweepGradient(
        startAngle: startAngle,
        endAngle: startAngle + sweepAngle * percentage.clamp(0.0, 1.0),
        colors: [

          fillColor,
          fillColor,
          fillColor.withValues(alpha: 0.2),
          fillColor.withValues(alpha: 0.4),
          fillColor.withValues(alpha: 0.6),
        ],
      ).createShader(rect)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
     ..strokeCap = StrokeCap.round;



    // Background arc (full horseshoe)
    canvas.drawArc(
      rect,
      startAngle,
      sweepAngle,
      false,
      backgroundPaint,
    );

    // Foreground arc (based on percentage)
    canvas.drawArc(
      rect,
      startAngle,
      sweepAngle * percentage.clamp(0.0, 1.0),
      false,
      foregroundPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
