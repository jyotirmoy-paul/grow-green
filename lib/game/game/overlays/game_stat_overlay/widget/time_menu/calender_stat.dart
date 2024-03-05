import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../utils/constants.dart';
import '../../../../../../utils/extensions/num_extensions.dart';
import '../../../../../../utils/text_styles.dart';

import '../../../../../../widgets/stylized_text.dart';
import '../../../../../utils/game_icons.dart';
import '../../cubit/calender_cubit.dart';
import '../stat_skeleton_widget.dart';

class CalenderStat extends StatelessWidget {
  const CalenderStat({super.key});

  @override
  Widget build(BuildContext context) {
    return StatSkeletonWidget(
      width: 280.s,
      iconAsset: GameIcons.calender,
      child: BlocBuilder<CalenderCubit, CalenderState>(
        builder: (context, state) {
          return AnimatedSwitcher(
            duration: kMS200,
            child: StylizedText(
              key: ValueKey(state.month),
              text: Text(
                '${state.month} ${state.year}',
                style: TextStyles.s28,
                textAlign: TextAlign.center,
              ),
            ),
          );
        },
      ),
    );
  }
}
