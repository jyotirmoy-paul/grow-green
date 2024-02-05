import 'dart:async';

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'grow_green_game_controller.dart';

class GrowGreenGame extends FlameGame with ScaleDetector {
  static const tag = 'GrowGreenGame';

  final gameController = GrowGreenGameController();

  @override
  FutureOr<void> onLoad() async {
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
