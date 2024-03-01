import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../game/game/overlays/notification_overlay/game_notification_widget.dart';
import '../../routes/app_routes.dart';
import '../../routes/routes.dart';
import '../../screens/game_screen/bloc/game_bloc.dart';
import '../../screens/splash_screen/cubit/splash_screen_cubit.dart';
import '../../services/auth/auth.dart';
import '../../utils/constants.dart';
import '../../utils/responsive.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    Responsive().init(context: context);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(),
        ),
        BlocProvider(
          create: (context) => SplashScreenCubit(
            authBloc: context.read<AuthBloc>(),
          ),
        ),
        BlocProvider(
          create: (_) => GameBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Grow Green',
        debugShowCheckedModeBanner: false,
        navigatorKey: Navigation.navigationKey,
        onGenerateRoute: AppRoutes.generateRoutes,
        initialRoute: RouteName.splashScreen.name,
        theme: ThemeData(fontFamily: kFontFamily),
        builder: (_, child) {
          return Stack(
            children: [child!, const GameNotificationWidget()],
          );
        },
      ),
    );
  }
}
