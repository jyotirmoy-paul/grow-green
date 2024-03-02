import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/sprite.dart';

import '../../../../../../../../../services/log/log.dart';
import '../../../../../../../../utils/game_extensions.dart';
import '../../../../../../../grow_green_game.dart';
import '../../animations/game_animation.dart';
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

  Image? treeAsset;
  SpriteBatch? treeSpriteBatch;

  TreeStage treeStage = TreeStage.sprout;

  GameAnimation? bounceAnimation;

  void _populateSpriteBatchWithAnimation() {
    if (bounceAnimation != null) return;

    bounceAnimation = GameAnimation(
      totalDuration: 0.626,
      maxValue: 1.6,
      onComplete: () {
        bounceAnimation = null;
      },
    );
  }

  void _animateBatch() async {
    if (treeAsset == null) return;
    if (treeSpriteBatch == null) return;

    treeSpriteBatch?.clear();

    final originalTreeSize = treeAsset!.size;
    final treeSource = originalTreeSize.toRect();
    final scale = treeSize.length / originalTreeSize.length;

    final bounceAnimationScaleFactor = bounceAnimation?.value ?? 1.0;
    final finalScale = scale * bounceAnimationScaleFactor;

    for (final position in treePositions) {
      final cartPosition = position.toCart(farmSize.half());

      treeSpriteBatch?.add(
        source: treeSource,
        offset: Vector2(cartPosition.x, cartPosition.y + ((originalTreeSize.y / 2) * scale)),
        anchor: Vector2(originalTreeSize.x / 2, originalTreeSize.y / 2),
        scale: finalScale,
      );
    }
  }

  Future<void> _populateSpriteBatch() async {
    /// load the new asset and set to the sprite batch
    treeAsset = await game.images.load(TreeAsset.of(treeType).at(treeStage));
    treeSpriteBatch = SpriteBatch(treeAsset!);
  }

  Future<List<Component>> initialize({required GrowGreenGame game}) async {
    this.game = game;

    /// animate to show addition occured
    await _populateSpriteBatch();
    _populateSpriteBatchWithAnimation();

    return const [];
  }

  void render(Canvas canvas) {
    treeSpriteBatch?.render(canvas);
  }

  void update(double dt) {
    if (bounceAnimation != null) {
      bounceAnimation!.update(dt);
      _animateBatch();
    }
  }

  void updateTreeStage(TreeStage treeStage) async {
    /// if the tree stage has not changed, no need to update it
    if (this.treeStage == treeStage) return;
    Log.d('$tag: updateTreeStage invoked for $treeType, updating tree stage from ${this.treeStage} to $treeStage');

    this.treeStage = treeStage;

    /// animate to notify stage change
    await _populateSpriteBatch();
    _populateSpriteBatchWithAnimation();
  }
}
