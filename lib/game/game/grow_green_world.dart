import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/sprite.dart';
import 'package:flame/src/game/notifying_vector2.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:growgreen/game/game/grow_green_game.dart';
import 'package:growgreen/game/utils/game_utils.dart';

class GrowGreenWorld extends World with HasGameRef<GrowGreenGame> {
  late TiledComponent worldMap;
  late ObjectGroup farms;
  late Selector selector;

  Function(Vector2 center)? onWorldLoad;

  GrowGreenWorld();

  void _initialize() {
    /// initialize game world size
    GameUtils.initializeWithWorldSize(worldMap.size);

    /// callback to notify game center
    onWorldLoad?.call(worldMap.absoluteCenter);

    /// initialize farms
    final farmsObjectGroup = worldMap.tileMap.getLayer<ObjectGroup>('Farms');

    if (farmsObjectGroup == null) {
      throw Exception('"Farms" layer not found! Have you added it in the map?');
    } else {
      farms = farmsObjectGroup;
    }
  }

  @override
  FutureOr<void> onLoad() async {
    worldMap = await TiledComponent.load(
      'world.tmx',
      GameUtils.tileSize,
      prefix: 'assets/exp/',
    )
      ..anchor = Anchor.topLeft;

    selector = Selector(
      await gameRef.images.load('tiles/selector.png'),
    );

    await addAll([
      worldMap,
      selector,
    ]);

    _initialize();
  }
}

class Selector extends SpriteComponent {
  bool show = false;

  Selector(Image image)
      : super(
          sprite: Sprite(image, srcSize: Vector2(1024, 1466)),
          anchor: Anchor.bottomCenter,
          position: Vector2(2048, 640 * 4),
        );

  @override
  void render(Canvas canvas) {
    if (!show) {
      return;
    }

    super.render(canvas);
  }
}
