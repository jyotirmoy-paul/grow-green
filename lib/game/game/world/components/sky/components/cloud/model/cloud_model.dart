import 'dart:ui';

import 'package:flame/game.dart';

class CloudModel {
  Rect sourceRect;
  Vector2 position;
  double scale;
  double velocity;

  CloudModel({
    required this.sourceRect,
    required this.position,
    this.scale = 1.0,
    this.velocity = 0.0,
  });
}
