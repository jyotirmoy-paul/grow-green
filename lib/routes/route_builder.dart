import 'package:flutter/material.dart';
import 'routes.dart';
import '../screens/splash_screen/view/splash_screen.dart';

abstract class RouteBuilder {
  static final navigationKey = GlobalKey<NavigatorState>();
  static NavigatorState get _navigatorState => navigationKey.currentState!;

  static Map<String, WidgetBuilder> routes() {
    return {
      RouteNames.splashScreen: (context) => const SplashScreen(),
      RouteNames.landingScreen: (context) => const Placeholder(),
      RouteNames.gameScreen: (context) => const Placeholder(),
    };
  }

  static Future<void> pushReplacementNamed(String routeName) {
    return _navigatorState.pushReplacementNamed(routeName);
  }
}
