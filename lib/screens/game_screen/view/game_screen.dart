import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:growgreen/game/game/grow_green_game.dart';
import 'package:growgreen/screens/game_screen/bloc/game_bloc.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => GameBloc(),
        ),
      ],
      child: BlocConsumer<GameBloc, GameState>(
        listener: (context, state) {},
        builder: (context, state) {
          return GameWidget(
            game: kDebugMode ? GrowGreenGame() : state.game,
          );
        },
      ),
    );
  }
}
