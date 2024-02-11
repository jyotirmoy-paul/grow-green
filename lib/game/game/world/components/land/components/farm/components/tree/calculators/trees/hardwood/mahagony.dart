import '../../tree_calculators.dart';

// source -
// https://signuptrendingnature.com/how-many-mahogany-trees-per-acre-income/
class MahagonyCalculator extends BaseTreeCalculator {
  @override
  AgePriceLinearData agePriceData() {
    const p1 = AgePrice(age: 10, potentialPrice: 20000);
    const p2 = AgePrice(age: 20, potentialPrice: 40000);
    return const AgePriceLinearData(p1: p1, p2: p2);
  }

  @override
  int harvestReadyAge() => 10;

  @override
  int maturityAge() => 25;

  @override
  int getRecurringHarvest(int age) => 0;

  @override
  AgePriceLinearData recurringHarvestData() => AgePriceLinearData.zero;
}
