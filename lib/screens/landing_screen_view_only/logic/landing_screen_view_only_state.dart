
import 'package:equatable/equatable.dart';

sealed class LandingScreenViewOnlyState extends Equatable {
  const LandingScreenViewOnlyState();

  @override
  List<Object> get props => [];
}

final class LandingScreenViewOnlyInitial extends LandingScreenViewOnlyState {
  const LandingScreenViewOnlyInitial();
}

final class LandingScreenViewOnlyPreparingGame extends LandingScreenViewOnlyState {
  const LandingScreenViewOnlyPreparingGame();
}

final class LandingScreenViewOnlyGameReady extends LandingScreenViewOnlyState {
  const LandingScreenViewOnlyGameReady();
}

