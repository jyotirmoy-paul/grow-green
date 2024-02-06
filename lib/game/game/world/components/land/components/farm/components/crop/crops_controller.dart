import 'package:flame/components.dart';
import 'enums/crop_type.dart';

import '../../../../../../../grow_green_game.dart';

class CropsController {
  final CropType _cropType;
  CropsController(this._cropType);

  late final GrowGreenGame game;

  Future<List<Component>> initialize({
    required GrowGreenGame game,
  }) async {
    this.game = game;

    return [];
  }
}
