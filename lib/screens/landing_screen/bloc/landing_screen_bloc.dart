import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'landing_screen_event.dart';
part 'landing_screen_state.dart';

class LandingScreenBloc extends Bloc<LandingScreenEvent, LandingScreenState> {
  LandingScreenBloc() : super(LandingScreenInitial()) {
    on<LandingScreenEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
