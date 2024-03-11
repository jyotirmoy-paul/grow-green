import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../../../routes/routes.dart';
import '../../../../../../../utils/extensions/num_extensions.dart';
import '../../../../../../../utils/utils.dart';
import '../../../../../../../widgets/button_animator.dart';
import '../../../../../../../widgets/dialog_container.dart';
import '../../../../../models/farm_system.dart';
import '../../../../../services/datastore/system_datastore.dart';
import '../../components/farm/farm.dart';
import '../farm_menu/enum/farm_menu_option.dart';
import '../farm_menu/farm_menu_helper.dart';
import '../system_selector_menu/enum/component_id.dart';
import 'choose_components_dialog.dart';
import 'widgets/system_item_widget.dart';

class _OffsetRestoration {
  ScrollController get scrollController => _scrollController;

  double _scrollOffset = 0.0;
  ScrollController _scrollController = ScrollController();

  void save() {
    _scrollOffset = _scrollController.offset;
  }

  void restoreController() {
    _scrollController = ScrollController(initialScrollOffset: _scrollOffset);
  }

  void createNewController() {
    _scrollController = ScrollController();
  }
}

/// TODO: language
class ChooseSystemDialog extends StatefulWidget {
  final Farm farm;
  final List<FarmSystem> farmSystems;
  static final offsetRestoration = _OffsetRestoration();

  const ChooseSystemDialog({
    super.key,
    required this.farm,
  }) : farmSystems = SystemDatastore.systems;

  @override
  State<ChooseSystemDialog> createState() => _ChooseSystemDialogState();
}

class _ChooseSystemDialogState extends State<ChooseSystemDialog> {
  @override
  void dispose() {
    ChooseSystemDialog.offsetRestoration.createNewController();
    super.dispose();
  }

  String _getChooseComponentsDialogTitle({
    required FarmSystem farmSystem,
  }) {
    if (farmSystem is AgroforestrySystem) {
      return 'Choose content';
    }

    return 'Choose content';
  }

  void _onSystemSelected({
    required FarmSystem farmSystem,
    required BuildContext context,
  }) async {
    ChooseSystemDialog.offsetRestoration.save();

    /// close the choose system dialog
    Navigator.pop(context);

    /// open choose components dialog
    final response = await Utils.showNonAnimatedDialog(
      barrierLabel: 'Choose components dialog',
      context: context,
      builder: (context) {
        return DialogContainer(
          dialogType: DialogType.large,
          title: _getChooseComponentsDialogTitle(farmSystem: farmSystem),
          child: ChooseComponentsDialog(
            farmContent: FarmMenuHelper.getFarmContentFromSystem(
              farmSystem: farmSystem,
              soilHealthPercentage: widget.farm.farmController.soilHealthPercentage,
            ),
            editableComponents: const [
              ComponentId.trees,
              ComponentId.crop,
              ComponentId.fertilizer,
              ComponentId.agroforestryLayout,
            ],
            farmController: widget.farm.farmController,
          ),
        );
      },
    );

    if (response == DialogEndType.close) {
      ChooseSystemDialog.offsetRestoration.restoreController();

      FarmMenuHelper.onMenuItemTap(
        menuOption: FarmMenuOption.composition,
        context: Navigation.navigationKey.currentContext!,
        farm: widget.farm,
      );
    } else {
      ChooseSystemDialog.offsetRestoration.createNewController();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView.separated(
        controller: ChooseSystemDialog.offsetRestoration.scrollController,
        padding: EdgeInsets.all(20.s),
        scrollDirection: Axis.horizontal,
        itemCount: widget.farmSystems.length,
        itemBuilder: (_, int index) {
          final farmSystem = widget.farmSystems[index];

          return ButtonAnimator(
            onPressed: () {
              _onSystemSelected(farmSystem: farmSystem, context: context);
            },
            child: SystemItemWidget(
              farm: widget.farm,
              farmSystem: farmSystem,
            ),
          );
        },
        separatorBuilder: (_, __) => Gap(20.s),
      ),
    );
  }
}
