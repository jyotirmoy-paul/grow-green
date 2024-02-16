// Values are per hacter

import '../../../crop/enums/crop_type.dart';
import '../../system_type.dart';
import '../systems/system.dart';
import '../calculators/qty.dart';

abstract class QtyCalculator {
  static int getNumOfSaplingsFor(SystemType systemType) {
    return System(systemType: systemType).plantationLayout.numberOfTrees;
  }

  static Qty getSeedQtyRequireFor({required systemType, required CropType cropType}) {
    return System(systemType: systemType).seedQty(cropType);
  }
}
