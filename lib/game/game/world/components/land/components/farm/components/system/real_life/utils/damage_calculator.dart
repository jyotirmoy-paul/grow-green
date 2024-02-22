import '../../../../../../../../../enums/agroforestry_type.dart';
import '../../../../../../../../../enums/system_type.dart';
import '../../../../model/content.dart';
import '../../../../model/fertilizer/fertilizer_type.dart';
import 'qty_calculator.dart';

class SoilHealthCalculator {
  static const tag = 'SoilHealthCalculator';

  static double _fertilizerEffect({
    required Content fertilizer,
    required double soilHealthPercentage,
  }) {
    final fertilizerPerYearPerHectar = QtyCalculator.getFertilizerQtyRequiredFromTime(
      soilHealthPercentage: soilHealthPercentage,
      ageInMonths: 12,
    );
    final fertilizerQty = fertilizer.qty.value;
    final fertilizerUsedRatio = fertilizerQty / fertilizerPerYearPerHectar.value;

    if (fertilizer.type is! FertilizerType) {
      throw Exception('$tag: _fertilizerEffect() invoked with wrong fertilizer.type: ${fertilizer.type}');
    }

    final fertilizerEffectWithFullQty = switch (fertilizer.type as FertilizerType) {
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

  static double updateSoilHealth({
    required double soilHealthPercentage,
    required Content fertilzerQty,
    required SystemType systemType,
    required bool treesPresent,
  }) {
    final fertilzerEffect = _fertilizerEffect(fertilizer: fertilzerQty, soilHealthPercentage: soilHealthPercentage);
    final systemTypeEffectValue = _systemTypeAffect(systemType: systemType, treesPresent: treesPresent);

    return soilHealthPercentage + fertilzerEffect + systemTypeEffectValue;
  }
}
