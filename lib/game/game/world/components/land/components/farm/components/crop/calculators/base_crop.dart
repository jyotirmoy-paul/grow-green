import '../../../../../../utils/month.dart';

import '../calculators/harvest_data.dart';

abstract class BaseCropCalculator {
  double getYieldKgPerCubicM();
  List<HarvestPeriod> harvestData();

  bool canSow(Month month) {
    return harvestData().any((period) => period.sowMonth == month);
  }

  bool canHarvest(Month month) {
    return harvestData().any((period) => period.harvestMonth == month);
  }
}
