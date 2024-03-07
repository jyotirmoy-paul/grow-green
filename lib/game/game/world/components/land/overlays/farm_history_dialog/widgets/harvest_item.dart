import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../../../../utils/extensions/num_extensions.dart';
import '../../../../../../../../utils/text_styles.dart';
import '../../../../../../../../utils/utils.dart';
import '../../../../../../../../widgets/stylized_text.dart';
import '../../../../../../../utils/game_icons.dart';
import '../../../components/farm/components/system/enum/growable.dart';
import '../../../components/farm/model/harvest_model.dart';
import '../models/merged_harvest_model.dart';

/// TODO: Language
class MergedHarvestItem extends StatelessWidget {
  final MergedHarvestModel model;
  final int itemNo;
  final Color bgColor;

  const MergedHarvestItem({
    super.key,
    required this.model,
    required this.itemNo,
    this.bgColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        /// date
        Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(8.s),
          ),
          padding: EdgeInsets.symmetric(horizontal: 12.s, vertical: 2.s),
          margin: EdgeInsets.only(bottom: 2.s),
          child: _Date(model: model),
        ),

        /// main body
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// item no
            SizedBox(
              width: 60.s,
              child: StylizedText(
                text: Text(
                  '$itemNo.',
                  style: TextStyles.s28.copyWith(
                    letterSpacing: 3.s,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(8.s),
                ),
                child: Row(
                  children: [
                    ///  growable asset
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 8.s, vertical: 8.s),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.s),
                            border: Border.all(
                              color: Colors.white,
                              width: 0.8.s,
                              strokeAlign: BorderSide.strokeAlignInside,
                            ),
                          ),
                          padding: EdgeInsets.all(2.s),
                          child: Image.asset(
                            model.growable.representativeAtAge(model.age),
                            height: 60.s,
                          ),
                        ),
                      ),
                    ),

                    /// growable details
                    Expanded(
                      flex: 3,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            model.growable.growableName,
                            style: TextStyles.s25,
                          ),
                          Gap(8.s),
                          Text(
                            'x${model.noOfMergedItems}',
                            style: TextStyles.s23,
                          ),
                        ],
                      ),
                    ),

                    /// harvest type
                    Expanded(
                      flex: 3,
                      child: _HarvestType(model: model),
                    ),

                    /// yield
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          Text(
                            'Yield',
                            style: TextStyles.s18,
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            '${(model.yield * 100).toStringAsFixed(1)} %',
                            style: TextStyles.s23,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    /// revenue
                    Expanded(
                      flex: 3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            model.totalRevenue.formattedValue,
                            style: TextStyles.s24,
                          ),
                          Gap(6.s),
                          Image.asset(
                            GameIcons.coin,
                            height: 30.s,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Date extends StatelessWidget {
  final MergedHarvestModel model;

  const _Date({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      () {
        if (model.startDate == model.endDate) {
          return Utils.monthYearDateFormat.format(model.startDate);
        }

        return '${Utils.monthYearDateFormat.format(model.startDate)} ... ${Utils.monthYearDateFormat.format(model.endDate)}';
      }(),
      style: TextStyles.s20.copyWith(
        letterSpacing: 2.s,
      ),
    );
  }
}

class _HarvestType extends StatelessWidget {
  final MergedHarvestModel model;

  const _HarvestType({
    super.key,
    required this.model,
  });

  Color get bgColor {
    switch (model.harvestType) {
      case HarvestType.recurring:
        // return Colors.blueAccent;
        return Colors.blue;

      case HarvestType.oneTime:
        return switch (model.growable.getGrowableType()) {
          GrowableType.tree => Colors.redAccent,
          GrowableType.crop => Colors.green,
        };
    }
  }

  String get text {
    switch (model.harvestType) {
      case HarvestType.recurring:
        return 'Recurring';

      case HarvestType.oneTime:
        return switch (model.growable.getGrowableType()) {
          GrowableType.tree => 'Sold',
          GrowableType.crop => 'Harvested',
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.s, vertical: 4.s),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8.s),
        ),
        child: Text(
          text,
          style: TextStyles.s23,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
