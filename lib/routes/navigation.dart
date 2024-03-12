import 'package:flutter/material.dart';
import 'routes.dart';

abstract class Navigation {
  static final navigationKey = GlobalKey<NavigatorState>();
  static NavigatorState get _navigatorState => navigationKey.currentState!;

  static Future<void> pushReplacement(RouteName routeName) {
    return _navigatorState.pushReplacementNamed(routeName.name);
  }

  static void popToFirst() {
    _navigatorState.popUntil((route) => route.isFirst);
  }

  static void popUntil(RouteName routeName) {
    _navigatorState.popUntil(ModalRoute.withName(routeName.name));
  }

  static Future<void> push(RouteName routeName) {
    return _navigatorState.pushNamed(routeName.name);
  }

  static Future<void> pushScreen(Widget screen) {
    return _navigatorState.push(MaterialPageRoute(builder: (context) => screen));
  }

  static void pop() {
    _navigatorState.pop();
  }
}
