import 'package:growgreen/game/game/world/components/land/components/farm/components/system/real_life/calculators/qty.dart';

import '../../../../../../../../utils/month.dart';
import '../../../../crop/enums/crop_type.dart';
import '../base_crop.dart';
import '../harvest_period.dart';

class WheatCropCalculator extends BaseCropCalculator {
  @override
  double getYieldKgPerSquareM() => 0.80;

  @override
  List<HarvestPeriod> harvestData() {
    return [
      HarvestPeriod(sowMonth: Month.oct, harvestMonth: Month.feb),
    ];
  }

  @override
  CropType cropType() => CropType.wheat;

  @override
  Qty getSeedsRequiredPerHacter() => const Qty(value: 100, scale: Scale.kg);
}
