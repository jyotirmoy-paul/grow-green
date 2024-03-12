part of 'game_bloc.dart';

sealed class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object> get props => [];
}

final class LoadGameEvent extends GameEvent {
  final MonetaryService monetaryService;
  final GameDatastore gameDatastore;
  final bool isViewOnly;

  const LoadGameEvent({
    required this.monetaryService,
    required this.gameDatastore,
    required this.isViewOnly,
  });

  @override
  List<Object> get props => [
        monetaryService,
        gameDatastore,
      ];
}
