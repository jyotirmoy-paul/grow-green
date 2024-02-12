import '../../../../../../../utils/month.dart';
import '../../enums/crop_type.dart';
import '../base_crop.dart';
import '../harvest_data.dart';

class PepperCropCalculator extends BaseCropCalculator {
  @override
  double getYieldKgPerCubicM() => 0.20;

  @override
  List<HarvestPeriod> harvestData() {
    return [
      HarvestPeriod(sowMonth: Month.may, harvestMonth: Month.jan),
    ];
  }

  @override
  CropType cropType() => CropType.pepper;
}
