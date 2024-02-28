import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/material.dart';

import '../../../../../../../services/log/log.dart';
import '../../../../../grow_green_game.dart';
import '../../../../../services/game_services/time/time_aware.dart';
import 'farm_controller.dart';

class Farm extends PolygonComponent with HasGameRef<GrowGreenGame>, TimeAware {
  static const tag = 'Farm';

  final farmController = FarmController();

  final String farmId;
  final Rectangle farmRect;

  Farm(
    super._vertices, {
    required this.farmId,
    required this.farmRect,
  }) : super(paint: Paint()..color = Colors.transparent);

  @override
  void update(double dt) {
    super.update(dt);
    farmController.update(dt);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    farmController.render(canvas);
  }

  @override
  FutureOr<void> onLoad() async {
    Log.i('$tag: id: $farmId, priority: $priority');

    debugColor = Colors.white;

    final components = await farmController.initialize(
      game: game,
      farm: this,
      farmRect: farmRect,
      add: add,
      addAll: addAll,
      remove: remove,
      removeAll: removeAll,
      debugMode: debugMode,
    );

    addAll(components);
  }

  @override
  void onTimeChange(DateTime dateTime) => farmController.onTimeChange(dateTime);

  @override
  String toString() {
    return farmId;
  }

  @override
  void onRemove() {
    super.onRemove();
    farmController.remove();
  }
}
