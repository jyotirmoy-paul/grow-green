import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

import '../../../../../../../../../services/log/log.dart';
import '../../../../../../../../utils/game_assets.dart';
import '../../../../../../../enums/agroforestry_type.dart';
import '../../../../../../../enums/farm_system_type.dart';
import '../../../../../../../grow_green_game.dart';
import '../../../../../../../services/priority/priority_engine.dart';
import '../../enum/farm_state.dart';
import '../farm_core_service.dart';

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
  SpriteComponent? _spriteComponent;
  String _lastAsset = '';

  String _farmBaseAssetFor(FarmState farmState) {
    return switch (farmState) {
      FarmState.notBought => GameAssets.notBoughtLand,
      FarmState.barren => GameAssets.barrenLand,
      FarmState.notFunctioning => GameAssets.normalLand,
      _ => () {
          final systemType = farmCoreService.farmContent?.systemType;
          if (systemType == null) return GameAssets.normalLand;
          if (systemType == FarmSystemType.monoculture || systemType == AgroforestryType.boundary) {
            return GameAssets.soilHorizontalLand;
          }

          return GameAssets.soilVerticalLand;
        }(),
    };
  }

  void _onFarmStateChange(FarmState farmState) async {
    Log.i('$tag: Farm state changed to $farmState, updating asset!');

    final farmAsset = _farmBaseAssetFor(farmState);

    /// if there's no change in asset, ignore it
    if (_lastAsset == farmAsset) return;
    _lastAsset = farmAsset;

    /// remove existing sprite component
    if (_spriteComponent != null) {
      remove(_spriteComponent!);
    }

    /// add the new component
    _spriteComponent = SpriteComponent.fromImage(
      await game.images.load(farmAsset),
      position: Vector2.zero(),
      anchor: Anchor.topLeft,
      priority: PriorityEngine.farmBaseLandPriority,
    );

    /// add the new sprite component
    add(_spriteComponent!);
  }

  void onSelected(double animationValue) {
    _spriteComponent?.tint(Colors.black.withOpacity(animationValue));
  }

  void onDeselect() {
    _spriteComponent?.getPaint().colorFilter = null;
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
