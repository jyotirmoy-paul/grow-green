import 'package:flutter/material.dart';

import '../../../../../grow_green_game.dart';
import '../../components/farm/components/crop/enums/crop_type.dart';
import '../../components/farm/components/system/real_life/utils/cost_calculator.dart';
import '../../components/farm/components/system/real_life/utils/qty_calculator.dart';
import '../../components/farm/components/tree/enums/tree_type.dart';
import '../../components/farm/model/content.dart';
import '../../components/farm/model/farm_content.dart';
import '../../components/farm/model/fertilizer/fertilizer_type.dart';
import 'widget/bill_group.dart';
import 'widget/bill_item.dart';

/// FIXME: Do proper handling for state management of bill menu
class BillMenu extends StatefulWidget {
  static const overlayName = 'bill-menu';
  static Widget builder(BuildContext context, GrowGreenGame game) {
    return BillMenu(
      game: game,
      farmContent: game.gameController.overlayData.farmContent,
    );
  }

  const BillMenu({
    super.key,
    required this.game,
    required this.farmContent,
  });

  final FarmContent farmContent;
  final GrowGreenGame game;

  @override
  State<BillMenu> createState() => _BillMenuState();
}

class _BillMenuState extends State<BillMenu> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _opacityAnimation;

  void _initAnimations() {
    /// initialize animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      reverseDuration: const Duration(milliseconds: 140),
      vsync: this,
    );

    /// opacity animation
    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    /// forward
    _animationController.forward();
  }

  void _onClose() async {
    await _animationController.reverse();

    widget.game.gameController.overlayData.stayOnSystemSelectorMenu = true;
    widget.game.overlays.remove(BillMenu.overlayName);
  }

  void _onPurchase() async {
    await _animationController.reverse();

    widget.game.gameController.overlayData.stayOnSystemSelectorMenu = false;
    widget.game.gameController.overlayData.farm.farmController.updateFarmComposition(
      farmContent: widget.farmContent,
    );

    widget.game.overlays.remove(BillMenu.overlayName);
  }

  @override
  void initState() {
    super.initState();

    _initAnimations();
  }

  Widget _buildCropGroup(Content<CropType>? crop) {
    return BillGroup(
      groupHeading: crop != null ? crop.type.name : 'Crop',
      billItems: crop != null
          ? [
              BillItem(title: 'Quantity', value: '${crop.qty.value} ${crop.qty.scale.name}'),
              BillItem(
                title: 'Price',
                value: 'Rs ${CostCalculator.seedCost(
                  cropType: crop.type,
                  seedsRequired: QtyCalculator.getSeedQtyRequireFor(
                    cropType: crop.type,
                    systemType: widget.farmContent.systemType,
                  ),
                )}',
              ),
            ]
          : const [],
    );
  }

  Widget _buildTreeGroup(List<Content<TreeType>>? trees) {
    return BillGroup(
      groupHeading: 'Trees',
      billItems: trees != null
          ? trees.map<Widget>(
              (tree) {
                return BillGroup(
                  bgColor: Colors.lightBlueAccent,
                  groupHeading: tree.type.name,
                  billItems: [
                    BillItem(title: 'Quantity', value: '${tree.qty.value} ${tree.qty.scale.name}'),
                    BillItem(
                      title: 'Price',
                      value: 'Rs ${CostCalculator.saplingCost(
                        treeType: tree.type,
                        saplingQty: QtyCalculator.getNumOfSaplingsFor(widget.farmContent.systemType),
                      )}',
                    ),
                  ],
                );
              },
            ).toList()
          : const [],
    );
  }

  Widget _buildFertilizerGroup(Content<FertilizerType>? fertilizer) {
    return BillGroup(
      groupHeading: fertilizer != null ? fertilizer.type.name : 'Fertilizer',
      billItems: fertilizer != null
          ? [
              BillItem(title: 'Quantity', value: '${fertilizer.qty.value} ${fertilizer.qty.scale.name}'),

              /// TODO: update with fertilizer calculator
              const BillItem(
                title: 'Price',
                value: 'Rs 10,000',
              ),
            ]
          : const [],
    );
  }

  Widget _buildTotal(FarmContent farmContent) {
    return BillGroup(
      groupHeading: 'Total',
      billItems: [
        BillItem(title: 'Price', value: farmContent.priceOfFarmContent.toString()),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (_, child) {
          return Opacity(
            opacity: _opacityAnimation.value,
            child: child,
          );
        },
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.35,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildCropGroup(widget.farmContent.crop),

                  /// tree
                  _buildTreeGroup(widget.farmContent.trees),

                  /// fertilizer
                  _buildFertilizerGroup(widget.farmContent.fertilizer),

                  /// total
                  _buildTotal(widget.farmContent),

                  /// action button
                  Row(
                    children: [
                      TextButton(
                        onPressed: _onClose,
                        child: const Text(
                          'Cancel Purchase',
                          style: TextStyle(color: Colors.red, fontSize: 24.0),
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: _onPurchase,
                        child: const Text(
                          'Confirm Purchase',
                          style: TextStyle(color: Colors.green, fontSize: 24.0),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
