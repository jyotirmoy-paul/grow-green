import 'dart:async';

import 'package:flame/components.dart';

import '../../../../../../../grow_green_game.dart';
import 'farmer_controller.dart';

class Farmer extends PositionComponent with HasGameRef<GrowGreenGame> {
  final farmerController = FarmerController();

  @override
  FutureOr<void> onLoad() async {
    final components = await farmerController.initialize(game: game);
    addAll(components);

    return super.onLoad();
  }
}
