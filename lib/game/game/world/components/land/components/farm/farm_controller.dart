import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/material.dart';

import '../../../../../grow_green_game.dart';
import 'model/farm_content.dart';

class FarmController {
  late final GrowGreenGame game;
  late final String farmName;
  late final Rectangle farmRect;

  bool get isFarmSelected => _isFarmSelected;
  bool _isFarmSelected = false;
  set isFarmSelected(bool v) {
    /// TODO: Take action when farm is selected
    _isFarmSelected = v;
  }

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

    return [];
  }

  /// update farm composition, this method is responsible for following:
  /// 1. Task - Designate positions for crops & trees (if any)
  /// 2. Instantiate - CropsController, FarmerController & TreeController (if not already)
  /// 3. Update - CropSupporter (Trees / Fertilizers)
  void updateFarmComposition(FarmContent farmContent) {}

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
