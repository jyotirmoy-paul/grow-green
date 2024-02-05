import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/material.dart';
import '../../../../../grow_green_game.dart';
import 'farm_controller.dart';

class Farm extends PolygonComponent with HasGameRef<GrowGreenGame> {
  final farmController = FarmController();

  final String farmName;
  final Rectangle farmRect;

  Farm(
    super._vertices, {
    required this.farmName,
    required this.farmRect,
  }) : super(paint: Paint()..color = Colors.transparent);

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (debugMode) {
      farmController.textPainter.paint(canvas, Offset.zero);
    }
  }

  @override
  FutureOr<void> onLoad() async {
    debugColor = Colors.white;

    final components = await farmController.initialize(
      game: game,
      farmName: farmName,
      farmRect: farmRect,
    );

    addAll(components);
  }

  @override
  String toString() {
    return farmName;
  }
}
