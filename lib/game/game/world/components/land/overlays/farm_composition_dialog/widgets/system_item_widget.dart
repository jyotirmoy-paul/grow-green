import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../../../../utils/extensions/num_extensions.dart';
import '../../../../../../../../utils/text_styles.dart';
import '../../../../../../../../utils/utils.dart';
import '../../../../../../../../widgets/game_button.dart';
import '../../../../../../../../widgets/shadowed_container.dart';
import '../../../../../../../../widgets/stylized_text.dart';
import '../../../../../../../utils/game_icons.dart';
import '../../../../../../enums/agroforestry_type.dart';
import '../../../../../../enums/farm_system_type.dart';
import '../../../../../../enums/system_type.dart';
import '../../../../../../models/farm_system.dart';
import '../../../components/farm/asset/layout_asset.dart';
import '../../../components/farm/components/system/real_life/utils/qty_calculator.dart';
import '../../../components/farm/farm.dart';
import '../../farm_menu/farm_menu_helper.dart';
import '../choose_components_dialog.dart';
import '../infomatics/layout_info.dart';
import 'menu_item_flip_skeleton.dart';

/// TODO: Language
class SystemItemWidget extends StatefulWidget {
  final Farm farm;
  final FarmSystem farmSystem;
  final Color bgColor;
  final Color secondaryColor;

  const SystemItemWidget({
    super.key,
    required this.farm,
    required this.farmSystem,
    this.bgColor = Colors.green,
    this.secondaryColor = Colors.white38,
  });

  @override
  State<SystemItemWidget> createState() => _SystemItemWidgetState();
}

class _SystemItemWidgetState extends State<SystemItemWidget> {
  late final FlipCardController flipCardController;

  @override
  void initState() {
    super.initState();
    flipCardController = FlipCardController();
  }

  void _onInfoTap() {
    flipCardController.toggleCard();
  }

  @override
  Widget build(BuildContext context) {
    return MenuItemFlipSkeleton(
      width: 300.s,
      bgColor: widget.bgColor,
      flipCardController: flipCardController,
      header: _header,
      backHeader: _header,
      body: _body,
      backBody: _backBody,
      footer: _footer,
      backFooter: _footer,
    );
  }

