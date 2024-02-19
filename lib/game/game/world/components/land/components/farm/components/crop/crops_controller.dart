import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/sprite.dart';

import '../../../../../../../../../services/log/log.dart';
import '../../../../../../../../utils/game_extensions.dart';
import '../../../../../../../grow_green_game.dart';
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
  SpriteBatch? cropSpriteBatch;

  CropStage cropStage = CropStage.sowing;

  void _populateSpriteBatch() async {
    final cropAsset = await game.images.load(CropAsset.of(cropType).at(cropStage));
    cropSpriteBatch = SpriteBatch(cropAsset);

    final originCropSize = cropAsset.size;
    final cropSource = originCropSize.toRect();

    for (final position in cropPositions) {
      final cartPosition = position.toCart(farmSize.half());

      cropSpriteBatch?.add(
        source: cropSource,
        offset: cartPosition,
        anchor: Vector2(originCropSize.x / 2, 0),
        scale: cropSize.length / originCropSize.length,
      );
    }
  }

  Future<List<Component>> initialize({
    required GrowGreenGame game,
  }) async {
    this.game = game;

    _populateSpriteBatch();

    return const [];
  }

  void render(Canvas canvas) {
    cropSpriteBatch?.render(canvas);
  }

  void updateCropStage(CropStage cropStage) {
    /// if the crop stage has not change, no need to update it
    if (this.cropStage == cropStage) return;

    Log.d('$tag: updateCropStage invoked for $cropType, updating crop stage from ${this.cropStage} to $cropStage');

    this.cropStage = cropStage;
    _populateSpriteBatch();
  }
}
