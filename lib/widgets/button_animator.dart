import 'package:flutter/material.dart';

import '../services/audio/audio_service.dart';
import '../utils/constants.dart';

class ButtonAnimator extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;

  ButtonAnimator({
    Key? key,
    required this.child,
    this.onPressed,
  }) : super(key: key);

  final _buttonPressedVn = ValueNotifier<bool>(false);

  void _animate() {
    _buttonPressedVn.value = true;
  }

  Future<void> _reverseAnimate() async {
    await Future.delayed(kMS50);
    _buttonPressedVn.value = false;
  }

  void _onPressConfirm() {
    AudioService().tap();
    onPressed?.call();
  }

  void _onTapUp() async {
    await _reverseAnimate();
    _onPressConfirm();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => _animate(),
        onTapUp: (_) => _onTapUp(),
        onTapCancel: _reverseAnimate,
        child: ValueListenableBuilder(
          valueListenable: _buttonPressedVn,
          child: child,
          builder: (_, bool isPressed, Widget? child) {
            return AnimatedScale(
              scale: isPressed ? 0.92 : 1.0,
              curve: isPressed ? Curves.linear : Curves.elasticOut,
              duration: isPressed ? kMS50 : kMS300,
              child: child,
            );
          },
        ),
      ),
    );
  }
}
