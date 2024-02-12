import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../game/game/world/components/land/overlays/component_selector_menu/component_selector_menu.dart';
import '../../../game/game/world/components/land/overlays/system_selector_menu/bloc/system_selector_menu_bloc.dart';
import '../../../game/game/world/components/land/overlays/system_selector_menu/system_selector_menu.dart';

import '../../../game/game/grow_green_game.dart';
import '../bloc/game_bloc.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  /// list down all overlays
  static const overlayBuilderMap = <String, Widget Function(BuildContext, GrowGreenGame)>{
    SystemSelectorMenu.overlayName: SystemSelectorMenu.builder,
    ComponentSelectorMenu.overlayName: ComponentSelectorMenu.builder,
  };

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => GameBloc(),
        ),
        BlocProvider(
          create: (context) => SystemSelectorMenuBloc(
            game: context.read<GameBloc>().state.game,
          ),
        ),
      ],
      child: BlocBuilder<GameBloc, GameState>(
        builder: (_, state) {
          return GameWidget<GrowGreenGame>(
            game: kDebugMode ? state.game : state.game,
            overlayBuilderMap: overlayBuilderMap,
          );
        },
      ),
    );
  }
}
