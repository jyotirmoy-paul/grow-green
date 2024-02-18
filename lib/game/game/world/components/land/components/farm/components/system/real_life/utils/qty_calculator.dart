// Values are per hacter

import '../../../../../../../../../enums/system_type.dart';
import '../../../crop/enums/crop_type.dart';
import '../../model/qty.dart';
import '../systems/system.dart';

abstract class QtyCalculator {
  static Qty getNumOfSaplingsFor(SystemType systemType) {
    return Qty(
      value: System(systemType: systemType).plantationLayout.numberOfTrees,
      scale: Scale.units,
    );
  }

  static Qty getSeedQtyRequireFor({required systemType, required CropType cropType}) {
    return System(systemType: systemType).seedQty(cropType);
  }

  // TODO : area is required and should not be assumed to be full one hacter
  static Qty getFertilizerQtyRequired({required double soilHealthPercentage, double area = 10000}) {
    const hacterToSqMeter = 10000;
    final areaRatio = area / hacterToSqMeter;
    final qtyPerHectare = -5 * soilHealthPercentage + 50;
    final qtyRequired = areaRatio * qtyPerHectare;
    return Qty(value: qtyRequired.round(), scale: Scale.units);
  }
}
