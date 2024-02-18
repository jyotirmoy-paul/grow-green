import '../../../../model/qty.dart';

import '../../../../../../../../../utils/month.dart';
import '../../../../../crop/enums/crop_type.dart';
import '../base_crop.dart';
import '../../../../model/harvest_period.dart';

class MaizeCropCalculator extends BaseCropCalculator {
  @override
  double getYieldKgPerSquareM() => 1.50;

  @override
  List<HarvestPeriod> harvestData() {
    return [
      HarvestPeriod(sowMonth: Month.jun),
      HarvestPeriod(sowMonth: Month.oct),
    ];
  }

  @override
  CropType cropType() => CropType.maize;

  @override
  Qty getSeedsRequiredPerHacter() => const Qty(value: 20, scale: Scale.kg);

  @override
  int get maxAgeInMonths => 3;
}
