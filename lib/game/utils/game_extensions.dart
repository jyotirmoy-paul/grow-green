import 'dart:math' as math;

import 'package:flame/game.dart';

import 'game_utils.dart';

extension GameExtension on Vector2 {
  Vector2 half() {
    return Vector2(x / 2.0, y / 2.0);
  }

  Vector2 toIso() {
    final halfWorldSize = GameUtils().gameWorldSize.half();
    final alpha = GameUtils().isoAngle;

    /// translate
    final p = translated(-halfWorldSize.x, 0);

    /// calculate sin ratio
    final sinRatio = p.length / math.sin(2 * alpha);

    /// using sin rule to find other edges
    final atan = math.atan2(p.x, p.y);
    final y1 = math.cos(alpha + atan) * sinRatio;
    final x1 = math.cos(alpha - atan) * sinRatio;

    /// adjust scale
    return Vector2(x1, y1)..scale(GameUtils().isoScaleFactor);
  }

  Vector2 toCart([Vector2? size]) {
    final halfWorldSize = size ?? GameUtils().gameWorldSize.half();
    final alpha = GameUtils().isoAngle;

    /// revert scale
    final p = scaled(1 / GameUtils().isoScaleFactor);

    /// calculate back cart coordinates
    final x1 = p.x * math.cos(alpha) - p.y * math.cos(alpha);
    final y2 = p.x * math.sin(alpha) + p.y * math.sin(alpha);

    /// translate back
    return Vector2(x1, y2)..translate(halfWorldSize.x, 0);
  }
}
