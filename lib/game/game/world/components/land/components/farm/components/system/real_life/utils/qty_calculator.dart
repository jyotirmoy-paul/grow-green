// Values are per hacter

import '../../../../../../../../../enums/system_type.dart';
import '../../../../model/fertilizer/fertilizer_type.dart';
import '../../../crop/enums/crop_type.dart';
import '../../model/qty.dart';
import '../calculators/crops/base_crop.dart';
import '../systems/system.dart';
import 'maintance_calculator.dart';

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
    required MaintenanceFor maintenanceFor,
  }) {
    final cropMaxAgeInMonths = BaseCropCalculator.fromCropType(cropType).maxAgeInMonths;
    return getFertilizerQtyRequiredFromTime(
      soilHealthPercentage: soilHealthPercentage,
      ageInMonths: cropMaxAgeInMonths,
      fertilizerType: fertilizerType,
      maintenanceFor: MaintenanceFor.crop,
      systemType: systemType,
    );
  }

  // TODO : area is required and should not be assumed to be full one hacter
  static Qty getFertilizerQtyRequiredFromTime({
    required double soilHealthPercentage,
    required MaintenanceFor maintenanceFor,
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
      maintenanceFor: maintenanceFor,
    );
    final areaRatio = areaInSqMeter / hacterToSqMeter;

    // Get the time factor
    // time factor is the time for which fertilizer is required with default being 4 months
    final ageRatio = ageInMonths / 12;

    // soil health factor
    final soilHealthFactor = calculateSoilHealthFactor(soilHealthPercentage);

    final fertilizerRequired = fetilizerPerHacterPerYear.value * areaRatio * ageRatio * soilHealthFactor;

    return Qty(value: fertilizerRequired.toInt(), scale: Scale.kg);
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
