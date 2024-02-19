import 'dart:math' as math;
import 'dart:ui';

class BounceAnimation {
  final double totalDuration;
  final double maxScale;
  final bool repeat;
  final VoidCallback? onComplete;

  BounceAnimation({
    this.totalDuration = 1.0,
    this.maxScale = 1.2,
    this.repeat = false,
    this.onComplete,
  });

  double elapsedTime = 0.0;
  double scale = 1.0;
  bool animationEnded = false;

  void update(double dt) {
    if (animationEnded) return;

    elapsedTime += dt;
    final t = elapsedTime / totalDuration;

    final adjustedScale = maxScale - 1.0;

    if (t < 0.5) {
      scale = 4 * adjustedScale * math.pow(t, 2) + 1; // Quadratic ease out
    } else {
      final newT = t - 0.5;
      scale = -4 * adjustedScale * math.pow(newT, 2) + maxScale; // Quadratic ease in
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
