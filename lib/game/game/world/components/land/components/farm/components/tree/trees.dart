import 'dart:async';

import 'package:flame/components.dart';
import 'enums/tree_type.dart';

import '../../../../../../../grow_green_game.dart';
import 'trees_controller.dart';

class Trees extends PositionComponent with HasGameRef<GrowGreenGame> {
  final TreeType treeType;
  final TreesController treesController;

  Trees(this.treeType) : treesController = TreesController(treeType);

  @override
  FutureOr<void> onLoad() async {
    final components = await treesController.initialize(game: game);
    addAll(components);
  }
}
