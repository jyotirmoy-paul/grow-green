import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../game/game/grow_green_game.dart';
import '../../../game/game/overlays/game_stat_overlay/cubit/calender_cubit.dart';
import '../../../game/game/overlays/game_stat_overlay/game_stat_overlay.dart';
import '../../../game/game/world/components/land/overlays/bill_menu/bill_menu.dart';
import '../../../game/game/world/components/land/overlays/component_selector_menu/component_selector_menu.dart';
import '../../../game/game/world/components/land/overlays/system_selector_menu/bloc/system_selector_menu_bloc.dart';
import '../../../game/game/world/components/land/overlays/system_selector_menu/system_selector_menu.dart';
import '../bloc/game_bloc.dart';

class GameScreen extends StatelessWidget {
  static const tag = 'GameScreen';

  const GameScreen({super.key});

  /// list down all overlays
  static const overlayBuilderMap = <String, Widget Function(BuildContext, GrowGreenGame)>{
    SystemSelectorMenu.overlayName: SystemSelectorMenu.builder,
    ComponentSelectorMenu.overlayName: ComponentSelectorMenu.builder,
    BillMenu.overlayName: BillMenu.builder,
    GameStatOverlay.overlayName: GameStatOverlay.builder,
  };

  @override
  Widget build(BuildContext context) {
    final gameBloc = context.read<GameBloc>();
    if (gameBloc.state is! GameLoaded) {
      throw Exception('$tag build() was invoked in wrong GameBloc state: ${gameBloc.state}');
    }

    final gameLoadedState = gameBloc.state as GameLoaded;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SystemSelectorMenuBloc(
            game: gameLoadedState.game,
          ),
        ),
        BlocProvider(
          create: (context) => CalenderCubit(),
        ),
      ],
      child: BlocBuilder<GameBloc, GameState>(
        builder: (_, state) {
          return GameWidget<GrowGreenGame>(
            game: gameLoadedState.game,
            overlayBuilderMap: overlayBuilderMap,
            initialActiveOverlays: const [
              GameStatOverlay.overlayName,
            ],
          );
        },
      ),
    );
  }
}
