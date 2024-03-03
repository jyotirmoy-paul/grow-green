import '../../../../../components/farm/components/tree/enums/tree_type.dart';

typedef AgeRevenueModels = List<AgeRevenueModel>;

class AgeRevenueModel {
  final int ageInYears;
  final int sellPrice;
  final int yearlyRevenue;
  final int totalRevenue;
  final TreeType treeType;
  AgeRevenueModel({
    required this.ageInYears,
    required this.sellPrice,
    required this.yearlyRevenue,
    required this.totalRevenue,
    required this.treeType,
  });
}
