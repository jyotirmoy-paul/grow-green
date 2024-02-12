import '../../../../../../../utils/month.dart';
import '../../enums/crop_type.dart';
import '../base_crop.dart';
import '../harvest_data.dart';

class WheatCropCalculator extends BaseCropCalculator {
  @override
  double getYieldKgPerCubicM() => 0.80;

  @override
  List<HarvestPeriod> harvestData() {
    return [
      HarvestPeriod(sowMonth: Month.oct, harvestMonth: Month.feb),
    ];
  }

  @override
  CropType cropType() => CropType.wheat;
}
