import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../models/auth/user.dart';
import '../../../models/auth/user_auth_type.dart';
import '../../../services/auth/auth.dart';
import '../cubit/landing_screen_cubit.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LandingScreenCubit(),
      child: Scaffold(
        body: Stack(
          children: [
            /// Background image

            /// View
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, authState) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  reverseDuration: const Duration(milliseconds: 300),
                  child: () {
                    if (authState is AuthLoginProcessing) {
                      return const Align(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          key: ValueKey('processing-view'),
                        ),
                      );
                    }

                    if (authState is AuthLoggedIn) {
                      return _LoggedInView(
                        key: const ValueKey('logged-in-view'),
                        user: authState.user,
                      );
                    }

                    return const _NotLoggedInView(
                      key: ValueKey('not-logged-in-view'),
                    );
                  }(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _LoggedInView extends StatelessWidget {
  final User user;
  const _LoggedInView({
    super.key,
    required this.user,
  });

  void onLogout(BuildContext context) {
    context.read<AuthBloc>().add(AuthLogoutEvent());
  }

  void onStartGame(BuildContext context) {
    context.read<LandingScreenCubit>().onStartGame();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Hi ${user.name}",
            style: const TextStyle(
              color: Colors.blue,
              fontSize: 40.0,
              letterSpacing: 2.0,
            ),
          ),
          const Gap(40.0),
          ElevatedButton(
            onPressed: () {
              onStartGame(context);
            },
            child: const Text(
              'Start Game',
              style: TextStyle(
                fontSize: 20.0,
                letterSpacing: 2.0,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              onLogout(context);
            },
            child: const Text(
              'Logout',
              style: TextStyle(
                fontSize: 20.0,
                letterSpacing: 2.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotLoggedInView extends StatelessWidget {
  const _NotLoggedInView({super.key});

  void onSignInTap({required BuildContext context, required UserAuthType authType}) {
    context.read<AuthBloc>().add(AuthLoginEvent(authType: authType));
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: () {
              onSignInTap(context: context, authType: UserAuthType.google);
            },
            child: const Text(
              'Sign in with Google',
              style: TextStyle(
                fontSize: 20.0,
                letterSpacing: 2.0,
              ),
            ),
          ),
          const Gap(20.0),
          ElevatedButton(
            onPressed: () {
              onSignInTap(context: context, authType: UserAuthType.apple);
            },
            child: const Text(
              'Sign in with Apple',
              style: TextStyle(
                fontSize: 20.0,
                letterSpacing: 2.0,
              ),
            ),
          ),
          const Gap(40.0),
          BlocBuilder<AuthBloc, AuthState>(
            builder: (_, authState) {
              if (authState is AuthLoggedInFailed) {
                return const Text(
                  "Something went wrong!",
                  style: TextStyle(
                    fontSize: 20.0,
                    letterSpacing: 2.0,
                    color: Colors.red,
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
