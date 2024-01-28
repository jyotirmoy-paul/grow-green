part of 'landing_screen_bloc.dart';

sealed class LandingScreenState extends Equatable {
  const LandingScreenState();

  @override
  List<Object> get props => [];
}

final class LandingScreenInitial extends LandingScreenState {}
