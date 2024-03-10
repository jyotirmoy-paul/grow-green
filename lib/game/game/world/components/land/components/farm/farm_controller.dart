import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/material.dart';

import '../../../../../../utils/game_extensions.dart';
import '../../../../../../utils/game_utils.dart';
import '../../../../../grow_green_game.dart';
import '../../../../../overlays/notification_overlay/service/notification_helper.dart';
import '../../../../../services/game_services/monetary/enums/transaction_type.dart';
import '../../../../../services/game_services/monetary/models/money_model.dart';
import 'animations/enums/game_animation_type.dart';
import 'animations/game_animation.dart';
import 'components/hover_board/hover_board.dart';
import 'enum/farm_state.dart';
import 'farm.dart';
import 'model/farm_content.dart';
import 'model/harvest_model.dart';
import 'model/soil_health_model.dart';
import 'model/tree_data.dart';
import 'service/crop_timer/crop_timer.dart';
import 'service/farm_asset_service/farm_asset_service.dart';
import 'service/farm_core_service.dart';
import 'service/harvest/harvest_reflector.dart';
import 'service/tree_maintanence/tree_maintanence_checker_service.dart';

class FarmController {
  static const tag = 'FarmController';

  late final GrowGreenGame game;
  late final Rectangle farmRect;
  late final Farm farm;
  late final HoverBoard hoverBoard;
  late final FarmCoreService _farmCoreService;
  late final HarvestReflector _harvestReflector;
  late final FarmAssetService _farmAssetService;
  late final TreeMaintanenceCheckerService _treeMaintanenceCheckerService;
  late final CropTimer _cropTimer;
  late final bool debugMode;

  bool _isFarmSelected = false;

  set isFarmSelected(bool value) {
    if (_isFarmSelected == value) return;

    _selectionAnimation.reset();
    _isFarmSelected = value;

    if (value == false) {
      _farmAssetService.onDeselect();
    }
  }

  bool get isFarmSelected => _isFarmSelected;

  FarmState get farmState => _farmCoreService.farmState;
  FarmContent? get farmContent => _farmCoreService.farmContent;
  double get soilHealthPercentage => _farmCoreService.soilHealthPercentage;
  TreeData get treeData => _farmCoreService.treeData;

  List<HarvestModel> get harvestModels => _farmCoreService.harvestModels;
  List<SoilHealthModel> get soilHealthModels => _farmCoreService.soilHealthModels;
  Stream<DateTime?> get lastTreeMaintenanceRefillOnStream => _farmCoreService.lastTreeMaintenanceRefillOnStream;

  VoidCallback? onFarmTap;

  final _polygonPath = Path();
  final _selectionAnimation = GameAnimation(
    totalDuration: 1.2,
    minValue: 0.0,
    maxValue: 0.2,
    repeat: true,
    type: GameAnimationType.breathing,
  );

  void _preparePolygonPath() {
    final halfFarmSize = farm.size.half();

    /// top-left corner
    final topLeft = Vector2(0, 0).toCart(halfFarmSize);
    final topRight = Vector2(farmRect.width, 0).toCart(halfFarmSize);
    final bottomRight = Vector2(farmRect.width, farmRect.height).toCart(halfFarmSize);
    final bottomLeft = Vector2(0, farmRect.height).toCart(halfFarmSize);

    _polygonPath.moveTo(topLeft.x, topLeft.y);

    /// lines to other corners
    _polygonPath.lineTo(topRight.x, topRight.y);
    _polygonPath.lineTo(bottomRight.x, bottomRight.y);
    _polygonPath.lineTo(bottomLeft.x, bottomLeft.y);

    _polygonPath.close();
  }

  Future<List<Component>> initialize({
    required GrowGreenGame game,
    required Rectangle farmRect,
    required Farm farm,
    required void Function(List<Component>) addAll,
    required void Function(Component) add,
    required void Function(List<Component>) removeAll,
    required void Function(Component) remove,
    bool debugMode = false,
  }) async {
    this.game = game;
    this.farmRect = farmRect;
    this.farm = farm;
    this.debugMode = debugMode;

    _preparePolygonPath();

    hoverBoard = HoverBoard(farm: farm);

    /// create farm service
    _farmCoreService = FarmCoreService(
      farm: farm,
      farmRect: farmRect,
      addComponent: add,
      addComponents: addAll,
      removeComponent: remove,
      removeComponents: removeAll,
    );

    /// create harvest reflector, and boot to handle harvest events
    _harvestReflector = HarvestReflector(farmCoreService: _farmCoreService);
    _harvestReflector.boot();

    /// create crop timer
    _cropTimer = CropTimer(farmCoreService: _farmCoreService)..boot();

    /// tree maintanence checker service
    _treeMaintanenceCheckerService = TreeMaintanenceCheckerService(farmCoreService: _farmCoreService)..boot();

    /// prepare farm service
    /// a call to `initialize` returns back initial components that needs to be shown
    await _farmCoreService.initialize();

    /// farm asset service shows the correct farm asset as per farm state value
    _farmAssetService = FarmAssetService(
      game: game,
      farmCoreService: _farmCoreService,
      add: add,
      remove: remove,
    )..boot();

    /// once hoverboard is loaded, let's notify the harvest model data
    hoverBoard.loaded.then((_) {
      _farmCoreService.notifyHarvestModelData();
    });

    return [
      hoverBoard,
    ];
  }

  void _purchaseFarm() async {
    final success = await game.monetaryService.transact(
      transactionType: TransactionType.debit,
      value: GameUtils.farmInitialPrice,
    );

    if (success) {
      _farmCoreService.purchaseSuccess();
      NotificationHelper.farmPurchaseSuccess();
    } else {
      NotificationHelper.farmPurchaseFailed();
    }
  }

  bool purchaseFarm() {
    final canAffordFarm = game.monetaryService.canAfford(GameUtils.farmInitialPrice);

    if (canAffordFarm) {
      _purchaseFarm();
      return true;
    }

    return false;
  }

  void updateFarmComposition({required FarmContent farmContent}) {
    _farmCoreService.updateFarmContent(farmContent);
  }

  void onTimeChange(DateTime dateTime) {
    _treeMaintanenceCheckerService.onTimeChange(dateTime);
    _farmCoreService.onTimeChange(dateTime);
  }

  MoneyModel getTreePotentialValue() {
    return _farmCoreService.getTreePotentionValue();
  }

  void sellTree() {
    return _farmCoreService.sellTree();
  }

  void remove() {
    _harvestReflector.shutdown();
    _cropTimer.shutdown();
    _treeMaintanenceCheckerService.shutdown();
    _farmAssetService.shutdown();
  }

  void update(dt) {
    _selectionAnimation.update(dt);

    if (isFarmSelected) {
      _farmAssetService.onSelected(_selectionAnimation.value);
    }
  }

  void render(Canvas canvas) {
    if (debugMode) {
      textPainter.paint(canvas, Offset.zero);
    }
  }

  TextPainter get textPainter => TextPainter(
        text: TextSpan(
          text: 'farmId: ${farm.farmId}, priority: ${farm.priority}',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
            fontSize: 20.0,
            backgroundColor: Colors.white,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
}
