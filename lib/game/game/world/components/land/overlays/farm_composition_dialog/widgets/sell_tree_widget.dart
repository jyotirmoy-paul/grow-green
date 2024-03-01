import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../../../../routes/routes.dart';
import '../../../../../../../../utils/extensions/num_extensions.dart';
import '../../../../../../../../utils/text_styles.dart';
import '../../../../../../../../widgets/game_button.dart';
import '../../../../../../../utils/game_icons.dart';
import '../../../components/farm/farm_controller.dart';
import '../../../components/farm/model/tree_data.dart';

class SellTreeWidget extends StatelessWidget {
  final FarmController farmController;
  final TreeData treeData;

  SellTreeWidget({
    super.key,
    required this.farmController,
  }) : treeData = farmController.treeData;

  void _sellTree() {
    farmController.sellTree();

    /// TODO: notification

    /// close everything!
    Navigation.popToFirst();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.s),
      child: Column(
        children: [
          /// title
          Expanded(
            flex: 3,
            child: Row(
              children: [
                /// text
                Expanded(
                  child: Text(
                    'You may be loosing out on recurring revenue & huge tree potential over time',
                    style: TextStyles.s25.copyWith(
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                /// graph
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(12.s),
                    child: Container(
                      alignment: Alignment.center,
                      color: Colors.grey,
                      child: Text('Graph here'),
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// info
          Expanded(
            flex: 2,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// info
                Image.asset(
                  GameIcons.info,
                  width: 50.s,
                ),

                /// gap
                Gap(20.s),

                /// description
                Expanded(
                  child: Text(
                    'On the other hand, the tree has removed 200 metric tones of CO2 over the last 10 years, if you keep for another 10 years, another 200 metric tones of CO2 will be removed from the atmosphere, making your village\'s climate much better!',
                    style: TextStyles.s26.copyWith(
                      color: Colors.black,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// button
          GameButton.textImage(
            bgColor: Colors.red,
            text: 'Sell Tree',
            image: GameIcons.cutTree,
            onTap: _sellTree,
          ),

          Gap(20.s),
        ],
      ),
    );
  }
}
