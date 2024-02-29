import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../../../utils/extensions/num_extensions.dart';
import '../../../../../../../utils/text_styles.dart';
import '../../../../../../../widgets/button_animator.dart';
import '../../../../../../utils/game_images.dart';
import '../../../../../enums/agroforestry_type.dart';
import '../../components/farm/asset/crop_asset.dart';
import '../../components/farm/asset/tree_asset.dart';
import '../../components/farm/components/crop/enums/crop_stage.dart';
import '../../components/farm/components/crop/enums/crop_type.dart';
import '../../components/farm/components/tree/enums/tree_stage.dart';
import '../../components/farm/components/tree/enums/tree_type.dart';
import '../../components/farm/model/fertilizer/fertilizer_type.dart';
import '../system_selector_menu/enum/component_id.dart';
import 'widgets/menu_item_skeleton.dart';

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
          image: 'assets/images/${CropAsset.of(crop).at(CropStage.maturity)}',
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
          image: 'assets/images/${TreeAsset.of(tree).at(TreeStage.giant)}',
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
        return const Color(0xff78A083);

      case ComponentId.trees:
        return const Color(0xff99BC85);

      case ComponentId.fertilizer:
        return const Color(0xffB67352);

      case ComponentId.agroforestryLayout:
        return const Color(0xffC7B7A3);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.all(16.s),
      itemBuilder: (context, index) {
        final model = models[index];

        return ButtonAnimator(
          onPressed: () {
            Navigator.pop(context, index);
          },
          child: MenuItemSkeleton(
            bgColor: bgColor,
            header: Center(
              child: Text(
                model.name,
                style: TextStyles.s30,
              ),
            ),
            body: Column(
              children: [
                Image.asset(model.image),
              ],
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
