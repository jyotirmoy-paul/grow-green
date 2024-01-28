part of 'splash_screen_cubit.dart';

@immutable
sealed class SplashScreenState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class SplashScreenInitial extends SplashScreenState {}

final class SplashScreenDone extends SplashScreenState {}
