import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../../../../l10n/l10n.dart';
import '../../../../../../../../utils/app_colors.dart';
import '../../../../../../../../utils/extensions/num_extensions.dart';
import '../../../../../../../../utils/text_styles.dart';
import '../../../../../../../../utils/utils.dart';
import '../../../../../../../utils/game_utils.dart';
import '../enum/soil_health_movement.dart';
import '../models/merged_soil_health_model.dart';

class SoilHealthItem extends StatelessWidget {
  final MergedSoilHealthModel mergedSoilHealthModel;
  final int itemNo;
  final Color positiveBgColor;
  final Color negativeBgColor;

  const SoilHealthItem({
    super.key,
    required this.mergedSoilHealthModel,
    required this.itemNo,
    this.positiveBgColor = AppColors.positive,
    this.negativeBgColor = AppColors.negative,
  });

  Color get color {
    return switch (mergedSoilHealthModel.soilHealthMovement) {
      SoilHealthMovement.up => positiveBgColor,
      SoilHealthMovement.down => negativeBgColor,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12.s),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.s, vertical: 8.s),
      child: Row(
        children: [
          /// indicator
          Icon(
            () {
              return switch (mergedSoilHealthModel.soilHealthMovement) {
                SoilHealthMovement.up => Icons.trending_up_rounded,
                SoilHealthMovement.down => Icons.trending_down_rounded,
              };
            }(),
            size: 50.s,
            color: Utils.lightenColor(color),
          ),

          Gap(30.s),

          /// soil health
          Column(
            children: [
              Text(context.l10n.soilHealth, style: TextStyles.s15),
              Text(mergedSoilHealthModel.soilHealth.toStringAsFixed(3), style: TextStyles.s28),
            ],
          ),

          Expanded(child: _InfoWidget(mergedSoilHealthModel: mergedSoilHealthModel)),

          /// year
          Column(
            children: [
              Text(context.l10n.year, style: TextStyles.s15),
              Text(mergedSoilHealthModel.year.toString(), style: TextStyles.s28),
            ],
          ),
        ],
      ),
    );
  }
}

/// MVP1: More info about exact user behaviour can be added
class _InfoWidget extends StatelessWidget {
  final MergedSoilHealthModel mergedSoilHealthModel;

  const _InfoWidget({
    super.key,
    required this.mergedSoilHealthModel,
  });

  String _getSoilHealthMoveUpDesc(BuildContext context) {
    /// these may be incorrect (as not maped to exact data) but good enough for demo purpose
    final reasons = [
      context.l10n.soilHealthMoveUpReason1,
      context.l10n.soilHealthMoveUpReason2,
      context.l10n.soilHealthMoveUpReason3,
      context.l10n.soilHealthMoveUpReason4,
      context.l10n.soilHealthMoveUpReason5,
      context.l10n.soilHealthMoveUpReason6,
    ];

    final luckyIndex = GameUtils().getRandomInteger(reasons.length);

    return reasons[luckyIndex];
  }

  String _getSoilHealthMoveDownDesc(BuildContext context) {
    return context.l10n.soilHealthMoveDownReason;
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      () {
        return switch (mergedSoilHealthModel.soilHealthMovement) {
          SoilHealthMovement.up => _getSoilHealthMoveUpDesc(context),
          SoilHealthMovement.down => _getSoilHealthMoveDownDesc(context),
        };
      }(),
      style: TextStyles.s23,
      textAlign: TextAlign.center,
    );
  }
}
