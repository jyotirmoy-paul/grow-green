import '../../../../../../../../../../utils/game_utils.dart';
import '../../../../../../../../../enums/agroforestry_type.dart';
import '../../../../../../../../../enums/farm_system_type.dart';
import '../../../../../../../../../enums/system_type.dart';
import '../../../../model/content.dart';
import '../../../../model/fertilizer/fertilizer_type.dart';
import 'maintance_calculator.dart';
import 'qty_calculator.dart';

abstract class SoilHealthCalculator {
  static const tag = 'SoilHealthCalculator';

  static double _fertilizerEffect({
    required Content fertilizer,
    required double soilHealthPercentage,
  }) {
    if (fertilizer.type is! FertilizerType) {
      throw Exception('$tag: _fertilizerEffect() invoked with wrong fertilizer.type: ${fertilizer.type}');
    }

    final fertilizerType = fertilizer.type as FertilizerType;

    final fertilizerPerYearPerHectar = QtyCalculator.getFertilizerQtyRequiredFromTime(
      soilHealthPercentage: soilHealthPercentage,
      ageInMonths: 12,
      fertilizerType: fertilizerType,
      maintenanceFor: MaintenanceFor.cropAndTree,
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

  static double _systemTypeAffect({
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
    required double currentSoilHealth,
    required Content? currentFertilizerInUse,
    required SystemType currentSystemType,
    required bool areTreesPresent,
  }) {
    /// TODO: following changes were discussed for chagne
    /// 1. usage of crop age to understand the duration of farming
    /// 2. capping the soil health growth at some percentage (may be 20%)
    /// 3. using a logarithmic function to lessen the growth everytime

    // final fertilzerEffect = _fertilizerEffect(fertilizer: fertilzerQty, soilHealthPercentage: soilHealthPercentage);
    // final systemTypeEffectValue = _systemTypeAffect(systemType: systemType, treesPresent: treesPresent);

    // return soilHealthPercentage + fertilzerEffect + systemTypeEffectValue;
    return currentSoilHealth * GameUtils().getRandomNumberBetween(min: 0.9999996, max: 1.000002);
  }
}
