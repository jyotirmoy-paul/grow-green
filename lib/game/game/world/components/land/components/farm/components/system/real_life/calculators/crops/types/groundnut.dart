import '../../../../../../../../../utils/month.dart';
import '../../../../../crop/enums/crop_type.dart';
import '../../../../model/harvest_period.dart';
import '../../../../model/qty.dart';
import '../base_crop.dart';

class GroundnutCropCalculator extends BaseCropCalculator {
  @override
  double getYieldKgPerSquareM() => 0.45;

  @override
  List<HarvestPeriod> sowData() {
    return [
      HarvestPeriod(sowMonth: Month.jun),
      HarvestPeriod(sowMonth: Month.jan),
    ];
  }

  @override
  CropType cropType() => CropType.groundnut;

  @override
  Qty getSeedsRequiredPerHacter() => const Qty(value: 100, scale: Scale.kg);

  @override
  int get maxAgeInMonths => 6;
}
