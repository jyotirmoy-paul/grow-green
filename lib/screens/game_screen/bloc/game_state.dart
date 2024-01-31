part of 'game_bloc.dart';

sealed class GameState extends Equatable {
  const GameState();

  GrowGreenGame get game;

  @override
  List<Object> get props => [];
}

final class GameInitial extends GameState {
  @override
  final GrowGreenGame game;

  const GameInitial({
    required this.game,
  });

  @override
  List<Object> get props => [game];
}
