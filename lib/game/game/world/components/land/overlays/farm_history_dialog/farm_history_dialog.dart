import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../../../utils/extensions/num_extensions.dart';
import '../../components/farm/farm.dart';
import '../../components/farm/model/harvest_model.dart';

class FarmHistoryDialog extends StatelessWidget {
  final Farm farm;
  final List<HarvestModel> harvestModels;

  FarmHistoryDialog({
    super.key,
    required this.farm,
  }) : harvestModels = farm.farmController.harvestModels;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: harvestModels.length,
      itemBuilder: (_, index) {
        final harvestModel = harvestModels[index];

        return Column(
          children: [
            Text(harvestModel.dateOfHarvest.toIso8601String()),
            Text('money: ${harvestModel.revenue.formattedValue}'),
          ],
        );
      },
      separatorBuilder: (_, __) {
        return Gap(12.s);
      },
    );
  }
}
