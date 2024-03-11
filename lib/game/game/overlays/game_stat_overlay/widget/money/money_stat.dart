import 'package:flutter/material.dart';

import '../../../../../../utils/extensions/num_extensions.dart';
import '../../../../../../utils/text_styles.dart';
import '../../../../../../widgets/stylized_text.dart';
import '../../../../../utils/game_assets.dart';
import '../../../../services/game_services/monetary/models/money_model.dart';
import '../../../../services/game_services/monetary/monetary_service.dart';
import '../stat_skeleton_widget.dart';
import 'int_tween_animation.dart';

class MoneyStat extends StatelessWidget {
  final MonetaryService monetaryService;

  const MoneyStat({
    super.key,
    required this.monetaryService,
  });

  @override
  Widget build(BuildContext context) {
    return StatSkeletonWidget(
      imageAlignment: StatSkeletonImageAlignment.left,
      width: 280.s,
      iconAsset: GameAssets.coin,
      child: StreamBuilder(
        stream: monetaryService.balanceStream,
        initialData: monetaryService.balance,
        builder: (context, snapshot) {
          final money = snapshot.data ?? MoneyModel.zero();

          return IntTweenAnimation(
            value: money.value,
            builder: (_, value) {
              return StylizedText(
                text: Text(
                  MoneyModel(value: value).formattedValue,
                  style: TextStyles.s28,
                  textAlign: TextAlign.center,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
