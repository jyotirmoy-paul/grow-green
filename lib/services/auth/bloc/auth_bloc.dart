import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../models/auth/user.dart';
import '../../../models/auth/user_auth_type.dart';
import '../auth.dart';
import '../../log/log.dart';
import '../../utils/service_action.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  static const tag = "AuthBloc";
  final authService = AuthServiceFactory.build(SupportedAuthService.firebase);

  AuthBloc() : super(AuthInitial()) {
    on<AuthInitializeEvent>(_onInitialize);
    on<AuthLoginEvent>(_onLogin);
    on<AuthLogoutEvent>(_onLogout);
  }

  void _onInitialize(_, Emitter<AuthState> emit) {
    /// Check if a logged in user is available
    if (authService.isLoggedIn()) {
      emit(AuthLoggedIn(user: authService.currentUser()));
    } else {
      emit(AuthNotLoggedIn());
    }

    /// Start listening for user state changes
    authService.userChanges().listen(
      (user) {
        if (user != null) {
          emit(AuthLoggedIn(user: user));
        } else {
          emit(AuthNotLoggedIn());
        }
      },
      onError: (e) {
        Log.e("$tag: _onInitialize error: $e");
      },
    );
  }

  void _onLogin(AuthLoginEvent event, Emitter<AuthState> emit) async {
    final authType = event.authType;
    late ServiceAction serviceAction;

    emit(AuthLoginProcessing());

    switch (authType) {
      case UserAuthType.google:
        serviceAction = await authService.signInWithGoogle();
        break;

      case UserAuthType.apple:
        serviceAction = await authService.signInWithApple();
        break;
    }

    if (serviceAction == ServiceAction.failure) {
      emit(AuthLoggedInFailed());
    }
  }

  void _onLogout(AuthLogoutEvent event, Emitter<AuthState> emit) {
    authService.logout();
  }
}
