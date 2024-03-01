import 'package:flutter/material.dart';

class FadingWidget extends StatefulWidget {
  final String id;
  final Widget child;
  final Duration showDuration;
  final Duration fadeDuration;
  final void Function(String) onFinish;

  FadingWidget({
    required this.id,
    required this.child,
    required this.onFinish,
    this.showDuration = const Duration(seconds: 3),
    this.fadeDuration = const Duration(milliseconds: 300),
  }) : super(key: ValueKey(id));

  @override
  State<FadingWidget> createState() => _FadingWidgetState();
}

class _FadingWidgetState extends State<FadingWidget> with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacityAnimation;

  void _initAnimation() {
    _controller = AnimationController(vsync: this, duration: widget.fadeDuration);
    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );
  }

  void _initControl() async {
    /// wait till show duration is over
    await Future.delayed(widget.showDuration);

    /// do the animation, only if the widget is still available
    if (mounted) {
      await _controller.forward();
    }

    widget.onFinish(widget.id);
  }

  @override
  void initState() {
    super.initState();
    _initAnimation();
    _initControl();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: widget.child,
    );
  }
}
