import 'dart:async';

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'grow_green_game_controller.dart';

class GrowGreenGame extends FlameGame with ScaleDetector {
  final gameController = GrowGreenGameController();

  @override
  FutureOr<void> onLoad() async {
    debugMode = kDebugMode;
    final components = await gameController.initialize();
    addAll(components);
  }

  @override
  void update(double dt) {
    super.update(dt);
    gameController.onUpdate(dt);
  }

  @override
  void onScaleStart(ScaleStartInfo info) {
    gameController.onScaleStart(info);
  }

  @override
  void onScaleUpdate(ScaleUpdateInfo info) {
    gameController.onScaleUpdate(info);
  }

  @override
  void onScaleEnd(ScaleEndInfo info) {
    gameController.onScaleEnd(info);
  }
}
