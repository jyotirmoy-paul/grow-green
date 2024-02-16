import '../../../../tree/enums/tree_type.dart';
import 'tree_calculators.dart';
import 'types/fruit/coconut.dart';
import 'types/fruit/jackfruit.dart';
import 'types/fruit/mango.dart';
import 'types/hardwood/mahagony.dart';
import 'types/hardwood/neem.dart';
import 'types/hardwood/rosewood.dart';
import 'types/hardwood/teakwood.dart';

abstract class BaseTreeCalculator {
  BaseTreeCalculator({required this.treeType});

  final TreeType treeType;
  int harvestReadyAge();
  int maturityAge();
  int get saplingCost;
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

  static BaseTreeCalculator fromTreeType(TreeType treeType) {
    switch (treeType) {
      case TreeType.rosewood:
        return RosewoodCalculator();
      case TreeType.jackfruit:
        return JackfruitCalculator();
      case TreeType.mango:
        return MangoTreeCalculator();
      case TreeType.mahagony:
        return MahagonyCalculator();
      case TreeType.cocounut:
        return CoconutCalculator();
      case TreeType.neem:
        return NeemCalculator();
      case TreeType.teakwood:
        return TeakWoodCalculator();
      default:
        throw Exception("Tree type not found");
    }
  }
}
