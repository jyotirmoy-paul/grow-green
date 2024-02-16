import 'dart:math' as math;

import 'package:flame/components.dart';

import '../../../../utils/game_utils.dart';
import '../../../grow_green_game.dart';
import 'enum/cloud.dart';

class SkyController {
  final double cloudSpeed;
  SkyController() : cloudSpeed = 10 + math.Random().nextDouble() * GameUtils.maxCloudVelocity;

  late final GrowGreenGame game;
  late final List<SpriteComponent> clouds = [];

  Future<List<Component>> initialize({
    required GrowGreenGame game,
  }) async {
    this.game = game;

    final cloudAsset = await game.images.load(NormalCloud.type_2.asset);
    final cloud = SpriteComponent.fromImage(
      cloudAsset,
      anchor: Anchor.center,
      position: Vector2(0, GameUtils().gameWorldSize.y),
      angle: -GameUtils().isoAngle,
      scale: Vector2.all(0.5),
    );

    clouds.add(cloud);

    return clouds;
  }

  void update(double dt) {
    for (final cloud in clouds) {
      final rateOfChange = cloudSpeed * dt;

      cloud.position = cloud.position.translated(
        rateOfChange,
        rateOfChange * math.tan(-GameUtils().isoAngle),
      );

      if (cloud.position.x > GameUtils().gameWorldSize.x) {
        cloud.position = Vector2(0, GameUtils().gameWorldSize.y);
      }

      cloud.angle = -GameUtils().isoAngle;
    }
  }

  void onTimeChange(DateTime dateTime) {}
}
