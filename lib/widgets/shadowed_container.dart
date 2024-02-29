import 'package:flutter/material.dart';

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
            borderRadius: widget.decoration?.borderRadius,
            color: Colors.black,
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
    return Stack(
      clipBehavior: Clip.none,
      children: [
        /// shadow illusion
        Transform.translate(
          offset: widget.shadowOffset,
          child: shadowContainer ?? const SizedBox.shrink(),
        ),

        /// main child
        Container(
          clipBehavior: widget.clipBehavior,
          padding: widget.padding,
          margin: widget.margin,
          width: widget.width,
          height: widget.height,
          decoration: widget.decoration,
          key: globalKey,
          child: widget.child,
        ),
      ],
    );
  }
}
