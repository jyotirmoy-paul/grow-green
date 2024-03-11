// Values are per hacter

import '../../../../../../../../../enums/system_type.dart';
import '../../../../model/fertilizer/fertilizer_type.dart';
import '../../../crop/enums/crop_type.dart';
import '../../enum/growable.dart';
import '../../model/qty.dart';
import '../calculators/crops/base_crop.dart';
import '../systems/system.dart';
import 'maintance_calculator.dart';
import 'soil_health_calculator.dart';

abstract class QtyCalculator {
  static Qty getNumOfSaplingsFor(SystemType systemType) {
    return Qty(
      value: System(systemType: systemType).plantationLayout.numberOfTrees,
      scale: Scale.units,
    );
  }

  static Qty getSeedQtyRequireFor({required SystemType systemType, required CropType cropType}) {
    return System(systemType: systemType).seedQty(cropType);
  }

  static Qty getFertilizerQtyRequiredFor({
    required SystemType systemType,
    required double soilHealthPercentage,
    required CropType cropType,
    required FertilizerType fertilizerType,
    required GrowableType growableType,
  }) {
    final cropMaxAgeInMonths = BaseCropCalculator.fromCropType(cropType).maxAgeInMonths;
    return getFertilizerUsedForGrowingGrowableForTime(
      soilHealthPercentage: soilHealthPercentage,
      ageInMonths: cropMaxAgeInMonths,
      fertilizerType: fertilizerType,
      growableType: growableType,
      systemType: systemType,
    );
  }

  static Qty getFertilizerUsedForGrowingGrowableForTime({
    required double soilHealthPercentage,
    required GrowableType growableType,
    required SystemType systemType,
    required FertilizerType fertilizerType,
    required int ageInMonths,
  }) {
    const inorganicFertilizerPerHacterPerYear = Qty(value: 200, scale: Scale.kg);
    const organicFertilizerPerHacterPerYear = Qty(value: 8000, scale: Scale.kg);
    final fetilizerPerHacterPerYear = fertilizerType == FertilizerType.organic
        ? organicFertilizerPerHacterPerYear
        : inorganicFertilizerPerHacterPerYear;

    // area factor is the area of land for which fertilizer is required with default being 1 hacter
    const hacterToSqMeter = 10000;
    final areaInSqMeter = MaintenanceCalculator.getMaintenanceArea(
      systemType: systemType,
      growableType: growableType,
    );
    final areaRatio = areaInSqMeter / hacterToSqMeter;

    // Get the time factor
    // time factor is the time for which fertilizer is required with default being 4 months
    final ageRatio = ageInMonths / 12;

    // soil health factor
    final soilHealthFactor = SoilHealthCalculator.calculateSoilHealthFactor(soilHealthPercentage);

    final fertilizerRequired = fetilizerPerHacterPerYear.value * areaRatio * ageRatio * soilHealthFactor;

    return Qty(value: fertilizerRequired.toInt(), scale: Scale.kg);
  }

  static MaintenanceQty maintenanceQtyFromTime({
    required SystemType systemType,
    required GrowableType growableType,
    required int ageInMonths, // age in months is the time for which maintenance is required
    required double soilHealthPercentage,
  }) {
    final yearFraction = ageInMonths / 12;
    final maintenancePerYear = MaintenanceCalculator.getMaintenanceQtyPerYear(
      systemType: systemType,
      growableType: growableType,
      soilHealthPercentage: soilHealthPercentage,
    );
    return (maintenancePerYear * yearFraction);
  }
}
