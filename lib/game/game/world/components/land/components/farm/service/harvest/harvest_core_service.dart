import '../../../../../../../services/game_services/monetary/models/money_model.dart';
import '../../components/crop/enums/crop_type.dart';
import '../../components/system/real_life/calculators/crops/base_crop.dart';
import '../../components/system/real_life/calculators/trees/base_tree.dart';
import '../../components/tree/enums/tree_type.dart';
import '../../model/harvest_model.dart';

/// Assumptions for MVP-1
/// 1. Tree's yield are always 100%
abstract interface class HarvestCoreService {
  static CropHarvestCoreService forCrop({
    required DateTime currentDateTime,
    required CropType cropType,
    required int cropAgeInDays,
  }) {
    return CropHarvestCoreService(
      cropType: cropType,
      currentDateTime: currentDateTime,
      cropAgeInDays: cropAgeInDays,
    );
  }

  static TreeHarvestCoreService forTree({
    required TreeType treeType,
    required int treeAgeInDays,
    required DateTime currentDateTime,
  }) {
    return TreeHarvestCoreService(
      treeType: treeType,
      treeAgeInDays: treeAgeInDays,
      currentDateTime: currentDateTime,
    );
  }

  HarvestModel harvest();
}

class CropHarvestCoreService implements HarvestCoreService {
  final DateTime currentDateTime;
  final int cropAgeInDays;
  final CropType cropType;
  final BaseCropCalculator cropCalculator;

  CropHarvestCoreService({
    required this.cropType,
    required this.currentDateTime,
    required this.cropAgeInDays,
  }) : cropCalculator = BaseCropCalculator.fromCropType(cropType);

  @override
  HarvestModel harvest() {
    return HarvestModel(
      harvestType: HarvestType.oneTime,
      yield: 1.0, // FIXME
      money: MoneyModel(rupees: 10000), // FIXME
      growable: cropType,
      dateOfHarvest: currentDateTime,
      ageAtHarvest: cropAgeInDays,
    );
  }
}

class TreeHarvestCoreService implements HarvestCoreService {
  final TreeType treeType;
  final int treeAgeInDays;
  final DateTime currentDateTime;
  final BaseTreeCalculator treeCalculator;

  TreeHarvestCoreService({
    required this.treeType,
    required this.treeAgeInDays,
    required this.currentDateTime,
  }) : treeCalculator = BaseTreeCalculator.fromTreeType(treeType);

  @override
  HarvestModel harvest() {
    final treeRecurringValue = treeCalculator.getRecurringHarvest(treeAgeInDays);

    return HarvestModel(
      harvestType: HarvestType.recurring,
      yield: 1.0,
      money: MoneyModel(rupees: treeRecurringValue),
      growable: treeType,
      dateOfHarvest: currentDateTime,
      ageAtHarvest: treeAgeInDays,
    );
  }

  HarvestModel sell() {
    final treePotentialPrice = treeCalculator.getPotentialPrice(treeAgeInDays);

    return HarvestModel(
      harvestType: HarvestType.oneTime,
      yield: 1.0,
      money: MoneyModel(rupees: treePotentialPrice),
      growable: treeType,
      dateOfHarvest: currentDateTime,
      ageAtHarvest: treeAgeInDays,
    );
  }
}
