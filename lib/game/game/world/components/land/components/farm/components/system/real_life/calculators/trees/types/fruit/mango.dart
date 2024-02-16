import '../../../../../../tree/enums/tree_type.dart';
import '../../tree_calculators.dart';

// source -
// https://www.agrifarming.in/mango-farming-project-report-cost-and-profit-analysis
class MangoTreeCalculator extends BaseTreeCalculator {
  MangoTreeCalculator({super.treeType = TreeType.mango});

  @override
  AgePriceLinearData agePriceData() {
    const p1 = AgePrice(age: 5, potentialPrice: 300);
    const p2 = AgePrice(age: 15, potentialPrice: 3000);
    return const AgePriceLinearData(p1: p1, p2: p2);
  }

  @override
  int harvestReadyAge() => 5;

  @override
  int maturityAge() => 15;

  @override
  AgePriceLinearData recurringHarvestData() {
    const pricePerKg = 100;
    final p1 = AgePrice(age: harvestReadyAge(), potentialPrice: pricePerKg * 10);
    final p2 = AgePrice(age: maturityAge(), potentialPrice: pricePerKg * 300);
    return AgePriceLinearData(p1: p1, p2: p2);
  }

  @override
  int get saplingCost => 50;
}
