import '../../tree_calculators.dart';

// source -
// https://signuptrendingnature.com/jackfruit-farming-profit-per-acre-guide/
//
class JackfruitCalculator extends BaseTreeCalculator {
  @override
  AgePriceLinearData agePriceData() {
    const pricePerCubicFt = 1500;
    const p1 = AgePrice(age: 5, potentialPrice: 6 * pricePerCubicFt);
    const p2 = AgePrice(age: 15, potentialPrice: 120 * pricePerCubicFt);
    return const AgePriceLinearData(p1: p1, p2: p2);
  }

  @override
  int harvestReadyAge() => 5;

  @override
  int maturityAge() => 15;

  @override
  AgePriceLinearData recurringHarvestData() {
    const pricePerKg = 15;
    const p1 = AgePrice(age: 5, potentialPrice: pricePerKg * 10);
    const p2 = AgePrice(age: 15, potentialPrice: pricePerKg * 200);
    return const AgePriceLinearData(p1: p1, p2: p2);
  }
}
