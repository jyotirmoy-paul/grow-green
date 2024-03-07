import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../../../../../utils/app_colors.dart';
import '../../../../../../../../utils/extensions/num_extensions.dart';
import '../../../../../../../../utils/text_styles.dart';
import '../../../../../../../utils/game_utils.dart';
import '../../widgets/dialog_stats.dart';
import '../models/merged_soil_health_model.dart';

class SoilHealthSummary extends StatelessWidget {
  final GlobalKey chartRendererKey;
  final List<MergedSoilHealthModel> mergedSoilHealthModels;
  final Color bgColor;
  final double yearsInterval;
  final double minSoilHealth;
  final double maxSoilHealth;

  SoilHealthSummary({
    super.key,
    required this.chartRendererKey,
    required this.mergedSoilHealthModels,
    this.bgColor = const Color(0xff503C3C),
    required this.minSoilHealth,
    required this.maxSoilHealth,
  }) : yearsInterval = (mergedSoilHealthModels.first.year - mergedSoilHealthModels.last.year) / 6;

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
                    'Soil Health over the years',
                    style: TextStyles.s28.copyWith(
                      letterSpacing: 1.4.s,
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
                            interval: (maxSoilHealth - minSoilHealth) / 6,
                            getTitlesWidget: (v, meta) {
                              if (v == meta.max || v == meta.min) return const SizedBox.shrink();
                              return Padding(
                                padding: EdgeInsets.only(right: 10.s),
                                child: Text(
                                  v.toStringAsFixed(2),
                                  textAlign: TextAlign.end,
                                  style: TextStyles.s20.copyWith(
                                    color: bgColor,
                                    letterSpacing: 1.s,
                                  ),
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
                      maxY: maxSoilHealth + 0.25,
                      minY: minSoilHealth - 0.25,
                      lineTouchData: LineTouchData(
                        touchTooltipData: LineTouchTooltipData(
                          tooltipBgColor: bgColor,
                          maxContentWidth: 300.s,
                          tooltipRoundedRadius: 10.s,
                          getTooltipItems: (touchedSpots) {
                            return touchedSpots.map(
                              (s) {
                                return LineTooltipItem(s.y.toStringAsFixed(3), TextStyles.s20);
                              },
                            ).toList();
                          },
                        ),
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          spots: mergedSoilHealthModels
                              .map<FlSpot>((d) => FlSpot(d.year.toDouble(), d.soilHealth))
                              .toList(),
                          isCurved: false,
                          color: bgColor,
                          barWidth: 2.s,
                          isStrokeCapRound: true,
                          dotData: const FlDotData(show: false),
                          aboveBarData: BarAreaData(
                            show: true,
                            cutOffY: GameUtils.cutOffSoilHealthInPercentage,
                            applyCutOffY: true,
                            gradient: AppColors.soilHealthNegativeGraphGradient,
                          ),
                          belowBarData: BarAreaData(
                            show: true,
                            cutOffY: GameUtils.cutOffSoilHealthInPercentage,
                            applyCutOffY: true,
                            gradient: AppColors.soilHealthPositiveGraphGradient,
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

        Expanded(child: SoilHealthStats(bgColor: bgColor, maxSoilHealth: maxSoilHealth, minSoilHealth: minSoilHealth)),
      ],
    );
  }
}
