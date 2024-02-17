import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../services/time/time_service.dart';
import 'clock_painters.dart';

class AbstractClock extends StatefulWidget {
  final Size size;

  const AbstractClock({
    super.key,
    this.size = const Size(100, 100),
  });

  @override
  State<AbstractClock> createState() => _AbstractClockState();
}

class _AbstractClockState extends State<AbstractClock> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  StreamSubscription? _timePaceListener;

  void init() {
    /// init animation
    _controller = AnimationController(
      vsync: this,
      duration: TimeService().currentPeriod,
    )..repeat();

    /// listen for time pace changes
    _timePaceListener = TimeService().timePaceStream.listen((timePace) {
      /// change pace
      _controller.duration = TimeService().currentPeriod;
      _controller.repeat();
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
    return Container(
      width: widget.size.width,
      height: widget.size.height,
      decoration: const BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle,
      ),
      padding: EdgeInsets.all(widget.size.width * 0.10),
      child: Stack(
        children: [
          /// background
          Positioned.fill(
            child: CustomPaint(
              size: widget.size,
              painter: TimeIndicatorPainter(
                lineLength: widget.size.width * 0.1,
              ),
            ),
          ),

          /// main clock
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  painter: ClockPainter(
                    handLength: widget.size.width * 0.2,
                    value: _controller.value,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
