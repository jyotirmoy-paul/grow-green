import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';

import '../../../../../../../../services/log/log.dart';
import '../../../../../../../../utils/extensions/date_time_extensions.dart';
import '../../../../../../services/game_services/monetary/enums/transaction_type.dart';
import '../../../../../../services/game_services/monetary/models/money_model.dart';
import '../../../../../../services/game_services/time/time_service.dart';
import '../../../../utils/month.dart';
import '../components/crop/crops.dart';
import '../components/crop/enums/crop_type.dart';
import '../components/system/enum/growable.dart';
import '../components/system/real_life/calculators/crops/base_crop.dart';
import '../components/system/real_life/calculators/trees/base_tree.dart';
import '../components/system/ui/layout_distribution.dart';
import '../components/tree/enums/tree_type.dart';
import '../components/tree/trees.dart';
import '../enum/farm_state.dart';
import '../farm.dart';
import '../model/farm_content.dart';

class FarmCoreService {
  static const treeSize = 50.0;
  static const cropSize = 25.0;

  final String tag;
  final Rectangle farmRect;
  final Farm farm;
  final void Function(List<Component>) addComponents;
  final void Function(Component) addComponent;
  final void Function(List<Component>) removeComponents;
  final void Function(Component) removeComponent;

  FarmCoreService({
    required this.farm,
    required this.farmRect,
    required this.addComponents,
    required this.addComponent,
    required this.removeComponents,
    required this.removeComponent,
  }) : tag = 'FarmCoreService[${farm.farmId}]';

  final _farmStateStreamController = StreamController<FarmState>.broadcast();
  late FarmState _farmStateValue;
  set _farmState(FarmState value) {
    Log.d('$tag: updating _farmState to $value');

    _farmStateValue = value;
    _farmStateStreamController.add(value);
  }

  late DateTime _dateTime;

  /// trees & crops components
  FarmContent? _farmContent;
  Trees? _trees;
  Crops? _crops;
  BaseTreeCalculator? _baseTreeCalculator;
  BaseCropCalculator? _baseCropCalculator;
  Month? _treeLastHarvestedInMonth;

  FarmState get farmState => _farmStateValue;
  Stream<FarmState> get farmStateStream => _farmStateStreamController.stream;
  FarmContent? get farmContent => _farmContent;

  /// read farm state from db
  Future<List<Component>> initialize() async {
    _farmState = FarmState.notBought;

    return const [];
  }

  void purchaseSuccess() {
    Log.i('$tag: ${farm.farmId} is successfully purchased!');

    /// move the farm state to not functioning!
    _farmState = FarmState.notFunctioning;
  }

  MoneyModel getTreePotentionValue() {
    final trees = _trees;
    final treesCalculator = _baseTreeCalculator;
    if (trees == null) {
      throw Exception('$tag: invoked getTreePotentionValue with null trees!');
    }
    if (treesCalculator == null) {
      throw Exception('$tag: _checkTree invoked with null _baseTreeCalculator value despite having valid trees!');
    }

    final treeAge = _dateTime.difference(trees.lifeStartedAt).inDays;
    final value = treesCalculator.getPotentialPrice(treeAge);

    return MoneyModel(rupees: value);
  }

  Future<bool> sellTree() async {
    final trees = _trees;

    if (trees == null) {
      throw Exception('$tag: sellTree invoked with null trees. How to sell tree without any tree?');
    }

    final treePotentialValue = getTreePotentionValue();

    /// remove trees reference
    _trees = null;
    _baseTreeCalculator = null;

    /// remove crops component
    removeComponent(trees);

    /// update farm state
    if (_crops == null) {
      _farmState = FarmState.notFunctioning;
    } else {
      _farmState = FarmState.functioningOnlyCrops;
    }

    /// update farm content
    _farmContent = _farmContent?.removeTree();

    /// TODO: Show alert dialog box for progress!

    return farm.game.gameController.monetaryService.transact(
      transactionType: TransactionType.credit,
      value: treePotentialValue,
    );
  }

