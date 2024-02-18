import '../../../../../../../../../../../../../../services/log/log.dart';
import '../../../../../../tree/enums/tree_type.dart';
import '../../base_tree.dart';
import '../../point_data.dart';

// source -
// https://signuptrendingnature.com/rosewood-tree-farming-profit-per-acre/
class RosewoodCalculator extends BaseTreeCalculator {
  RosewoodCalculator({super.treeType = TreeType.rosewood});

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

  @override
  int get saplingCost => 100;
}

void main(List<String> args) {
  final roseWood = RosewoodCalculator();
  Log.i(roseWood.getPotentialPrice(21));
}
