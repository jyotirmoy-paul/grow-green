part of 'game_overlay_cubit.dart';

sealed class GameOverlayState extends Equatable {
  const GameOverlayState();

  @override
  List<Object> get props => [];
}

final class GameOverlayNone extends GameOverlayState {
  const GameOverlayNone();
}

final class GameOverlaySystemSelector extends GameOverlayState {
  final Farm farm;

  const GameOverlaySystemSelector({
    required this.farm,
  });

  @override
  List<Object> get props => [farm];
}

final class GameOverlayFarmComposition extends GameOverlayState {
  final Farm farm;

  const GameOverlayFarmComposition({
    required this.farm,
  });

  @override
  List<Object> get props => [farm];
}
