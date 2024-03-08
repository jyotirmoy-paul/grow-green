import 'package:flutter/material.dart';

import '../../../../../../../../utils/extensions/num_extensions.dart';

class MenuImage extends StatelessWidget {
  final String imageAssetPath;
  final double? dimension;
  final double? blurRadius;
  final Color? blurColor;
  final BoxShape shape;
  const MenuImage({
    super.key,
    required this.imageAssetPath,
    this.dimension,
    this.blurRadius,
    this.blurColor,
    this.shape = BoxShape.rectangle,
  });

  double get _dimension => dimension ?? 150.s;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _dimension,
      height: _dimension,
      decoration: BoxDecoration(
        color: Colors.white12,
        shape: shape,
        borderRadius: shape == BoxShape.rectangle ? BorderRadius.circular(20.s) : null,
        border: Border.all(
          color: Colors.white.withOpacity(0.5),
          width: 2.s,
        ),
      ),
      padding: EdgeInsets.all(_dimension * 0.1),
      child: Image.asset(
        imageAssetPath,
        height: _dimension,
        width: _dimension,
        fit: BoxFit.contain,
      ),
    );
  }
}
