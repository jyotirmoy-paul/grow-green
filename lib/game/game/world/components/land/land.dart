import 'dart:async';
import 'dart:ffi';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

import '../../../grow_green_game.dart';
import 'land_controller.dart';

class Land extends PositionComponent with HasGameRef<GrowGreenGame>, TapCallbacks {
  final landController = LandController();

  @override
  FutureOr<void> onLoad() async {
    final components = await landController.initialize(game);
    addAll(components);
  }

  @override
  void onTapUp(TapUpEvent event) => landController.onTapUp(event);

  @override
  bool containsLocalPoint(Vector2 point) {
    /// TODO: fix boundary
    return true;
  }
}
