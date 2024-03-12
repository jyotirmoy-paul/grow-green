import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../game/utils/game_assets.dart';
import '../../../models/auth/user.dart';
import '../../../models/auth/user_auth_type.dart';
import '../../../routes/routes.dart';
import '../../../services/audio/audio_service.dart';
import '../../../services/auth/auth.dart';
import '../../../services/log/log.dart';
import '../../../utils/extensions/num_extensions.dart';
import '../../../utils/text_styles.dart';
import '../../../widgets/app_name.dart';
import '../../../widgets/game_button.dart';
import '../../../widgets/stylized_container.dart';
import '../../../widgets/stylized_text.dart';
import '../../game_screen/bloc/game_bloc.dart';
import '../cubit/landing_screen_cubit.dart';

class LandingScreen extends StatelessWidget {
  static const tag = 'LandingScreen';

  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<GameBloc, GameState>(
      listener: (context, state) {
        if (state is GameLoaded) {
          Log.d('$tag: Game is loaded, moving to game screen!');
          Navigation.pushReplacement(RouteName.gameScreen);
        }
      },
      child: BlocProvider(
        create: (context) => LandingScreenCubit(
          gameBloc: context.read<GameBloc>(),
          authBloc: context.read<AuthBloc>(),
        ),
        child: Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(GameAssets.background),
                fit: BoxFit.cover,
              ),
            ),
            child: BlocBuilder<AuthBloc, AuthState>(
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
          ),
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
    return Padding(
      padding: EdgeInsets.all(40.s),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          /// sign out button
          Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              height: 60.s,
              width: 160.s,
              child: GameButton.text(
                text: 'Sign out',
                color: Colors.red,
                textStyle: TextStyles.s30,
                onTap: () {
                  onLogout(context);
                },
              ),
            ),
          ),

          /// app name
          const Align(
            alignment: Alignment(0, -0.5),
            child: AppName(),
          ),

          /// greeting
          Align(
            child: StylizedText(
              text: Text(
                'Hi ${user.name.split(' ').first}!',
                style: TextStyles.s35,
              ),
            ),
          ),

          /// play button
          Align(
            alignment: Alignment.bottomRight,
            child: SizedBox(
              width: 300.s,
              height: 60.s,
              child: GameButton.text(
                text: 'Go to your village',
                color: Colors.blueAccent,
                textStyle: TextStyles.s30,
                onTap: () {
                  onStartGame(context);
                },
              ),
            ),
          ),

          /// music control buttons
          const Align(
            alignment: Alignment.bottomLeft,
            child: _AudioVolumeSettings(),
          ),
        ],
      ),
    );
  }
}

class _AudioVolumeSettings extends StatelessWidget {
  const _AudioVolumeSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// sfx
          StylizedText(
            text: Text(
              'Sound Effects',
              style: TextStyles.s30,
            ),
          ),

          _SeekProgressBar(
            iconData: Icons.volume_up_rounded,
            initialValue: AudioService().sfxVolume,
            onChange: (value) {
              if (value == 1.0) {
                AudioService().tap();
              }

              AudioService().updateSfxVolumne(value);
            },
          ),

          Gap(40.s),

          /// bgm
          StylizedText(
            text: Text(
              'Music',
              style: TextStyles.s30,
            ),
          ),

          _SeekProgressBar(
            iconData: Icons.music_note_rounded,
            initialValue: AudioService().bgmVolume,
            onChange: (value) {
              AudioService().updateBgmVolume(value);
            },
          ),
        ],
      ),
    );
  }
}

class _SeekProgressBar extends StatelessWidget {
  final IconData iconData;
  final double width;
  final double thumbSize;
  final double initialValue;

  final void Function(double value) onChange;

  _SeekProgressBar({
    required this.iconData,
    required this.initialValue,
    required this.onChange,
    super.key,
  })  : assert(0 <= initialValue && initialValue <= 1.0),
        width = 300.s,
        thumbSize = 48.s;

  late final availableWidth = width - thumbSize;
  late final valueNotifier = ValueNotifier<double>(initialValue * (width - thumbSize));

  double getClampedValue(double v) {
    return v.clamp(0, availableWidth);
  }

  final slashWidget = Transform.rotate(
    angle: -0.7,
    child: Transform.scale(
      scaleY: 1.0,
      scaleX: 0.8,
      child: StylizedText(
        text: Text(
          '|',
          style: TextStyles.s30.copyWith(
            color: Colors.red,
          ),
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: thumbSize,
      child: ValueListenableBuilder<double>(
        valueListenable: valueNotifier,
        builder: (context, position, child) {
          return Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              /// background
              child!,

              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  height: 15.s,
                  width: position + (thumbSize / 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.horizontal(left: Radius.circular(12.s)),
                    color: Colors.green,
                  ),
                ),
              ),

              /// thumb
              Positioned(
                height: thumbSize,
                width: thumbSize,
                left: position,
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    final newValue = getClampedValue(valueNotifier.value + details.delta.dx);
                    if (newValue == valueNotifier.value) return;

                    /// update state & give callback
                    valueNotifier.value = newValue;
                    onChange(valueNotifier.value / availableWidth);
                  },
                  child: () {
                    final thumb = Container(
                      height: thumbSize,
                      width: thumbSize,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.black,
                          width: 2.0,
                        ),
                      ),
                      child: Icon(iconData, size: 40.s),
                    );

                    if (valueNotifier.value == 0.0) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          thumb,
                          slashWidget,
                        ],
                      );
                    }

                    return thumb;
                  }(),
                ),
              ),
            ],
          );
        },
        child: SizedBox(
          height: 15.s,
          width: width,
          child: const StylizedContainer(
            applyColorOpacity: true,
            padding: EdgeInsets.zero,
            margin: EdgeInsets.zero,
            child: SizedBox.shrink(),
          ),
        ),
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
