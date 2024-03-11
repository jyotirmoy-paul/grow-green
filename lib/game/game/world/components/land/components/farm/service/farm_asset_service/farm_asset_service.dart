import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../../../../../../../../services/log/log.dart';
import '../../../../../../../../utils/game_world_assets.dart';
import '../../../../../../../enums/agroforestry_type.dart';
import '../../../../../../../enums/farm_system_type.dart';
import '../../../../../../../grow_green_game.dart';
import '../../../../../../../services/priority/priority_engine.dart';
import '../../enum/farm_state.dart';
import '../farm_core_service.dart';
import 'components/animated_sprite_component.dart';

class FarmAssetService {
  static const tag = 'FarmAssetService';

  final GrowGreenGame game;
  final FarmCoreService farmCoreService;
  final void Function(Component) add;
  final void Function(Component) remove;

  FarmAssetService({
    required this.game,
    required this.farmCoreService,
    required this.add,
    required this.remove,
  });

  StreamSubscription? _subscription;
  CrossFadeSpriteComponent? _spriteComponent;
  String _lastAsset = '';

  String _farmBaseAssetFor(FarmState farmState) {
    return switch (farmState) {
      FarmState.notBought => GameWorldAssets.notBoughtLand,
      FarmState.barren => GameWorldAssets.barrenLand,
      FarmState.notFunctioning => GameWorldAssets.normalLand,
      _ => () {
          final systemType = farmCoreService.farmContent?.systemType;
          if (systemType == null) return GameWorldAssets.normalLand;
          if (systemType == FarmSystemType.monoculture || systemType == AgroforestryType.boundary) {
            return GameWorldAssets.soilHorizontalLand;
          }

          return GameWorldAssets.soilVerticalLand;
        }(),
    };
  }

  void _onFarmStateChange(FarmState farmState) async {
    Log.i('$tag: Farm state changed to $farmState, updating asset!');
    final farmAsset = _farmBaseAssetFor(farmState);

    /// if there's no change in asset, ignore it
    if (_lastAsset == farmAsset) return;
    _lastAsset = farmAsset;

    final sprite = Sprite(await game.images.load(farmAsset));

    /// remove existing sprite component
    if (_spriteComponent == null) {
      /// no existing component available, create one and add to the world
      _spriteComponent = CrossFadeSpriteComponent(initialSprite: sprite)
        ..priority = PriorityEngine.farmBaseLandPriority;

      /// add the new sprite component
      add(_spriteComponent!);
    } else {
      /// sprite component exists already, let's update the sprite
      _spriteComponent!.changeSprite(sprite);
    }
  }

  void onSelected(double animationValue) {
    _spriteComponent?.setColorFilter(ColorFilter.mode(Colors.black.withOpacity(animationValue), BlendMode.srcATop));
  }

  void onDeselect() {
    _spriteComponent?.setColorFilter(null);
  }

  void boot() {
    /// set first time farm base asset
    _onFarmStateChange(farmCoreService.farmState);

    /// subscribe to listen for farm state changes
    _subscription = farmCoreService.farmStateStream.listen(_onFarmStateChange);
  }

  void shutdown() {
    _subscription?.cancel();
  }
}
