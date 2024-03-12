import 'package:flutter/material.dart';

import '../../../../../../../routes/routes.dart';
import '../../../../../../../services/log/log.dart';
import '../../../../../../../utils/text_styles.dart';
import '../../../../../../../utils/utils.dart';
import '../../../../../../../widgets/game_button.dart';
import '../../../../../../../widgets/stylized_text.dart';
import '../../../../../grow_green_game.dart';
import '../../../../../overlays/notification_overlay/model/notification_model.dart';
import '../../../../../overlays/notification_overlay/service/notification_service.dart';
import 'redeem_service.dart';

class RedeemButton extends StatelessWidget {
  static const tag = 'RedeemButton';
  final GrowGreenGame game;

  const RedeemButton({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return GameButton.text(
      text: "Redeem",
      onTap: () async {
        Utils.showNonAnimatedDialog(
          barrierLabel: "Enter Redeem Code",
          context: context,
          builder: (context) {
            return inputField(context);
          },
        );
      },
      textStyle: TextStyles.s30,
      color: Colors.transparent,
    );
  }

  Widget inputField(BuildContext context) {
    final controller = TextEditingController();
    return AlertDialog(
      backgroundColor: Colors.white,
      title: StylizedText(text: Text("Enter Redeem Code", style: TextStyles.s30)),
      content: _input(controller),
      actions: [
        actions(controller, context),
      ],
    );
  }

  GameButton actions(TextEditingController controller, BuildContext context) {
    return GameButton.text(
      text: "Redeem",
      onTap: () async {
        final code = controller.text;
        if (code.isEmpty) {
          Log.e("$tag: Redeem code is empty");
          return;
        }
        final redeemService = RedeemService(game: game);
        final money = await redeemService.getMoneyIfPresent(code);

        final response = await redeemService.redeemCode(code);
        if (response == RedeemCodeResponse.success) {
          final successNotification = NotificationModel(
            text: "Yay! You have successfully redeemed ${money?.formattedValue}",
            textColor: Colors.green,
          );
          NotificationService().notify(successNotification);
          Navigation.pop();
        } else {
          final failureNotification = NotificationModel(
            text: "Oops! Redeem code is not valid",
            textColor: Colors.red,
          );
          NotificationService().notify(failureNotification);
          Log.e("$tag: Redeem code is not valid");
        }
      },
    );
  }

  TextField _input(TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: "Enter redeem code",
      ),
    );
  }
}
