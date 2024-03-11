import '../../../../../../../enums/system_type.dart';
import '../../../../components/farm/components/crop/enums/crop_type.dart';
import '../../../../components/farm/components/system/enum/growable.dart';
import '../../../../components/farm/components/system/real_life/calculators/crops/base_crop.dart';
import '../../../../components/farm/components/system/real_life/utils/maintance_calculator.dart';
import '../../../../components/farm/components/system/real_life/utils/qty_calculator.dart';
import '../../../../components/farm/model/content.dart';
import '../../../../components/farm/model/fertilizer/fertilizer_type.dart';

class SupportConfigPredictor {
  static List<Content> predictAllFertilizerConfigsForFarm({
    required SystemType systemType,
    required double soilHealthPercentage,
    required Growable growable,
  }) {
    return FertilizerType.values.map((fertilizerType) {
      return predictFertilizerConfigForFarm(
        systemType: systemType,
        soilHealthPercentage: soilHealthPercentage,
        fertilizerType: fertilizerType,
        growable: growable,
      );
    }).toList();
  }

  // U
  static Content predictFertilizerConfigForFarm({
    required SystemType systemType,
    required double soilHealthPercentage,
    required FertilizerType fertilizerType,
    required Growable growable,
  }) {
    final isCrop = growable.getGrowableType() == GrowableType.crop;
    final ageInMonths = isCrop ? BaseCropCalculator.fromCropType(growable as CropType).maxAgeInMonths : 12;
    final fertilzerQty = QtyCalculator.getFertilizerUsedForGrowingGrowableForTime(
      soilHealthPercentage: soilHealthPercentage,
      growableType: growable.getGrowableType(),
      systemType: systemType,
      fertilizerType: fertilizerType,
      ageInMonths: ageInMonths,
    );
    final fertilizerContent = Content(qty: fertilzerQty, type: fertilizerType);

    return fertilizerContent;
  }

  static MaintenanceQty predictMaintenanceConfigForFarm({
    required SystemType systemType,
    required Growable growable,
    required double soilHealthPercentage,
  }) {
    final isCrop = growable.getGrowableType() == GrowableType.crop;
    final ageInMonths = isCrop ? BaseCropCalculator.fromCropType(growable as CropType).maxAgeInMonths : 12;
    final maintenanceQty = QtyCalculator.maintenanceQtyFromTime(
      systemType: systemType,
      growableType: growable.getGrowableType(),
      ageInMonths: ageInMonths,
      soilHealthPercentage: soilHealthPercentage,
    );

    return maintenanceQty;
  }
}
