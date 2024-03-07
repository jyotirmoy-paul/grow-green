import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../../../utils/extensions/num_extensions.dart';
import '../../../../../../../utils/text_styles.dart';
import '../../../../../../../widgets/stylized_text.dart';
import '../../../../../../utils/game_images.dart';
import '../../components/farm/farm.dart';
import 'models/merged_soil_health_model.dart';
import 'widgets/soil_health_item.dart';
import 'widgets/soil_health_summary.dart';

class SoilHealthDialog extends StatelessWidget {
  final List<MergedSoilHealthModel> mergedSoilHealthModels;
  final GlobalKey chartRendererKey;

  SoilHealthDialog({
    super.key,
    required Farm farm,
  })  : mergedSoilHealthModels = MergedSoilHealthModel.generateMergedSoilHealthModel(
          farm.farmController.soilHealthModels,
        ),
        chartRendererKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    if (mergedSoilHealthModels.length < 3) {
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
              'Not enough soil health data recorded, keep farming!',
              style: TextStyles.s28,
            ),
          ),
        ],
      );
    }

    return ListView.separated(
      padding: EdgeInsets.all(12.s),
      itemCount: mergedSoilHealthModels.length + 1,
      itemBuilder: (_, i) {
        if (i == 0) {
          final (minSoilHealth, maxSoilHealth) = MergedSoilHealthModel.minMaxSoilHealth(mergedSoilHealthModels);

          return SoilHealthSummary(
            minSoilHealth: minSoilHealth,
            maxSoilHealth: maxSoilHealth,
            mergedSoilHealthModels: mergedSoilHealthModels,
            chartRendererKey: chartRendererKey,
          );
        }

        final index = i - 1;
        final mergedModel = mergedSoilHealthModels[index];

        return SoilHealthItem(
          mergedSoilHealthModel: mergedModel,
          itemNo: index + 1,
        );
      },
      separatorBuilder: (_, __) {
        return Gap(20.s);
      },
    );
  }
}
