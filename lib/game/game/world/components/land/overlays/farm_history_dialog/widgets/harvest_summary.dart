import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../../../../../l10n/l10n.dart';
import '../../../../../../../../utils/app_colors.dart';
import '../../../../../../../../utils/extensions/num_extensions.dart';
import '../../../../../../../../utils/text_styles.dart';
import '../../../../../../services/game_services/monetary/models/money_model.dart';
import '../../../components/farm/model/harvest_model.dart';
import '../../widgets/dialog_stats.dart';
import '../models/harvest_revenue_data_point.dart';

class HarvestSummary extends StatelessWidget {
  final GlobalKey chartRendererKey;
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
    required this.chartRendererKey,
    this.bgColor = Colors.black,
  })  : totalRevenue = harvestRevenueDataPoints.last.revenue,
        yearsInterval = (harvestRevenueDataPoints.last.year - harvestRevenueDataPoints.first.year) / 6,
        moneyInterval =
            (harvestRevenueDataPoints.last.revenue.value - harvestRevenueDataPoints.first.revenue.value) / 3;

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
                  padding: EdgeInsets.symmetric(horizontal: 20.s, vertical: 4.s),
                  child: Text(
                    context.l10n.cummulativeRevenueTitle,
                    style: TextStyles.s28.copyWith(letterSpacing: 1.4.s),
                  ),
                ),
              ),

              /// chart for cummulative revenue
              Padding(
                padding: EdgeInsets.only(right: 30.s, top: 10.s),
                child: AspectRatio(
                  aspectRatio: 2,
                  child: LineChart(
                    chartRendererKey: chartRendererKey,
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
                              if (v == meta.max || v == meta.min) return const SizedBox.shrink();
                              return Text(v.toStringAsFixed(0), style: TextStyles.s20.copyWith(color: bgColor));
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
                              if (v == meta.max || v == meta.min) return const SizedBox.shrink();

                              return Padding(
                                padding: EdgeInsets.only(right: 10.s),
                                child: Text(
                                  MoneyModel(value: v.toInt()).formattedValue,
                                  textAlign: TextAlign.end,
                                  style: TextStyles.s20.copyWith(
                                    color: bgColor,
                                    letterSpacing: 1.s,
                                  ),
                                ),
                              );
                            },
                            reservedSize: 150.s,
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
                          dotData: const FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: AppColors.farmRevenueGraphGradient,
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

        Expanded(child: HarvestStats(harvestModels: harvestModels, bgColor: bgColor, totalRevenue: totalRevenue)),
      ],
    );
  }
}
