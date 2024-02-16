import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

import '../../../../../../../../../services/log/log.dart';
import '../../../../../../../../utils/game_extensions.dart';
import '../../../../../../../grow_green_game.dart';
import '../system/ui/layout_distribution.dart';
import 'enums/tree_type.dart';

class TreesController {
  static const tag = 'TreesController';

  final TreeType treeType;
  final Vector2 farmSize;
  final Vector2 treeSize;
  final List<Position> treePositions;

  TreesController({
    required this.treeType,
    required this.farmSize,
    required this.treeSize,
    required this.treePositions,
  });

  late final GrowGreenGame game;

  late final SpriteBatch spriteBatch;

  Future<List<Component>> initialize({required GrowGreenGame game}) async {
    this.game = game;

    final treeAsset = await game.images.load('tiles/banana_iso.png');
    spriteBatch = SpriteBatch(treeAsset);

    for (final position in treePositions) {
      final cartPosition = position.toVector2().toCart(farmSize.half());

      Log.i('$tag: Drawing tree at position: $position, cartPosition: $cartPosition');

      spriteBatch.add(
        source: treeSize.toRect(),
        offset: cartPosition,
        anchor: Vector2(treeSize.x / 2, 0),
      );
    }

    return const [];
  }

  void render(Canvas canvas) {
    spriteBatch.render(canvas);
  }
}
