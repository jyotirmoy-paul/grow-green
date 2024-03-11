import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';

import '../../../../../grow_green_game.dart';
import '../../../../../services/game_services/time/time_aware.dart';
import '../../../../../services/game_services/time/time_service.dart';
import 'cloud_batch_component_controller.dart';

class CloudBatchComponent extends PositionComponent with HasGameRef<GrowGreenGame>, TimeAware {
  final cloudController = CloudBatchComponentController();

  @override
  FutureOr<void> onLoad() async {
    final components = await cloudController.initialize(
      game: game,
      cloudBatchComponent: this,
    );

    anchor = Anchor.center;

    addAll(components);

    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    cloudController.render(canvas);
    super.render(canvas);
  }

  @override
  void update(double dt) {
    /// add time pace affect to cloud animations
    cloudController.update(dt * TimeService().timePace);
    super.update(dt);
  }

  @override
  void onTimeChange(DateTime dateTime) {}
}
