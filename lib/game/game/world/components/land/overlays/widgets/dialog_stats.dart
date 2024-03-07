import 'package:flutter/widgets.dart';

import '../../../../../../../utils/extensions/num_extensions.dart';
import '../../../../../../../utils/text_styles.dart';
import '../../../../../../../utils/utils.dart';
import '../../../../../services/game_services/monetary/models/money_model.dart';
import '../../components/farm/model/harvest_model.dart';

class SoilHealthStats extends StatelessWidget {
  final Color bgColor;
  final double minSoilHealth;
  final double maxSoilHealth;
  final int farmingForYears;

  const SoilHealthStats({
    super.key,
    required this.bgColor,
    required this.maxSoilHealth,
    required this.minSoilHealth,
    required this.farmingForYears,
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
          Text('Stats', style: TextStyles.s28, textAlign: TextAlign.center),

          Column(
            children: [
              StatItem(
                textA: 'Min',
                textB: minSoilHealth.toStringAsFixed(3),
              ),
              StatItem(
                textA: 'Max',
                textB: maxSoilHealth.toStringAsFixed(3),
              ),
              StatItem(
                textA: 'Farming For',
                textB: '$farmingForYears years',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class HarvestStats extends StatelessWidget {
  final Color bgColor;
  final List<HarvestModel> harvestModels;
  final MoneyModel totalRevenue;

  const HarvestStats({
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
          Text('Stats', style: TextStyles.s28, textAlign: TextAlign.center),

          Column(
            children: [
              StatItem(
                textA: 'Since',
                textB: Utils.monthYearDateFormat.format(harvestModels.last.dateOfHarvest),
              ),
              StatItem(
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

class StatItem extends StatelessWidget {
  final String textA;
  final String textB;

  const StatItem({
    super.key,
    required this.textA,
    required this.textB,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        /// text a
        Text(textA, style: TextStyles.s20),

        /// spacer
        const Spacer(),

        /// text b
        Text(textB, style: TextStyles.s20),
      ],
    );
  }
}
