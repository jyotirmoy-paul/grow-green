import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';

import '../../../../../../../grow_green_game.dart';
import '../system/ui/layout_distribution.dart';
import 'crops_controller.dart';
import 'enums/crop_type.dart';

class Crops extends PositionComponent with HasGameRef<GrowGreenGame> {
  final List<Position> cropPositions;
  final Vector2 cropSize;
  final Vector2 farmSize;
  final CropType cropType;
  final CropsController cropsController;

  Crops({
    required this.cropType,
    required this.cropSize,
    required this.farmSize,
    required this.cropPositions,
  }) : cropsController = CropsController(
          cropType: cropType,
          cropSize: cropSize,
          cropPositions: cropPositions,
          farmSize: farmSize,
        );

  @override
  FutureOr<void> onLoad() async {
    final components = await cropsController.initialize(game: game);
    addAll(components);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    cropsController.render(canvas);
  }
}
