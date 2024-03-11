import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../../../utils/app_colors.dart';
import '../../../../../../../utils/extensions/num_extensions.dart';
import '../../../../../../../utils/text_styles.dart';
import '../../../../../../../widgets/button_animator.dart';
import '../../../../../../../widgets/flip_card/flip_card_controller.dart';
import '../../../../../../../widgets/game_button.dart';
import '../../../../../../../widgets/stylized_text.dart';
import '../../../../../../utils/game_images.dart';
import '../../../../../enums/agroforestry_type.dart';
import '../../components/farm/asset/crop_asset.dart';
import '../../components/farm/asset/tree_asset.dart';
import '../../components/farm/components/crop/enums/crop_type.dart';
import '../../components/farm/components/system/model/qty.dart';
import '../../components/farm/components/system/real_life/calculators/trees/base_tree.dart';
import '../../components/farm/components/system/real_life/utils/cost_calculator.dart';
import '../../components/farm/components/tree/enums/tree_type.dart';
import '../../components/farm/model/fertilizer/fertilizer_type.dart';
import '../system_selector_menu/enum/component_id.dart';
import 'infomatics/crop_info.dart';
import 'infomatics/fertililizer_info.dart';
import 'infomatics/tree_info.dart';
import 'widgets/age_revenue_widget/logic/age_revenue_fetcher.dart';
import 'widgets/age_revenue_widget/view/age_revenue_chart.dart';
import 'widgets/crop_revenue_widget/crop_revenue_data_fetcher.dart';
import 'widgets/crop_revenue_widget/crop_revenue_widget.dart';
import 'widgets/menu_image.dart';
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

      case ComponentId.maintenance:
        return;
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
        return AppColors.cropMenuCardBg;

      case ComponentId.trees:
        return AppColors.treeMenuCardBg;

      case ComponentId.fertilizer:
        return AppColors.fertilizerMenuCardBg;

      case ComponentId.agroforestryLayout:
        return AppColors.kSystemMenuCardBg;

      case ComponentId.maintenance:
        return Colors.transparent;
    }
  }

  double get _width {
    return switch (widget.componentId) {
      ComponentId.trees => 340.s,
      _ => 300.s,
    };
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 30.s, vertical: 40.s),
      itemBuilder: (context, index) {
        final model = models[index];
        final flipCardController = FlipCardController();

        onTap() {
          flipCardController.toggleCard();
        }

        return ButtonAnimator(
          onPressed: () {
            Navigator.pop(context, index);
          },
          child: MenuItemFlipSkeleton(
            flipCardController: flipCardController,
            bgColor: bgColor,
            width: _width,
            header: _header(model: model, onTap: onTap, isBack: false),
            backHeader: _header(model: model, onTap: onTap, isBack: true),
            body: _body(index),
            backBody: _backBody(index),
            footer: _footer(index),
            backFooter: _footer(index),
          ),
        );
      },
      separatorBuilder: (context, index) {
        return Gap(32.s);
      },
      itemCount: models.length,
    );
  }

  Widget _header({
    required _ComponentModel model,
    required void Function() onTap,
    required bool isBack,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.s),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          /// price
          Align(
            alignment: Alignment.centerLeft,
            child: StylizedText(
              text: Text(
                model.name,
                style: TextStyles.s25,
              ),
            ),
          ),

          /// info button to learn more
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox.square(
              dimension: 48.s,
              child: GameButton.text(
                text: isBack ? 'x' : 'i',
                onTap: onTap,
                color: isBack ? Colors.redAccent : Colors.blue.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _body(index) {
    final model = models[index];
    final treeType = TreeType.values.elementAtOrNull(index);
    final cropType = CropType.values.elementAtOrNull(index);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Gap(10.s),
        MenuImage(
          imageAssetPath: model.image,
          dimension: 130.s,
        ),
        if (widget.componentId == ComponentId.trees)
          AgeRevenueChart.fromAgeRevenueModels(
            ageRevenueModels: AgeRevenueFetcher(treeType: treeType!).fetch(),
            size: Size(300.s, 200.s),
          ),
        if (widget.componentId == ComponentId.crop)
          CropRevenueWidget(
            cropType: cropType!,
            bgColor: bgColor,
          )
      ],
    );
  }

  Widget _backBody(int index) {
    final model = models[index];

    String info = '';
    switch (widget.componentId) {
      case ComponentId.crop:
        {
          final cropType = CropType.values.elementAtOrNull(index);
          info = CropInfo.getCropInfo(cropType);
        }
        break;
      case ComponentId.trees:
        {
          final treeType = TreeType.values.elementAtOrNull(index);

          info = TreeInfo.getTreeInfo(treeType);
        }
        break;
      case ComponentId.fertilizer:
        {
          final fertilizerType = FertilizerType.values.elementAtOrNull(index);
          info = FertilizerInfo.getFertilizerInfo(fertilizerType);
        }
        break;
      case ComponentId.agroforestryLayout:
      case ComponentId.maintenance:
        break;
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.s),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Gap(10.s),
          MenuImage(imageAssetPath: model.image),
          Gap(10.s),
          Text(
            info,
            style: TextStyles.s18,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _footer(int index) {
    switch (widget.componentId) {
      case ComponentId.crop:
        {
          final cropType = CropType.values.elementAtOrNull(index);
          final dataFetcher = CropRevenueDataFetcher(cropType: cropType ?? CropType.wheat);

          return MenuFooterTextRow(
            leftText: "Cost per ${dataFetcher.qtyType}",
            rightText: "${dataFetcher.costPerUnitSeed}",
          );
        }
      case ComponentId.trees:
        {
          final treeType = TreeType.values.elementAtOrNull(index);
          final treeSaplingCost = BaseTreeCalculator.fromTreeType(treeType ?? TreeType.coconut).saplingCost;
          return MenuFooterTextRow(
            leftText: "1 Sapling cost",
            rightText: "$treeSaplingCost",
          );
        }
      case ComponentId.fertilizer:
        {
          final fertilizerType = FertilizerType.values.elementAtOrNull(index);
          final cost = CostCalculator.getFertilizerCost(
            qty: const Qty(value: 1, scale: Scale.kg),
            type: fertilizerType ?? FertilizerType.chemical,
          );
          return MenuFooterTextRow(
            leftText: "Cost per kg",
            rightText: cost.toString(),
          );
        }
      case ComponentId.agroforestryLayout:
      case ComponentId.maintenance:
        return const SizedBox.shrink();
    }
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
