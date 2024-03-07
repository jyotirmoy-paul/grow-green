import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../../../utils/extensions/num_extensions.dart';
import '../../../../../../../utils/text_styles.dart';
import '../../../../../../../widgets/stylized_text.dart';
import '../../../../../../utils/game_images.dart';
import '../../components/farm/farm.dart';
import '../../components/farm/model/harvest_model.dart';
import 'models/harvest_revenue_data_point.dart';
import 'models/merged_harvest_model.dart';
import 'widgets/harvest_item.dart';
import 'widgets/harvest_summary.dart';

class FarmHistoryDialog extends StatelessWidget {
  final Farm farm;
  final List<HarvestModel> harvestModels;
  final List<MergedHarvestModel> mergedHarvestModels;
  final List<HarvestRevenueDataPoint> harvestRevenueDataPoints;
  final Color bgColor;

  FarmHistoryDialog({
    super.key,
    required this.farm,
    this.bgColor = const Color(0xff474F7A),
  })  : harvestModels = farm.farmController.harvestModels,
        mergedHarvestModels = MergedHarvestModel.generateMergedHarvestModelFrom(farm.farmController.harvestModels),
        harvestRevenueDataPoints = HarvestRevenueDataPoint.generateRevenueDataPoint(farm.farmController.harvestModels);

  @override
  Widget build(BuildContext context) {
    if (harvestModels.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset(
            GameImages.itSeemsEmptyHere,
            height: 200.s,
          ),
          Gap(20.s),
          StylizedText(
            text: Text(
              'Nothing to show!',
              style: TextStyles.s28,
            ),
          ),
        ],
      );
    }

    return ListView.separated(
      /// first item is a summarized map
      itemCount: mergedHarvestModels.length + 1,
      padding: EdgeInsets.all(12.s),
      itemBuilder: (_, i) {
        if (i == 0) {
          return HarvestSummary(
            harvestRevenueDataPoints: harvestRevenueDataPoints,
            bgColor: bgColor,
            harvestModels: harvestModels,
          );
        }

        final index = i - 1;
        final mergedHarvestModel = mergedHarvestModels[index];
        return MergedHarvestItem(
          model: mergedHarvestModel,
          itemNo: index + 1,
          bgColor: bgColor,
        );
      },
      separatorBuilder: (_, __) {
        return Gap(20.s);
      },
    );
  }
}
