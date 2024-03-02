import 'dart:math' as math;

import 'package:flame/components.dart';

import '../game/services/game_services/monetary/models/money_model.dart';
import 'game_extensions.dart';

class GameUtils {
  /// constants
  static final tileSize = Vector2(1024, 640);
  static const maxZoom = 0.8;
  static const maxCloudVelocity = 20.0;

  static final farmInitialPrice = MoneyModel(rupees: 3000000);

  final Vector2 gameWorldSize;
  final double isoAngle;
  final double isoScaleFactor;

  final math.Random _random = math.Random();

  static GameUtils? _instance;
  GameUtils._(this.gameWorldSize)
      : isoAngle = math.atan(gameWorldSize.y / gameWorldSize.x),
        isoScaleFactor = tileSize.y / tileSize.half().length;

  factory GameUtils() {
    if (_instance == null) {
      throw Exception('Game Utils is not initialized. Initialize using GameUtils.withWorldSize(...)');
    }

    return _instance!;
  }

  factory GameUtils.initializeWithWorldSize(Vector2 gameWorldSize) {
    return _instance = GameUtils._(gameWorldSize);
  }

  /// generates random double between `min` & `max` values
  double getRandomNumberBetween({required double min, required double max}) {
    double rnd = _random.nextDouble();
    double bias = math.sin(rnd * math.pi - (math.pi / 2)) / 2 + 0.5;
    return bias * (max - min) + min;
  }
}
