import 'package:flutter/material.dart';

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
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          /// background
          Align(
            alignment: Alignment.topCenter,
            child: IgnorePointer(
              ignoring: true,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.20,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.6),
                      Colors.black.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
          ),

          Positioned.fill(
            child: SafeArea(
              child: Stack(
                children: [
                  /// show calender on top
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
