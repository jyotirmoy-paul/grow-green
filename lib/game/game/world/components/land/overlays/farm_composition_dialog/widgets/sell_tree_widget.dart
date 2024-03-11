import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../../../../routes/routes.dart';
import '../../../../../../../../utils/app_colors.dart';
import '../../../../../../../../utils/extensions/num_extensions.dart';
import '../../../../../../../../utils/text_styles.dart';
import '../../../../../../../../widgets/game_button.dart';
import '../../../../../../../utils/game_icons.dart';
import '../../../../../../overlays/notification_overlay/service/notification_helper.dart';
import '../../../../../../services/game_services/time/time_service.dart';
import '../../../../sky/weather_service/services/co2_absorption_calculator.dart';
import '../../../components/farm/farm_controller.dart';
import '../../../components/farm/model/tree_data.dart';

/// TODO: Language

class SellTreeWidget extends StatelessWidget {
  static const predictionDurationInYears = 5;

  final FarmController farmController;
  final TreeData treeData;
  final Co2AbsorptionCalculator _co2absorptionCalculator;

  SellTreeWidget({
    super.key,
    required this.farmController,
  })  : treeData = farmController.treeData,
        _co2absorptionCalculator = Co2AbsorptionCalculator(treeType: farmController.treeData.treeType);

  void _sellTree() {
    farmController.sellTree();

    NotificationHelper.treesSold();

    /// close everything!
    Navigation.popToFirst();
  }

  String get description {
    final dateTime = TimeService().currentDateTime;

    final age = dateTime.difference(treeData.lifeStartedAt).inDays;
    final co2SequestrationByOneTreeOverTheAge = _co2absorptionCalculator.getTotalCo2SequestratedBy(
      treeAgeInDays: age,
    );

    final predictionAgeInDays =
        dateTime.add(const Duration(days: 365 * predictionDurationInYears)).difference(treeData.lifeStartedAt).inDays;

    final co2SequestrationPrediction = _co2absorptionCalculator.getTotalCo2SequestratedBy(
      treeAgeInDays: predictionAgeInDays,
    );

    final totalCo2SequestratedInKgs = co2SequestrationByOneTreeOverTheAge * treeData.noOfTrees;
    final totalCo2SequestratedAsPerPredictionInKgs = co2SequestrationPrediction * treeData.noOfTrees;

    final co2Sequestrated = totalCo2SequestratedInKgs > 1000
        ? '${(totalCo2SequestratedInKgs / 1000).toStringAsFixed(2)} metric tons'
        : '$totalCo2SequestratedInKgs kgs';

    final co2SequestratePrediction =
        '${(totalCo2SequestratedAsPerPredictionInKgs / 1000).toStringAsFixed(2)} metric tons';

    final treeAge = age > 365 ? '${age / 365} years' : '$age days';

    return "Quick fact: In $treeAge, your ${treeData.noOfTrees} trees have zapped $co2Sequestrated of CO2 from the air! Imagine, just by letting it grow for $predictionDurationInYears more years, it'll snatch up an extra $co2SequestratePrediction of CO2.\n\nThis isn't just good for us; it's a win for our village's climate too. Something to ponder before you trade it away!";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.s),
      child: Column(
        children: [
          /// title
          Expanded(
            flex: 5,
            child: Padding(
              padding: EdgeInsets.all(12.s),
              child: Column(
                children: [
                  /// text
                  Text(
                    "Selling now? You're overlooking future gains!",
                    style: TextStyles.s28.copyWith(
                      color: Colors.redAccent,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.left,
                  ),

                  Gap(10.s),

                  /// graph
                  Expanded(
                    child: Container(),
                  ),
                ],
              ),
            ),
          ),

          /// info
          Expanded(
            flex: 4,
            child: Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// info
                  SizedBox.square(
                    dimension: 50.s,
                    child: GameButton.text(
                      text: 'i',
                      color: Colors.blue,
                      onTap: () {},
                    ),
                  ),

                  /// gap
                  Gap(20.s),

                  /// description
                  Expanded(
                    child: Text(
                      description,
                      style: TextStyles.s25.copyWith(
                        color: AppColors.brown,
                        letterSpacing: 0.6,
                        height: 1.15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Gap(10.s),

          /// button
          GameButton.textImage(
            bgColor: Colors.red,
            text: 'Emh, sell anyway',
            image: GameIcons.cutTree,
            onTap: _sellTree,
          ),

          Gap(20.s),
        ],
      ),
    );
  }
}
