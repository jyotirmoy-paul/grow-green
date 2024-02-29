import 'package:flutter/material.dart';

import '../../../../../../../../utils/extensions/num_extensions.dart';
import '../../../../../../../../utils/utils.dart';
import '../../../../../../../../widgets/shadowed_container.dart';

class MenuItemSkeleton extends StatelessWidget {
  final Color bgColor;
  final double width;

  final Widget? header;
  final Widget body;
  final Widget footer;

  const MenuItemSkeleton({
    super.key,
    this.bgColor = Colors.green,
    this.width = 380.0,
    this.header,
    this.body = const SizedBox.shrink(),
    this.footer = const SizedBox.shrink(),
  });

  @override
  Widget build(BuildContext context) {
    return ShadowedContainer(
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.s),
        color: bgColor,
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
                border: Border(
                  bottom: BorderSide(
                    color: Utils.lightenColor(bgColor, 0.4),
                    width: 3.s,
                  ),
                ),
              ),
              child: header,
            ),
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
