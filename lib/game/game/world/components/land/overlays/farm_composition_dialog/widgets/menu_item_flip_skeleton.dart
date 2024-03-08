import 'package:flutter/material.dart';

import '../../../../../../../../utils/extensions/num_extensions.dart';
import '../../../../../../../../utils/utils.dart';
import '../../../../../../../../widgets/flip_card/flip_card.dart';
import '../../../../../../../../widgets/flip_card/flip_card_controller.dart';
import '../../../../../../../../widgets/shadowed_container.dart';

class MenuItemFlipSkeleton extends StatelessWidget {
  final Color bgColor;
  final double width;

  final Widget? header;
  final Widget body;
  final Widget footer;

  final Widget? backHeader;
  final Widget backBody;
  final Widget backFooter;

  final FlipCardController? flipCardController;
  const MenuItemFlipSkeleton({
    super.key,
    this.bgColor = Colors.green,
    this.width = 380.0,
    this.header,
    this.body = const SizedBox.shrink(),
    this.footer = const SizedBox.shrink(),
    this.backHeader = const SizedBox.shrink(),
    this.backBody = const SizedBox.shrink(),
    this.backFooter = const SizedBox.shrink(),
    this.flipCardController,
  });

  @override
  Widget build(BuildContext context) {
    return FlipCard(
      flipOnTouch: false,
      front: front,
      back: back,
      controller: flipCardController,
    );
  }

  Widget get front {
    return MenuItemSkeleton(width: width, bgColor: bgColor, header: header, body: body, footer: footer);
  }

  Widget get back {
    return MenuItemSkeleton(width: width, bgColor: bgColor, header: backHeader, body: backBody, footer: backFooter);
  }
}

class MenuItemSkeleton extends StatelessWidget {
  const MenuItemSkeleton({
    super.key,
    required this.width,
    required this.bgColor,
    required this.header,
    required this.body,
    required this.footer,
  });

  final double width;
  final Color bgColor;
  final Widget? header;
  final Widget body;
  final Widget footer;

  @override
  Widget build(BuildContext context) {
    return ShadowedContainer(
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.s),
        color: bgColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 10.s,
            blurRadius: 10.s,
            blurStyle: BlurStyle.outer,
          ),
        ],
      ),
      shadowOffset: Offset(10.s, 10.s),
      child: Column(
        children: [
          /// header
          Expanded(
            child: Container(
              padding: EdgeInsets.all(12.s),
              decoration: BoxDecoration(
                color: Utils.darkenColor(bgColor, 0.2),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12.0),
                ),
                // border: Border(
              ),
              child: header,
            ),
          ),

          Container(
            height: 3.s,
            color: Utils.lightenColor(bgColor, 0.4),
          ),

          /// body
          Expanded(
            flex: 4,
            child: body,
          ),

          /// gap
          Container(
            height: 6.s,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(width: 2.s, color: Colors.black.withOpacity(0.7)),
                bottom: BorderSide(width: 2.s, color: Utils.lightenColor(bgColor, 0.4)),
              ),
            ),
          ),

          /// footer
          Expanded(
            child: footer,
          ),
        ],
      ),
    );
  }
}