  Widget get _header {
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
                _getTitle(),
                style: TextStyles.s18,
              ),
            ),
          ),

          /// info button to learn more
          Align(
            alignment: Alignment.centerRight,
            child: GameButton.text(
              text: "i",
              size: Size.square(40.s),
              onTap: _onInfoTap,
              color: Colors.blue.shade800,
            ),
          ),
        ],
      ),
    );
  }

  Widget get _body {
    return Padding(
      padding: EdgeInsets.all(20.0.s),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(child: systemWidget),
          Gap(8.s),
          Align(
            alignment: Alignment.centerLeft,
            child: StylizedText(text: Text("You need", style: TextStyles.s23)),
          ),
          Center(
            child: Column(
              children: [
                ShadowedContainer(
                  padding: EdgeInsets.symmetric(horizontal: 6.s, vertical: 12.s),
                  shadowOffset: Offset(6.s, 6.s),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(12.s),
                    border: Border.all(
                      color: Utils.lightenColor(Colors.white24),
                      width: 2.s,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _getComponents,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<SizedBox> get _getComponents =>
      buildComponents().map((e) => SizedBox.square(dimension: 120.s, child: e)).toList();

  Padding get _backBody {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.s),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        children: [
          Flexible(child: systemWidget),
          Expanded(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.s),
                child: StylizedText(
                  text: Text(
                    LayoutInfo.fromSystemType(widget.farmSystem).info,
                    style: TextStyles.s14,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget get _footer {
    return MenuFooterTextRow(
      leftText: "Min Cost",
      rightText: '₹ ${FarmMenuHelper.getPriceForFarmSystem(
        farmSystem: widget.farmSystem,
        soilHealthPercentage: widget.farm.farmController.soilHealthPercentage,
      ).formattedValue}',
    );
  }

  Widget systemImage(SystemType systemType) {
    return BackgroundGlow(
      dimension: 34.s,
      child: Image.asset(
        LayoutAsset.representativeOf(systemType),
        width: 200.s,
        height: 200.s,
      ),
    );
  }

  String _getTitle() {
    if (widget.farmSystem.farmSystemType == FarmSystemType.monoculture) {
      return 'Monoculture';
    }

    final agroType = (widget.farmSystem as AgroforestrySystem).agroforestryType;

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
    final treeQty = QtyCalculator.getNumOfSaplingsFor(system.agroforestryType);

    final treesData = _SystemComponent(
      key: ValueKey('trees-${system.agroforestryType}'),
      footer: treeQty.readableFormat,
      componentImage: "assets/images/icons/sapling.png",
      bgColor: widget.secondaryColor,
      header: "Saplings",
    );

    /// crops
    final cropType = system.crop;
    final cropQty = QtyCalculator.getSeedQtyRequireFor(
      systemType: system.agroforestryType,
      cropType: cropType,
    );

    final cropsData = _SystemComponent(
      key: ValueKey('crops-${system.agroforestryType}'),
      footer: cropQty.readableFormat,
      componentImage: "assets/images/icons/seeds.png",
      bgColor: widget.secondaryColor,
      header: "Crop Seeds",
    );

    return [
      treesData,
      cropsData,
    ];
  }

  Widget get systemWidget {
    if (widget.farmSystem is AgroforestrySystem) {
      return systemImage((widget.farmSystem as AgroforestrySystem).agroforestryType);
    } else if (widget.farmSystem is MonocultureSystem) {
      return systemImage((widget.farmSystem as MonocultureSystem).farmSystemType);
    }

    return const SizedBox();
  }

  List<Widget> buildComponentsFromMonoculture(MonocultureSystem system) {
    /// crops
    final cropType = system.crop;
    final cropQty = QtyCalculator.getSeedQtyRequireFor(
      systemType: system.farmSystemType,
      cropType: cropType,
    );

    final cropsData = _SystemComponent(
      footer: cropQty.readableFormat,
      componentImage: "assets/images/icons/seeds.png",
      bgColor: widget.secondaryColor,
      header: "Crop Seeds",
    );

    /// fertilizer
    final fertilizerQty = QtyCalculator.getFertilizerQtyRequiredFor(
      systemType: system.farmSystemType,
      soilHealthPercentage: widget.farm.farmController.soilHealthPercentage,
      cropType: cropType,
    );

    final fertilierData = _SystemComponent(
      footer: fertilizerQty.readableFormat,
      componentImage: "assets/images/icons/fertilizer.png",
      bgColor: widget.secondaryColor,
      header: "Fertilizer",
    );

    return [
      cropsData,
      fertilierData,
    ];
  }

  List<Widget> buildComponents() {
    final system = widget.farmSystem;

    if (system is AgroforestrySystem) {
      return buildComponentsFromAgroforestry(system);
    } else if (system is MonocultureSystem) {
      return buildComponentsFromMonoculture(system);
    }

    return const [];
  }
}

class MenuFooterTextRow extends StatelessWidget {
  final String leftText;
  final String rightText;
  const MenuFooterTextRow({
    super.key,
    required this.leftText,
    required this.rightText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.s),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          /// price
          Align(
            alignment: Alignment.centerLeft,
            child: StylizedText(
              text: Text(
                leftText,
                style: TextStyles.s28,
              ),
            ),
          ),

          Align(
            alignment: Alignment.centerRight,
            child: StylizedText(
              text: Text(
                rightText,
                style: TextStyles.s28,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BackgroundGlow extends StatelessWidget {
  final Color glowColor = Colors.white38;
  final Widget child;
  final double? dimension;
  const BackgroundGlow({
    super.key,
    required this.child,
    Color glowColor = Colors.black,
    this.dimension,
  });

  double get _dimension => dimension ?? 20.s;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: _dimension,
          height: _dimension,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: glowColor,
                blurRadius: _dimension,
                spreadRadius: _dimension,
              ),
            ],
          ),
        ),
        child,
      ],
    );
  }
}

class _SystemComponent extends StatelessWidget {
  final String componentImage;
  final String header;
  final String footer;
  final Color bgColor;

  const _SystemComponent({
    super.key,
    required this.header,
    required this.footer,
    required this.componentImage,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Center(
            child: MenuImage(
              imageAssetPath: componentImage,
              dimension: 100.s,
              shape: BoxShape.circle,
            ),
          ),
        ),
        Gap(10.s),
        StylizedText(
          text: Text(
            header,
            style: TextStyles.s18,
            textAlign: TextAlign.center,
          ),
        ),
        StylizedText(
          text: Text(
            footer,
            style: TextStyles.s18,
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }
}
