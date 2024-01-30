part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthInitializeEvent extends AuthEvent {}

class AuthLoginEvent extends AuthEvent {
  final UserAuthType authType;

  const AuthLoginEvent({
    required this.authType,
  });

  @override
  List<Object> get props => [authType];
}

class AuthUserUpdateEvent extends AuthEvent {
  final User user;

  const AuthUserUpdateEvent({
    required this.user,
  });

  @override
  List<Object> get props => [user];
}

class AuthLogoutEvent extends AuthEvent {}
