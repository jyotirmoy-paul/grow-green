import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../utils/extensions/num_extensions.dart';
import '../../grow_green_game.dart';
import 'widget/money/money_stat.dart';
import 'widget/temperature_stat.dart';
import 'widget/time_menu/calender_stat.dart';
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// money
                MoneyStat(monetaryService: game.monetaryService),

                Gap(10.s),

                /// temperature
                TemperatureStat(
                  villageTemperatureService:
                      game.gameController.world.worldController.land.landController.villageTemperatureService,
                ),
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
