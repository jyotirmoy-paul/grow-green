import '../../../../../../../../../enums/system_type.dart';
import '../../../crop/enums/crop_type.dart';
import '../../../tree/enums/tree_type.dart';
import '../calculators/crops/base_crop.dart';
import '../calculators/trees/base_tree.dart';
import 'qty_calculator.dart';

class CostCalculator {
  static int seedCost({
    required CropType cropType,
    required SystemType systemType,
  }) {
    final crop = BaseCropCalculator.fromCropType(cropType);
    final seedsRequired = QtyCalculator.getSeedQtyRequireFor(systemType: systemType, cropType: cropType);
    final totalCost = seedsRequired.value * crop.getSellingPricePerKg();
    return totalCost;
  }

  static int saplingCost({
    required SystemType systemType,
    required TreeType treeType,
  }) {
    final saplingQty = QtyCalculator.getNumOfSaplingsFor(systemType);
    final oneSaplingCost = BaseTreeCalculator.fromTreeType(treeType).saplingCost;
    return saplingQty.value * oneSaplingCost;
  }
}
