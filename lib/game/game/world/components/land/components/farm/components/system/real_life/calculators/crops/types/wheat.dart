import '../../../../../../../../../utils/month.dart';
import '../../../../../crop/enums/crop_type.dart';
import '../../../../model/harvest_period.dart';
import '../../../../model/qty.dart';
import '../base_crop.dart';

class WheatCropCalculator extends BaseCropCalculator {
  @override
  double getYieldKgPerSquareM() => 0.40;

  @override
  List<HarvestPeriod> sowData() {
    return [
      HarvestPeriod(sowMonth: Month.oct),
    ];
  }

  @override
  CropType cropType() => CropType.wheat;

  @override
  Qty getSeedsRequiredPerHacter() => const Qty(value: 100, scale: Scale.kg);

  @override
  int get maxAgeInMonths => 4;
}
