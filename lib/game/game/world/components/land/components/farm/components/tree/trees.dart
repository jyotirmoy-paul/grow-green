import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../../../../../../grow_green_game.dart';
import 'enums/tree_stage.dart';
import 'enums/tree_type.dart';
import 'trees_controller.dart';

class Trees extends PositionComponent with HasGameRef<GrowGreenGame> {
  final Vector2 farmSize;
  final List<Vector2> treePositions;
  final Vector2 treeSize;
  final TreeType treeType;
  final TreesController treesController;
  final DateTime lifeStartedAt;

  Trees({
    required this.farmSize,
    required this.treeType,
    required this.treeSize,
    required this.treePositions,
    required this.lifeStartedAt,
  }) : treesController = TreesController(
          treeType: treeType,
          treeSize: treeSize,
          farmSize: farmSize,
          treePositions: treePositions,
        );

  @override
  FutureOr<void> onLoad() async {
    final components = await treesController.initialize(game: game);

    size = farmSize;
    priority = -1;

    addAll(components);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    treesController.update(dt);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    treesController.render(canvas);
  }

  void updateTreeStage(TreeStage treeStage) => treesController.updateTreeStage(treeStage);
}
