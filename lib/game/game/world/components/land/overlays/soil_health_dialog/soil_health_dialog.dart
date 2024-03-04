import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../../../utils/extensions/num_extensions.dart';
import '../../components/farm/farm.dart';
import '../../components/farm/model/soil_health_model.dart';

class SoilHealthDialog extends StatelessWidget {
  final Farm farm;
  final List<SoilHealthModel> soilHealthModels;

  SoilHealthDialog({
    super.key,
    required this.farm,
  }) : soilHealthModels = farm.farmController.soilHealthModels;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: soilHealthModels.length,
      itemBuilder: (_, index) {
        final harvestModel = soilHealthModels[index];

        return Column(
          children: [
            Text(harvestModel.recordedOnDate.toIso8601String()),
            Text('current soil health: ${harvestModel.currentSoilHealth}'),
          ],
        );
      },
      separatorBuilder: (_, __) {
        return Gap(12.s);
      },
    );
  }
}
