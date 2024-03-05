import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../../../utils/extensions/num_extensions.dart';
import '../../../../../../widgets/stylized_container.dart';
import '../../../../services/game_services/time/time_service.dart';
import 'clock_painters.dart';

class GameClock extends StatefulWidget {
  final Size size;

  const GameClock({
    super.key,
    this.size = const Size(100, 100),
  });

  @override
  State<GameClock> createState() => _GameClockState();
}

class _GameClockState extends State<GameClock> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  StreamSubscription? _timePaceListener;

  Duration _getClockAnimationDurationFromTimePace(int timePace) {
    return Duration(milliseconds: 1000 ~/ timePace);
  }

  void init() {
    /// init animation
    _controller = AnimationController(
      vsync: this,
      duration: _getClockAnimationDurationFromTimePace(TimeService().timePace),
    )..repeat();

    /// listen for time pace changes
    _timePaceListener = TimeService().timePaceStream.listen((timePace) {
      if (timePace == 0) {
        _controller.stop();
      } else {
        _controller.duration = _getClockAnimationDurationFromTimePace(timePace);
        _controller.repeat();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    _controller.dispose();
    _timePaceListener?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size.width,
      height: widget.size.height,
      child: StylizedContainer(
        color: Colors.black,
        padding: EdgeInsets.all(8.s),
        margin: EdgeInsets.zero,
        child: Stack(
          children: [
            /// background
            Positioned.fill(
              key: const ValueKey('time-indicator'),
              child: CustomPaint(
                size: widget.size,
                painter: TimeIndicatorPainter(
                  lineLength: 8.s,
                  specialHourStrokeWidth: 5.s,
                  regularHourStrokeWidth: 2.s,
                  specialHourColor: Colors.white,
                  regularHourColor: Colors.white,
                ),
              ),
            ),

            /// main clock
            Positioned.fill(
              key: const ValueKey('clock-hand'),
              child: RepaintBoundary(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: ClockHandPainter(
                        value: _controller.value,
                        handLength: 12.s,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
