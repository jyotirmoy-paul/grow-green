import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../../../../../utils/extensions/num_extensions.dart';
import '../../../../../../../../../utils/text_styles.dart';
import '../../../../../../../../../widgets/stylized_text.dart';
import '../../../../../../../../utils/game_icons.dart';
import '../../../../components/farm/components/crop/enums/crop_type.dart';
import 'crop_revenue_data_fetcher.dart';

class CropRevenueWidget extends StatelessWidget {
  final CropType cropType;
  final Color bgColor;

  CropRevenueWidget({
    super.key,
    required this.cropType,
    this.bgColor = Colors.transparent,
  });

  final Size size = Size(270.s, 150.s);
  final double cropAssetHeight = 60.s;
  double get cropAssetWidth => cropAssetHeight * 0.4;

  final double revenueRowHeight = 40.s;
  final double intervalHangerWidth = 100.s;
  final double hBarSpaceRatio = 0.1;

  CropRevenueDataFetcher get dataFetcher => CropRevenueDataFetcher(cropType: cropType);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.fromSize(
        size: size,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Positioned(
                  top: cropAssetHeight - revenueRowHeight / 2,
                  width: size.width,
                  child: Center(child: revenueRow),
                ),
                Center(child: intervalHanger),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget get revenueRow {
    return SizedBox(
      height: revenueRowHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          revenueWidget(label: dataFetcher.costPerUnitSeed.toString(), assetPath: GameIcons.minus),
          SizedBox(
            width: intervalHangerWidth * (1 + 4 * hBarSpaceRatio),
            child: Container(height: 2, color: Colors.white),
          ),
          revenueWidget(label: dataFetcher.revenuePerKgSeedSown.toString(), assetPath: GameIcons.plus),
        ],
      ),
    );
  }

  Widget cropAsset(String assetPath) {
    return SizedBox.fromSize(
      size: Size(cropAssetWidth, cropAssetHeight),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Image.asset(
          assetPath,
          fit: BoxFit.fill,
          width: cropAssetWidth,
        ),
      ),
    );
  }

  Widget get cropHanger {
    const prefix = "assets/images/";
    return SizedBox(
      width: intervalHangerWidth + cropAssetWidth,
      height: cropAssetHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          cropAsset(prefix + dataFetcher.germinationAssetPath),
          cropAsset(prefix + dataFetcher.ripeAssetPath),
        ],
      ),
    );
  }

  Widget get intervalHanger {
    var intervals = CropRevenueDataFetcher(cropType: cropType)
        .intervals
        .map(
          (interval) => intervalWidget(interval),
        )
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [cropHanger, ...intervals],
    );
  }

  Widget intervalWidget(String intervalLabel) {
    return SizedBox(
      width: intervalHangerWidth * (1 + 2 * hBarSpaceRatio),
      child: Column(
        children: [
          SizedBox(
            height: 15.s,
            width: intervalHangerWidth,
            child: Container(
              decoration: BoxDecoration(
                border: Border.symmetric(vertical: BorderSide(color: Colors.white, width: 2.s)),
              ),
            ),
          ),
          Container(
            height: 30.s,
            decoration: BoxDecoration(
              color: bgColor.darken(0.3),
              borderRadius: BorderRadius.circular(10.s),
              border: Border.all(color: Colors.white, width: 1.s),
            ),
            child: Center(
              child: StylizedText(
                text: Text(
                  intervalLabel.toUpperCase(),
                  style: TextStyles.s18,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget get hangerBarVertical {
    return Container(
      width: 2.s,
      height: 10.s,
      color: Colors.white,
    );
  }

  Widget revenueWidget({required String label, required String assetPath}) {
    return Container(
      height: 30.s,
      width: intervalHangerWidth * (1 - 4 * hBarSpaceRatio),
      decoration: BoxDecoration(
        color: bgColor.darken(0.3),
        borderRadius: BorderRadius.circular(10.s),
        border: Border.all(color: Colors.white, width: 1.s),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10.s),
      child: FittedBox(
        child: Row(
          children: [
            Image.asset(
              assetPath,
              width: 10.s,
              height: 10.s,
              fit: BoxFit.contain,
            ),
            Gap(5.s),
            FittedBox(
              child: StylizedText(
                text: Text(
                  label,
                  style: TextStyles.s14,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
