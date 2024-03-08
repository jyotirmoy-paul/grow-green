import '../../../../../../../../../utils/month.dart';
import '../../../../../crop/enums/crop_type.dart';
import '../../../../model/harvest_period.dart';
import '../../../../model/qty.dart';
import '../base_crop.dart';

class MaizeCropCalculator extends BaseCropCalculator {
  @override
  double getYieldKgPerSquareM() => 0.3;

  @override
  List<HarvestPeriod> sowData() {
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
