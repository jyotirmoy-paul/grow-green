import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';

import '../../../../../grow_green_game.dart';
import '../../../../../services/time/time_aware.dart';
import 'cloud_batch_component_controller.dart';

class CloudBatchComponent extends PositionComponent with HasGameRef<GrowGreenGame>, TimeAware {
  final cloudController = CloudBatchComponentController();

  @override
  FutureOr<void> onLoad() async {
    final components = await cloudController.initialize(game: game);
    addAll(components);
  }

  @override
  void render(Canvas canvas) {
    cloudController.render(canvas);
    super.render(canvas);
  }

  @override
  void update(double dt) {
    cloudController.update(dt);
    super.update(dt);
  }

  @override
  void onTimeChange(DateTime dateTime) {}
}
