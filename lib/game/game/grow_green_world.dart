import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:growgreen/game/game/grow_green_game.dart';

class GrowGreenWorld extends World with HasGameRef<GrowGreenGame> {
  late TiledComponent mapp;
  late ObjectGroup farms;
  Function(Vector2 center) getCenter;

  GrowGreenWorld(
    this.getCenter,
  );

  @override
  FutureOr<void> onLoad() async {
    const height = 640.0;
    mapp = await TiledComponent.load(
      'world.tmx',
      Vector2(height * 1.6, height),
      prefix: 'assets/exp/',
    );

    mapp.anchor = Anchor.topLeft;

    add(mapp);
    getCenter(mapp.absoluteCenter);

    final farmsObjectGroup = mapp.tileMap.getLayer<ObjectGroup>('Farms');
    // final grounds = mapp.tileMap.getLayer<TileLayer>('Ground');

    if (farmsObjectGroup == null) {
      throw Exception('"Farms" layer not found! Have you added it in the map?');
    } else {
      farms = farmsObjectGroup;
    }

    // for (final farm in farms.objects) {
    //   // farm.polygon.contains();
    // }

    return super.onLoad();
  }
}
