import 'dart:math' as math;
import 'dart:ui';

import 'enums/game_animation_types.dart';

class GameAnimation {
  final double totalDuration;
  final double minScale;
  final double maxScale;
  final bool repeat;
  final VoidCallback? onComplete;
  final GameAnimationTypes types;

  GameAnimation({
    this.totalDuration = 1.0,
    this.minScale = 1.0,
    this.maxScale = 1.2,
    this.repeat = false,
    this.onComplete,
    this.types = GameAnimationTypes.easeInOut,
  });

  double elapsedTime = 0.0;
  double scale = 1.0;
  bool animationEnded = false;

  void update(double dt) {
    if (animationEnded) return;

    elapsedTime += dt;
    final t = elapsedTime / totalDuration;
    final adjustedScale = maxScale - minScale;

    switch (types) {
      case GameAnimationTypes.breathing:
        scale = minScale + adjustedScale * (0.5 * (1 + math.sin(2 * math.pi * t - math.pi / 2)));
        break;

      case GameAnimationTypes.easeInOut:
        if (t < 0.5) {
          /// quadratic ease out
          scale = 4 * adjustedScale * math.pow(t, 2) + 1;
        } else {
          final newT = t - 0.5;

          /// quadratic ease in
          scale = -4 * adjustedScale * math.pow(newT, 2) + maxScale;
        }
        break;

      default:
        scale = 1.0;
        break;
    }

    /// Reset if the total duration is reached, to repeat the animation or stop
    if (elapsedTime >= totalDuration) {
      if (repeat) {
        elapsedTime = 0.0;
      } else {
        onComplete?.call();
        animationEnded = true;
      }
    }
  }

  // Call this method to get the current scale value
  double getCurrentScale() {
    return scale;
  }
}
