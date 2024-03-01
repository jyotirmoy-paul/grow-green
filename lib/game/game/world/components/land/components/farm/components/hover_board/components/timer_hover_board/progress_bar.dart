import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class ProgressBar extends PositionComponent {
  final double progressWidth;
  final double progressHeight;
  final double strokeWidth;
  final Color minColor;
  final Color maxColor;
  final Radius borderRadius;

  ProgressBar({
    required this.progressFactor,
    this.progressWidth = 100.0,
    this.progressHeight = 16.0,
    this.strokeWidth = 2.0,
    this.minColor = Colors.red,
    this.maxColor = Colors.green,
    this.borderRadius = const Radius.circular(2.0),
  });

  double progressFactor;

  @override
  FutureOr<void> onLoad() {
    size = Vector2(progressWidth, progressHeight);
    anchor = Anchor.center;

    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Draw the background of the progress bar (the empty part)
    final Paint backgroundPaint = Paint()
      ..color = Colors.black.withOpacity(0.4)
      ..style = PaintingStyle.fill;

    final Paint borderPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    final backgroundRect = RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, width, height), borderRadius);

    canvas.drawRRect(backgroundRect, backgroundPaint);
    canvas.drawRRect(backgroundRect, borderPaint);

    final color = Color.lerp(minColor, maxColor, progressFactor)!;

    final Paint foregroundPaint = Paint()..color = color;
    final foregroundRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        strokeWidth / 2,
        strokeWidth / 2,
        width * progressFactor - strokeWidth,
        height - strokeWidth,
      ),
      borderRadius,
    );

    canvas.drawRRect(foregroundRect, foregroundPaint);
  }
}
