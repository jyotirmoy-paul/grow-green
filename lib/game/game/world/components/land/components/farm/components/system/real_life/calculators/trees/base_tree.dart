import '../../../../../../../../utils/month.dart';
import '../../../../tree/enums/tree_stage.dart';
import '../../../../tree/enums/tree_type.dart';
import 'point_data.dart';
import 'types/fruit/coconut.dart';
import 'types/fruit/jackfruit.dart';
import 'types/fruit/mango.dart';
import 'types/hardwood/mahagony.dart';
import 'types/hardwood/neem.dart';
import 'types/hardwood/rosewood.dart';
import 'types/hardwood/teakwood.dart';

abstract class BaseTreeCalculator {
  static const tag = 'BaseTreeCalculator';

  BaseTreeCalculator({required this.treeType});

  final TreeType treeType;
  int harvestReadyAge();
  int maturityAge();
  int get saplingCost;
  AgePriceLinearData agePriceData();
  AgePriceLinearData recurringHarvestData();
  Month? getRecurringHarvestMonth();

  bool isHarvestReady(int treeAgeInDays) {
    int ageInYears = treeAgeInDays ~/ 365;
    return ageInYears >= harvestReadyAge();
  }

  bool canHarvest({
    required int treeAgeInDays,
    required Month currentMonth,
  }) {
    // Tree is not ready to harvest
    int ageInYears = treeAgeInDays ~/ 365;
    if (ageInYears < harvestReadyAge()) return false;

    // The tree does not provide recurring harvest
    if (getRecurringHarvestMonth() == null) return false;

    // Current month is not the month of harvest
    if (currentMonth != getRecurringHarvestMonth()) return false;

    return true;
  }

  TreeStage getTreeStage(int treeAgeInDays) {
    final growthFactor = treeAgeInDays / (maturityAge() * 365);

    switch (growthFactor) {
      case < .03:
        return TreeStage.sprout;

      case < .2:
        return TreeStage.sapling;

      case < .35:
        return TreeStage.maturing;

      case < .55:
        return TreeStage.flourishing;

      default:
        return TreeStage.elder;
    }
  }

  int getMaxPotentialPrice() {
    return getPotentialPrice(maturityAge());
  }

  int getMaxRecurringHarvestValue() {
    return getRecurringHarvest(maturityAge());
  }

  int getPotentialPrice(int age) {
    assert(harvestReadyAge() <= maturityAge(), "Harvest ready age should be less than or equal to maturity age");

    if (age < harvestReadyAge()) return 0;
    if (age > maturityAge()) return getPotentialPrice(maturityAge());
    final p1 = agePriceData().p1;
    final p2 = agePriceData().p2;

    if (p1.age == p2.age) return p1.potentialPrice;
    final m = (p2.potentialPrice - p1.potentialPrice) / (p2.age - p1.age);
    final price = p1.potentialPrice + ((age - p1.age) * m).round();
    return price;
  }

  // returns the price of produce from the tree at the given age
  int getRecurringHarvest(int age) {
    if (age < harvestReadyAge()) return 0;
    if (age > maturityAge()) return getRecurringHarvest(maturityAge());

    final p1 = recurringHarvestData().p1;
    final p2 = recurringHarvestData().p2;
    if (p1.age == p2.age) return p1.potentialPrice;

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
      case TreeType.coconut:
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
