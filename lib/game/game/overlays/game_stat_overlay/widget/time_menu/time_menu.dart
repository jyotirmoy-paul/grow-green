import 'package:flutter/material.dart';

import '../../../../../../services/log/log.dart';
import '../../../../../../utils/extensions/num_extensions.dart';
import '../../../../../../utils/text_styles.dart';
import '../../../../../../widgets/button_animator.dart';
import '../../../../../../widgets/stylized_container.dart';
import '../../../../../../widgets/stylized_text.dart';
import '../../../../services/game_services/time/time_service.dart';
import '../../enum/time_option.dart';
import 'game_clock.dart';

class TimeMenu extends StatefulWidget {
  const TimeMenu({super.key});

  @override
  State<TimeMenu> createState() => _TimeMenuState();
}

class _TimeMenuState extends State<TimeMenu> with TickerProviderStateMixin {
  final double clockSize = 75.s;
  final double buttonSize = 48.s;
  late final double buttonPositionOffset = buttonSize * 1.50;
  late final double firstButtonPosition = clockSize - buttonSize + buttonPositionOffset;

  final _animationControllers = <AnimationController>[];
  final _animations = <Animation<double>>[];

  void _initAnimators() {
    for (int i = 0; i < TimeOption.options.length; i++) {
      _animationControllers.add(
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 280),
          reverseDuration: const Duration(milliseconds: 180),
        ),
      );

      _animations.add(
        Tween<double>(begin: 0.0, end: firstButtonPosition + i * buttonPositionOffset).animate(
          CurvedAnimation(
            parent: _animationControllers[i],
            curve: Curves.easeOutQuint,
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _initAnimators();
  }

  bool _buttonsAreShown = false;
  bool _buttonsAnimating = false;
  bool _hideButtons = true;

  void _onTimeMenuTap() async {
    /// if buttons are hidden, show them
    if (_hideButtons == true) {
      setState(() {
        _hideButtons = false;
      });
    }

    /// ignore taps, if buttons are already animating
    if (_buttonsAnimating) return;
    _buttonsAnimating = true;

    /// take action
    if (_buttonsAreShown) {
      /// hide buttons
      for (final ac in _animationControllers) {
        await ac.reverse();
      }
    } else {
      /// show all the buttons
      for (final ac in _animationControllers) {
        await ac.forward();
      }
    }

    /// revert state
    _buttonsAreShown = !_buttonsAreShown;
    _buttonsAnimating = false;

    /// on reverse animation complete, if hide buttons was false, let's hide all the buttons
    if (_hideButtons == false && !_buttonsAreShown) {
      setState(() {
        _hideButtons = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: firstButtonPosition + buttonPositionOffset * TimeOption.options.length,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          ...(_hideButtons
              ? const []
              : TimeOption.options.asMap().entries.map(
                  (entry) {
                    final index = entry.key;
                    final timeOption = entry.value;

                    return AnimatedBuilder(
                      animation: _animationControllers[index],
                      builder: (_, child) {
                        return Transform.translate(
                          transformHitTests: true,
                          offset: Offset(0.0, _animations[index].value),
                          child: child,
                        );
                      },
                      child: StreamBuilder<int>(
                        initialData: TimeService().timePace,
                        stream: TimeService().timePaceStream,
                        builder: (context, timePace) {
                          return TimeOptionButton(
                            key: ValueKey(timeOption),
                            size: buttonSize,
                            timeOption: timeOption,
                            isSelected: timeOption.timePaceFactor == timePace.data,
                          );
                        },
                      ),
                    );
                  },
                )),

          /// clock
          ButtonAnimator(
            onPressed: _onTimeMenuTap,
            child: GameClock(size: Size.square(clockSize)),
          ),
        ],
      ),
    );
  }
}

class TimeOptionButton extends StatelessWidget {
  static const tag = 'TimeOptionButton';

  final double size;
  final TimeOption timeOption;
  final IconData icon;
  final bool isSelected;

  TimeOptionButton({
    super.key,
    required this.size,
    required this.timeOption,
    required this.isSelected,
  }) : icon = timeOption.iconData;

  /// update time pace factor
  void _onTap() {
    if (isSelected) return;

    Log.i('$tag: on time factor update to option: $timeOption');
    TimeService().timePace = timeOption.timePaceFactor;
  }

  @override
  Widget build(BuildContext context) {
    return ButtonAnimator(
      onPressed: _onTap,
      child: SizedBox.square(
        dimension: size,
        child: StylizedContainer(
          color: isSelected ? Colors.greenAccent : Colors.white.withOpacity(0.50),
          padding: EdgeInsets.zero,
          margin: EdgeInsets.zero,
          child: Center(
            child: StylizedText(
              text: Text(
                String.fromCharCode(icon.codePoint),
                style: TextStyles.s32.copyWith(fontFamily: icon.fontFamily),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
