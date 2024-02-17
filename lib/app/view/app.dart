import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../routes/app_routes.dart';
import '../../routes/routes.dart';
import '../../screens/splash_screen/cubit/splash_screen_cubit.dart';
import '../../services/auth/auth.dart';
import '../../utils/constants.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
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
      ],
      child: MaterialApp(
        title: 'Grow Green',
        debugShowCheckedModeBanner: false,
        navigatorKey: Navigation.navigationKey,
        onGenerateRoute: AppRoutes.generateRoutes,
        initialRoute: RouteName.splashScreen.name,
        theme: ThemeData(fontFamily: kFontFamily),
      ),
    );
  }
}
