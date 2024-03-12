import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../../../../utils/extensions/num_extensions.dart';
import '../../../../../../../../utils/text_styles.dart';
import '../../../../../../../utils/game_assets.dart';

enum ChangeDurationType { perUse, yearly }

class SoilHealthEffect extends StatelessWidget {
  final bool isExpanded;
  final double changePercentage;
  final ChangeDurationType changeDurationType;

  const SoilHealthEffect({
    super.key,
    this.isExpanded = false,
    required this.changePercentage,
    required this.changeDurationType,
  });

  MainAxisAlignment get rowMainAxisAlignment => isExpanded ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start;
  MainAxisSize get rowMainAxisSize => isExpanded ? MainAxisSize.max : MainAxisSize.min;
  bool get isChangePositive => changePercentage > 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: rowMainAxisAlignment,
      mainAxisSize: rowMainAxisSize,
      children: [
        Text('Soil Health ', style: TextStyles.s28),
        if (!isExpanded) Gap(10.s),
        _ChangeInfo(
          changePercentage: changePercentage,
          changeDurationType: changeDurationType,
        )
      ],
    );
  }
}

class _ChangeInfo extends StatelessWidget {
  final double changePercentage;
  final ChangeDurationType changeDurationType;

  const _ChangeInfo({
    super.key,
    required this.changePercentage,
    required this.changeDurationType,
  });
  bool get isChangePositive => changePercentage >= 0;
  String get changeAssetPath => isChangePositive ? GameAssets.positiveTriangle : GameAssets.negativeTriangle;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(changeAssetPath, width: 14.s, height: 14.s),
        Gap(6.s),
        Text(
          '${changePercentage.toStringAsFixed(2)}% ',
          style: TextStyles.s24,
        ),
        Text(
          changeDurationType == ChangeDurationType.perUse ? ' per use' : ' yearly',
          style: TextStyles.s24,
        ),
      ],
    );
  }
}
