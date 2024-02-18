import '../../../../../../../../../utils/month.dart';
import '../../../../../crop/enums/crop_type.dart';
import '../base_crop.dart';
import '../../../../model/harvest_period.dart';
import '../../../../model/qty.dart';

class PepperCropCalculator extends BaseCropCalculator {
  @override
  double getYieldKgPerSquareM() => 0.20;

  @override
  List<HarvestPeriod> harvestData() {
    return [
      HarvestPeriod(sowMonth: Month.may, harvestMonth: Month.jan),
    ];
  }

  @override
  CropType cropType() => CropType.pepper;

  @override
  Qty getSeedsRequiredPerHacter() => const Qty(value: 3000, scale: Scale.units);
}
