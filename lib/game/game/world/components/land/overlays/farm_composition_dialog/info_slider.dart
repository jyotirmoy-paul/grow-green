import 'package:flutter/material.dart';

import '../../../../../../../utils/extensions/num_extensions.dart';
import '../../../../../../../utils/text_styles.dart';

class InfoSlider2 extends StatefulWidget {
  final double? height;
  final double? width;
  final Point min;
  final Point max;

  const InfoSlider2({
    required this.height,
    required this.width,
    required this.min,
    required this.max,
    super.key,
  });

  @override
  State<InfoSlider2> createState() => _InfoSlider2State();
}

class Point {
  final double x;
  final double y;

  const Point(this.x, this.y);
}

class _InfoSlider2State extends State<InfoSlider2> {
  final kDefaultSliderHeight = 100.s;
  final kDefaultSliderWidth = 300.s;

  double get _height => widget.height ?? kDefaultSliderHeight;
  double get _width => widget.width ?? kDefaultSliderWidth;

  double get _trackHeight => _height * 0.1;
  double get _trackWidth => _width - _thumbHeight;
  double get _thumbHeight => _height * 0.5;

  double get _pointXFromTrackFraction => widget.min.x + (widget.max.x - widget.min.x) * getPartitionTrackFraction;

  double _thumbPosX = 0;

  double get getPartitionTrackFraction => widget.min.x / widget.max.x;

  @override
  void initState() {
    super.initState();
    _thumbPosX = getThumbPosFromTrackFraction(getPartitionTrackFraction);
  }

  double getThumbPosFromTrackFraction(double fraction) {
    return _trackWidth * fraction;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _height,
      width: _width,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          _getSliderTrack,
          Positioned(left: _thumbPosX, top: _trackHeight / 2, child: _getThumb),
        ],
      ),
    );
  }

  Widget get _getSliderTrack {
    return GestureDetector(
      onPanStart: (details) {
        if (details.localPosition.dx < 0 || details.localPosition.dx > _trackWidth) return;
        _updateThumbPos(details.localPosition.dx);
      },
      onPanUpdate: (details) {
        if (details.localPosition.dx < 0 || details.localPosition.dx > _trackWidth) return;
        _updateThumbPos(details.localPosition.dx);
      },
      child: Container(
        height: _trackHeight + _thumbHeight,
        width: _trackWidth,
        color: Colors.transparent,
        alignment: Alignment.topCenter,
        child: Container(
          height: _trackHeight,
          width: _trackWidth,
          alignment: Alignment.centerRight,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.s),
            border: Border.all(
              color: Colors.black,
              width: 2.s,
              strokeAlign: BorderSide.strokeAlignOutside,
            ),
          ),
          child: Container(
            height: _trackHeight,
            width: _trackWidth * (1 - getPartitionTrackFraction),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.yellow, Colors.green],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(10.s),
            ),
          ),
        ),
      ),
    );
  }

  void _updateThumbPos(double dx) {
    if (dx < 0 || dx > _trackWidth) return;
    setState(() => _thumbPosX = dx);
  }

  Widget get _getThumb {
    return GestureDetector(
      onPanUpdate: (details) {
        _updateThumbPos(_thumbPosX + details.delta.dx);
      },
      child: Container(
        height: _thumbHeight,
        width: _thumbHeight,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/button/game_indicator_button.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: FractionallySizedBox(
          widthFactor: 0.5,
          heightFactor: 0.5,
          child: FittedBox(
            child: Text(
              "50",
              style: TextStyles.s18,
            ),
          ),
        ),
      ),
    );
  }
}
