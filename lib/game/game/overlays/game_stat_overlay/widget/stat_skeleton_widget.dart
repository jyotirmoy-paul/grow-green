import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../utils/extensions/num_extensions.dart';
import '../../../../../widgets/stylized_container.dart';

enum StatSkeletonImageAlignment {
  left,
  right,
}

class StatSkeletonWidget extends StatelessWidget {
  final double width;
  final Widget child;
  final String iconAsset;
  final StatSkeletonImageAlignment imageAlignment;

  const StatSkeletonWidget({
    super.key,
    required this.width,
    required this.child,
    required this.iconAsset,
    this.imageAlignment = StatSkeletonImageAlignment.right,
  });

  Widget get image {
    return Transform.scale(
      scale: 1.25,
      alignment: () {
        switch (imageAlignment) {
          case StatSkeletonImageAlignment.left:
            return Alignment.centerRight;

          case StatSkeletonImageAlignment.right:
            return Alignment.centerLeft;
        }
      }(),
      child: StylizedContainer(
        color: Colors.black,
        margin: EdgeInsets.zero,
        padding: EdgeInsets.all(7.s),
        child: Image.asset(
          iconAsset,
          width: 40.s,
          height: 40.s,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 12.5.s),
      child: SizedBox(
        width: width,
        height: 50.s,
        child: StylizedContainer(
          color: Colors.black.withOpacity(0.3),
          padding: EdgeInsets.symmetric(horizontal: 8.s),
          margin: EdgeInsets.zero,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Gap(4.s),

                /// image
                if (imageAlignment == StatSkeletonImageAlignment.left) image,
                if (imageAlignment == StatSkeletonImageAlignment.left) Gap(4.s),

                /// calender
                Expanded(child: child),

                /// image
                if (imageAlignment == StatSkeletonImageAlignment.right) Gap(4.s),
                if (imageAlignment == StatSkeletonImageAlignment.right) image,

                Gap(4.s),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
