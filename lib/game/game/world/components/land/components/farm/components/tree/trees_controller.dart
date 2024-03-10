import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/sprite.dart';

import '../../../../../../../../../services/log/log.dart';
import '../../../../../../../../utils/game_extensions.dart';
import '../../../../../../../../utils/game_utils.dart';
import '../../../../../../../grow_green_game.dart';
import '../../animations/game_animation.dart';
import '../../asset/tree_asset.dart';
import 'enums/tree_stage.dart';
import 'enums/tree_type.dart';

class TreesController {
  static const tag = 'TreesController';

  /// constants
  /// this scale tries to adjust the tree scale based on surrounding
  static const constScale = 1.6;
  static const scaleMin = 0.9;
  static const scaleMax = 1.10;
  static const rotationMin = -0.07;
  static const rotationMax = 0.07;

  final TreeType treeType;
  final Vector2 farmSize;
  final Vector2 treeSize;
  final List<Vector2> treePositions;

  TreesController({
    required this.treeType,
    required this.farmSize,
    required this.treeSize,
    required this.treePositions,
  }) {
    /// sort the tree positions for better z-index rendering
    treePositions.sort((a, b) {
      return (a.x + a.y).compareTo((b.x + b.y));
    });
  }

  late final GrowGreenGame game;

  Image? treeAsset;
  SpriteBatch? treeSpriteBatch;

  TreeStage treeStage = TreeStage.sprout;

  GameAnimation? bounceAnimation;

  final List<bool> _isTreeAssetFlippedList = [];
  final List<double> _treeScaleList = [];
  final List<double> _treeRotatedByAngle = [];

  void _populateSpriteBatchWithAnimation() {
    if (bounceAnimation != null) return;

    bounceAnimation = GameAnimation(
      totalDuration: 0.626,
      maxValue: 1.2,
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
    final scale = (treeSize.length / originalTreeSize.length);

    final bounceAnimationScaleFactor = bounceAnimation?.value ?? 1.0;
    final finalScale = scale * bounceAnimationScaleFactor * constScale;

    for (int i = 0; i < treePositions.length; i++) {
      final position = treePositions[i];
      final isAssetFlipped = _isTreeAssetFlippedList[i];

      final cartPosition = position.toCart(farmSize.half());

      treeSpriteBatch?.add(
        source: treeSource,
        offset: Vector2(cartPosition.x, cartPosition.y + ((originalTreeSize.y / 2) * scale)),
        anchor: Vector2(originalTreeSize.x / 2, originalTreeSize.y),
        scale: finalScale * _treeScaleList[i],
        rotation: _treeRotatedByAngle[i],
        flip: isAssetFlipped,
      );
    }
  }

  Future<void> _populateSpriteBatch() async {
    /// load the new asset and set to the sprite batch
    treeAsset = await game.images.load(TreeAsset.of(treeType).at(treeStage));
    treeSpriteBatch = SpriteBatch(treeAsset!);
  }

  void _randomizeTreeCharacter() {
    for (final _ in treePositions) {
      /// randomize tree flip
      _isTreeAssetFlippedList.add(GameUtils().getRandomBool());

      /// randomize tree scale
      _treeScaleList.add(GameUtils().getRandomNumberBetween(min: scaleMin, max: scaleMax));

      /// randomize tree rotations
      _treeRotatedByAngle.add(GameUtils().getRandomNumberBetween(min: rotationMin, max: rotationMax));
    }
  }

  Future<List<Component>> initialize({required GrowGreenGame game}) async {
    this.game = game;

    _randomizeTreeCharacter();

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
