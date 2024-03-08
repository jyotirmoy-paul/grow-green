import '../../../../../../../../../enums/system_type.dart';
import '../../../crop/enums/crop_type.dart';
import '../calculators/crops/base_crop.dart';
import '../systems/database/layouts.dart';

class RevenueCalculator {
  static int getCropRevenue({required CropType cropType, required SystemType systemType}) {
    final crop = BaseCropCalculator.fromCropType(cropType);

    final yieldPerHectare = crop.getYieldKgPerSquareM() * 10000;
    final cropAreaFractionPerHectare = PlantationLayout.fromSytemType(systemType).areaFractionForCrops;
    final yield = yieldPerHectare * cropAreaFractionPerHectare;

    final revenue = yield * crop.getSellingPricePerKg;
    return revenue.round();
  }
}
