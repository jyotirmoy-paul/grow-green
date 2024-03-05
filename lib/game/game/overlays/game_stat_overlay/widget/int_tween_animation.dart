import 'package:flutter/material.dart';

class IntTweenAnimation extends StatefulWidget {
  final int value;
  final Duration duration;
  final Widget Function(BuildContext context, int value) builder;

  const IntTweenAnimation({
    Key? key,
    required this.value,
    required this.builder,
    this.duration = const Duration(seconds: 1),
  }) : super(key: key);

  @override
  State<IntTweenAnimation> createState() => _IntTweenAnimationState();
}

class _IntTweenAnimationState extends State<IntTweenAnimation> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<int> _animation;
  int _lastValue = 0;

  void _buildAnimation() {
    _animation = IntTween(begin: _lastValue, end: widget.value).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  void _prepraeAnimation() {
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _buildAnimation();
    _controller.forward();
    _lastValue = widget.value;
  }

  @override
  void initState() {
    super.initState();
    _prepraeAnimation();
  }

  void _reStartAnimation() {
    _controller.reset();
    _buildAnimation();
    _controller.forward();
    _lastValue = widget.value;
  }

  @override
  void didUpdateWidget(IntTweenAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.value != _lastValue) {
      _reStartAnimation();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return widget.builder(context, _animation.value);
      },
    );
  }
}
