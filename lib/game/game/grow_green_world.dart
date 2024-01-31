import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:growgreen/game/game/grow_green_game.dart';

class GrowGreenWorld extends World with HasGameRef<GrowGreenGame> {
  Function(Vector2 center) getCenter;

  GrowGreenWorld(
    this.getCenter,
  );

  @override
  FutureOr<void> onLoad() async {
    final comp = await TiledComponent.load(
      'world-map.tmx',
      Vector2(32.0, 16.0),
      prefix: 'assets/exp/',
    );

    // comp.anchor = Anchor.topLeft;
    // comp.position = Vector2(100, 0);

    add(comp);

    getCenter(comp.absoluteCenter);

    return super.onLoad();
  }
}
