import 'dart:async';

import 'package:flame/components.dart';

import '../../../grow_green_game.dart';
import '../../../services/time/time_aware.dart';
import 'sky_controller.dart';

class Sky extends PositionComponent with TimeAware, HasGameRef<GrowGreenGame> {
  final skyController = SkyController();

  @override
  FutureOr<void> onLoad() async {
    final components = await skyController.initialize(
      game: game,
    );
    addAll(components);
  }

  @override
  void update(double dt) {
    super.update(dt);
    skyController.update(dt);
  }

  @override
  void onTimeChange(DateTime dateTime) => skyController.onTimeChange(dateTime);
}
