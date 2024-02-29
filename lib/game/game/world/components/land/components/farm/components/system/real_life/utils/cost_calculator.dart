import '../../../../model/content.dart';
import '../../../crop/enums/crop_type.dart';
import '../../../tree/enums/tree_type.dart';
import '../../model/qty.dart';
import '../calculators/crops/base_crop.dart';
import '../calculators/trees/base_tree.dart';

class CostCalculator {
  static int seedCostFromContent({required Content cropContent}) {
    return seedCost(
      seedsRequired: cropContent.qty,
      cropType: cropContent.type as CropType,
    );
  }

  static int seedCost({required Qty seedsRequired, required CropType cropType}) {
    final crop = BaseCropCalculator.fromCropType(cropType);
    final totalCost = seedsRequired.value * crop.getSellingPricePerKg();
    return totalCost;
  }

  static int saplingCostFromContent({required Content treeContent}) {
    return saplingCost(
      saplingQty: treeContent.qty,
      treeType: treeContent.type as TreeType,
    );
  }

  static int saplingCost({required Qty saplingQty, required TreeType treeType}) {
    final oneSaplingCost = BaseTreeCalculator.fromTreeType(treeType).saplingCost;
    return saplingQty.value * oneSaplingCost;
  }

  static int fertilizerCostFromContent({required Content fertilizerContent}) {
    /// TODO: No need for knowing if it's organic / inorganic?
    return getFertilizerCost(
      qty: fertilizerContent.qty,
    );
  }

  static int getFertilizerCost({required Qty qty}) {
    const costPerUnit = 125;
    return qty.value * costPerUnit;
  }
}
