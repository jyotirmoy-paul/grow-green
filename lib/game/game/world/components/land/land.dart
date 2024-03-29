import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';

import '../../../grow_green_game.dart';
import 'land_controller.dart';

class Land extends PositionComponent with HasGameRef<GrowGreenGame>, TapCallbacks {
  final landController = LandController();

  @override
  FutureOr<void> onLoad() async {
    final components = await landController.initialize(game);
    addAll(components);
    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    landController.render(canvas);
  }

  @override
  void onTapUp(TapUpEvent event) => landController.onTapUp(event);

  @override
  bool containsLocalPoint(Vector2 point) {
    return true;
  }
}
