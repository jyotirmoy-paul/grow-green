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
  final _authService = AuthServiceFactory.build(SupportedAuthService.firebase);

  AuthBloc() : super(AuthInitial()) {
    on<AuthInitializeEvent>(_onInitialize);
    on<AuthLoginEvent>(_onLogin);
    on<AuthLogoutEvent>(_onLogout);
    on<AuthUserUpdateEvent>(_onUserUpdate);
  }

  void _onInitialize(_, Emitter<AuthState> emit) {
    /// Check if a logged in user is available
    if (!_authService.isLoggedIn()) {
      emit(AuthNotLoggedIn());
    }

    /// Start listening for user state changes
    _authService.userChanges().listen(
      (user) {
        if (user != null) {
          add(AuthUserUpdateEvent(user: user));
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
        serviceAction = await _authService.signInWithGoogle();
        break;

      case UserAuthType.apple:
        serviceAction = await _authService.signInWithApple();
        break;
    }

    if (serviceAction == ServiceAction.failure) {
      emit(AuthLoggedInFailed());
    }
  }

  void _onLogout(AuthLogoutEvent event, Emitter<AuthState> emit) {
    _authService.logout();
    emit(AuthNotLoggedIn());
  }

  void _onUserUpdate(AuthUserUpdateEvent event, Emitter<AuthState> emit) {
    emit(AuthLoggedIn(user: event.user));
  }
}
