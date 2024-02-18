import '../../../../../../../../../../utils/month.dart';
import '../../../../../../tree/enums/tree_type.dart';
import '../../base_tree.dart';
import '../../point_data.dart';

// source -
// https://signuptrendingnature.com/malabar-neem-tree-weight-after-5-years/
// https://signuptrendingnature.com/neem-tree-yield-per-acre-project-report/
class NeemCalculator extends BaseTreeCalculator {
  NeemCalculator({super.treeType = TreeType.neem});

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
  AgePriceLinearData recurringHarvestData() {
    const pricePerKg = 20;
    const p1 = AgePrice(age: 5, potentialPrice: pricePerKg * 10);
    const p2 = AgePrice(age: 8, potentialPrice: pricePerKg * 50);
    return const AgePriceLinearData(p1: p1, p2: p2);
  }

  @override
  int get saplingCost => 50;

  @override
  Month? getRecurringHarvestMonth() => Month.may;
}
