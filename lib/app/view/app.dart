import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:growgreen/screens/splash_screen/cubit/splash_screen_cubit.dart';

import '../../routes/routes.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SplashScreenCubit()),
      ],
      child: MaterialApp(
        title: 'Grow Green',
        routes: RouteBuilder.routes(),
        initialRoute: RouteNames.splashScreen,
        navigatorKey: RouteBuilder.navigationKey,
      ),
    );
  }
}
