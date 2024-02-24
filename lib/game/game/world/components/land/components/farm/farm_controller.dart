import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/material.dart';

import '../../../../../grow_green_game.dart';
import '../../../../../services/game_services/monetary/models/money_model.dart';
import 'enum/farm_state.dart';
import 'farm.dart';
import 'model/farm_content.dart';
import 'service/farm_core_service.dart';

class FarmController {
  static const tag = 'FarmController';

  late final GrowGreenGame game;
  late final Rectangle farmRect;
  late final Farm farm;
  late final FarmCoreService _farmCoreService;

  /// FIXME: a farm stays selected until a new farm is selected, it's a bug
  bool isFarmSelected = false;

  FarmState get farmState => _farmCoreService.farmState;
  FarmContent? get farmContent => _farmCoreService.farmContent;

  Future<List<Component>> initialize({
    required GrowGreenGame game,
    required Rectangle farmRect,
    required Farm farm,
    required void Function(List<Component>) addAll,
    required void Function(Component) add,
    required void Function(List<Component>) removeAll,
    required void Function(Component) remove,
  }) async {
    this.game = game;
    this.farmRect = farmRect;
    this.farm = farm;

    /// create farm service
    _farmCoreService = FarmCoreService(
      farm: farm,
      farmRect: farmRect,
      addComponent: add,
      addComponents: addAll,
      removeComponent: remove,
      removeComponents: removeAll,
    );

    /// prepare farm service
    /// a call to `initialize` returns back initial components that needs to be shown
    return _farmCoreService.initialize();
  }

  void purchaseSuccess() {
    _farmCoreService.purchaseSuccess();
  }

  void updateFarmComposition({required FarmContent farmContent}) {
    _farmCoreService.updateFarmContent(farmContent);
  }

  void onTimeChange(DateTime dateTime) {
    _farmCoreService.onTimeChange(dateTime);
  }

  MoneyModel getTreePotentialValue() {
    return _farmCoreService.getTreePotentionValue();
  }

  void sellTree() {
    return _farmCoreService.sellTree();
  }

  TextPainter get textPainter => TextPainter(
        text: TextSpan(
          text: farm.farmId,
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
