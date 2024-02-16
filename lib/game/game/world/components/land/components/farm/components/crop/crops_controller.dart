import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/sprite.dart';

import '../../../../../../../../../services/log/log.dart';
import '../../../../../../../../utils/game_extensions.dart';
import '../../../../../../../grow_green_game.dart';
import '../system/ui/layout_distribution.dart';
import 'enums/crop_type.dart';

class CropsController {
  static const tag = 'CropsController';

  final CropType cropType;
  final Vector2 cropSize;
  final List<Position> cropPositions;
  final Vector2 farmSize;

  CropsController({
    required this.cropType,
    required this.cropSize,
    required this.cropPositions,
    required this.farmSize,
  });

  late final GrowGreenGame game;
  late final SpriteBatch healthyCropSpriteBatch;

  Future<List<Component>> initialize({
    required GrowGreenGame game,
  }) async {
    this.game = game;

    final cropAsset = await game.images.load('tiles/banana_iso.png');
    healthyCropSpriteBatch = SpriteBatch(cropAsset);

    for (final position in cropPositions) {
      final cartPosition = position.toVector2().toCart(farmSize.half());
      final originCropSize = cropAsset.size;

      Log.i('$tag: Drawing tree at position: $position, cartPosition: $cartPosition');

      healthyCropSpriteBatch.add(
        source: originCropSize.toRect(),
        offset: cartPosition,
        anchor: Vector2(originCropSize.x / 2, 0),
        scale: cropSize.length / originCropSize.length,
      );
    }

    return const [];
  }

  void render(Canvas canvas) {
    healthyCropSpriteBatch.render(canvas);
  }
}
