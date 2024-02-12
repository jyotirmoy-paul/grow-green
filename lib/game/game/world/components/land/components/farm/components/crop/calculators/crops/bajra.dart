import '../../../../../../../utils/month.dart';
import '../../enums/crop_type.dart';
import '../base_crop.dart';
import '../harvest_data.dart';

class BajraCropCalculator extends BaseCropCalculator {
  @override
  double getYieldKgPerCubicM() => 0.40;

  @override
  List<HarvestPeriod> harvestData() {
    return [
      HarvestPeriod(sowMonth: Month.jun, harvestMonth: Month.sep),
      HarvestPeriod(sowMonth: Month.oct, harvestMonth: Month.feb),
    ];
  }

  @override
  CropType cropType() => CropType.bajra;
}
