import 'package:flame/components.dart';

import '../../../../../../../grow_green_game.dart';

class FarmerController {
  late final GrowGreenGame game;

  Future<List<Component>> initialize({
    required GrowGreenGame game,
  }) async {
    this.game = game;

    return [];
  }
}
