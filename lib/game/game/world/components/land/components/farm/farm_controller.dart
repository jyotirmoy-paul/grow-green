import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/material.dart';
import 'package:growgreen/game/game/models/farm_system.dart';
import 'package:growgreen/game/game/world/components/land/components/farm/enum/farm_state.dart';

import '../../../../../grow_green_game.dart';
import 'model/farm_content.dart';

class FarmController {
  late final GrowGreenGame game;
  late final String farmName;
  late final Rectangle farmRect;

  bool isFarmSelected = false;

  FarmState _currentFarmState = FarmState.notInitialized;
  FarmState get currentFarmState => _currentFarmState;

  FarmContent? _farmContent;
  FarmContent? get farmContent => _farmContent;

  Future<List<Component>> initialize({
    required GrowGreenGame game,
    required String farmName,
    required Rectangle farmRect,
  }) async {
    this.game = game;
    this.farmName = farmName;
    this.farmRect = farmRect;

    /// TODO: read from db
    /// _currentFarmState

    return [];
  }

  /// update farm composition, this method is responsible for following:
  /// 1. Task - Designate positions for crops & trees (if any)
  /// 2. Instantiate - CropsController, FarmerController & TreeController (if not already)
  /// 3. Update - CropSupporter (Trees / Fertilizers)
  void updateFarmComposition({
    required FarmContent farmContent,
  }) {
    /// TODO
  }

  TextPainter get textPainter => TextPainter(
        text: TextSpan(
          text: farmName,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
            fontSize: 64.0,
            backgroundColor: Colors.white,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
}
