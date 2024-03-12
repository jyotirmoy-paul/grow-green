import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../../../../routes/routes.dart';
import '../../../../../../../../utils/app_colors.dart';
import '../../../../../../../../utils/extensions/num_extensions.dart';
import '../../../../../../../../utils/text_styles.dart';
import '../../../../../../../../widgets/game_button.dart';
import '../../../../../../../utils/game_assets.dart';
import '../../../../../../overlays/notification_overlay/service/notification_helper.dart';
import '../../../../../../services/game_services/monetary/models/money_model.dart';
import '../../../../../../services/game_services/time/time_service.dart';
import '../../../../sky/weather_service/services/co2_absorption_calculator.dart';
import '../../../components/farm/components/system/real_life/calculators/trees/base_tree.dart';
import '../../../components/farm/farm_controller.dart';
import '../../../components/farm/model/tree_data.dart';

/// TODO: Language

class SellTreeWidget extends StatelessWidget {
  static const predictionDurationInYears = 10;

  final FarmController farmController;
  final TreeData treeData;
  final BaseTreeCalculator treeCalculator;
  final Co2AbsorptionCalculator _co2absorptionCalculator;
  final GlobalKey chartRenderKey;
  final Color graphColor;
  final double treesAgeInYears;

  SellTreeWidget({
    super.key,
    required this.farmController,
    this.graphColor = AppColors.farmHistoryThemeColor,
  })  : chartRenderKey = GlobalKey(),
        treeData = farmController.treeData,
        treeCalculator = BaseTreeCalculator.fromTreeType(farmController.treeData.treeType),
        _co2absorptionCalculator = Co2AbsorptionCalculator(treeType: farmController.treeData.treeType),
        treesAgeInYears = TimeService().currentDateTime.difference(farmController.treeData.lifeStartedAt).inDays / 365;

  void _sellTree() {
    farmController.sellTree();

    NotificationHelper.treesSold();

    /// close everything!
    Navigation.popUntil(RouteName.gameScreen);
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
    final totalCo2SequestratedAsPerPredictionInKgs =
        co2SequestrationPrediction * treeData.noOfTrees - totalCo2SequestratedInKgs;

    final co2Sequestrated = totalCo2SequestratedInKgs > 1000
        ? '${(totalCo2SequestratedInKgs / 1000).toStringAsFixed(2)} metric tons'
        : '$totalCo2SequestratedInKgs kgs';

    final co2SequestratePrediction =
        '${(totalCo2SequestratedAsPerPredictionInKgs / 1000).toStringAsFixed(2)} metric tons';

    final treeAge = age > 365 ? '${age ~/ 365} years' : '$age days';

    return "Quick fact: In $treeAge, your ${treeData.noOfTrees} trees have zapped $co2Sequestrated of CO2 from the air! Imagine, just by letting it grow for $predictionDurationInYears more years, it'll snatch up an extra $co2SequestratePrediction of CO2.\n\nThis isn't just good for us; it's a win for our village's climate too. Do you still wanna sell?";
  }

  List<LineChartBarData> get generateData {
    final List<FlSpot> realSpots = [];
    final List<FlSpot> predictedSpots = [];

    for (int i = 1; i < treesAgeInYears + predictionDurationInYears; i++) {
      final realData = i < treesAgeInYears;

      final treePotentialPrice = treeCalculator.getPotentialPrice(i);
      final treeRecurringPrice = treeCalculator.getRecurringHarvest(i);

      final totalPotentialRevenue = (treePotentialPrice + treeRecurringPrice) * treeData.noOfTrees;

      if (realData) {
        realSpots.add(FlSpot(i.toDouble(), totalPotentialRevenue.toDouble()));
      } else {
        predictedSpots.add(FlSpot(i.toDouble(), totalPotentialRevenue.toDouble()));
      }
    }

    return [
      /// real value
      if (realSpots.isNotEmpty)
        LineChartBarData(
          spots: realSpots,
          isCurved: false,
          color: AppColors.positive,
          barWidth: 2.s,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: true),
        ),

      /// predicted value
      LineChartBarData(
        spots: predictedSpots,
        isCurved: false,
        color: AppColors.negative,
        barWidth: 2.s,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: true),
        dashArray: [
          5.s.toInt(),
          5.s.toInt(),
        ],
      ),
    ];
  }

  /// maximum value tree can generate
  double get maxYValue {
    return (treeCalculator.getMaxPotentialPrice().toDouble() + treeCalculator.getMaxRecurringHarvestValue()) *
        treeData.noOfTrees *
        1.10;
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
                    child: LineChart(
                      chartRendererKey: chartRenderKey,
                      LineChartData(
                        gridData: const FlGridData(show: true),
                        titlesData: FlTitlesData(
                          show: true,
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: (treesAgeInYears + predictionDurationInYears) / 10,
                              getTitlesWidget: (v, meta) {
                                if (v == meta.max || v == meta.min) return const SizedBox.shrink();
                                return Text(v.toStringAsFixed(0), style: TextStyles.s20.copyWith(color: graphColor));
                              },
                              reservedSize: 30.s,
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: maxYValue / 4,
                              getTitlesWidget: (v, meta) {
                                if (v < 0) return const SizedBox.shrink();

                                return Padding(
                                  padding: EdgeInsets.only(right: 10.s),
                                  child: Text(
                                    MoneyModel(value: v.toInt()).formattedValue,
                                    textAlign: TextAlign.end,
                                    style: TextStyles.s20.copyWith(
                                      color: graphColor,
                                      letterSpacing: 1.s,
                                    ),
                                  ),
                                );
                              },
                              reservedSize: 130.s,
                            ),
                          ),
                        ),
                        borderData: FlBorderData(
                          show: true,
                          border: Border.all(
                            color: graphColor,
                            width: 2.s,
                            strokeAlign: BorderSide.strokeAlignOutside,
                          ),
                        ),
                        lineBarsData: generateData,
                        minY: -maxYValue / 10, // this is done, so that 0 hovers above the line
                        maxY: maxYValue,
                        minX: 1,
                        maxX: treesAgeInYears + predictionDurationInYears,
                        lineTouchData: LineTouchData(
                          touchTooltipData: LineTouchTooltipData(
                            tooltipBgColor: Colors.black,
                            maxContentWidth: 150.s,
                            tooltipRoundedRadius: 10.s,
                            getTooltipItems: (touchedSpots) {
                              return touchedSpots.map(
                                (s) {
                                  return LineTooltipItem(MoneyModel(value: s.y.toInt()).formattedValue, TextStyles.s20);
                                },
                              ).toList();
                            },
                          ),
                        ),
                      ),
                    ),
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
            bgColor: Colors.black.withOpacity(0.2),
            text: 'Emh, sell anyway',
            image: GameAssets.cutTree,
            onTap: _sellTree,
          ),

          Gap(20.s),
        ],
      ),
    );
  }
}
