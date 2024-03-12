part of 'app_routes.dart';

class _FadePageRouteBuilder<T> extends PageRoute<T> {
  final Widget child;

  _FadePageRouteBuilder({
    super.settings,
    required this.child,
  });

  @override
  Color get barrierColor => Colors.black;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return child;
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
}
