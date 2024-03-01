import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class RoundedRectangleComponent extends PositionComponent {
  final double borderRadius;
  final Color color;
  final Color shadowColor;
  final double shadowBlurRadius;

  RoundedRectangleComponent({
    required this.borderRadius,
    required this.color,
    this.shadowColor = Colors.black,
    this.shadowBlurRadius = 4.0,
    required Vector2 position,
    required Vector2 size,
  }) : super(
          position: position,
          size: size,
        );

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final rRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.x, size.y),
      Radius.circular(borderRadius),
    );

    canvas.drawRRect(rRect, Paint()..color = color);
  }
}
