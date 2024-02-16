import '../../../../../../../../utils/month.dart';
import '../../../../crop/enums/crop_type.dart';
import '../base_crop.dart';
import '../harvest_period.dart';
import '../qty.dart';

class BajraCropCalculator extends BaseCropCalculator {
  @override
  double getYieldKgPerSquareM() => 0.40;

  @override
  List<HarvestPeriod> harvestData() {
    return [
      HarvestPeriod(sowMonth: Month.jun, harvestMonth: Month.sep),
      HarvestPeriod(sowMonth: Month.oct, harvestMonth: Month.feb),
    ];
  }

  @override
  CropType cropType() => CropType.bajra;

  @override
  Qty getSeedsRequiredPerHacter() => const Qty(value: 5, scale: Scale.kg);
}
