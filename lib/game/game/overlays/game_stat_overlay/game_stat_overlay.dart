import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../utils/extensions/num_extensions.dart';
import '../../grow_green_game.dart';
import '../../world/components/land/overlays/redeem/redeem_button.dart';
import 'widget/achievement_stat.dart';
import 'widget/money/money_stat.dart';
import 'widget/share_button.dart';
import 'widget/temperature_stat.dart';
import 'widget/time_menu/calender_stat.dart';
import 'widget/time_menu/time_menu.dart';
import 'widget/view_only_mode.dart';

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
                /// achievements
                AchievementsStat(
                  achievementsService: game.gameController.achievementsService,
                ),

                Gap(10.s),

                /// money
                MoneyStat(monetaryService: game.monetaryService),

                Gap(10.s),

                /// temperature

                TemperatureStat(
                  villageTemperatureService:
                      game.gameController.world.worldController.land.landController.villageTemperatureService,
                ),

                Gap(20.s),

                /// achievements
                if (!game.isViewOnly) ...[
                  AchievementsStat(
                    achievementsService: game.gameController.achievementsService,
                  ),
                  Gap(20.s)
                ],

                /// share button
                if (!game.isViewOnly) ...[const ShareButton(), Gap(20.s)],

                /// Redeem button
                if (!game.isViewOnly) ...[RedeemButton(game: game), Gap(20.s)],
              ],
            ),
            const Spacer(),

            if (game.isViewOnly) const ViewOnlyMode(),

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
                if (!game.isViewOnly) const TimeMenu(),
              ],
            ),
            Gap(25.s),
          ],
        ),
      ),
    );
  }
}
