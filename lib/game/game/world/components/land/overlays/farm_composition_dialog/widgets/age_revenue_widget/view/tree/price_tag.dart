import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

class PriceTag extends StatelessWidget {
  final String text;
  final Size size;
  final Color borderColor;
  final Color? backgroundColor;
  final Color textColor;

  const PriceTag({
    Key? key,
    required this.text,
    required this.size,
    this.borderColor = Colors.white,
    this.backgroundColor,
    this.textColor = Colors.white,
  }) : super(key: key);

  Color get _backgroundColor => backgroundColor ?? Colors.white24;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width * 0.8,
      height: size.height,
      decoration: BoxDecoration(
        color: _backgroundColor,
        shape: BoxShape.rectangle,
        border: Border.all(color: borderColor, width: size.width * 0.03),
        borderRadius: BorderRadius.circular(size.height * 0.3),
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          border: Border.all(
            color: _backgroundColor.darken(0.5),
            width: size.width * 0.06,
          ),
          borderRadius: BorderRadius.circular(size.height * 0.3),
        ),
        child: Center(
          child: Text(
            text,
            maxLines: 1,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: size.height * 0.25, // Adjust font size according to your size
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
