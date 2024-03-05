import 'package:flutter/material.dart';
import 'package:growgreen/utils/utils.dart';

import '../utils/extensions/num_extensions.dart';

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

  factory ShadowedContainer.preset({
    required Widget child,
  }) {
    return ShadowedContainer(
      padding: EdgeInsets.symmetric(horizontal: 6.s, vertical: 12.s),
      shadowOffset: Offset(6.s, 6.s),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(12.s),
        border: Border.all(
          color: Utils.lightenColor(Colors.white24),
          width: 2.s,
        ),
      ),
      child: child,
    );
  }

  @override
  State<ShadowedContainer> createState() => _ShadowedContainerState();
}

class _ShadowedContainerState extends State<ShadowedContainer> {
  final globalKey = GlobalKey();

  Widget? shadowContainer;

  void _prepareShadow(Duration _) {
    final size = globalKey.currentContext?.size;
    if (size == null) return;

    setState(
      () {
        shadowContainer = Container(
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(
              // borderRadius: widget.decoration?.borderRadius,
              // color: Colors.black,

              ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_prepareShadow);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: widget.clipBehavior,
      padding: widget.padding,
      margin: widget.margin,
      width: widget.width,
      height: widget.height,
      decoration: widget.decoration,
      key: globalKey,
      child: widget.child,
    );
  }
}
