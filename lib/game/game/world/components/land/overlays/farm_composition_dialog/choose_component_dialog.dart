import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../../../utils/app_colors.dart';
import '../../../../../../../utils/extensions/num_extensions.dart';
import '../../../../../../../utils/text_styles.dart';
import '../../../../../../../widgets/button_animator.dart';
import '../../../../../../../widgets/stylized_text.dart';
import '../../../../../../utils/game_images.dart';
import '../../../../../enums/agroforestry_type.dart';
import '../../components/farm/asset/crop_asset.dart';
import '../../components/farm/asset/tree_asset.dart';
import '../../components/farm/components/crop/enums/crop_type.dart';
import '../../components/farm/components/system/real_life/calculators/trees/base_tree.dart';
import '../../components/farm/components/tree/enums/tree_type.dart';
import '../../components/farm/model/fertilizer/fertilizer_type.dart';
import '../system_selector_menu/enum/component_id.dart';
import 'choose_components_dialog.dart';
import 'widgets/age_revenue_widget/logic/age_revenue_fetcher.dart';
import 'widgets/age_revenue_widget/view/age_revenue_chart.dart';
import 'widgets/crop_revenue_widget/crop_revenue_widget.dart';
import 'widgets/menu_item_flip_skeleton.dart';
import 'widgets/system_item_widget.dart';

class ChooseComponentDialog extends StatefulWidget {
  final ComponentId componentId;

  const ChooseComponentDialog({
    super.key,
    required this.componentId,
  });

  @override
  State<ChooseComponentDialog> createState() => _ChooseComponentDialogState();
}

class _ChooseComponentDialogState extends State<ChooseComponentDialog> {
  final models = <_ComponentModel>[];

  void _populateCrop() {
    for (final crop in CropType.values) {
      models.add(
        _ComponentModel(
          image: CropAsset.menuRepresentativeOf(crop),
          name: crop.name.toUpperCase(),
          info: const [],
        ),
      );
    }
  }

  void _populateTrees() {
    for (final tree in TreeType.values) {
      models.add(
        _ComponentModel(
          image: TreeAsset.menuRepresentativeOf(tree),
          name: tree.name.toUpperCase(),
          info: const [],
        ),
      );
    }
  }

  void _populateFertilizer() {
    for (final fertilizer in FertilizerType.values) {
      models.add(
        _ComponentModel(
          image: fertilizer == FertilizerType.chemical ? GameImages.chemicalFertilizer : GameImages.organicFertilizer,
          name: fertilizer.name.toUpperCase(),
          info: const [],
        ),
      );
    }
  }

  void _populateAgroforestryLayout() {
    for (final agroforestryType in AgroforestryType.values) {
      models.add(
        _ComponentModel(
          image: () {
            switch (agroforestryType) {
              case AgroforestryType.alley:
                return GameImages.alleyPlanation;
              case AgroforestryType.boundary:
                return GameImages.boundaryPlantation;
              case AgroforestryType.block:
                return GameImages.blockPlantation;
            }
          }(),
          name: agroforestryType.name.toUpperCase(),
          info: const [],
        ),
      );
    }
  }

  void _populateChildren() {
    switch (widget.componentId) {
      case ComponentId.crop:
        return _populateCrop();

      case ComponentId.trees:
        return _populateTrees();

      case ComponentId.fertilizer:
        return _populateFertilizer();

      case ComponentId.agroforestryLayout:
        return _populateAgroforestryLayout();
    }
  }

  @override
  void initState() {
    super.initState();
    _populateChildren();
  }

  Color get bgColor {
    switch (widget.componentId) {
      case ComponentId.crop:
        return AppColors.kCropMenuCardBg;

      case ComponentId.trees:
        return AppColors.kTreeMenuCardBg;

      case ComponentId.fertilizer:
        return AppColors.kFertilizerMenuCardBg;

      case ComponentId.agroforestryLayout:
        return const Color(0xffC7B7A3);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 30.s, vertical: 40.s),
      itemBuilder: (context, index) {
        final model = models[index];
        final treeType = TreeType.values.elementAtOrNull(index);
        final cropType = CropType.values.elementAtOrNull(index);
        final treeSaplingCost = BaseTreeCalculator.fromTreeType(treeType ?? TreeType.coconut).saplingCost;
        return ButtonAnimator(
          onPressed: () {
            Navigator.pop(context, index);
          },
          child: MenuItemFlipSkeleton(
            bgColor: bgColor,
            width: 300.s,
            header: Center(
              child: StylizedText(
                text: Text(
                  model.name,
                  style: TextStyles.s35,
                ),
              ),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Gap(10.s),
                MenuImage(
                  imageAssetPath: model.image,
                ),
                if (widget.componentId == ComponentId.trees)
                  AgeRevenueChart.fromAgeRevenueModels(
                    ageRevenueModels: AgeRevenueFetcher(treeType: treeType ?? TreeType.coconut).fetch(),
                    size: Size(200.s, 180.s),
                  ),
                if (widget.componentId == ComponentId.crop)
                  CropRevenueWidget(
                    cropType: cropType ?? CropType.wheat,
                    bgColor: bgColor,
                  )
              ],
            ),
            footer: MenuFooterTextRow(
              leftText: "1 Sapling cost",
              rightText: "$treeSaplingCost",
            ),
          ),
        );
      },
      separatorBuilder: (context, index) {
        return Gap(32.s);
      },
      itemCount: models.length,
    );
  }
}

class _ComponentModel {
  final String image;
  final String name;
  final List<String> info;

  _ComponentModel({
    required this.image,
    required this.name,
    required this.info,
  });
}
