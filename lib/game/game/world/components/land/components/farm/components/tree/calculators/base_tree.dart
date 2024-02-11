import 'tree_calculators.dart';

abstract class BaseTreeCalculator {
  int harvestReadyAge();
  int maturityAge();
  AgePriceLinearData agePriceData();
  AgePriceLinearData recurringHarvestData();

  int getPotentialPrice(int age) {
    assert(harvestReadyAge() <= maturityAge(), "Harvest ready age should be less than or equal to maturity age");

    if (age < harvestReadyAge()) return 0;
    if (age > maturityAge()) return getPotentialPrice(maturityAge());
    final p1 = agePriceData().p1;
    final p2 = agePriceData().p2;
    final m = (p2.potentialPrice - p1.potentialPrice) / (p2.age - p1.age);

    final price = p1.potentialPrice + ((age - p1.age) * m).round();
    return price;
  }

  int getRecurringHarvest(int age) {
    if (age < harvestReadyAge()) return 0;
    if (age > maturityAge()) return getRecurringHarvest(maturityAge());

    final p1 = recurringHarvestData().p1;
    final p2 = recurringHarvestData().p2;

    final m = (p2.potentialPrice - p1.potentialPrice) / (p2.age - p1.age);
    final price = p1.potentialPrice + ((age - p1.age) * m).round();
    return price;
  }
}
