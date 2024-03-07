import '../../../../../../../../../enums/system_type.dart';
import '../../../../model/content.dart';
import '../../../../model/fertilizer/fertilizer_type.dart';
import '../../../crop/enums/crop_type.dart';
import '../../../tree/enums/tree_type.dart';
import '../../model/qty.dart';
import '../calculators/crops/base_crop.dart';
import '../calculators/trees/base_tree.dart';
import 'maintance_calculator.dart';

class CostCalculator {
  static int seedCostFromContent({required Content cropContent}) {
    return seedCost(
      seedsRequired: cropContent.qty,
      cropType: cropContent.type as CropType,
    );
  }

  static int seedCost({required Qty seedsRequired, required CropType cropType}) {
    final crop = BaseCropCalculator.fromCropType(cropType);
    final totalCost = seedsRequired.value * crop.getSellingPricePerKg;
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

  static int fertilizerCostFromContent({
    required Content fertilizerContent,
    required FertilizerType type,
  }) {
    return getFertilizerCost(
      qty: fertilizerContent.qty,
      type: type,
    );
  }

  static int getFertilizerCost({
    required Qty qty,
    required FertilizerType type,
  }) {
    final pricePerUnit = type == FertilizerType.organic ? 2 : 40;
    return qty.value * pricePerUnit;
  }

  static double maintenanceCostFromTime({
    required SystemType systemType,
    required MaintenanceFor maintenanceFor,
    required int ageInMonths, // age in months is the time for which maintenance is required
  }) {
    final yearFraction = ageInMonths / 12;
    final maintenancePerYear = MaintenanceCalculator.getMaintenanceCostPerYear(
      systemType: systemType,
      maintenanceFor: maintenanceFor,
    );
    return yearFraction * maintenancePerYear;
  }
}
