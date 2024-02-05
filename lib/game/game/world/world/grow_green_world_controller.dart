import 'package:flame/components.dart';

import '../../grow_green_game.dart';
import '../components/land/land.dart';
import '../components/sky/sky.dart';

class GrowGreenWorldController {
  static const tag = 'GrowGreenWorldController';

  late final GrowGreenGame game;
  late final Land land;
  late final Sky sky;

  /// initialize components of the world
  Future<List<Component>> initialize(GrowGreenGame game) async {
    this.game = game;

    /// load land
    land = Land();

    /// sky
    sky = Sky();

    return [
      land,
      sky,
    ];
  }
}
