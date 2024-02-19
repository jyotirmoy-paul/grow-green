import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';

import '../../../../../../../grow_green_game.dart';
import 'crops_controller.dart';
import 'enums/crop_stage.dart';
import 'enums/crop_type.dart';

class Crops extends PositionComponent with HasGameRef<GrowGreenGame> {
  final List<Vector2> cropPositions;
  final Vector2 cropSize;
  final Vector2 farmSize;
  final CropType cropType;
  final CropsController cropsController;

  DateTime? lifeStartedAt;

  Crops({
    required this.cropType,
    required this.cropSize,
    required this.farmSize,
    required this.cropPositions,
    this.lifeStartedAt,
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
  void update(double dt) {
    super.update(dt);
    cropsController.update(dt);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    cropsController.render(canvas);
  }

  void updateCropStage(CropStage cropStage) => cropsController.updateCropStage(cropStage);
}
