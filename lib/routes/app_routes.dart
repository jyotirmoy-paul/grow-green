import 'package:flutter/material.dart';
import '../screens/game_screen/view/game_screen.dart';

import '../screens/landing_screen/view/landing_screen.dart';
import '../screens/splash_screen/view/splash_screen.dart';
import '../utils/extensions/string_extensions.dart';
import 'routes.dart';

part 'fade_page_route_builder.dart';

abstract class AppRoutes {
  static Route<dynamic>? generateRoutes(RouteSettings settings) {
    final routeName = settings.name.toEnum(RouteName.values, RouteName.splashScreen);

    return _FadePageRouteBuilder(
      settings: settings,
      child: _buildScreen(routeName),
    );
  }

  static Widget _buildScreen(RouteName routeName) {
    switch (routeName) {
      case RouteName.splashScreen:
        return const SplashScreen();

      case RouteName.landingScreen:
        return const LandingScreen();

      case RouteName.gameScreen:
        return const GameScreen();
    }
  }
}
