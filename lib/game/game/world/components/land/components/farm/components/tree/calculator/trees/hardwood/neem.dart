import '../../tree_calculators.dart';

// source -
// https://signuptrendingnature.com/malabar-neem-tree-weight-after-5-years/
class NeemCalculator extends BaseTreeCalculator {
  @override
  AgePriceLinearData agePriceData() {
    const p1 = AgePrice(age: 5, potentialPrice: 5 * 5000);
    const p2 = AgePrice(age: 8, potentialPrice: 7 * 5000);
    return const AgePriceLinearData(p1: p1, p2: p2);
  }

  @override
  int harvestReadyAge() => 5;

  @override
  int maturityAge() => 8;

  @override
  int getRecurringHarvest(int age) => 0;

  @override
  AgePriceLinearData recurringHarvestData() => AgePriceLinearData.zero;
}
