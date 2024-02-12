// Groundnut Class
import '../../../../../../../utils/month.dart';
import '../base_crop.dart';
import '../harvest_data.dart';

class GroundnutCropCalculator extends BaseCropCalculator {
  @override
  double getYieldKgPerCubicM() => 0.45;

  @override
  List<HarvestPeriod> harvestData() {
    return [
      HarvestPeriod(sowMonth: Month.jun, harvestMonth: Month.dec),
      HarvestPeriod(sowMonth: Month.jan, harvestMonth: Month.jun),
    ];
  }
}