  /// update farm composition, this method is responsible for following:
  /// 1. Task - Designate positions for crops & trees (if any)
  /// 2. Instantiate - CropsController, FarmerController & TreeController (if not already)
  /// 3. Update - CropSupporter (Trees / Fertilizers)
  void updateFarmContent(FarmContent farmContent) {
    switch (farmState) {
      case FarmState.notBought:
      case FarmState.functioning:
      case FarmState.barren:
      case FarmState.onlyCropsWaiting:
      case FarmState.treesAndCropsButCropsWaiting:
        throw Exception('$tag updateFarmComposition invoked in wrong farm state: $farmState');

      /// nothing is available in the farm, need to setup from scratch
      case FarmState.notFunctioning:
        return _setupFarmFromScratch(farmContent);

      /// only trees are functioning, crops can be updated
      case FarmState.functioningOnlyTrees:
        return _addCropsToFarm(farmContent);

      /// only crops are functioning, tree spaces are available, trees can be updated
      case FarmState.functioningOnlyCrops:
        return _addTreesToFarm(farmContent);
    }
  }

  void _harvestCrops(Crops crop) {
    Log.d('$tag: Harvest season has arrived for ${crop.cropType}, harvesting!');

    /// remove crops reference
    _crops = null;
    _baseCropCalculator = null;

    /// remove crops component
    removeComponent(crop);

    /// update farm state
    if (_trees == null) {
      _farmState = FarmState.notFunctioning;
    } else {
      _farmState = FarmState.functioningOnlyTrees;
    }

    /// update farm content
    _farmContent = _farmContent?.removeCrop();

    /// TODO: Do something with the harvest result
  }

  /// repeateadly checks for crop
  void _updateCrops() {
    final crops = _crops;
    final cropsCalculator = _baseCropCalculator;
    if (crops == null) return;
    if (cropsCalculator == null) {
      throw Exception('$tag: _checkCrop invoked with null _baseCropCalculator value despite having valid crops!');
    }

    final cropAge = _dateTime.difference(crops.lifeStartedAt!).inDays;

    /// check for harvest
    final canHarvestCrop = cropsCalculator.canHarvest(cropAge);
    if (canHarvestCrop) {
      return _harvestCrops(crops);
    }

    /// check for crop stage
    final cropStage = cropsCalculator.getCropStage(cropAge);
    crops.updateCropStage(cropStage);
  }

  void _harvestTrees(Trees trees) {
    /// TODO: Do something with the harvest result
  }

  void _updateTrees() {
    final trees = _trees;
    final treesCalculator = _baseTreeCalculator;
    if (trees == null) return;
    if (treesCalculator == null) {
      throw Exception('$tag: _checkTree invoked with null _baseTreeCalculator value despite having valid trees!');
    }

    final treeAge = _dateTime.difference(trees.lifeStartedAt).inDays;

    /// check for harvest each month (recurring)
    final currentMonth = _dateTime.gameMonth;
    final canHarvestTree = treesCalculator.canHarvest(treeAgeInDays: treeAge, currentMonth: currentMonth);

    if (canHarvestTree && _treeLastHarvestedInMonth != currentMonth) {
      _treeLastHarvestedInMonth = currentMonth;
      _harvestTrees(trees);
    }

    /// update tree stage
    final treeStage = treesCalculator.getTreeStage(treeAge);
    trees.updateTreeStage(treeStage);
  }

  void onTimeChange(DateTime dateTime) {
    _dateTime = dateTime;

    _updateCrops();
    _updateTrees();
  }

  void _putTrees({required Trees trees}) {
    final treeType = trees.treeType;
    _baseTreeCalculator = BaseTreeCalculator.fromTreeType(treeType);

    addComponent(trees);

    if (farmState == FarmState.functioningOnlyCrops) {
      _farmState = FarmState.functioning;
    }

    _trees = trees;
  }

