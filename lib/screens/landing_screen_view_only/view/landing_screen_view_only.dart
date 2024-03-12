import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../routes/routes.dart';
import '../../../utils/extensions/num_extensions.dart';
import '../../../utils/text_styles.dart';
import '../../../widgets/game_button.dart';
import '../../../widgets/stylized_text.dart';
import '../../game_screen/bloc/game_bloc.dart';
import '../logic/landing_screen_view_only_cubit.dart';

class ViewOnlyLandingScreen extends StatefulWidget {
  final Uri uri;

  const ViewOnlyLandingScreen({
    super.key,
    required this.uri,
  });

  @override
  State<ViewOnlyLandingScreen> createState() => _ViewOnlyLandingScreenState();
}

class _ViewOnlyLandingScreenState extends State<ViewOnlyLandingScreen> {
  String? get _id => widget.uri.queryParameters['id'];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GameBloc, GameState>(
      listener: (context, state) {
        if (state is GameLoaded) {
          Navigation.popToFirst();
          Navigation.push(RouteName.viewOnlyGameScreen);
        }
      },
      child: BlocProvider(
        create: (context) => LandingScreenViewOnlyCubit(
          gameBloc: context.read<GameBloc>(),
          id: _id,
        ),
        child: Builder(builder: (context) {
          return Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StylizedText(
                  text: Text(
                    ' You are entering View Only Mode for other user',
                    style: TextStyles.s35,
                  ),
                ),
                Gap(24.s),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GameButton.text(
                      onTap: () async {
                        context.read<LandingScreenViewOnlyCubit>().onStartGame();
                      },
                      text: 'Start Game',
                      color: Colors.green,
                      textStyle: TextStyles.s35,
                    ),
                    Gap(24.s),
                    GameButton.text(
                      text: 'Cancel',
                      onTap: () => Navigation.pop(),
                      color: Colors.red,
                      textStyle: TextStyles.s35,
                    )
                  ],
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
