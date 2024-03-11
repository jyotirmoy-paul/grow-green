import 'package:flutter/material.dart';

enum TimeOption {
  pause(timePaceFactor: 0, iconData: Icons.pause_rounded),
  t1x(timePaceFactor: 1, iconData: Icons.play_arrow_rounded),
  t10x(timePaceFactor: 10, iconData: Icons.fast_forward_rounded),

  /// following options are only available in debug mode
  t30x(timePaceFactor: 30, iconData: Icons.double_arrow_rounded),
  t50x(timePaceFactor: 50, iconData: Icons.speed_rounded);

  final int timePaceFactor;
  final IconData iconData;

  const TimeOption({
    required this.timePaceFactor,
    required this.iconData,
  });

  static List<TimeOption> get options => [
        TimeOption.pause,
        TimeOption.t1x,
        TimeOption.t10x,
      ];
}
