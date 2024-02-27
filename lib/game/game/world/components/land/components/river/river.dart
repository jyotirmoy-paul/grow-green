import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../../../../grow_green_game.dart';
import 'river_controller.dart';

class River extends PositionComponent with HasGameRef<GrowGreenGame> {
  final List<Vector2> riverPositions;
  final RiverController riverController;

  River({
    required this.riverPositions,
  }) : riverController = RiverController(riverPositions: riverPositions);

  @override
  FutureOr<void> onLoad() {
    return riverController.prepare(game: game);
  }

  @override
  void update(double dt) {
    super.update(dt);
    riverController.update(dt);
  }

  final _debugPaint = Paint()
    ..color = Colors.red
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 50.0;

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    riverController.render(canvas);

    if (debugMode) {
      canvas.drawPoints(
        PointMode.points,
        riverPositions.map((e) => e.toOffset()).toList(),
        _debugPaint,
      );
    }
  }
}
