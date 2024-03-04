import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';

import '../../../../../../../../services/log/log.dart';
import '../../../../../../../../utils/extensions/date_time_extensions.dart';
import '../../../../../../enums/agroforestry_type.dart';
import '../../../../../../services/datastore/game_datastore.dart';
import '../../../../../../services/game_services/monetary/models/money_model.dart';
import '../../../../../../services/game_services/time/time_service.dart';
import '../components/crop/crops.dart';
import '../components/crop/enums/crop_type.dart';
import '../components/system/enum/growable.dart';
import '../components/system/real_life/calculators/crops/base_crop.dart';
import '../components/system/real_life/calculators/trees/base_tree.dart';
import '../components/system/real_life/utils/soil_health_calculator.dart';
import '../components/system/ui/layout_distribution.dart';
import '../components/tree/enums/tree_type.dart';
import '../components/tree/trees.dart';
import '../enum/farm_state.dart';
import '../farm.dart';
import '../model/farm_content.dart';
import '../model/farm_state_model.dart';
import '../model/fertilizer/fertilizer_type.dart';
import '../model/harvest_model.dart';
import '../model/soil_health_model.dart';
import '../model/tree_data.dart';
import 'harvest/harvest_core_service.dart';
import 'harvest/harvest_recorder.dart';
import 'soil_health/soil_health_recorder.dart';

class FarmCoreService {
  static const treeSize = 50.0;
  static const cropSize = 25.0;
  static const soilHealthRecordIntervalTick = 16;

