import 'package:flame/components.dart';

import '../../grow_green_game.dart';
import '../components/land/land.dart';
import '../components/sky/sky.dart';

class GrowGreenWorldController {
  static const tag = 'GrowGreenWorldController';

  late final GrowGreenGame game;
  late final void Function(Component) add;

  late final Land land;
  late final Sky sky;

  /// initialize components of the world
  Future<List<Component>> initialize({
    required GrowGreenGame game,
    required void Function(Component) add,
  }) async {
    this.game = game;
    this.add = add;

    /// load land
    land = Land();

    /// once land is loaded, load the skyc
    land.loaded.then((_) {
      sky = Sky();
      add(sky);
    });

    return [
      land,
    ];
  }
}
