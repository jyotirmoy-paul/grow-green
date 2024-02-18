import '../../../../../../tree/enums/tree_type.dart';
import '../../base_tree.dart';
import '../../point_data.dart';

// source -
// https://signuptrendingnature.com/coconut-tree-profit-per-acre-coconut-cult/#5_Is_coconut_the_tree_of_life
//
class CoconutCalculator extends BaseTreeCalculator {
  CoconutCalculator({super.treeType = TreeType.cocounut});

  @override
  AgePriceLinearData agePriceData() {
    const pricePerCubicFt = 600;
    const p1 = AgePrice(age: 6, potentialPrice: pricePerCubicFt * 8);
    const p2 = AgePrice(age: 20, potentialPrice: pricePerCubicFt * 100);
    return const AgePriceLinearData(p1: p1, p2: p2);
  }

  @override
  int harvestReadyAge() => 6;

  @override
  int maturityAge() => 20;

  @override
  AgePriceLinearData recurringHarvestData() {
    const pricePerNut = 20;
    const p1 = AgePrice(age: 6, potentialPrice: pricePerNut * 35);
    const p2 = AgePrice(age: 20, potentialPrice: pricePerNut * 75);
    return const AgePriceLinearData(p1: p1, p2: p2);
  }

  @override
  int get saplingCost => 100;
}