  final String tag;
  final Rectangle farmRect;
  final Farm farm;
  final HarvestRecorder _harvestRecorder;
  final SoilHealthRecorder _soilHealthRecorder;
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
  })  : tag = 'FarmCoreService[${farm.farmId}]',
        _dateTime = TimeService().currentDateTime,
        _harvestRecorder = HarvestRecorder(farmId: farm.farmId, gameDatastore: farm.game.gameDatastore),
        _soilHealthRecorder = SoilHealthRecorder(farmId: farm.farmId, gameDatastore: farm.game.gameDatastore);

  final _farmStateModelStreamController = StreamController<FarmStateModel>.broadcast();

  bool _initPhase = true;
  int _soilHealthRecorderCurrentTick = 0;

  late FarmStateModel _farmStateModelValue;

  DateTime _dateTime;

  /// trees & crops components
  Trees? _trees;
  Crops? _crops;
  BaseTreeCalculator? _baseTreeCalculator;
  BaseCropCalculator? _baseCropCalculator;
  double? _updatedSoilhealthPercentage;

  /// getters
  GameDatastore get gameDatastore => farm.game.gameDatastore;
  FarmState get farmState => _farmStateModelValue.farmState;
  FarmContent? get farmContent => _farmStateModelValue.farmContent;
  List<HarvestModel> get harvestModels => _harvestRecorder.harvestModels;
  List<SoilHealthModel> get soilHealthModels => _soilHealthRecorder.soilHealthModels;
  double get soilHealthPercentage => _farmStateModelValue.soilHealthPercentage;
  DateTime? get cropSowRequestedAt => _farmStateModelValue.cropSowRequestedAt;
  DateTime? get _treeLastHarvestedOn => _farmStateModelValue.treeLastHarvestedOn;
  TreeData get treeData {
    final farmContent = this.farmContent;
    if (farmContent == null) {
      throw Exception('$tag: treeData getter invoked at null farmContent, how can this happen?');
    }

    final trees = _trees;
    if (trees == null) {
      throw Exception('$tag: treeData getter invoked at null trees, how can this happen?');
    }

    return TreeData(
      agroforestryType: farmContent.systemType as AgroforestryType,
      treeType: trees.treeType,
      lifeStartedAt: trees.lifeStartedAt,
    );
  }

  /// streams available for getting updates of farm!
  Stream<FarmState> get farmStateStream => _farmStateModelStreamController.stream.map<FarmState>(
        (e) => e.farmState,
      );

  Stream<List<HarvestModelNonAckData>> get harvestNotAckDataStream => _harvestRecorder.harvestNotAckDataStream;

  FarmContent? _getFarmContentAsPerFarmState(FarmStateModel newFarmStateModel) {
    switch (newFarmStateModel.farmState) {
      case FarmState.notBought:
      case FarmState.barren:
      case FarmState.notFunctioning:
        return null;

      case FarmState.onlyCropsWaiting:
      case FarmState.treesAndCropsButCropsWaiting:
      case FarmState.functioning:
        return newFarmStateModel.farmContent;

      case FarmState.functioningOnlyTrees:
        return newFarmStateModel.farmContent?.copyWith(
          crop: null,
          fertilizer: null,
        );

      case FarmState.treesRemovedOnlyCropsWaiting:
      case FarmState.functioningOnlyCrops:
        return newFarmStateModel.farmContent?.copyWith(
          trees: null,
        );
    }
  }

  void updateFarmStateModel(FarmStateModel newFarmStateModel) {
    Log.d('$tag: updating _farmStateModel to $newFarmStateModel, _initPhase: $_initPhase');

    /// update farm state value
    _farmStateModelValue = newFarmStateModel;

    if (!_initPhase) {
      if (_crops == null) {
        newFarmStateModel.cropsLifeStartedAt = null;
      }

      if (newFarmStateModel.farmContent?.crop == null) {
        newFarmStateModel.cropSowRequestedAt = null;
      }

      if (_trees == null) {
        newFarmStateModel.treeLastHarvestedOn = null;
        newFarmStateModel.treesLifeStartedAt = null;
      }

      newFarmStateModel.farmContent = _getFarmContentAsPerFarmState(newFarmStateModel);
    }

    /// update farm state model & farm state
    Log.d('$tag: notifying all listeners of changes in farm state model');
    _farmStateModelStreamController.add(newFarmStateModel);

    if (!_initPhase) {
      /// sync changes to server - it's a fire and forget call
      /// there are internal mechanisms for retrying
      unawaited(gameDatastore.saveFarmState(newFarmStateModel));
    }
  }

  void _handleBarren() {
    throw UnimplementedError('barren land implementation is not done yet');
  }

  ((List<Vector2>, Vector2), (List<Vector2>, Vector2)) _getTreesAndCropsPositionAndSizeFor(FarmContent farmContent) {
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

    return ((treePositions, layoutDistributor.treeSizeVector2), (cropPositions, layoutDistributor.cropSizeVector2));
  }

  void _populateFarmFromData(FarmContent farmContent) {
    final (treeData, cropData) = _getTreesAndCropsPositionAndSizeFor(farmContent);

    _trees = null;
    _crops = null;

    if (farmContent.hasCrop) {
      _crops = Crops(
        lifeStartedAt: _farmStateModelValue.cropsLifeStartedAt,
        cropType: farmContent.crop!.type as CropType,
        cropPositions: cropData.$1,
        cropSize: cropData.$2,
        farmSize: farm.size,
      );
    }

    if (farmContent.hasTrees) {
      _trees = Trees(
        lifeStartedAt: _farmStateModelValue.treesLifeStartedAt!,
        treeType: farmContent.trees![0].type as TreeType,
        treePositions: treeData.$1,
        treeSize: treeData.$2,
        farmSize: farm.size,
      );
    }

    /// add trees & crops to the game
    if (_trees != null) _putTreesAndGetFarmState(trees: _trees!);
    if (_crops != null) {
      final cropType = _crops!.cropType;

      /// update base crop calculator
      _baseCropCalculator = BaseCropCalculator.fromCropType(cropType);

      addComponent(_crops!);
    }
  }

  /// TODO: Move these logics to farm populator service
  void _prepareFarm() {
    switch (farmState) {
      case FarmState.onlyCropsWaiting:
      case FarmState.treesAndCropsButCropsWaiting:
      case FarmState.treesRemovedOnlyCropsWaiting:
        if (farmContent == null) {
          throw Exception('$tag: invalid farm content for farmState: $farmState');
        }

        return _setupFarmFromScratch(farmContent!);

      case FarmState.functioning:
      case FarmState.functioningOnlyTrees:
      case FarmState.functioningOnlyCrops:
        if (farmContent == null) {
          throw Exception('$tag: invalid farm content for farmState: $farmState');
        }

        return _populateFarmFromData(farmContent!);

      case FarmState.barren:
        return _handleBarren();

      /// nothing special to do
      case FarmState.notBought:
      case FarmState.notFunctioning:
        return;
    }
  }

  void notifyHarvestModelData() {
    _harvestRecorder.notiy();
  }

  /// read farm state from db
  Future<void> initialize() async {
    /// init phase is true
    _initPhase = true;

    /// fetch harvest recorder & soil health data
    await _harvestRecorder.init();
    await _soilHealthRecorder.init();

    final farmStateModel = await farm.game.gameDatastore.getFarmState(farm.farmId);

    /// write to server
    updateFarmStateModel(farmStateModel);

    _prepareFarm();

    _updateCrops();
    _updateTrees();

    /// mark init phase to be false
    _initPhase = false;
  }

  void purchaseSuccess() {
    final farmStateModel = _farmStateModelValue;

    Log.i('$tag: ${farm.farmId} is successfully purchased!');

    /// move the farm state to not functioning!
    farmStateModel.farmState = FarmState.notFunctioning;
    updateFarmStateModel(farmStateModel);
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

  void sellTree() async {
    final trees = _trees;
    if (trees == null) {
      throw Exception('$tag: sellTree invoked with null trees. How to sell tree without any tree?');
    }

    final farmStateModel = _farmStateModelValue;

    /// remove trees reference
    _trees = null;
    _baseTreeCalculator = null;

    /// remove crops component
    removeComponent(trees);

    /// update farm state
    if (farmStateModel.farmContent?.crop == null) {
      farmStateModel.farmState = FarmState.notFunctioning;
    } else {
      /// farm has crops
      if (_crops == null) {
        /// crops were not ready, and still waiting
        farmStateModel.farmState = FarmState.treesRemovedOnlyCropsWaiting;
      } else {
        farmStateModel.farmState = FarmState.functioningOnlyCrops;
      }
    }

    /// update farm content
    farmStateModel.farmContent = farmContent?.removeTree();

    final treeAge = _dateTime.difference(trees.lifeStartedAt).inDays;

    final treeHarvestService = HarvestCoreService.forTree(
      treeType: trees.treeType,
      treeAgeInDays: treeAge,
      currentDateTime: _dateTime,
    );

    final harvestModel = treeHarvestService.sell();
    _harvestRecorder.recordHarvest(harvestModel);

    /// write to server
    updateFarmStateModel(farmStateModel);
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
      case FarmState.treesRemovedOnlyCropsWaiting:
        return _addTreesToFarm(farmContent);
    }
  }

  void _harvestCrops(Crops crop, int cropAge) {
    final farmStateModel = _farmStateModelValue;
    Log.d('$tag: Harvest season has arrived for ${crop.cropType}, harvesting!');

    /// let's generate harvest for crop
    final cropHarvestService = HarvestCoreService.forCrop(
      cropType: crop.cropType,
      currentDateTime: _dateTime,
      cropAgeInDays: cropAge,
    );

    final harvestModel = cropHarvestService.harvest();
    _harvestRecorder.recordHarvest(harvestModel);

    /// remove crops reference
    _crops = null;
    _baseCropCalculator = null;

    /// remove crops component
    removeComponent(crop);

    /// update farm state
    if (_trees == null) {
      farmStateModel.farmState = FarmState.notFunctioning;
    } else {
      farmStateModel.farmState = FarmState.functioningOnlyTrees;
    }

    /// update farm content
    farmStateModel.farmContent = farmContent?.removeCrop();

    /// write to server
    updateFarmStateModel(farmStateModel);
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
      return _harvestCrops(crops, cropAge);
    }

    /// check for crop stage
    final cropStage = cropsCalculator.getCropStage(cropAge);
    crops.updateCropStage(cropStage);
  }

  /// periodic harvest of trees
  void _harvestTrees(Trees trees, int treeAge) {
    final farmStateModel = _farmStateModelValue;
    Log.i('$tag: _harvestTrees invoked for ${trees.treeType} on ${_dateTime.gameMonth}');

    /// update last harvested on
    farmStateModel.treeLastHarvestedOn = _dateTime;

    final treeHarvestService = HarvestCoreService.forTree(
      treeType: trees.treeType,
      treeAgeInDays: treeAge,
      currentDateTime: _dateTime,
    );

    final harvestModel = treeHarvestService.harvest();
    _harvestRecorder.recordHarvest(harvestModel);

    /// write to server
    updateFarmStateModel(farmStateModel);
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

    bool canHarvesAgain = true;
    if (_treeLastHarvestedOn != null) {
      final harvestedDayDiff = _dateTime.difference(_treeLastHarvestedOn!).inDays;

      /// if more than a month has passed, we can harvest again whenever treesCalculator says it's harvest time
      canHarvesAgain = harvestedDayDiff > 31;
    }

    if (canHarvestTree && canHarvesAgain) {
      _harvestTrees(trees, treeAge);
    }

    /// update tree stage
    final treeStage = treesCalculator.getTreeStage(treeAge);
    trees.updateTreeStage(treeStage);
  }

  bool isSoilHealthAffected() {
    if (farmContent == null) return false;

    final hasFertilizerEffect = _crops != null;
    final hasTreeEffect = farmContent?.hasTrees ?? false;

    if (!hasFertilizerEffect && !hasTreeEffect) {
      return false;
    }

    return true;
  }

  /// update the soil health based on the contents of the current farm
  /// this is done on every tick
  void _updateSoilHealth() {
    if (!isSoilHealthAffected()) return;

    final newSoilHealth = SoilHealthCalculator.getNewSoilHealth(
      currentSoilHealth: soilHealthPercentage,

      /// we don't care about fertilizer used, until there's crop in the farm
      currentFertilizerInUse: _crops == null ? null : farmContent!.fertilizer,
      currentSystemType: farmContent!.systemType,
      areTreesPresent: farmContent!.hasTrees,
    );

    /// we store the updated soil health locally and DO NOT sync the data immediately
    /// so whenever a sync happens, the soil health gets updated
    _updatedSoilhealthPercentage = newSoilHealth;
  }

  void _recordSoilHealth() async {
    if (!isSoilHealthAffected()) return;

    final newSoilHealth = _updatedSoilhealthPercentage!;
    Log.i('$tag: invoked _recordSoilHealth(), recording current soil health of: $newSoilHealth');

    final soilHealthModel = SoilHealthModel(
      recordedOnDate: _dateTime,
      currentSoilHealth: newSoilHealth,
      systemType: farmContent!.systemType,

      /// we don't care about fertilizer used, until there's crop in the farm
      fertilizerType: _crops == null ? null : farmContent!.fertilizer?.type as FertilizerType?,
      areTreesPresent: farmContent!.hasTrees,
    );

    await _soilHealthRecorder.record(soilHealthModel);

    /// this will sync the latest soilHealth value
    await gameDatastore.updateSoilHealth(
      farmId: farm.farmId,
      data: SoilHealthValueUpdateModel(soilHealthPercentage: newSoilHealth),
    );
  }

  void _checkToRecordSoilHealthData() {
    if (_soilHealthRecorderCurrentTick == soilHealthRecordIntervalTick) {
      /// reset soil health recorder tick value
      _soilHealthRecorderCurrentTick = 0;

      /// record soil health
      _recordSoilHealth();
    } else {
      _soilHealthRecorderCurrentTick++;
    }
  }

  void onTimeChange(DateTime dateTime) {
    _dateTime = dateTime;

    /// trees & crops
    _updateCrops();
    _updateTrees();

    /// soil health
    _updateSoilHealth();
    _checkToRecordSoilHealthData();
  }

  FarmState? _putTreesAndGetFarmState({required Trees trees}) {
    final treeType = trees.treeType;
    _baseTreeCalculator = BaseTreeCalculator.fromTreeType(treeType);

    addComponent(trees);

    _trees = trees;

    if (farmState == FarmState.functioningOnlyCrops) {
      return FarmState.functioning;
    } else if (farmState == FarmState.treesRemovedOnlyCropsWaiting) {
      return FarmState.treesAndCropsButCropsWaiting;
    }

    return null;
  }

  void _putCropsWhenReady({
    required Crops crops,
    required FarmStateModel farmStateModel,
    bool areTreesAvailable = false,
  }) {
    Log.i('$tag: _putCropsWhenReady invoked, waiting until harvest season for ${crops.cropType}');

    /// if trees were not removed while waiting for crop, handle the farm state accordingly
    if (farmState != FarmState.treesRemovedOnlyCropsWaiting) {
      if (areTreesAvailable) {
        farmStateModel.farmState = FarmState.treesAndCropsButCropsWaiting;
      } else {
        farmStateModel.farmState = FarmState.onlyCropsWaiting;
      }
    }

    /// keep a record of when crop sow was requested
    final cropSowRequestedAt = farmStateModel.cropSowRequestedAt ?? _dateTime;
    farmStateModel.cropSowRequestedAt = cropSowRequestedAt;

    /// write to server
    updateFarmStateModel(farmStateModel);

    final cropType = crops.cropType;
    final cropCalculator = BaseCropCalculator.fromCropType(cropType);

    /// update base crop calculator
    _baseCropCalculator = cropCalculator;

    StreamSubscription? subscription;

    subscription = TimeService().dateTimeStream.listen((dateTime) {
      if (cropCalculator.canSow(dateTime.gameMonth)) {
        /// hurray! we can finally sow the crop, let's do it
        final farmStateModel = _farmStateModelValue;

        subscription?.cancel();
        Log.i('$tag: _putCropsWhenReady: Sowing season has arrived for ${crops.cropType}, sowing now!');

        if (areTreesAvailable && _trees == null) {
          farmStateModel.farmState = FarmState.functioningOnlyCrops;
        } else {
          farmStateModel.farmState = FarmState.functioning;
        }

        /// set crop's life started at value
        crops.lifeStartedAt = dateTime;
        farmStateModel.cropsLifeStartedAt = dateTime;

        /// update in the global variable
        _crops = crops;

        addComponent(crops);

        /// write to server
        updateFarmStateModel(farmStateModel);
      }
    });
  }

  void _setupFarmFromScratch(FarmContent farmContent) {
    final farmStateModel = _farmStateModelValue;

    farmStateModel.farmContent = farmContent;

    final (treeData, cropData) = _getTreesAndCropsPositionAndSizeFor(farmContent);

    /// build trees & crops components
    if (farmContent.hasOnlyCrops) {
      _trees = null;
    } else {
      final treeLifeStartedAt = farmStateModel.treesLifeStartedAt ?? _dateTime;

      _trees = Trees(
        lifeStartedAt: treeLifeStartedAt,
        treeType: farmContent.trees![0].type as TreeType,
        treePositions: treeData.$1,
        treeSize: treeData.$2,
        farmSize: farm.size,
      );

      farmStateModel.treesLifeStartedAt = treeLifeStartedAt;
    }

    final crops = Crops(
      cropType: farmContent.crop!.type as CropType,
      cropPositions: cropData.$1,
      cropSize: cropData.$2,
      farmSize: farm.size,
    );

    /// add trees & crops to the game
    if (_trees != null) {
      final farmState = _putTreesAndGetFarmState(trees: _trees!);
      if (farmState != null) farmStateModel.farmState = farmState;
    }

    _putCropsWhenReady(
      crops: crops,
      areTreesAvailable: _trees != null,
      farmStateModel: farmStateModel,
    );
  }

  void _addCropsToFarm(FarmContent farmContent) {
    if (this.farmContent == null) {
      throw Exception('$tag: Can not invoke _addCropsToFarm on a farm which is not initialized. _farmContent is null.');
    }

    final farmStateModel = _farmStateModelValue;

    farmStateModel.farmContent = this.farmContent!.copyWith(
          crop: farmContent.crop,
          fertilizer: farmContent.fertilizer,
        );

    final (_, cropData) = _getTreesAndCropsPositionAndSizeFor(farmContent);

    final crops = Crops(
      cropType: farmContent.crop!.type as CropType,
      cropPositions: cropData.$1,
      cropSize: cropData.$2,
      farmSize: farm.size,
    );

    _putCropsWhenReady(
      crops: crops,
      areTreesAvailable: true,
      farmStateModel: farmStateModel,
    );
  }

  void _addTreesToFarm(FarmContent farmContent) {
    if (this.farmContent == null) {
      throw Exception('$tag: Can not invoke _addCropsToFarm on a farm which is not initialized. _farmContent is null.');
    }

    final farmStateModel = _farmStateModelValue;

    farmStateModel.farmContent = this.farmContent!.copyWith(
          trees: farmContent.trees,
        );
    final (treeData, _) = _getTreesAndCropsPositionAndSizeFor(farmContent);

    _trees = Trees(
      lifeStartedAt: _dateTime,
      treeType: farmContent.trees![0].type as TreeType,
      treePositions: treeData.$1,
      treeSize: treeData.$2,
      farmSize: farm.size,
    );

    /// add tree
    final state = _putTreesAndGetFarmState(trees: _trees!);
    if (state != null) {
      farmStateModel.farmState = state;
    }

    updateFarmStateModel(farmStateModel);
  }

  void markHarvestsAckFor({
    required List<String> ids,
  }) {
    Log.d('markAllHarvestsAck($ids) invoked, to mark given harvest models as ack');
    _harvestRecorder.updateAckStatusFor(ids);
  }
}
