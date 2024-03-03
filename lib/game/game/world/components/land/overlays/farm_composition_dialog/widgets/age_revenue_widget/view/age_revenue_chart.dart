import 'package:flutter/material.dart';

import '../../../../../components/farm/asset/tree_asset.dart';
import '../../../../../components/farm/components/system/real_life/calculators/trees/base_tree.dart';
import '../../../../../components/farm/components/tree/enums/tree_stage.dart';
import '../logic/age_revenue_models.dart';
import 'tree/age_revenue_tree.dart';

class AgeRevenueChart extends StatelessWidget {
  final List<Widget> ageRevenueTrees;
  final Size size;
  AgeRevenueChart({
    super.key,
    required this.ageRevenueTrees,
    required this.size,
  });

  factory AgeRevenueChart.fromAgeRevenueModels({required AgeRevenueModels ageRevenueModels, required Size size}) {
    final modelsSize = ageRevenueModels.length;
    final widthPerTree = size.width / (modelsSize + 1);
    final treeSize = Size(widthPerTree, size.height);

    final headerTree = AgeRevenueTree(
      rootTitles: const ["Sold At", "Yearly", "Total"],
      size: treeSize,
      rootTitleColor: Colors.deepOrangeAccent,
      topImageFooterShape: TopImageFooterShape.circle,
    );
    final revenueTrees = ageRevenueModels.map((ageRevenueModel) {
      final treeType = ageRevenueModel.treeType;
      final ageInYears = ageRevenueModel.ageInYears;
      final treeStage = BaseTreeCalculator.fromTreeType(treeType).getTreeStage(ageInYears * 365);
      final treeAssetPath = "assets/images/" + TreeAsset.of(treeType).at(treeStage);
      return AgeRevenueTree(
        size: treeSize,
        topImagePath: treeAssetPath,
        topImageFooter: ageRevenueModel.ageInYears.toString(),
        rootTitles: [
          ageRevenueModel.sellPrice.toString(),
          ageRevenueModel.yearlyRevenue.toString(),
          ageRevenueModel.totalRevenue.toString(),
        ],
      );
    }).toList();

    final ageRevenueTrees = [headerTree, ...revenueTrees];
    return AgeRevenueChart(ageRevenueTrees: ageRevenueTrees, size: size);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: size,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: ageRevenueTrees,
      ),
    );
  }
}
