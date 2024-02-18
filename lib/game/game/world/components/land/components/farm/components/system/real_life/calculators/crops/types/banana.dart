import '../../../../model/qty.dart';

import '../../../../../../../../../utils/month.dart';
import '../../../../../crop/enums/crop_type.dart';
import '../base_crop.dart';
import '../../../../model/harvest_period.dart';

class BananaCropCalculator extends BaseCropCalculator {
  @override
  double getYieldKgPerSquareM() => 8.00;

  @override
  List<HarvestPeriod> harvestData() {
    return [
      HarvestPeriod(sowMonth: Month.jan, harvestMonth: Month.dec),
      HarvestPeriod(sowMonth: Month.feb, harvestMonth: Month.jan),
      HarvestPeriod(sowMonth: Month.mar, harvestMonth: Month.feb),
      HarvestPeriod(sowMonth: Month.apr, harvestMonth: Month.mar),
      HarvestPeriod(sowMonth: Month.may, harvestMonth: Month.apr),
      HarvestPeriod(sowMonth: Month.jun, harvestMonth: Month.may),
      HarvestPeriod(sowMonth: Month.jul, harvestMonth: Month.jun),
      HarvestPeriod(sowMonth: Month.aug, harvestMonth: Month.jul),
      HarvestPeriod(sowMonth: Month.sep, harvestMonth: Month.aug),
      HarvestPeriod(sowMonth: Month.oct, harvestMonth: Month.sep),
      HarvestPeriod(sowMonth: Month.nov, harvestMonth: Month.oct),
      HarvestPeriod(sowMonth: Month.dec, harvestMonth: Month.nov),
    ];
  }

  @override
  CropType cropType() => CropType.banana;

  @override
  Qty getSeedsRequiredPerHacter() => const Qty(value: 2500, scale: Scale.units);
}
