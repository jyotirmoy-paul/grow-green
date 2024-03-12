import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../../../../../utils/extensions/list_extensions.dart';
import '../../../../../../../../../utils/extensions/num_extensions.dart';
import '../../../../../../../../../utils/text_styles.dart';
import '../../../../../../../../utils/game_assets.dart';
import '../../../../../../../services/game_services/monetary/models/money_model.dart';
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

  final Size size = Size(400.s, 150.s);
  final double cropAssetHeight = 60.s;
  double get cropAssetWidth => cropAssetHeight * 0.4;

  final double revenueRowHeight = 40.s;
  final double intervalHangerWidth = 120.s;
  final double hBarSpaceRatio = 0.1;

  CropRevenueDataFetcher get dataFetcher => CropRevenueDataFetcher(cropType: cropType);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        revenueRow,
        Gap(2.s),
        intervalHanger,
      ],
    );
  }

  Widget get revenueRow {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        revenueWidget(
          label: MoneyModel(value: dataFetcher.costPerUnitSeed).formattedValue,
          assetPath: GameAssets.minus,
        ),
        SizedBox(
          width: intervalHangerWidth * (1 + 4 * hBarSpaceRatio),
          child: Container(height: 2, color: Colors.white),
        ),
        revenueWidget(
          label: MoneyModel(value: dataFetcher.revenuePerKgSeedSown).formattedValue,
          assetPath: GameAssets.plus,
        ),
      ],
    );
  }

  Widget get intervalHanger {
    var intervals = CropRevenueDataFetcher(
      cropType: cropType,
    ).intervals.map((interval) => intervalWidget(interval)).addSeparator(Gap(4.s));

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: intervals,
    );
  }

  Widget intervalWidget(String intervalLabel) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor.darken(0.3),
        borderRadius: BorderRadius.circular(10.s),
        border: Border.all(color: Colors.white, width: 1.s),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.s, vertical: 8.s),
      child: Text(
        intervalLabel.toUpperCase(),
        style: TextStyles.s24,
      ),
    );
  }

  Widget revenueWidget({required String label, required String assetPath}) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor.darken(0.3),
        borderRadius: BorderRadius.circular(10.s),
        border: Border.all(color: Colors.white, width: 1.s),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10.s, vertical: 4.s),
      child: FittedBox(
        child: Row(
          children: [
            Image.asset(
              assetPath,
              width: 30.s,
              height: 30.s,
              fit: BoxFit.contain,
            ),
            Gap(5.s),
            Text(
              label,
              style: TextStyles.s24,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
