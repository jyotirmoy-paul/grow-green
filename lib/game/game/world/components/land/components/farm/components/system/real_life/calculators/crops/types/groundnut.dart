import '../../../../../../../../../utils/month.dart';
import '../../../../../crop/enums/crop_type.dart';
import '../base_crop.dart';
import '../../../../model/harvest_period.dart';
import '../../../../model/qty.dart';

class GroundnutCropCalculator extends BaseCropCalculator {
  @override
  double getYieldKgPerSquareM() => 0.45;

  @override
  List<HarvestPeriod> harvestData() {
    return [
      HarvestPeriod(sowMonth: Month.jun, harvestMonth: Month.dec),
      HarvestPeriod(sowMonth: Month.jan, harvestMonth: Month.jun),
    ];
  }

  @override
  CropType cropType() => CropType.groundnut;

  @override
  Qty getSeedsRequiredPerHacter() => const Qty(value: 100, scale: Scale.kg);
}
