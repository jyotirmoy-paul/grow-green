import '../../../../../components/farm/components/system/real_life/calculators/trees/base_tree.dart';
import '../../../../../components/farm/components/tree/enums/tree_type.dart';
import 'age_revenue_models.dart';

class AgeRevenueFetcher {
  final TreeType treeType;

  AgeRevenueFetcher({required this.treeType});

  AgeRevenueModels fetch() {
    final tree = BaseTreeCalculator.fromTreeType(treeType);

    final harvestReadyAge = tree.harvestReadyAge();
    final maturityAge = tree.maturityAge();

    final requestedAges = [harvestReadyAge, maturityAge];

    return requestedAges.map((age) => _fetchForAge(age: age)).toList();
  }

  AgeRevenueModel _fetchForAge({required int age}) {
    final sellingPrice = _fetchSellingPriceFor(treeType: treeType, age: age);
    final yearlyRevenue = _fetchYearlyRevenueFor(treeType: treeType, age: age);
    final totalRevenue = sellingPrice + yearlyRevenue;
    return AgeRevenueModel(
      ageInYears: age,
      sellPrice: sellingPrice,
      yearlyRevenue: yearlyRevenue,
      totalRevenue: totalRevenue,
      treeType: treeType,
    );
  }

  int _fetchYearlyRevenueFor({required TreeType treeType, required int age}) {
    final tree = BaseTreeCalculator.fromTreeType(treeType);
    return tree.getRecurringHarvest(age);
  }

  int _fetchSellingPriceFor({required TreeType treeType, required int age}) {
    final tree = BaseTreeCalculator.fromTreeType(treeType);
    return tree.getPotentialPrice(age);
  }
}
