import 'package:growgreen/services/log/log.dart';
import '../../tree_calculators.dart';

// source -
// https://signuptrendingnature.com/rosewood-tree-farming-profit-per-acre/
class RosewoodCalculator extends BaseTreeCalculator {
  @override
  int maturityAge() => 20;

  @override
  int harvestReadyAge() => 10;

  @override
  AgePriceLinearData agePriceData() {
    const p1 = AgePrice(age: 10, potentialPrice: 40000);
    const p2 = AgePrice(age: 15, potentialPrice: 125000);

    return const AgePriceLinearData(p1: p1, p2: p2);
  }

  @override
  AgePriceLinearData recurringHarvestData() => AgePriceLinearData.zero;
}

void main(List<String> args) {
  final roseWood = RosewoodCalculator();
  Log.i(roseWood.getPotentialPrice(21));
}
