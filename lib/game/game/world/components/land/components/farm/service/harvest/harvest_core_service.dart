import '../../../../../../../enums/system_type.dart';
import '../../../../../../../services/game_services/monetary/models/money_model.dart';
import '../../components/crop/enums/crop_type.dart';
import '../../components/system/real_life/calculators/crops/base_crop.dart';
import '../../components/system/real_life/calculators/trees/base_tree.dart';
import '../../components/system/real_life/systems/database/layouts.dart';
import '../../components/system/real_life/utils/RevenueCalculator.dart';
import '../../components/tree/enums/tree_type.dart';
import '../../model/harvest_model.dart';

/// Assumptions for MVP-1
/// 1. Tree's yield are always 100%
abstract interface class HarvestCoreService {
  static CropHarvestCoreService forCrop({
    required DateTime currentDateTime,
    required CropType cropType,
    required int cropAgeInDays,
    required SystemType systemType,
  }) {
    return CropHarvestCoreService(
      cropType: cropType,
      currentDateTime: currentDateTime,
      cropAgeInDays: cropAgeInDays,
      systemType: systemType,
    );
  }

  static TreeHarvestCoreService forTree({
    required TreeType treeType,
    required int treeAgeInDays,
    required DateTime currentDateTime,
    required SystemType systemType,
  }) {
    return TreeHarvestCoreService(
      treeType: treeType,
      treeAgeInDays: treeAgeInDays,
      currentDateTime: currentDateTime,
      systemType: systemType,
    );
  }

  HarvestModel harvest();
}

class CropHarvestCoreService implements HarvestCoreService {
  final DateTime currentDateTime;
  final int cropAgeInDays;
  final CropType cropType;
  final BaseCropCalculator cropCalculator;
  final SystemType systemType;

  CropHarvestCoreService({
    required this.cropType,
    required this.currentDateTime,
    required this.cropAgeInDays,
    required this.systemType,
  }) : cropCalculator = BaseCropCalculator.fromCropType(cropType);

  @override
  HarvestModel harvest() {
    final revenueValue = RevenueCalculator.getCropRevenue(cropType: cropType, systemType: systemType);
    return HarvestModel(
      harvestType: HarvestType.oneTime,
      yield: 1.0,
      revenue: MoneyModel(value: revenueValue),
      growable: cropType,
      dateOfHarvest: currentDateTime,
      ageInDaysAtHarvest: cropAgeInDays,
    );
  }
}

class TreeHarvestCoreService implements HarvestCoreService {
  final TreeType treeType;
  final int treeAgeInDays;
  final DateTime currentDateTime;
  final BaseTreeCalculator treeCalculator;
  final SystemType systemType;

  TreeHarvestCoreService({
    required this.treeType,
    required this.treeAgeInDays,
    required this.currentDateTime,
    required this.systemType,
  }) : treeCalculator = BaseTreeCalculator.fromTreeType(treeType);

  @override
  HarvestModel harvest() {
    final treeRecurringValue = treeCalculator.getRecurringHarvest(treeAgeInDays);
    final numberOfTrees = PlantationLayout.fromSytemType(systemType).numberOfTrees;
    final totalRecurringRevenue = treeRecurringValue * numberOfTrees;
    return HarvestModel(
      harvestType: HarvestType.recurring,
      yield: 1.0,
      revenue: MoneyModel(value: totalRecurringRevenue),
      growable: treeType,
      dateOfHarvest: currentDateTime,
      ageInDaysAtHarvest: treeAgeInDays,
    );
  }

  HarvestModel sell() {
    final treePotentialPrice = treeCalculator.getPotentialPrice(treeAgeInDays);
    final numberOfTrees = PlantationLayout.fromSytemType(systemType).numberOfTrees;
    final totalPotentialRevenue = treePotentialPrice * numberOfTrees;
    return HarvestModel(
      harvestType: HarvestType.oneTime,
      yield: 1.0,
      revenue: MoneyModel(value: totalPotentialRevenue),
      growable: treeType,
      dateOfHarvest: currentDateTime,
      ageInDaysAtHarvest: treeAgeInDays,
    );
  }
}
