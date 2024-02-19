import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/sprite.dart';

import '../../../../../../../../../services/log/log.dart';
import '../../../../../../../../utils/game_extensions.dart';
import '../../../../../../../grow_green_game.dart';
import '../../asset/tree_asset.dart';
import 'enums/tree_stage.dart';
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
  SpriteBatch? treeSpriteBatch;

  TreeStage treeStage = TreeStage.seedling;

  void _populateSpriteBatch() async {
    /// load the new asset and set to the sprite batch
    final treeAsset = await game.images.load(TreeAsset.of(treeType).at(treeStage));
    treeSpriteBatch = SpriteBatch(treeAsset);

    final originalTreeSize = treeAsset.size;
    final treeSource = originalTreeSize.toRect();

    for (final position in treePositions) {
      final cartPosition = position.toCart(farmSize.half());
      final originalTreeSize = treeAsset.size;

      treeSpriteBatch?.add(
        source: treeSource,
        offset: cartPosition,
        anchor: Vector2(originalTreeSize.x / 2, 0),
        scale: treeSize.length / originalTreeSize.length,
      );
    }
  }

  Future<List<Component>> initialize({required GrowGreenGame game}) async {
    this.game = game;

    _populateSpriteBatch();

    return const [];
  }

  void render(Canvas canvas) {
    treeSpriteBatch?.render(canvas);
  }

  void updateTreeStage(TreeStage treeStage) {
    /// if the tree stage has not changed, no need to update it
    if (this.treeStage == treeStage) return;

    Log.d('$tag: updateTreeStage invoked for $treeType, updating tree stage from ${this.treeStage} to $treeStage');

    this.treeStage = treeStage;
    _populateSpriteBatch();
  }
}
