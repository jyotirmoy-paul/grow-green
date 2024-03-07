import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../../../../../utils/extensions/num_extensions.dart';
import '../../../../../../../../utils/text_styles.dart';
import '../../../../../../../../utils/utils.dart';
import '../../../../../../../../widgets/stylized_text.dart';
import '../../../../../../services/game_services/monetary/models/money_model.dart';
import '../../../components/farm/model/harvest_model.dart';
import '../models/harvest_revenue_data_point.dart';

/// TODO: Language

class HarvestSummary extends StatelessWidget {
  final List<HarvestModel> harvestModels;
  final List<HarvestRevenueDataPoint> harvestRevenueDataPoints;
  final Color bgColor;
  final MoneyModel totalRevenue;
  final double yearsInterval;
  final double moneyInterval;

  HarvestSummary({
    super.key,
    required this.harvestModels,
    required this.harvestRevenueDataPoints,
    this.bgColor = Colors.black,
  })  : totalRevenue = harvestRevenueDataPoints.last.revenue,
        yearsInterval = (harvestRevenueDataPoints.last.year - harvestRevenueDataPoints.first.year) / 10,
        moneyInterval =
            (harvestRevenueDataPoints.last.revenue.value - harvestRevenueDataPoints.first.revenue.value) / 4;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        /// graph
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /// heading
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(12.s),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12.s, vertical: 4.s),
                  child: StylizedText(
                    text: Text(
                      'Cummulative Revenue over the years!',
                      style: TextStyles.s24.copyWith(
                        letterSpacing: 1.4.s,
                      ),
                    ),
                  ),
                ),
              ),

              /// chart for cummulative revenue
              Padding(
                padding: EdgeInsets.only(right: 30.s, top: 10.s),
                child: AspectRatio(
                  aspectRatio: 2,
                  child: LineChart(
                    LineChartData(
                      gridData: const FlGridData(show: true),
                      titlesData: FlTitlesData(
                        show: true,
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: yearsInterval.toDouble(),
                            getTitlesWidget: (v, meta) {
                              /// if min & max not falling on interval, ignore them!
                              if ((v == meta.max || v == meta.min) && (v.toInt() % yearsInterval.toInt() != 0)) {
                                return const SizedBox.shrink();
                              }

                              return StylizedText(
                                text: Text(v.toStringAsFixed(0), style: TextStyles.s20),
                              );
                            },
                            reservedSize: 30.s,
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: moneyInterval,
                            getTitlesWidget: (v, meta) {
                              /// if min & max not falling on interval, ignore them!
                              if ((v == meta.max || v == meta.min) && (v.toInt() % yearsInterval.toInt() != 0)) {
                                return const SizedBox.shrink();
                              }

                              return StylizedText(
                                text: Text(
                                  MoneyModel(value: v.toInt()).formattedValue,
                                  style: TextStyles.s20,
                                ),
                              );
                            },
                            reservedSize: 100.s,
                          ),
                        ),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border.all(
                          color: bgColor,
                          width: 2.s,
                          strokeAlign: BorderSide.strokeAlignOutside,
                        ),
                      ),
                      minY: 0,
                      maxY: (totalRevenue.value * 1.2).toDouble(),
                      lineTouchData: LineTouchData(
                        touchTooltipData: LineTouchTooltipData(
                          tooltipBgColor: bgColor,
                          maxContentWidth: 300.s,
                          tooltipRoundedRadius: 10.s,
                          getTooltipItems: (touchedSpots) {
                            return touchedSpots.map((s) {
                              return LineTooltipItem(
                                MoneyModel(value: s.y.toInt()).formattedValue,
                                TextStyles.s20,
                              );
                            }).toList();
                          },
                        ),
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          spots: harvestRevenueDataPoints
                              .map<FlSpot>((d) => FlSpot(d.year.toDouble(), d.revenue.value.toDouble()))
                              .toList(),
                          isCurved: false,
                          color: bgColor,
                          barWidth: 2.s,
                          isStrokeCapRound: true,
                          dotData: const FlDotData(show: true),
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                bgColor,
                                bgColor.withOpacity(0.6),
                                bgColor.withOpacity(0.2),
                                // Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              /// extra info
            ],
          ),
        ),

        Expanded(child: _HarvestStats(harvestModels: harvestModels, bgColor: bgColor, totalRevenue: totalRevenue)),
      ],
    );
  }
}

class _HarvestStats extends StatelessWidget {
  final Color bgColor;
  final List<HarvestModel> harvestModels;
  final MoneyModel totalRevenue;

  const _HarvestStats({
    super.key,
    required this.bgColor,
    required this.harvestModels,
    required this.totalRevenue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8.s),
      ),
      padding: EdgeInsets.all(12.s),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: [
          /// heading
          StylizedText(
            text: Text('Stats', style: TextStyles.s28, textAlign: TextAlign.center),
          ),

          Column(
            children: [
              _StatItem(
                textA: 'Since',
                textB: Utils.monthYearDateFormat.format(harvestModels.last.dateOfHarvest),
              ),
              _StatItem(
                textA: 'Revenue',
                textB: totalRevenue.formattedValue,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String textA;
  final String textB;

  const _StatItem({
    super.key,
    required this.textA,
    required this.textB,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        /// text a
        StylizedText(
          text: Text(textA, style: TextStyles.s20),
        ),

        /// spacer
        const Spacer(),

        /// text b
        StylizedText(
          text: Text(textB, style: TextStyles.s20),
        ),
      ],
    );
  }
}
