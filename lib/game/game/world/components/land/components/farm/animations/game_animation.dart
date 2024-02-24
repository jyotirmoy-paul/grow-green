import 'dart:math' as math;
import 'dart:ui';

import 'enums/game_animation_types.dart';

class GameAnimation {
  final double totalDuration;
  final double minValue;
  final double maxValue;
  final bool repeat;
  final VoidCallback? onComplete;
  final GameAnimationTypes types;

  GameAnimation({
    this.totalDuration = 1.0,
    this.minValue = 1.0,
    this.maxValue = 1.2,
    this.repeat = false,
    this.onComplete,
    this.types = GameAnimationTypes.bounce,
  });

  double _elapsedTime = 0.0;
  double _value = 1.0;
  bool _animationEnded = false;

  void update(double dt) {
    if (_animationEnded) return;

    _elapsedTime += dt;
    final t = _elapsedTime / totalDuration;
    final adjustedValue = maxValue - minValue;

    switch (types) {
      case GameAnimationTypes.breathing:
        _value = minValue + adjustedValue * (0.5 * (1 + math.sin(2 * math.pi * t - math.pi / 2)));
        break;

      case GameAnimationTypes.bounce:
        if (t < 0.5) {
          /// quadratic ease out
          _value = 4 * adjustedValue * math.pow(t, 2) + 1;
        } else {
          final newT = t - 0.5;

          /// quadratic ease in
          _value = -4 * adjustedValue * math.pow(newT, 2) + maxValue;
        }
        break;

      case GameAnimationTypes.tween:
        _value = minValue + (maxValue - minValue) * t;
        break;

      case GameAnimationTypes.easeOut:
        _value = minValue + (maxValue - minValue) * (1 - math.pow(1 - t, 2));
        break;

      default:
        _value = 1.0;
        break;
    }

    /// Reset if the total duration is reached, to repeat the animation or stop
    if (_elapsedTime >= totalDuration) {
      if (repeat) {
        _elapsedTime = 0.0;
      } else {
        onComplete?.call();
        _animationEnded = true;
      }
    }
  }

  // Call this method to get the current scale value
  double get value {
    return _value;
  }
}
