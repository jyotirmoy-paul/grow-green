import '../../../../../../../../../../utils/game_utils.dart';
import '../../../../../../../../../enums/agroforestry_type.dart';
import '../../../../../../../../../enums/farm_system_type.dart';
import '../../../../../../../../../enums/system_type.dart';
import '../../../../../../../../../services/game_services/time/time_service.dart';
import '../../../../../../overlays/farm_composition_dialog/choose_maintenance/logic/support_config.dart';
import '../../../../model/content.dart';
import '../../../../model/farm_content.dart';
import '../../../../model/fertilizer/fertilizer_type.dart';
import '../../../crop/enums/crop_type.dart';
import '../../../tree/enums/tree_type.dart';
import '../../enum/growable.dart';
import '../calculators/crops/base_crop.dart';
import 'qty_calculator.dart';

abstract class SoilHealthCalculator {
  static const tag = 'SoilHealthCalculator';

  static double fertilizerEffect({
    required Content fertilizer,
    required double soilHealthPercentage,
  }) {
    if (fertilizer.type is! FertilizerType) {
      throw Exception('$tag: _fertilizerEffect() invoked with wrong fertilizer.type: ${fertilizer.type}');
    }

    final fertilizerType = fertilizer.type as FertilizerType;

    final fertilizerPerYearPerHectar = QtyCalculator.getFertilizerUsedForGrowingGrowableForTime(
      soilHealthPercentage: soilHealthPercentage,
      ageInMonths: 12,
      fertilizerType: fertilizerType,
      growableType: GrowableType.crop,
      systemType: FarmSystemType.monoculture,
    );
    final fertilizerQty = fertilizer.qty.value;

    final fertilizerUsedRatio = fertilizerQty / fertilizerPerYearPerHectar.value;

    final fertilizerEffectWithFullQty = switch (fertilizerType) {
      FertilizerType.organic => 0.2,
      FertilizerType.chemical => -0.2,
    };

    return fertilizerEffectWithFullQty * fertilizerUsedRatio;
  }

  static double systemTypeAffect({
    required SystemType systemType,
    required bool treesPresent,
  }) {
    if (!treesPresent) return 0;
    if (systemType is AgroforestryType) {
      switch (systemType) {
        case AgroforestryType.boundary:
          return 0.2;
        case AgroforestryType.alley:
          return 0.4;
        case AgroforestryType.block:
          return 0.6;
      }
    } else {
      return 0;
    }
  }

  /// this method is build on the assumption that, it will be invoked at every tick!
  static double getNewSoilHealth({
    required FarmContent farmContent,
    required double currentSoilHealth,
  }) {
    /// 1. usage of crop age to understand the duration of farming
    /// 2. capping the soil health growth at some percentage (may be 20%)
    /// 3. using a logarithmic function to lessen the growth everytime
    double totalFertilizerEffect = 0;

    if (farmContent.hasCrop && farmContent.hasCropSupport) {
      final cropFertilizerEffectForMaxAge = fertilizerEffect(
        fertilizer: farmContent.cropSupportConfig!.fertilizerConfig,
        soilHealthPercentage: currentSoilHealth,
      );
      final cropAgeInMonths = BaseCropCalculator.fromCropType(farmContent.crop!.type as CropType).maxAgeInMonths;
      final cropAgeInDays = cropAgeInMonths * 30;

      totalFertilizerEffect += cropFertilizerEffectForMaxAge / cropAgeInDays;
    }
    if (farmContent.hasTrees && farmContent.hasTreeSupport) {
      final treeFertilizerEffect = fertilizerEffect(
        fertilizer: farmContent.treeSupportConfig!.fertilizerConfig,
        soilHealthPercentage: currentSoilHealth,
      );
      const treeFertilizerUsageInDays = 365;
      totalFertilizerEffect += treeFertilizerEffect / treeFertilizerUsageInDays;
    }

    final systemTypeEffectValue = systemTypeAffect(
      systemType: farmContent.systemType,
      treesPresent: farmContent.hasTrees,
    );
    final systemTypeEffectPerDay = systemTypeEffectValue / 365;

    return currentSoilHealth + totalFertilizerEffect + systemTypeEffectPerDay;
  }

  static double calculateSoilHealthFactor(double soilHealthPercentage) {
    if (soilHealthPercentage <= 0.2) {
      return 1; // No reduction for very very poor soil
    } else if (soilHealthPercentage <= 1) {
      return -0.2 * soilHealthPercentage + 1; // Reduction for poor soil
    } else if (soilHealthPercentage <= 5) {
      return -0.1 * soilHealthPercentage + 0.9; // Reduction for good soil health
    } else {
      // soilHealthPercentage > 5
      return 0.4; // Reduction for excellent soil health
    }
  }
}
