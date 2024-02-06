import 'dart:async';

import 'package:flame/components.dart';

import '../../../../../../../grow_green_game.dart';
import 'crops_controller.dart';
import 'enums/crop_type.dart';

class Crops extends PositionComponent with HasGameRef<GrowGreenGame> {
  final CropType cropType;
  final CropsController cropsController;

  Crops(this.cropType) : cropsController = CropsController(cropType);

  @override
  FutureOr<void> onLoad() async {
    final components = await cropsController.initialize(game: game);
    addAll(components);
  }
}
