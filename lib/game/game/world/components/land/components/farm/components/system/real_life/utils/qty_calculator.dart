// Values are per hacter

import '../../../../../../../../../enums/system_type.dart';
import '../../../crop/enums/crop_type.dart';
import '../../model/qty.dart';
import '../calculators/crops/base_crop.dart';
import '../systems/system.dart';

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
    double area = 10000,
  }) {
    final cropMaxAgeInMonths = BaseCropCalculator.fromCropType(cropType).maxAgeInMonths;
    return getFertilizerQtyRequiredFromTime(
      soilHealthPercentage: soilHealthPercentage,
      ageInMonths: cropMaxAgeInMonths,
      area: area,
    );
  }

  // TODO : area is required and should not be assumed to be full one hacter
  static Qty getFertilizerQtyRequiredFromTime({
    required double soilHealthPercentage,
    required int ageInMonths,
    double area = 10000,
  }) {
    // area factor is the area of land for which fertilizer is required with default being 1 hacter
    const hacterToSqMeter = 10000;
    final areaRatio = area / hacterToSqMeter;
    final qtyPerHectare = -5 * soilHealthPercentage + 50;

    // Get the time factor
    // time factor is the time for which fertilizer is required with default being 4 months
    const referenceAgeInMonths = 4;
    final cropMaxAgeInMonths = ageInMonths;
    final ageRatio = cropMaxAgeInMonths / referenceAgeInMonths;

    final qtyRequired = ageRatio * areaRatio * qtyPerHectare;

    return Qty(value: qtyRequired.round(), scale: Scale.units);
  }
}
