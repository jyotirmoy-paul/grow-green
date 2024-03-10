import '../../../../../../../../../utils/month.dart';
import '../../../../../crop/enums/crop_type.dart';
import '../../../../model/harvest_period.dart';
import '../../../../model/qty.dart';
import '../base_crop.dart';

class BajraCropCalculator extends BaseCropCalculator {
  @override
  double getYieldKgPerSquareM() => 0.40;

  @override
  List<HarvestPeriod> sowData() {
    return [
      HarvestPeriod(sowMonth: Month.jun),
      HarvestPeriod(sowMonth: Month.nov),
    ];
  }

  @override
  CropType cropType() => CropType.bajra;

  @override
  Qty getSeedsRequiredPerHacter() => const Qty(value: 5, scale: Scale.kg);

  @override
  int get maxAgeInMonths => 4;
}
