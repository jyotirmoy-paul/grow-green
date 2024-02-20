import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../../grow_green_game.dart';
import '../../../components/farm/farm.dart';
import '../../../components/farm/model/farm_content.dart';
import '../bill_menu.dart';

class BillSell extends StatelessWidget {
  static const tag = 'BillSell';

  final Farm farm;
  final FarmContent farmContent;
  final AnimationController animationController;
  final GrowGreenGame game;

  const BillSell({
    super.key,
    required this.game,
    required this.animationController,
    required this.farm,
    required this.farmContent,
  });

  String get treeName {
    final trees = farmContent.trees;
    if (trees == null || trees.isEmpty) {
      throw Exception('$tag: _buildContent invoked with null trees in the farm Content. Did you forgot to set it?');
    }

    return trees[0].type.name;
  }

  String get content {
    return 'If you sell $treeName right now, you would get a value of Rs ${farm.farmController.getTreePotentialValue().formattedRupees}. Do you want to proceed with the sell?';
  }

  void _onClose() async {
    await animationController.reverse();
    game.overlays.remove(BillMenu.overlayName);
  }

  void _onSellConfirm() async {
    final treeSuccessfullySold = await farm.farmController.sellTree();

    /// TODO: handle tree sell result
    game.overlays.remove(BillMenu.overlayName);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Sell $treeName?',
          style: TextStyle(fontSize: 32.0),
        ),

        /// gap
        const Gap(32.0),

        Text(
          content,
          style: TextStyle(fontSize: 26.0),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: _onClose,
              child: Text(
                'Cancel',
                style: TextStyle(fontSize: 24.0),
              ),
            ),
            TextButton(
              onPressed: _onSellConfirm,
              child: Text(
                'Sell',
                style: TextStyle(fontSize: 24.0),
              ),
            ),
          ],
        )
      ],
    );
  }
}
