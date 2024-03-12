part of 'app_routes.dart';

class _FadePageRouteBuilder<T> extends PageRoute<T> {
  final Widget child;

  _FadePageRouteBuilder({
    super.settings,
    required this.child,
  });

  @override
  Color get barrierColor => Colors.transparent;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => kMS500;
}
