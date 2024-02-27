import 'package:flame/components.dart';

/// class that generates priority of different component types availalbe in the game
/// this is to handle z index sorting
abstract class PriorityEngine {
  static generatePriorityFrom(Vector2 position) {
    return (position.x + position.y).toInt();
  }
}
