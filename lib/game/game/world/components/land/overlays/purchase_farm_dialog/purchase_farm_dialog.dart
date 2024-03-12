import 'package:flutter/material.dart';

import '../../../../../../../l10n/l10n.dart';
import '../../../../../../../services/audio/audio_service.dart';
import '../../../../../../../utils/extensions/num_extensions.dart';
import '../../../../../../../utils/text_styles.dart';
import '../../../../../../../widgets/game_button.dart';
import '../../../../../../utils/game_assets.dart';
import '../../../../../../utils/game_utils.dart';
import '../../../../../overlays/notification_overlay/service/notification_helper.dart';
import '../../components/farm/farm.dart';

class PurchaseFarmDialog extends StatelessWidget {
  final Farm farm;

  const PurchaseFarmDialog({
    super.key,
    required this.farm,
  });

  void _purchaseFarm(BuildContext context) {
    final canBuy = farm.farmController.purchaseFarm();

    if (canBuy) {
      /// farm purchased audio
      AudioService().farmPurchased();

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
              context.l10n.confirmFarmPurchase,
              style: TextStyles.s28brown,
            ),

            const Spacer(),

            /// buy button
            GameButton.textImage(
              text: GameUtils.farmInitialPrice.formattedValue,
              image: GameAssets.coin,
              onTap: () => _purchaseFarm(context),
              bgColor: Colors.lightGreen,
            ),
          ],
        ),
      ),
    );
  }
}
