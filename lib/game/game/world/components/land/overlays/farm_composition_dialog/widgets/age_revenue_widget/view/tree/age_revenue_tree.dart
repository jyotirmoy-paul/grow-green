import 'package:flutter/material.dart';

import '../../../../../../../../../../../utils/extensions/num_extensions.dart';
import '../tree/age_tag.dart';
import 'price_tag.dart';

enum TopImageFooterShape{rhombus,circle}
class AgeRevenueTree extends StatelessWidget {
  final String? topImagePath;
  final String? topImageFooter;
  final TopImageFooterShape topImageFooterShape;
  final List<String> rootTitles;
  final Color? rootTitleColor;
  final Size size;
  

  const AgeRevenueTree({
    super.key,
    this.topImagePath,
    this.topImageFooter,
    this.topImageFooterShape = TopImageFooterShape.rhombus,
    required this.rootTitles,
    required this.size,
    this.rootTitleColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: size,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildTopImage,
          _buildTopImageFooter,
          ..._buildRootTitles,
        ],
      ),
    );
  }

  Widget get _buildTopImage {
    final imageSize = Size(size.width, size.height * 0.2);
    if (topImagePath == null) return SizedBox.fromSize(size: imageSize);
    return Image.asset(
      topImagePath!,
      fit: BoxFit.contain,
      width: imageSize.width,
      height: imageSize.height,
    );
  }

  Widget get _buildTopImageFooter {
    final footerSize = Size(size.width, size.height * 0.1);
    return SizedBox.fromSize(
      size: footerSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            color: Colors.brown,
            width: size.width,
            height: 2.s,
          ),
          AgeTag(
            title: topImageFooter,
            size: footerSize,
            shape : topImageFooterShape,
          )
        ],
      ),
    );
  }

  List<Widget> get _buildRootTitles {
    final rootTilesTotalHeight = size.height * 0.7;
    final rootTileHeight = rootTilesTotalHeight / rootTitles.length;
    return rootTitles
        .map(
          (title) => _buildRootTitle(
            title: title,
            size: Size(size.width, rootTileHeight),
          ),
        )
        .expand(
          (element) => element,
        )
        .toList();
  }

  List<Widget> _buildRootTitle({required String title, required Size size}) {
    final line = Container(
      height: size.height * 0.2,
      width: 2,
      color: Colors.brown,
    );
    final priceTag = PriceTag(
      text: title,
      size: Size(size.width, size.height * 0.8),
      backgroundColor: rootTitleColor,
    );
    return [line, priceTag];
  }
}
