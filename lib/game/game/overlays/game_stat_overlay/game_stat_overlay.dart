import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../utils/extensions/num_extensions.dart';
import '../../grow_green_game.dart';
import 'widget/calender_stat.dart';
import 'widget/money_stat.dart';
import 'widget/time_menu/time_menu.dart';

class GameStatOverlay extends StatelessWidget {
  static const overlayName = 'game-stats';
  static Widget builder(BuildContext context, GrowGreenGame game) {
    return GameStatOverlay(game: game);
  }

  const GameStatOverlay({
    super.key,
    required this.game,
  });

  final GrowGreenGame game;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20.s,
          vertical: 20.s,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// money, temperature
            Column(
              children: [
                /// money
                MoneyStat(monetaryService: game.monetaryService),

                /// temperature
              ],
            ),

            /// spacer
            const Spacer(),

            /// timer & calender
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// calender
                const CalenderStat(),

                Gap(25.s),

                /// time menu
                const TimeMenu(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/**
 * /// show calender on top
          const Align(
            alignment: Alignment.topCenter,
            child: CalenderStat(),
          ),

          /// menu for editing time factor
          const Align(
            alignment: Alignment.topRight,
            child: TimeMenu(),
          ),

          /// show money on top left
          Align(
            alignment: Alignment.topLeft,
            child: MoneyStat(
              monetaryService: game.gameController.monetaryService,
            ),
          ),
 */
