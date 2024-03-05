import 'package:flutter/material.dart';

import '../utils/extensions/num_extensions.dart';

class StylizedContainer extends StatefulWidget {
  final Widget child;
  final EdgeInsets padding;
  final EdgeInsets? margin;
  final Color color;
  final bool applyColorOpacity;

  const StylizedContainer({
    Key? key,
    required this.child,
    EdgeInsets? padding,
    this.margin,
    this.applyColorOpacity = false,
    Color? color,
  })  : padding = padding ?? const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
        color = color ?? Colors.white,
        super(key: key);

  @override
  State<StylizedContainer> createState() => _StylizedContainerState();
}

class _StylizedContainerState extends State<StylizedContainer> {
  final globalKey = GlobalKey();

  Widget? sideReflectionWidget;
  Widget? topReflectionWidget;

  Widget _buildSideReflectionWidget() {
    final size = globalKey.currentContext?.size;
    if (size == null) return const SizedBox.shrink();

    return Container(
      height: size.height,
      width: size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.s),
        border: Border.all(
          color: Colors.white,
          width: 2.s,
          strokeAlign: BorderSide.strokeAlignInside,
        ),
      ),
    );
  }

  Widget _buildTopReflectionWidget() {
    final size = globalKey.currentContext?.size;
    if (size == null) return const SizedBox.shrink();

    final marginValue = 5.s;

    return Container(
      margin: EdgeInsets.all(marginValue),
      height: size.height * 0.50 - marginValue * 2,
      width: size.width - marginValue * 2,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8.s),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          topReflectionWidget = _buildTopReflectionWidget();
          sideReflectionWidget = _buildSideReflectionWidget();
        });
      }
    });
  }

  Color get bgColor {
    if (widget.applyColorOpacity) {
      if (widget.color == Colors.white) {
        return Colors.white.withOpacity(0.5);
      }

      return widget.color.withOpacity(0.9);
    }

    return widget.color;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.none,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12.s),
        border: Border.all(
          color: Colors.black,
          width: 2.s,
          strokeAlign: BorderSide.strokeAlignOutside,
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          // reflection widget
          topReflectionWidget ?? const SizedBox.shrink(),

          /// side relfection widget
          sideReflectionWidget ?? const SizedBox.shrink(),

          // child widget
          Padding(
            key: globalKey,
            padding: widget.padding,
            child: widget.child,
          ),
        ],
      ),
    );
  }
}
