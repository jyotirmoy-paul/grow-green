import '../../../../../../../utils/month.dart';
import '../base_crop.dart';
import '../harvest_data.dart';

class MaizeCropCalculator extends BaseCropCalculator {
  @override
  double getYieldKgPerCubicM() => 1.50; // From our earlier data

  @override
  List<HarvestPeriod> harvestData() {
    return [
      HarvestPeriod(sowMonth: Month.jun, harvestMonth: Month.sep),
      HarvestPeriod(sowMonth: Month.oct, harvestMonth: Month.jan),
    ];
  }
}
