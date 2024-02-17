import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/material.dart';
import '../../../../../../../services/log/log.dart';
import '../../../../../grow_green_game.dart';
import 'components/crop/crops.dart';
import 'components/system/growable.dart';
import 'components/system/ui/layout_distribution.dart';
import 'components/tree/trees.dart';
import 'enum/farm_state.dart';
import 'farm.dart';
import 'model/farm_content.dart';

class FarmController {
  static const tag = 'FarmController';

  Trees? _trees;
  Crops? _crops;

  FarmState _farmState = FarmState.notInitialized;

  FarmContent? _farmContent;

  /// support variables

  late final GrowGreenGame game;
  late final String farmName;
  late final Vector2 farmPosition;
  late final Rectangle farmRect;
  late final Farm farm;

  late final void Function(List<Component>) addAll;
  late final void Function(Component) add;
  late final void Function(List<Component>) removeAll;
  late final void Function(Component) remove;

  bool isFarmSelected = false;

  FarmState get farmState => _farmState;
  FarmContent? get farmContent => _farmContent;

  Future<List<Component>> initialize({
    required GrowGreenGame game,
    required String farmName,
    required Vector2 farmPosition,
    required Rectangle farmRect,
    required Farm farm,
    required void Function(List<Component>) addAll,
    required void Function(Component) add,
    required void Function(List<Component>) removeAll,
    required void Function(Component) remove,
  }) async {
    this.game = game;
    this.farmName = farmName;
    this.farmPosition = farmPosition;
    this.farmRect = farmRect;
    this.farm = farm;
    this.addAll = addAll;
    this.add = add;
    this.removeAll = removeAll;
    this.remove = remove;

    /// TODO: read farm's state from db and update all relevant variables
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
    Log.i('$tag: updateFarmComposition: $farmContent');

    switch (_farmState) {
      case FarmState.notBought:
      case FarmState.functioning:
        throw Exception('$tag updateFarmComposition invoked in wrong farm state: $_farmState');

      /// nothing is available in the farm, need to setup from scratch
      case FarmState.notFunctioning:
      case FarmState.notInitialized:
        return _setupFarmFromScratch(farmContent);

      /// only trees are functioning, crops can be updated
      case FarmState.functioningOnlyTrees:
        return _addCropsToFarm(farmContent);

      /// only crops are functioning, tree spaces are available, trees can be updated
      case FarmState.functioningOnlyCrops:
        return _addTreesToFarm(farmContent);
    }
  }

  void _setupFarmFromScratch(FarmContent farmContent) {
    /// agroforestry system
    const treeSize = 50.0;
    const cropSize = 25.0;

    final layoutDistributor = LayoutDistribution(
      systemType: farmContent.systemType,
      size: farmRect.width,
      treeSize: treeSize,
      cropSize: cropSize,
    );

    final farmDistribution = layoutDistributor.getDistribution();

    Log.i('$tag: farmDistribution: $farmDistribution');

    final treePositions = <Vector2>[];
    final cropPositions = <Vector2>[];

    /// populate tree & crop positions
    for (final growablePosition in farmDistribution) {
      switch (growablePosition.growable) {
        case GrowableType.tree:
          treePositions.add(growablePosition.pos);
          break;

        case GrowableType.crop:
          cropPositions.add(growablePosition.pos);
          break;
      }
    }

    /// build trees & crops components
    if (farmContent.hasOnlyCrops) {
      _trees = null;
    } else {
      _trees = Trees(
        treeType: farmContent.trees![0].type,
        treeSize: Vector2(layoutDistributor.treeSize.toDouble() * 1.6, layoutDistributor.treeSize.toDouble()),
        treePositions: treePositions,
        farmSize: farm.size,
      );
    }

    _crops = Crops(
      cropType: farmContent.crop!.type,
      cropPositions: cropPositions,
      cropSize: Vector2(layoutDistributor.cropSize.toDouble() * 1.6, layoutDistributor.cropSize.toDouble()),
      farmSize: farm.size,
    );

    /// add trees & crops to the game
    if (_trees != null) add(_trees!);
    if (_crops != null) add(_crops!);

    _farmContent = farmContent;
    _farmState = FarmState.functioning;
  }

  void _addCropsToFarm(FarmContent farmContent) {}

  void _addTreesToFarm(FarmContent farmContent) {}

  void onTimeChange(DateTime dateTime) {
    Log.i('$tag: onTimeChange: $dateTime');
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
