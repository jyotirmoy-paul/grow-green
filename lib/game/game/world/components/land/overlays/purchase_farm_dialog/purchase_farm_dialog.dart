import 'package:flutter/material.dart';

import '../../../../../../../utils/extensions/num_extensions.dart';
import '../../../../../../../utils/text_styles.dart';
import '../../../../../../../widgets/game_button.dart';
import '../../../../../../utils/game_icons.dart';
import '../../../../../../utils/game_utils.dart';
import '../../../../../overlays/notification_overlay/service/notification_helper.dart';
import '../../components/farm/farm.dart';

/// TODO: Language
class PurchaseFarmDialog extends StatelessWidget {
  final Farm farm;

  const PurchaseFarmDialog({
    super.key,
    required this.farm,
  });

  void _purchaseFarm(BuildContext context) {
    final canBuy = farm.farmController.purchaseFarm();

    if (canBuy) {
      Navigator.pop(context, true);
    } else {
      NotificationHelper.cannotAffordFarm();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12.s),
      child: Center(
        child: Column(
          children: [
            const Spacer(),

            /// confirmation text
            Text(
              'Are you sure you want to purchase the farm?',
              style: TextStyles.s28brown,
            ),

            const Spacer(),

            /// buy button
            GameButton.textImage(
              text: GameUtils.farmInitialPrice.formattedValue,
              image: GameIcons.coin,
              onTap: () => _purchaseFarm(context),
              bgColor: Colors.lightGreen,
            ),
          ],
        ),
      ),
    );
  }
}