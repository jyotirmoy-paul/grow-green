import '../../../../../../../../../../../../../../services/log/log.dart';
import '../../../../../../../../../../utils/month.dart';
import '../../../../../../tree/enums/tree_type.dart';
import '../../base_tree.dart';
import '../../point_data.dart';

// source -
// https://signuptrendingnature.com/how-many-teak-trees-per-acre-farm-income/
class TeakWoodCalculator extends BaseTreeCalculator {
  TeakWoodCalculator({super.treeType = TreeType.teakwood});

  @override
  int harvestReadyAge() => 10;

  @override
  int maturityAge() => 20;

  @override
  AgePriceLinearData agePriceData() {
    const p1 = AgePrice(age: 20, potentialPrice: 35000);
    const p2 = AgePrice(age: 10, potentialPrice: 20000);
    return const AgePriceLinearData(p1: p1, p2: p2);
  }

  @override
  int getRecurringHarvest(int age) => 0;

  @override
  AgePriceLinearData recurringHarvestData() => AgePriceLinearData.zero;

  @override
  int get saplingCost => 50;

  @override
  Month? getRecurringHarvestMonth() => null;
}

void main(List<String> args) {
  final teakWoodCalculator = TeakWoodCalculator();
  final points = List.generate(
    30,
    (index) => AgePrice(age: index, potentialPrice: teakWoodCalculator.getPotentialPrice(index)),
  );
  for (var element in points) {
    Log.i(element.toString());
  }
}
