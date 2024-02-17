import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../../../../../../grow_green_game.dart';
import 'enums/tree_type.dart';
import 'trees_controller.dart';

class Trees extends PositionComponent with HasGameRef<GrowGreenGame> {
  final Vector2 farmSize;
  final List<Vector2> treePositions;
  final Vector2 treeSize;
  final TreeType treeType;
  final TreesController treesController;

  Trees({
    required this.farmSize,
    required this.treeType,
    required this.treeSize,
    required this.treePositions,
  }) : treesController = TreesController(
          treeType: treeType,
          treeSize: treeSize,
          farmSize: farmSize,
          treePositions: treePositions,
        );

  @override
  FutureOr<void> onLoad() async {
    debugMode = true;
    debugColor = Colors.white;

    final components = await treesController.initialize(game: game);

    addAll(components);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    treesController.render(canvas);
  }
}
