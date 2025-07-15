import 'package:flutter/material.dart';

class DottedLine extends StatelessWidget {
  final Color color;
  final double strokeWidth;
  final double width;

  const DottedLine({this.color = Colors.grey, this.strokeWidth = 1, this.width = double.infinity});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, strokeWidth),
      painter: _DottedLinePainter(color: color, strokeWidth: strokeWidth),
    );
  }
}

class _DottedLinePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  _DottedLinePainter({required this.color, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth;

    double dashWidth = 5;
    double dashSpace = 3;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
