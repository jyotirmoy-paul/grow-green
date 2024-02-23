import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/sprite.dart';

import '../../../../../../../../../services/log/log.dart';
import '../../../../../../../../utils/game_extensions.dart';
import '../../../../../../../grow_green_game.dart';
import '../../animations/bounce_animation.dart';
import '../../asset/crop_asset.dart';
import 'enums/crop_stage.dart';
import 'enums/crop_type.dart';

class CropsController {
  static const tag = 'CropsController';

  final CropType cropType;
  final Vector2 cropSize;
  final List<Vector2> cropPositions;
  final Vector2 farmSize;

  CropsController({
    required this.cropType,
    required this.cropSize,
    required this.cropPositions,
    required this.farmSize,
  });

  late final GrowGreenGame game;

  Image? cropAsset;
  SpriteBatch? cropSpriteBatch;

  CropStage cropStage = CropStage.sowing;

  BounceAnimation? bounceAnimation;

  void _populateSpriteBatchWithAnimation() {
    if (bounceAnimation != null) return;

    bounceAnimation = BounceAnimation(
      totalDuration: 0.626,
      maxScale: 1.6,
      onComplete: () {
        bounceAnimation = null;
      },
    );
  }

  void _animateBatch() {
    if (cropAsset == null) return;
    if (cropSpriteBatch == null) return;

    final originCropSize = cropAsset!.size;
    final cropSource = originCropSize.toRect();
    final scale = cropSize.length / originCropSize.length;

    cropSpriteBatch?.clear();

    final bounceAnimationScaleFactor = bounceAnimation?.getCurrentScale() ?? 1.0;
    final finalScale = scale * bounceAnimationScaleFactor;

    for (final position in cropPositions) {
      final cartPosition = position.toCart(farmSize.half());

      cropSpriteBatch?.add(
        source: cropSource,
        offset: Vector2(cartPosition.x, cartPosition.y + ((originCropSize.y / 2) * scale)),
        anchor: Vector2(originCropSize.x / 2, originCropSize.y / 2),
        scale: finalScale,
      );
    }
  }

  Future<void> _populateSpriteBatch() async {
    cropAsset = await game.images.load(CropAsset.of(cropType).at(cropStage));
    cropSpriteBatch = SpriteBatch(cropAsset!);
  }

  Future<List<Component>> initialize({
    required GrowGreenGame game,
  }) async {
    this.game = game;

    /// animate to show addition occured
    await _populateSpriteBatch();
    _populateSpriteBatchWithAnimation();

    return const [];
  }

  void render(Canvas canvas) {
    cropSpriteBatch?.render(canvas);
  }

  void update(dt) {
    if (bounceAnimation != null) {
      bounceAnimation!.update(dt);
      _animateBatch();
    }
  }

  void updateCropStage(CropStage cropStage) async {
    /// if the crop stage has not change, no need to update it
    if (this.cropStage == cropStage) return;

    Log.d('$tag: updateCropStage invoked for $cropType, updating crop stage from ${this.cropStage} to $cropStage');

    this.cropStage = cropStage;

    /// animate to notify stage change
    await _populateSpriteBatch();
    _populateSpriteBatchWithAnimation();
  }
}
