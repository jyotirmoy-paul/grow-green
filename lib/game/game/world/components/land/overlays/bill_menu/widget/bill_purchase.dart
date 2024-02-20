import 'package:flutter/material.dart';

import '../../../../../../grow_green_game.dart';
import '../../../components/farm/model/farm_content.dart';
import '../bill_menu.dart';
import '../enums/bill_state.dart';
import '../utils/bill_widget_utils.dart';

class BillPurchase extends StatelessWidget {
  final GrowGreenGame game;
  final AnimationController animationController;
  final FarmContent farmContent;
  final BillState billState;

  const BillPurchase({
    super.key,
    required this.game,
    required this.animationController,
    required this.farmContent,
    required this.billState,
  });

  void _onClose() async {
    await animationController.reverse();

    game.gameController.overlayData.stayOnSystemSelectorMenu = true;
    game.overlays.remove(BillMenu.overlayName);
  }

  void _onPurchase() async {
    await animationController.reverse();

    game.gameController.overlayData.stayOnSystemSelectorMenu = false;
    game.gameController.overlayData.farm.farmController.updateFarmComposition(
      farmContent: farmContent,
    );

    game.overlays.remove(BillMenu.overlayName);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        /// crop
        BillWidgetUtils.buildCropGroup(farmContent: farmContent),

        /// tree
        BillWidgetUtils.buildTreeGroup(farmContent: farmContent),

        /// fertilizer
        BillWidgetUtils.buildFertilizerGroup(farmContent: farmContent),

        /// total
        BillWidgetUtils.buildTotal(farmContent: farmContent),

        /// action button
        Row(
          children: [
            TextButton(
              onPressed: _onClose,
              child: const Text(
                'Cancel Purchase',
                style: TextStyle(color: Colors.red, fontSize: 24.0),
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: _onPurchase,
              child: const Text(
                'Confirm Purchase',
                style: TextStyle(color: Colors.green, fontSize: 24.0),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
