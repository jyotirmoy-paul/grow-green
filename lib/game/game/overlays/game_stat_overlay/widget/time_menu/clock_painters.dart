import 'dart:math' as math;

import 'package:flutter/material.dart';

class TimeIndicatorPainter extends CustomPainter {
  final Paint linePaint;
  final double lineLength;
  final double specialHourStrokeWidth;
  final double regularHourStrokeWidth;

  TimeIndicatorPainter({
    this.lineLength = 10.0,
    this.specialHourStrokeWidth = 4.0,
    this.regularHourStrokeWidth = 2.0,
  }) : linePaint = Paint()
          ..color = Colors.white
          ..strokeCap = StrokeCap.round;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2;
    final center = Offset(size.width / 2, size.height / 2);

    // Draw a line for each hour
    for (int i = 0; i < 12; i++) {
      // Check if the hour is 12, 3, 6, or 9 and set the stroke width accordingly
      linePaint.strokeWidth = (i % 3 == 0) ? specialHourStrokeWidth : regularHourStrokeWidth;

      // Calculate the angle for each hour
      final angle = (math.pi / 6) * i;

      // Calculate the start position of the line
      final start = Offset(center.dx + radius * math.cos(angle), center.dy + radius * math.sin(angle));

      // Calculate the end position of the line
      final end = Offset(
        center.dx + (radius - lineLength) * math.cos(angle),
        center.dy + (radius - lineLength) * math.sin(angle),
      );

      // Draw the line
      canvas.drawLine(start, end, linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class ClockPainter extends CustomPainter {
  final double handLength;
  final double value;

  ClockPainter({
    required this.value,
    required this.handLength,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final angle = 2 * math.pi * value;

    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);

    final position = Offset(
      center.dx + math.cos(angle) * handLength,
      center.dy + math.sin(angle) * handLength,
    );

    canvas.drawLine(center, position, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
