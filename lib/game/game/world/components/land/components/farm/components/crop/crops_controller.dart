import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/sprite.dart';

import '../../../../../../../../../services/log/log.dart';
import '../../../../../../../../utils/game_extensions.dart';
import '../../../../../../../../utils/game_utils.dart';
import '../../../../../../../grow_green_game.dart';
import '../../animations/game_animation.dart';
import '../../asset/crop_asset.dart';
import 'enums/crop_stage.dart';
import 'enums/crop_type.dart';

class CropsController {
  static const tag = 'CropsController';

  /// constants
  /// this scale crops to adjust the tree scale based on surrounding

  static const scaleMin = 0.9;
  static const scaleMax = 1.10;

  final CropType cropType;
  final Vector2 cropSize;
  final List<Vector2> cropPositions;
  final Vector2 farmSize;
  final math.Random _random;
  late final double constScale;

  double get _individualCropScaleFactor {
    return switch (cropType) {
      CropType.maize => 1.0,
      CropType.bajra => 1.0,
      CropType.wheat => 1.0,
      CropType.groundnut => 1.2,
      CropType.pepper => 1.0,
      CropType.banana => 2.0,
    };
  }

  CropsController({
    required this.cropType,
    required this.cropSize,
    required this.cropPositions,
    required this.farmSize,
  }) : _random = math.Random() {
    /// sort the tree positions for better z-index rendering
    cropPositions.sort((a, b) {
      return (a.x + a.y).compareTo((b.x + b.y));
    });

    /// find out crop scale
    constScale = _individualCropScaleFactor;
  }

  late final GrowGreenGame game;

  Image? cropAsset;
  SpriteBatch? cropSpriteBatch;

  CropStage cropStage = CropStage.germination;

  GameAnimation? bounceAnimation;

  final List<bool> _isCropAssetFlippedList = [];
  final List<double> _cropScaleList = [];

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

  void _animateBatch() {
    if (cropAsset == null) return;
    if (cropSpriteBatch == null) return;

    final originCropSize = cropAsset!.size;
    final cropSource = originCropSize.toRect();
    final scale = cropSize.length / originCropSize.length;

    cropSpriteBatch?.clear();

    final bounceAnimationScaleFactor = bounceAnimation?.value ?? 1.0;
    final finalScale = scale * bounceAnimationScaleFactor * constScale;

    for (int i = 0; i < cropPositions.length; i++) {
      final position = cropPositions[i];
      final isAssetFlipped = _isCropAssetFlippedList[i];
      final cartPosition = position.toCart(farmSize.half());

      cropSpriteBatch?.add(
        source: cropSource,
        offset: Vector2(cartPosition.x, cartPosition.y + ((originCropSize.y / 2) * scale)),
        anchor: Vector2(originCropSize.x / 2, originCropSize.y),
        scale: finalScale * _cropScaleList[i],
        flip: isAssetFlipped,
      );
    }
  }

  Future<void> _populateSpriteBatch() async {
    cropAsset = await game.images.load(CropAsset.of(cropType).at(cropStage));
    cropSpriteBatch = SpriteBatch(cropAsset!);
  }

  void _randomizeCropCharacter() {
    for (final _ in cropPositions) {
      /// randomize tree flip
      _isCropAssetFlippedList.add(_random.nextBool());

      /// randomize tree scale
      _cropScaleList.add(GameUtils().getRandomNumberBetween(min: scaleMin, max: scaleMax));
    }
  }

  Future<List<Component>> initialize({
    required GrowGreenGame game,
  }) async {
    this.game = game;

    _randomizeCropCharacter();

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
