import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/image_composition.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:growgreen/game/game/grow_green_game.dart';

class GrowGreenWorld extends World with HasGameRef<GrowGreenGame> {
  late TiledComponent mapp;
  late ObjectGroup farms;
  late Selector selector;
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

    selector = Selector(
      await gameRef.images.load('tiles/selector.png'),
    );
    selector.show = true;
    add(selector);

    return super.onLoad();
  }
}

class Selector extends SpriteComponent {
  bool show = true;

  Selector(Image image)
      : super(
          sprite: Sprite(image, srcSize: Vector2(1024, 1466)),
          anchor: Anchor.bottomCenter,
          position: Vector2(2048, 640),
        );

  @override
  void render(Canvas canvas) {
    if (!show) {
      return;
    }

    super.render(canvas);
  }
}
