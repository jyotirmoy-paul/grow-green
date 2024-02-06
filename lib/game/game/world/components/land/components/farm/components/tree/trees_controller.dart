import 'package:flame/components.dart';

import '../../../../../../../grow_green_game.dart';
import 'enums/tree_type.dart';

class TreesController {
  final TreeType _treeType;
  TreesController(this._treeType);

  late final GrowGreenGame game;

  Future<List<Component>> initialize({
    required GrowGreenGame game,
  }) async {
    this.game = game;

    return [];
  }
}
