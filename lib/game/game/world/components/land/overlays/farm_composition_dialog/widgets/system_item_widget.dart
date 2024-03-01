import 'package:flutter/material.dart';

import '../../../../../../../../utils/extensions/num_extensions.dart';
import '../../../../../../../../utils/text_styles.dart';
import '../../../../../../../../utils/utils.dart';
import '../../../../../../../../widgets/game_button.dart';
import '../../../../../../../../widgets/shadowed_container.dart';
import '../../../../../../../../widgets/stylized_text.dart';
import '../../../../../../../utils/game_icons.dart';
import '../../../../../../enums/agroforestry_type.dart';
import '../../../../../../enums/farm_system_type.dart';
import '../../../../../../models/farm_system.dart';
import '../../../components/farm/asset/crop_asset.dart';
import '../../../components/farm/asset/tree_asset.dart';
import '../../../components/farm/components/crop/enums/crop_stage.dart';
import '../../../components/farm/components/system/real_life/utils/qty_calculator.dart';
import '../../../components/farm/components/tree/enums/tree_stage.dart';
import '../../../components/farm/farm.dart';
import '../../farm_menu/farm_menu_helper.dart';
import 'menu_item_skeleton.dart';

/// TODO: Language
class SystemItemWidget extends StatelessWidget {
  final Farm farm;
  final FarmSystem farmSystem;
  final Color bgColor;
  final Color secondaryColor;

  const SystemItemWidget({
    super.key,
    required this.farm,
    required this.farmSystem,
    this.bgColor = Colors.green,
    this.secondaryColor = Colors.blueAccent,
  });

  String _getTitle() {
    if (farmSystem.farmSystemType == FarmSystemType.monoculture) {
      return 'Monoculture';
    }

    final agroType = (farmSystem as AgroforestrySystem).agroforestryType;

    switch (agroType) {
      case AgroforestryType.alley:
        return 'Alley Cropping';

      case AgroforestryType.boundary:
        return 'Boundary Planation';

      case AgroforestryType.block:
        return 'Block Planation';
    }
  }

  List<Widget> buildComponentsFromAgroforestry(AgroforestrySystem system) {
    /// trees
    final treeType = system.trees.first;
    final treeQty = QtyCalculator.getNumOfSaplingsFor(system.agroforestryType);

    final treesData = _SystemComponent(
      key: ValueKey('trees-${system.agroforestryType}'),
      text: '${treeQty.value} ${treeQty.scale.name} of ${treeType.name}',
      componentImage: 'assets/images/${TreeAsset.of(treeType).at(TreeStage.adult)}',
      bgColor: secondaryColor,
    );

    /// crops
    final cropType = system.crop;
    final cropQty = QtyCalculator.getSeedQtyRequireFor(
      systemType: system.agroforestryType,
      cropType: cropType,
    );

    final cropsData = _SystemComponent(
      key: ValueKey('crops-${system.agroforestryType}'),
      text: '${cropQty.value} ${cropQty.scale.name} of ${cropType.name}',
      componentImage: 'assets/images/${CropAsset.of(cropType).at(CropStage.maturity)}',
      bgColor: secondaryColor,
    );

    /// system
    final systemData = _SystemComponent(
      key: ValueKey('system-${system.agroforestryType}'),
      text: system.agroforestryType.name,
      componentImage: treesData.componentImage,
      bgColor: secondaryColor,
    );

    return [
      treesData,
      cropsData,
      systemData,
    ];
  }

  List<Widget> buildComponentsFromMonoculture(MonocultureSystem system) {
    /// crops
    final cropType = system.crop;
    final cropQty = QtyCalculator.getSeedQtyRequireFor(
      systemType: system.farmSystemType,
      cropType: cropType,
    );

    final cropsData = _SystemComponent(
      text: '${cropQty.value} ${cropQty.scale.name} of ${cropType.name}',
      componentImage: 'assets/images/${CropAsset.of(cropType).at(CropStage.maturity)}',
      bgColor: secondaryColor,
    );

    /// fertilizer
    final fertilizerQty = QtyCalculator.getFertilizerQtyRequiredFor(
      systemType: system.farmSystemType,
      soilHealthPercentage: farm.farmController.soilHealthPercentage,
      cropType: cropType,
    );

    final fertilizerType = system.fertilizer;
    final fertilierData = _SystemComponent(
      text: '${fertilizerQty.value} ${fertilizerQty.scale.name} of ${fertilizerType.name}',
      componentImage: cropsData.componentImage,
      bgColor: secondaryColor,
    );

    return [
      cropsData,
      fertilierData,
    ];
  }

  List<Widget> buildComponents() {
    final system = farmSystem;

    if (system is AgroforestrySystem) {
      return buildComponentsFromAgroforestry(system);
    } else if (system is MonocultureSystem) {
      return buildComponentsFromMonoculture(system);
    }

    return const [];
  }

  void _onInfoTap() {
    /// TODO: handle on info tap
  }

  @override
  Widget build(BuildContext context) {
    return MenuItemSkeleton(
      width: 380.s,
      bgColor: bgColor,
      header: Center(
        child: StylizedText(
          text: Text(
            _getTitle(),
            textAlign: TextAlign.center,
            style: TextStyles.s35,
          ),
        ),
      ),
      body: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        runAlignment: WrapAlignment.center,
        spacing: 16.s,
        runSpacing: 16.s,
        children: buildComponents()
            .map(
              (e) => SizedBox.square(
                dimension: 160.s,
                child: e,
              ),
            )
            .toList(),
      ),
      footer: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          /// price
          StylizedText(
            text: Text(
              '₹ ${FarmMenuHelper.getPriceForFarmSystem(
                farmSystem: farmSystem,
                soilHealthPercentage: farm.farmController.soilHealthPercentage,
              ).formattedRupees}',
              style: TextStyles.s32,
            ),
          ),

          /// info button to learn more
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.s),
              child: GameButton.image(
                image: GameIcons.info,
                bgColor: secondaryColor,
                onTap: _onInfoTap,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SystemComponent extends StatelessWidget {
  final String componentImage;
  final String text;
  final Color bgColor;

  const _SystemComponent({
    super.key,
    required this.text,
    required this.componentImage,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return ShadowedContainer(
      padding: EdgeInsets.all(12.s),
      shadowOffset: Offset(6.s, 6.s),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12.s),
        border: Border.all(
          color: Utils.lightenColor(bgColor),
          width: 2.s,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Image.asset(componentImage),
          ),
          StylizedText(
            text: Text(
              text,
              style: TextStyles.s26,
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}
