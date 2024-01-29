part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

final class AuthNotLoggedIn extends AuthState {}

final class AuthLoginProcessing extends AuthState {}

final class AuthLoggedIn extends AuthState {
  final User user;

  const AuthLoggedIn({required this.user});

  @override
  List<Object> get props => [user];
}

final class AuthLoggedInFailed extends AuthState {}
