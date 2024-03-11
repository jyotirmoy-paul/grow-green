import 'package:flutter/material.dart';

import '../../../../../../../../../../../utils/extensions/num_extensions.dart';
import '../../../../../../../../../../../utils/text_styles.dart';

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
        border: Border.all(color: borderColor, width: 1.s),
        borderRadius: BorderRadius.circular(size.height * 0.3),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyles.s26,
      ),
    );
  }
}
