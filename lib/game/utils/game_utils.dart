import 'dart:math' as math;

import 'package:flame/components.dart';

import '../game/services/game_services/monetary/models/money_model.dart';
import 'game_extensions.dart';

class GameUtils {
  /// constants
  static final tileSize = Vector2(1024, 640);
  static final cloudTileSize = Vector2(500, 250);
  static const maxZoom = 1.4;
  static const maxCloudVelocity = 20.0;
  static const startingSoilHealthInPercentage = 1.0;
  static const cutOffSoilHealthInPercentage = 1.0;
  static const maxSoilHealthInPercentage = 5.0;
  static const minSoilHealthInPercentage = 0.03;
  static const maxVillageTemperature = 35.0;
  static const minVillageTemperature = 17.0;

  static final farmInitialPrice = MoneyModel(value: 3000000);

  final Vector2 gameWorldSize;
  final Vector2 gameBackgroundSize;
  final double isoAngle;
  final double isoScaleFactor;

  final math.Random _random = math.Random();

  static GameUtils? _instance;
  GameUtils._(this.gameWorldSize)
      : gameBackgroundSize = gameWorldSize * 1.1,
        isoAngle = math.atan(gameWorldSize.y / gameWorldSize.x),
        isoScaleFactor = tileSize.y / tileSize.half().length;

  factory GameUtils() {
    if (_instance == null) {
      throw Exception('Game Utils is not initialized. Initialize using GameUtils.withWorldSize(...)');
    }

    return _instance!;
  }

  factory GameUtils.initializeWithWorldSize({
    required Vector2 gameWorldSize,
  }) {
    return _instance = GameUtils._(gameWorldSize);
  }

  bool getRandomBool() {
    return _random.nextBool();
  }

  int getRandomInteger(int max) {
    return _random.nextInt(max);
  }

  /// generates random double between `min` & `max` values
  double getPureRandomNumberBetween({required double min, required double max}) {
    return _random.nextDouble() * (max - min) + min;
  }

  double getRandomNumberBetween({required double min, required double max}) {
    double rnd = _random.nextDouble();
    double bias = math.sin(rnd * math.pi - (math.pi / 2)) / 2 + 0.5;
    return bias * (max - min) + min;
  }
}
