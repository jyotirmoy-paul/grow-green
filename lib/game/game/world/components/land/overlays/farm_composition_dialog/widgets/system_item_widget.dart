import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../../../../utils/extensions/num_extensions.dart';
import '../../../../../../../../utils/text_styles.dart';
import '../../../../../../../../utils/utils.dart';
import '../../../../../../../../widgets/flip_card/flip_card_controller.dart';
import '../../../../../../../../widgets/game_button.dart';
import '../../../../../../../../widgets/shadowed_container.dart';
import '../../../../../../../../widgets/stylized_text.dart';
import '../../../../../../../utils/game_assets.dart';
import '../../../../../../enums/agroforestry_type.dart';
import '../../../../../../enums/farm_system_type.dart';
import '../../../../../../enums/system_type.dart';
import '../../../../../../models/farm_system.dart';
import '../../../components/farm/components/system/real_life/systems/database/layouts.dart';
import '../../../components/farm/components/system/real_life/utils/soil_health_calculator.dart';
import '../../../components/farm/farm.dart';
import '../../farm_menu/farm_menu_helper.dart';
import '../infomatics/layout_info.dart';
import 'menu_image.dart';
import 'menu_item_flip_skeleton.dart';
import 'soil_health_effect.dart';

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
      header: _header(isBack: false),
      backHeader: _header(isBack: true),
      body: _body,
      backBody: _backBody,
      footer: _footer,
      backFooter: _footer,
    );
  }

  Widget _header({required bool isBack}) {
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
            child: SizedBox.square(
              dimension: 48.s,
              child: GameButton.text(
                text: isBack ? 'x' : 'i',
                onTap: _onInfoTap,
                color: isBack ? Colors.redAccent : Colors.blue.shade800,
              ),
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
            child: StylizedText(text: Text("You get", style: TextStyles.s23)),
          ),
          Column(
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
              ),
              Gap(20.s),
              SoilHealthEffect(
                changePercentage: SoilHealthCalculator.systemTypeAffect(
                  systemType: systemType,
                  treesPresent: true,
                ),
                changeDurationType: ChangeDurationType.yearly,
                isExpanded: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<SizedBox> get _getComponents =>
      buildComponents().map((e) => SizedBox.square(dimension: 100.s, child: e)).toList();

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
      rightText: FarmMenuHelper.getPriceForFarmSystem(
        farmSystem: widget.farmSystem,
        soilHealthPercentage: widget.farm.farmController.soilHealthPercentage,
      ).formattedValue,
    );
  }

  Widget systemImage(SystemType systemType) {
    return BackgroundGlow(
      dimension: 34.s,
      child: Image.asset(
        GameAssets.getLayoutRepresentationFor(systemType),
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
    final layout = PlantationLayout.fromSytemType(system.agroforestryType);

    /// trees
    final treeQty = layout.numberOfTrees;

    final treesData = _SystemComponent(
      key: ValueKey('trees-${system.agroforestryType}'),
      componentImage: GameAssets.sapling,
      bgColor: widget.secondaryColor,
      footer: "x$treeQty",
      header: "Trees",
    );

    /// crops
    final cropAreaHa = layout.areaFractionForCrops;

    final cropsData = _SystemComponent(
      key: ValueKey('crops-${system.agroforestryType}'),
      componentImage: GameAssets.seeds,
      bgColor: widget.secondaryColor,
      header: "Crop Area",
      footer: "${cropAreaHa.toStringAsFixed(2)} ha",
    );

    return [
      treesData,
      cropsData,
    ];
  }

  SystemType get systemType {
    if (widget.farmSystem is AgroforestrySystem) {
      return (widget.farmSystem as AgroforestrySystem).agroforestryType;
    } else if (widget.farmSystem is MonocultureSystem) {
      return (widget.farmSystem as MonocultureSystem).farmSystemType;
    }

    return FarmSystemType.monoculture;
  }

  Widget get systemWidget {
    return systemImage(systemType);
  }

  List<Widget> buildComponentsFromMonoculture(MonocultureSystem system) {
    /// crops

    final layout = PlantationLayout.fromSytemType(system.farmSystemType);
    final cropAreaHa = layout.areaFractionForCrops;
    final cropsData = _SystemComponent(
      key: ValueKey('crops-${system.farmSystemType}'),
      componentImage: GameAssets.seeds,
      bgColor: widget.secondaryColor,
      header: "Crop Area",
      footer: "${cropAreaHa.toStringAsFixed(2)} ha",
    );

    return [
      cropsData,
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
  final TextStyle? textStyle;
  const MenuFooterTextRow({
    super.key,
    required this.leftText,
    required this.rightText,
    this.textStyle,
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
                style: textStyle ?? TextStyles.s28,
              ),
            ),
          ),

          Align(
            alignment: Alignment.centerRight,
            child: StylizedText(
              text: Text(
                rightText,
                style: textStyle ?? TextStyles.s28,
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
  final String? footer;
  final Color bgColor;

  const _SystemComponent({
    super.key,
    required this.header,
    this.footer,
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
              dimension: 50.s,
              shape: BoxShape.circle,
            ),
          ),
        ),
        Gap(10.s),
        StylizedText(
          text: Text(
            header,
            style: TextStyles.s16,
            textAlign: TextAlign.center,
          ),
        ),
        if (footer != null)
          StylizedText(
            text: Text(
              footer!,
              style: TextStyles.s16,
              textAlign: TextAlign.center,
            ),
          )
      ],
    );
  }
}
