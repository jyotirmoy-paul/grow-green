import 'dart:async';

import 'package:flame/components.dart';
import '../../../game/grow_green_game.dart';

class Land extends PositionComponent with HasGameRef<GrowGreenGame> {
  @override
  FutureOr<void> onLoad() async {
    final image = await gameRef.images.load('tiles/crop-sowing.png');

    final sprite = Sprite(image);

    final sc = SpriteComponent(sprite: sprite);
    add(sc);
  }
}
