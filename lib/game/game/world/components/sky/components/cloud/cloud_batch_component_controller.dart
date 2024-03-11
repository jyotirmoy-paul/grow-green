import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

import '../../../../../../utils/game_assets.dart';
import '../../../../../../utils/game_extensions.dart';
import '../../../../../../utils/game_utils.dart';
import '../../../../../grow_green_game.dart';
import 'cloud_batch_component.dart';
import 'model/cloud_model.dart';
import 'service/cloud_distribution_service.dart';

class CloudBatchComponentController {
  static const noOfClouds = 60;

  final random = math.Random();

  late GrowGreenGame game;
  late CloudBatchComponent cloudBatchComponent;
  late SpriteBatch normalCloudSpriteBatch;
  late CloudDistributionService cloudDistributionService;
  late Vector2 normalCloudSpriteSheetSize;
  late Vector2 cloudAreaSize;

  late double cloudMinZoomLimit;
  late double cloudMaxZoomLimit;
  late double cloudZoomLimitDiff;

  late int cloudSpriteSheetMaxX;
  late int cloudSpriteSheetMaxY;

  final List<CloudModel> clouds = [];
  final cloudsPainter = Paint();

  static const cloudScaleMin = 1.3;
  static const cloudScaleMax = 2.0;

  static const cloudVelocityMin = 10.0;
  static const cloudVelocityMax = 80.0;

  double get _randomCloudScale => GameUtils().getRandomNumberBetween(min: cloudScaleMin, max: cloudScaleMax);
  double get _randomCloudSpeed => GameUtils().getRandomNumberBetween(min: cloudVelocityMin, max: cloudVelocityMax);

  double get _getCloudOpacity {
    final zoom = game.gameController.camera.viewfinder.zoom;

    /// cloud opacity as per current zoom level
    if (cloudMinZoomLimit <= zoom && zoom <= cloudMaxZoomLimit) {
      return 1 - ((zoom - cloudMinZoomLimit) / cloudZoomLimitDiff);
    }

    if (zoom > cloudMaxZoomLimit) return 0.0;
    return 1.0;
  }

  double calculateScaleWithEaseIn({
    required double currentZoom,
    required double minZoom,
    required double maxZoom,
    required double minScale,
    required double maxScale,
  }) {
    final normalizedZoom = (currentZoom - minZoom) / (maxZoom - minZoom);
    final easedZoom = math.pow(normalizedZoom, 1.5);
    return minScale + (maxScale - minScale) * easedZoom;
  }

  double get _calculateScale {
    final zoom = game.gameController.camera.viewfinder.zoom;

    const minScale = 1.0;
    const maxScale = 4.0;

    final minZoom = game.gameController.minZoom;
    const maxZoom = GameUtils.maxZoom;

    return calculateScaleWithEaseIn(
      currentZoom: zoom,
      minZoom: minZoom,
      maxZoom: maxZoom,
      minScale: minScale,
      maxScale: maxScale,
    );
  }

  _determineCloudZoomLimits() {
    cloudMinZoomLimit = game.gameController.minZoom * 1.6;
    cloudMaxZoomLimit = GameUtils.maxZoom;
    cloudZoomLimitDiff = cloudMaxZoomLimit - cloudMinZoomLimit;
  }

  Rect get _randomSourceRect {
    return Rect.fromLTWH(
      random.nextInt(cloudSpriteSheetMaxX) * GameUtils.cloudTileSize.x,
      random.nextInt(cloudSpriteSheetMaxY) * GameUtils.cloudTileSize.y,
      GameUtils.cloudTileSize.x,
      GameUtils.cloudTileSize.y,
    );
  }

  void _initializeClouds() {
    final gameBackgroundSize = GameUtils().gameBackgroundSize;

    cloudAreaSize = Vector2(gameBackgroundSize.x * 1.1, gameBackgroundSize.y * 1.3);
    final cloudSize = GameUtils.cloudTileSize.half();
    final position = Vector2(
      gameBackgroundSize.x - cloudAreaSize.x,
      gameBackgroundSize.y - cloudAreaSize.y,
    );

    cloudBatchComponent.size = cloudAreaSize;
    cloudBatchComponent.position = cloudAreaSize.half();

    cloudDistributionService = CloudDistributionService(
      worldSize: cloudAreaSize,
      cloudSize: cloudSize,
      worldPosition: position,
    );

    final cloudsPositions = cloudDistributionService.generateCloudPoints(
      numberOfPoints: noOfClouds,
    );

    for (final position in cloudsPositions) {
      clouds.add(
        CloudModel(
          sourceRect: _randomSourceRect,
          position: position,
          scale: _randomCloudScale,
          velocity: _randomCloudSpeed,
        ),
      );
    }
  }

  Future<List<Component>> initialize({
    required GrowGreenGame game,
    required CloudBatchComponent cloudBatchComponent,
  }) async {
    this.game = game;
    this.cloudBatchComponent = cloudBatchComponent;

    _determineCloudZoomLimits();

    /// normal cloud asset
    final normalCloudAsset = await game.images.load(GameAssets.clouds);
    normalCloudSpriteSheetSize = normalCloudAsset.size;
    normalCloudSpriteBatch = SpriteBatch(normalCloudAsset);

    cloudSpriteSheetMaxX = normalCloudSpriteSheetSize.x ~/ GameUtils.cloudTileSize.x;
    cloudSpriteSheetMaxY = normalCloudSpriteSheetSize.y ~/ GameUtils.cloudTileSize.y;

    _initializeClouds();

    return const [];
  }

  void render(Canvas canvas) {
    cloudBatchComponent.scale = Vector2.all(_calculateScale);

    final opacity = _getCloudOpacity;

    /// if opacity is 0, nothing to draw!
    if (opacity == 0.0) return;

    normalCloudSpriteBatch.clear();

    for (final cloud in clouds) {
      normalCloudSpriteBatch.add(
        source: cloud.sourceRect,
        anchor: cloud.sourceRect.size.toVector2().half(),
        offset: cloud.position,
        scale: cloud.scale,
      );
    }

    normalCloudSpriteBatch.render(
      canvas,
      paint: cloudsPainter..color = Colors.transparent.withOpacity(opacity),
    );
  }

  void _handleOutOfBoundCloud(CloudModel cloud) {
    cloud
      ..sourceRect = _randomSourceRect
      ..position = cloudDistributionService.generateCloudSpawnPoint()
      ..scale = _randomCloudScale
      ..velocity = _randomCloudSpeed;
  }

  void update(double dt) {
    for (final cloud in clouds) {
      cloud.position += Vector2(cloud.velocity * dt, 0);

      if (cloud.position.x > cloudAreaSize.x) {
        _handleOutOfBoundCloud(cloud);
      }
    }
  }
}
