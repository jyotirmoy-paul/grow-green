part of 'game_bloc.dart';

sealed class GameState extends Equatable {
  const GameState();

  @override
  List<Object> get props => [];
}

final class GameLoading extends GameState {
  const GameLoading();
}

final class GameLoaded extends GameState {
  final GrowGreenGame game;

  const GameLoaded({
    required this.game,
  });

  @override
  List<Object> get props => [game];
}
