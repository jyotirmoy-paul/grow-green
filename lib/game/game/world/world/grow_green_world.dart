import 'dart:async';

import 'package:flame/components.dart';

import '../../grow_green_game.dart';
import 'grow_green_world_controller.dart';

class GrowGreenWorld extends World with HasGameRef<GrowGreenGame> {
  final worldController = GrowGreenWorldController();

  @override
  FutureOr<void> onLoad() async {
    final components = await worldController.initialize(
      game: game,
      add: add,
    );
    addAll(components);

    return super.onLoad();
  }
}
