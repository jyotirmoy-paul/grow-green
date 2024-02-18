import '../../../crop/enums/crop_type.dart';
import '../../../tree/enums/tree_type.dart';
import '../../model/qty.dart';
import '../calculators/crops/base_crop.dart';
import '../calculators/trees/base_tree.dart';

class CostCalculator {
  static int seedCost({required Qty seedsRequired, required CropType cropType}) {
    final crop = BaseCropCalculator.fromCropType(cropType);
    final totalCost = seedsRequired.value * crop.getSellingPricePerKg();
    return totalCost;
  }

  static int saplingCost({required Qty saplingQty, required TreeType treeType}) {
    final oneSaplingCost = BaseTreeCalculator.fromTreeType(treeType).saplingCost;
    return saplingQty.value * oneSaplingCost;
  }

  int getFertilizerCost({required Qty qty}) {
    const costPerUnit = 125;
    return qty.value * costPerUnit;
  }
}
