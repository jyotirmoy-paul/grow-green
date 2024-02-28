import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../../../utils/game_extensions.dart';
import '../../../../utils/game_utils.dart';
import '../../../grow_green_game.dart';
import 'sky_controller.dart';

class Sky extends PositionComponent with HasGameRef<GrowGreenGame> {
  final skyController = SkyController();

  @override
  FutureOr<void> onLoad() async {
    debugColor = Colors.blueAccent;
    final components = await skyController.initialize(
      game: game,
    );

    final worldSize = GameUtils().gameWorldSize;
    final skyPosition = worldSize.half();

    /// set sky properties
    size = worldSize;
    anchor = Anchor.center;
    angle = -GameUtils().isoAngle;
    position = skyPosition;

    addAll(components);
  }
}
