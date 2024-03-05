import 'dart:math' as math;

import 'package:flutter/material.dart';

class TimeIndicatorPainter extends CustomPainter {
  final double lineLength;
  final double specialHourStrokeWidth;
  final double regularHourStrokeWidth;
  final Color specialHourColor;
  final Color regularHourColor;

  final Paint specialLinePaint;
  final Paint regularLinePaint;

  TimeIndicatorPainter({
    this.lineLength = 10.0,
    this.specialHourStrokeWidth = 4.0,
    this.regularHourStrokeWidth = 2.0,
    this.specialHourColor = Colors.white,
    this.regularHourColor = Colors.white,
  })  : specialLinePaint = Paint()
          ..color = specialHourColor
          ..strokeWidth = specialHourStrokeWidth
          ..strokeCap = StrokeCap.round,
        regularLinePaint = Paint()
          ..color = regularHourColor
          ..strokeWidth = regularHourStrokeWidth
          ..strokeCap = StrokeCap.round;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2;
    final center = Offset(size.width / 2, size.height / 2);

    /// drawing each hour hands
    for (int i = 0; i < 12; i++) {
      /// treat the special hour hands with a different width
      final paint = (i % 3 == 0) ? specialLinePaint : regularLinePaint;

      /// create the line
      final angle = (math.pi / 6) * i;
      final start = Offset(center.dx + radius * math.cos(angle), center.dy + radius * math.sin(angle));
      final end = Offset(
        center.dx + (radius - lineLength) * math.cos(angle),
        center.dy + (radius - lineLength) * math.sin(angle),
      );

      canvas.drawLine(start, end, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ClockHandPainter extends CustomPainter {
  final double handLength;
  final double value;
  final Color color;
  final Paint handPaint;

  ClockHandPainter({
    required this.value,
    required this.handLength,
    this.color = Colors.white,
  }) : handPaint = Paint()
          ..color = color
          ..strokeWidth = 4
          ..strokeCap = StrokeCap.round;

  @override
  void paint(Canvas canvas, Size size) {
    final angle = 2 * math.pi * value;

    final center = Offset(size.width / 2, size.height / 2);

    final position = Offset(
      center.dx + math.cos(angle) * handLength,
      center.dy + math.sin(angle) * handLength,
    );

    canvas.drawLine(center, position, handPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
