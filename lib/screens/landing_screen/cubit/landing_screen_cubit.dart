import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:growgreen/routes/routes.dart';

part 'landing_screen_state.dart';

class LandingScreenCubit extends Cubit<LandingScreenState> {
  LandingScreenCubit() : super(LandingScreenInitial());

  void onStartGame() {
    Navigation.pushReplacement(RouteName.gameScreen);
  }
}
