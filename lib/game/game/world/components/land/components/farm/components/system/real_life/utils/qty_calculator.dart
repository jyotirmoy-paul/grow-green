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
}
