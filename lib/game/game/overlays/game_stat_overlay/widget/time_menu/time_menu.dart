import 'package:flutter/material.dart';

import '../../../../../../services/log/log.dart';
import '../../../../services/game_services/time/time_service.dart';
import 'abstract_clock.dart';

/// TODO: Refactor this class to use BLoC
class TimeMenu extends StatefulWidget {
  const TimeMenu({super.key});

  @override
  State<TimeMenu> createState() => _TimeMenuState();
}

class _TimeMenuState extends State<TimeMenu> with TickerProviderStateMixin {
  static const tag = '_TimeMenuState';

  double firstButtonPosition = 0.0;
  double buttonPositionOffset = 0.0;

  final timeSpeedUpSetting = <int>[
    1,
    10,
    30,
  ];

  final buttons = <IconData>[
    Icons.play_arrow_rounded,
    Icons.fast_forward_rounded,
    Icons.speed_rounded,
  ];

  final _animationControllers = <AnimationController>[];
  final _animations = <Animation<double>>[];

  void _initAnimators() {
    for (int i = 0; i < buttons.length; i++) {
      _animationControllers.add(
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 280),
          reverseDuration: const Duration(milliseconds: 180),
        ),
      );
    }

    for (int i = 0; i < _animationControllers.length; i++) {
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

  bool _isInitialized = false;

  void _init() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final height = MediaQuery.of(context).size.height;

      /// populate button position & offsets
      firstButtonPosition = height * 0.10;
      buttonPositionOffset = height * 0.07;

      _initAnimators();

      setState(() {
        _isInitialized = true;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  Widget _buildIconButton({
    required IconData icon,
    VoidCallback? onTap,
    bool isSelected = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.black,
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          icon,
          color: isSelected ? Colors.grey : Colors.white,
          size: 30.0,
        ),
      ),
    );
  }

  bool _buttonsAreShown = false;
  bool _buttonsAnimating = false;

  void _onTimeMenuTap() async {
    Log.i('$tag: _onTimeMenuTap');

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
  }

  void _onIconButtonTap(int index) {
    Log.i('$tag: on icon button tap: $index');

    /// TODO: refactor this to use enum
    if (index == 0) {
      TimeService().timePace = 1;
    } else if (index == 1) {
      TimeService().timePace = 10;
    } else if (index == 2) {
      TimeService().timePace = 30;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) return const SizedBox.shrink();

    return Container(
      height: firstButtonPosition + buttonPositionOffset * buttons.length,
      margin: const EdgeInsets.all(24.0),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          /// children
          ...buttons.asMap().entries.map((entry) {
            final index = entry.key;
            final buttonIcon = entry.value;

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
                  stream: TimeService().timePaceStream,
                  builder: (context, timePace) {
                    bool isSelected = false;

                    if (timePace.data == 1 && index == 0) {
                      isSelected = true;
                    } else if (timePace.data == 5 && index == 1) {
                      isSelected = true;
                    } else if (timePace.data == 10 && index == 2) {
                      isSelected = true;
                    }

                    return _buildIconButton(
                      icon: buttonIcon,
                      onTap: () => _onIconButtonTap(index),
                      isSelected: isSelected,
                    );
                  }),
            );
          }).toList(),

          /// clock
          GestureDetector(
            onTap: _onTimeMenuTap,
            child: const AbstractClock(
              size: Size.square(70.0),
            ),
          ),
        ],
      ),
    );
  }
}
