import 'package:flutter/material.dart';

import '../../../../../utils/extensions/num_extensions.dart';
import '../../../../../utils/text_styles.dart';
import '../../../../../widgets/stylized_text.dart';
import '../../../../utils/game_icons.dart';
import 'stat_skeleton_widget.dart';

class TemperatureStat extends StatelessWidget {
  const TemperatureStat({super.key});

  @override
  Widget build(BuildContext context) {
    return StatSkeletonWidget(
      imageAlignment: StatSkeletonImageAlignment.left,
      width: 180.s,
      iconAsset: GameIcons.temperature,
      child: StylizedText(
        text: Text(
          '30.87° C',
          style: TextStyles.s28,
        ),
      ),
    );
  }
}
