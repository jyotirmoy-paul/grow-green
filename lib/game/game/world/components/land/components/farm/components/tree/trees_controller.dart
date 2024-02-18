import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/sprite.dart';

import '../../../../../../../../../services/log/log.dart';
import '../../../../../../../../utils/game_extensions.dart';
import '../../../../../../../grow_green_game.dart';
import 'enums/tree_type.dart';

class TreesController {
  static const tag = 'TreesController';

  final TreeType treeType;
  final Vector2 farmSize;
  final Vector2 treeSize;
  final List<Vector2> treePositions;

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
      final cartPosition = position.toCart(farmSize.half());
      final originalTreeSize = treeAsset.size;

      spriteBatch.add(
        source: originalTreeSize.toRect(),
        offset: cartPosition,
        anchor: Vector2(originalTreeSize.x / 2, 0),
        scale: treeSize.length / originalTreeSize.length,
      );
    }

    return const [];
  }

  void render(Canvas canvas) {
    spriteBatch.render(canvas);
  }
}
