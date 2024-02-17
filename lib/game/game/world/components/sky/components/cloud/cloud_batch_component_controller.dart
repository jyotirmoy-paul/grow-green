import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/sprite.dart';

import '../../../../../../utils/game_extensions.dart';
import '../../../../../../utils/game_utils.dart';
import '../../../../../grow_green_game.dart';
import 'model/cloud_model.dart';
import 'service/cloud_distribution_service.dart';

class CloudBatchComponentController {
  static const noOfClouds = 10;

  late GrowGreenGame game;
  late SpriteBatch normalCloudSpriteBatch;
  late CloudDistributionService cloudDistributionService;
  late Vector2 normalCloudSpriteSheetSize;

  final List<CloudModel> clouds = [];

  static const cloudScaleMin = 0.8;
  static const cloudScaleMax = 1.5;

  static const cloudVelocityMin = 10.0;
  static const cloudVelocityMax = 50.0;

  double get _randomCloudScale => GameUtils().getRandomNumberBetween(min: cloudScaleMin, max: cloudScaleMax);
  double get _randomCloudSpeed => GameUtils().getRandomNumberBetween(min: cloudVelocityMin, max: cloudVelocityMax);

  Rect _getRandomRectSource() {
    final random = math.Random();

    /// calculate the no of assets present in one side
    final n = normalCloudSpriteSheetSize.x ~/ GameUtils.tileSize.x;
    final maxX = n;
    final maxY = n;

    return Rect.fromLTWH(
      random.nextInt(maxX) * GameUtils.tileSize.x,
      random.nextInt(maxY) * GameUtils.tileSize.y,
      GameUtils.tileSize.x,
      GameUtils.tileSize.y,
    );
  }

  void _initializeClouds() {
    final worldSize = GameUtils().gameWorldSize;
    final cloudSize = GameUtils.tileSize.half();

    cloudDistributionService = CloudDistributionService(
      worldSize: worldSize,
      cloudSize: cloudSize,
    );

    final cloudsPositions = cloudDistributionService.generateCloudPoints(
      numberOfPoints: noOfClouds,
    );

    for (final position in cloudsPositions) {
      clouds.add(
        CloudModel(
          sourceRect: _getRandomRectSource(),
          position: position,
          scale: _randomCloudScale,
          velocity: _randomCloudSpeed,
        ),
      );
    }
  }

  Future<List<Component>> initialize({
    required GrowGreenGame game,
  }) async {
    this.game = game;

    /// normal cloud asset
    final normalCloudAsset = await game.images.load('clouds/normal_cloud.png');
    normalCloudSpriteSheetSize = normalCloudAsset.size;
    normalCloudSpriteBatch = SpriteBatch(normalCloudAsset);

    _initializeClouds();

    return const [];
  }

  void render(Canvas canvas) {
    normalCloudSpriteBatch.clear();

    for (final cloud in clouds) {
      normalCloudSpriteBatch.add(
        source: cloud.sourceRect,
        anchor: cloud.sourceRect.size.toVector2().half(),
        offset: cloud.position,
        scale: cloud.scale,
      );
    }

    normalCloudSpriteBatch.render(canvas);
  }

  void _handleOutOfBoundCloud(CloudModel cloud) {
    cloud
      ..sourceRect = _getRandomRectSource()
      ..position = cloudDistributionService.generateCloudSpawnPoint()
      ..scale = _randomCloudScale
      ..velocity = _randomCloudSpeed;
  }

  void update(double dt) {
    for (final cloud in clouds) {
      cloud.position += Vector2(cloud.velocity * dt, 0);

      if (cloud.position.x > GameUtils().gameWorldSize.x) {
        _handleOutOfBoundCloud(cloud);
      }
    }
  }
}
