import 'package:flutter/material.dart';

import '../../../../../grow_green_game.dart';
import '../../components/farm/farm.dart';
import '../../components/farm/model/farm_content.dart';
import 'enums/bill_state.dart';
import 'widget/bill_purchase.dart';
import 'widget/bill_sell.dart';

/// FIXME: Do proper handling for state management of bill menu
class BillMenu extends StatefulWidget {
  static const overlayName = 'bill-menu';
  static Widget builder(BuildContext context, GrowGreenGame game) {
    return BillMenu(
      game: game,
      farm: game.gameController.overlayData.farm,
      billState: game.gameController.overlayData.billState,
      farmContent: game.gameController.overlayData.farmContent,
    );
  }

  const BillMenu({
    super.key,
    required this.game,
    required this.farm,
    required this.billState,
    required this.farmContent,
  });

  final Farm farm;
  final BillState billState;
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

  @override
  void initState() {
    super.initState();

    _initAnimations();
  }

  Widget _buildWidget() {
    switch (widget.billState) {
      case BillState.purchaseEverything:
      case BillState.purchaseOnlyCrops:
      case BillState.purchaseOnlyTrees:
        return BillPurchase(
          farmContent: widget.farmContent,
          billState: widget.billState,
          game: widget.game,
          animationController: _animationController,
        );

      case BillState.sellTree:
        return BillSell(
          game: widget.game,
          animationController: _animationController,
          farm: widget.farm,
          farmContent: widget.farmContent,
        );
    }
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
              child: _buildWidget(),
            ),
          ),
        ),
      ),
    );
  }
}
