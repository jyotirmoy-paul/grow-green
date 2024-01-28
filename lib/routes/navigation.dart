import 'package:flutter/material.dart';

import 'routes.dart';

abstract class Navigation {
  static final navigationKey = GlobalKey<NavigatorState>();
  static NavigatorState get _navigatorState => navigationKey.currentState!;

  static Future<void> pushReplacement(RouteName routeName) {
    return _navigatorState.pushNamed(routeName.name);
  }
}
