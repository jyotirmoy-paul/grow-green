import 'package:flutter/material.dart';

import '../../../../../../../../utils/extensions/num_extensions.dart';
import '../../../../../../../../utils/text_styles.dart';
import '../../../../../../../../utils/utils.dart';
import '../../../../../../../../widgets/game_button.dart';
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

/// TODO: Language
class SystemItemWidget extends StatelessWidget {
  final Farm farm;
  final FarmSystem farmSystem;

  const SystemItemWidget({
    super.key,
    required this.farm,
    required this.farmSystem,
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
      text: '${treeQty.value} ${treeQty.scale.name} of ${treeType.name}',
      componentImage: 'assets/images/${TreeAsset.of(treeType).at(TreeStage.adult)}',
    );

    /// crops
    final cropType = system.crop;
    final cropQty = QtyCalculator.getSeedQtyRequireFor(
      systemType: system.agroforestryType,
      cropType: cropType,
    );

    final cropsData = _SystemComponent(
      text: '${cropQty.value} ${cropQty.scale.name} of ${cropType.name}',
      componentImage: 'assets/images/${CropAsset.of(cropType).at(CropStage.maturity)}',
    );

    /// system
    final systemData = _SystemComponent(
      text: system.agroforestryType.name,
      componentImage: treesData.componentImage,
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

  void _onInfoTap() {}

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      width: 300.s,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.s),
        color: Colors.green,
        boxShadow: Utils.tappableOutlineShadows,
      ),
      child: Column(
        children: [
          /// header
          Expanded(
            child: Container(
              padding: EdgeInsets.all(12.s),
              decoration: BoxDecoration(
                color: Utils.darkenColor(Colors.green, 0.2),
                border: Border(
                  bottom: BorderSide(
                    color: Utils.lightenColor(Colors.green, 0.4),
                    width: 3.s,
                  ),
                ),
              ),
              child: Center(
                child: Text(
                  _getTitle(),
                  textAlign: TextAlign.center,
                  style: TextStyles.s24,
                ),
              ),
            ),
          ),

          /// body
          Expanded(
            flex: 3,
            child: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              runAlignment: WrapAlignment.center,
              spacing: 10.s,
              runSpacing: 10.s,
              children: buildComponents()
                  .map(
                    (e) => SizedBox.square(
                      dimension: 135.s,
                      child: e,
                    ),
                  )
                  .toList(),
            ),
          ),

          Container(
            height: 2.s,
            color: Colors.black.withOpacity(0.7),
          ),
          Container(
            height: 2.s,
            color: Utils.lightenColor(Colors.green, 0.4),
          ),

          /// footer
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                /// price
                /// TODO: get actual price
                Text(
                  '₹ 2 00 000',
                  style: TextStyles.s20,
                ),

                /// info button to learn more
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.s),
                    child: SizedBox(
                      width: 50.s,
                      child: GameButton.image(
                        image: GameIcons.info,
                        bgColor: Colors.blueAccent,
                        onTap: _onInfoTap,
                      ),
                    ),
                  ),
                ),
              ],
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

  const _SystemComponent({
    super.key,
    required this.text,
    required this.componentImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.s),
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.circular(12.s),
        boxShadow: Utils.tappableOutlineShadows,
        border: Border.all(
          color: Utils.lightenColor(Colors.blueAccent),
          width: 2.s,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Image.asset(componentImage),
          ),
          Text(
            text,
            style: TextStyles.s16,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