  void _putCropsWhenReady({
    required Crops crops,
    bool areTreesAvailable = false,
  }) {
    Log.i('$tag: _putCropsWhenReady invoked, waiting until harvest season for ${crops.cropType}');

    if (areTreesAvailable) {
      _farmState = FarmState.treesAndCropsButCropsWaiting;
    } else {
      _farmState = FarmState.onlyCropsWaiting;
    }

    final cropType = crops.cropType;
    final cropCalculator = BaseCropCalculator.fromCropType(cropType);

    /// update base crop calculator
    _baseCropCalculator = cropCalculator;

    StreamSubscription? subscription;

    subscription = TimeService().dateTimeStream.listen((dateTime) {
      if (cropCalculator.canSow(dateTime.gameMonth)) {
        /// hurray! we can finally sow the crop, let's do it

        subscription?.cancel();
        Log.i('$tag: _putCropsWhenReady: Sowing season has arrived for ${crops.cropType}, sowing now!');

        if (areTreesAvailable && _trees == null) {
          _farmState = FarmState.functioningOnlyCrops;
        } else {
          _farmState = FarmState.functioning;
        }

        /// set crop's life started at value
        crops.lifeStartedAt = dateTime;

        addComponent(crops);

        /// update in the global variable
        _crops = crops;
      }
    });
  }

  void _setupFarmFromScratch(FarmContent farmContent) {
    _farmContent = farmContent;

    final layoutDistributor = LayoutDistribution(
      systemType: farmContent.systemType,
      size: farmRect.width,
      treeSize: treeSize,
      cropSize: cropSize,
    );

    final farmDistribution = layoutDistributor.getDistribution();

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
        lifeStartedAt: _dateTime,
        treeType: farmContent.trees![0].type as TreeType,
        treeSize: layoutDistributor.treeSizeVector2,
        treePositions: treePositions,
        farmSize: farm.size,
      );
    }

    final crops = Crops(
      cropType: farmContent.crop!.type as CropType,
      cropPositions: cropPositions,
      cropSize: layoutDistributor.cropSizeVector2,
      farmSize: farm.size,
    );

    /// add trees & crops to the game
    if (_trees != null) _putTrees(trees: _trees!);
    _putCropsWhenReady(crops: crops, areTreesAvailable: _trees != null);
  }

  void _addCropsToFarm(FarmContent farmContent) {
    if (_farmContent == null) {
      throw Exception('$tag: Can not invoke _addCropsToFarm on a farm which is not initialized. _farmContent is null.');
    }

    _farmContent = _farmContent!.copyWith(
      crop: farmContent.crop,
      fertilizer: farmContent.fertilizer,
    );

    final layoutDistributor = LayoutDistribution(
      systemType: farmContent.systemType,
      size: farmRect.width,
      treeSize: treeSize,
      cropSize: cropSize,
    );

    final farmDistribution = layoutDistributor.getDistribution();

    final cropPositions = <Vector2>[];

    /// populate crop positions
    for (final growablePosition in farmDistribution) {
      if (growablePosition.growable == GrowableType.crop) {
        cropPositions.add(growablePosition.pos);
      }
    }

    final crops = Crops(
      cropType: farmContent.crop!.type as CropType,
      cropPositions: cropPositions,
      cropSize: layoutDistributor.cropSizeVector2,
      farmSize: farm.size,
    );

    _putCropsWhenReady(
      crops: crops,
      areTreesAvailable: true,
    );
  }

  void _addTreesToFarm(FarmContent farmContent) {
    if (_farmContent == null) {
      throw Exception('$tag: Can not invoke _addCropsToFarm on a farm which is not initialized. _farmContent is null.');
    }

    _farmContent = _farmContent!.copyWith(
      trees: farmContent.trees,
    );

    final layoutDistributor = LayoutDistribution(
      systemType: farmContent.systemType,
      size: farmRect.width,
      treeSize: treeSize,
      cropSize: cropSize,
    );

    final farmDistribution = layoutDistributor.getDistribution();

    final treePositions = <Vector2>[];

    /// populate crop positions
    for (final growablePosition in farmDistribution) {
      if (growablePosition.growable == GrowableType.tree) {
        treePositions.add(growablePosition.pos);
      }
    }

    _trees = Trees(
      lifeStartedAt: _dateTime,
      treeType: farmContent.trees![0].type as TreeType,
      treeSize: layoutDistributor.treeSizeVector2,
      treePositions: treePositions,
      farmSize: farm.size,
    );

    /// add tree
    _putTrees(trees: _trees!);
  }
}
