import 'package:flame/components.dart';

import '../../../grow_green_game.dart';
import 'components/cloud/cloud_batch_component.dart';

class SkyController {
  static const tag = 'SkyController';

  late final GrowGreenGame game;

  Future<List<Component>> initialize({
    required GrowGreenGame game,
  }) async {
    this.game = game;

    final clouds = CloudBatchComponent();

    return [
      clouds,
    ];
  }
}
