import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../routes/app_routes.dart';
import '../../screens/splash_screen/cubit/splash_screen_cubit.dart';

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
        navigatorKey: Navigation.navigationKey,
        onGenerateRoute: AppRoutes.generateRoutes,
        initialRoute: RouteName.splashScreen.name,
      ),
    );
  }
}
