import 'package:flutter/material.dart';

/// FIXME: Revisit the usage of this shadowed container
class ShadowedContainer extends StatefulWidget {
  final Widget child;
  final Clip clipBehavior;
  final BoxDecoration? decoration;
  final double? width;
  final double? height;
  final Offset shadowOffset;
  final EdgeInsets? padding;
  final EdgeInsets? margin;

  const ShadowedContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.decoration,
    this.clipBehavior = Clip.none,
    this.shadowOffset = const Offset(10.0, 10.0),
    this.padding,
    this.margin,
  });

  @override
  State<ShadowedContainer> createState() => _ShadowedContainerState();
}

class _ShadowedContainerState extends State<ShadowedContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: widget.clipBehavior,
      padding: widget.padding,
      margin: widget.margin,
      width: widget.width,
      height: widget.height,
      decoration: widget.decoration,
      child: widget.child,
    );
  }
}
