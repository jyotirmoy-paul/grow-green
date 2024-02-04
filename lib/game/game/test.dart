import 'package:flame/game.dart';
import 'dart:math' as math;

void main(List<String> args) {
  Vector2 transformPoint(Vector2 point) {
    // Translate the point
    double x1 = point.x - 2048;
    double y1 = -point.y;
    double alphax = (90 - 32) * math.pi / 180;

    // Apply the rotation
    double x2 = x1 * math.cos(alphax) - y1 * math.sin(alphax);
    double y2 = x1 * math.cos(alphax) + y1 * math.sin(alphax);

    // Return the transformed point
    return Vector2(x2, -y2);
  }
  final point = Vector2(640, y)
}
