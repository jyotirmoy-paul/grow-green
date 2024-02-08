import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../game/game/world/components/land/overlays/farm_composition_menu/cubit/farm_composition_menu_cubit.dart';
import '../../../game/game/world/components/land/overlays/inventory/cubit/inventory_cubit.dart';
import '../../../game/game/world/components/land/overlays/inventory/inventory.dart';

import '../../../game/game/grow_green_game.dart';
import '../../../game/game/world/components/land/overlays/farm_composition_menu/farm_composition_menu.dart';
import '../bloc/game_bloc.dart';
import '../cubit/game_overlay_cubit.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  /// list down all overlays
  static const overlayBuilderMap = <String, Widget Function(BuildContext, GrowGreenGame)>{
    FarmCompositionMenu.overlayName: FarmCompositionMenu.builder,
    Inventory.overlayName: Inventory.builder,
  };

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => GameBloc(),
        ),
        BlocProvider(
          create: (_) => GameOverlayCubit(),
        ),
        BlocProvider(
          create: (context) => FarmCompositionMenuCubit(
            game: context.read<GameBloc>().state.game,
          ),
        ),
        BlocProvider(
          create: (context) => InventoryCubit(
            inventoryDatastore: context.read<GameBloc>().state.game.gameController.gameDatastore.inventoryDatastore,
            farmCompositionMenuCubit: context.read<FarmCompositionMenuCubit>(),
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
