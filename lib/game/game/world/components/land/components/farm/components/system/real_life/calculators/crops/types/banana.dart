import '../../../../../../../../../utils/month.dart';
import '../../../../../crop/enums/crop_type.dart';
import '../../../../model/harvest_period.dart';
import '../../../../model/qty.dart';
import '../base_crop.dart';

class BananaCropCalculator extends BaseCropCalculator {
  @override
  double getYieldKgPerSquareM() => 8.00;

  @override
  List<HarvestPeriod> sowData() {
    return [
      HarvestPeriod(sowMonth: Month.jan),
      HarvestPeriod(sowMonth: Month.feb),
      HarvestPeriod(sowMonth: Month.mar),
      HarvestPeriod(sowMonth: Month.apr),
      HarvestPeriod(sowMonth: Month.may),
      HarvestPeriod(sowMonth: Month.jun),
      HarvestPeriod(sowMonth: Month.jul),
      HarvestPeriod(sowMonth: Month.aug),
      HarvestPeriod(sowMonth: Month.sep),
      HarvestPeriod(sowMonth: Month.oct),
      HarvestPeriod(sowMonth: Month.nov),
      HarvestPeriod(sowMonth: Month.dec),
    ];
  }

  @override
  CropType cropType() => CropType.banana;

  @override
  Qty getSeedsRequiredPerHacter() => const Qty(value: 2500, scale: Scale.units);

  @override
  int get maxAgeInMonths => 11;
}
