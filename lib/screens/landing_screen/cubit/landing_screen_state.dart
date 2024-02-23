part of 'landing_screen_cubit.dart';

sealed class LandingScreenState extends Equatable {
  const LandingScreenState();

  @override
  List<Object> get props => [];
}

final class LandingScreenInitial extends LandingScreenState {
  const LandingScreenInitial();
}

final class LandingScreenPreparingGame extends LandingScreenState {
  const LandingScreenPreparingGame();
}

final class LandingScreenGameReady extends LandingScreenState {
  const LandingScreenGameReady();
}
