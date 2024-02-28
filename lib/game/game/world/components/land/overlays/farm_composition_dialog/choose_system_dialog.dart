import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../../../utils/extensions/num_extensions.dart';
import '../../../../../../../widgets/button_animator.dart';
import '../../../../../models/farm_system.dart';
import '../../../../../services/datastore/system_datastore.dart';
import '../../components/farm/farm.dart';
import 'widgets/system_item_widget.dart';

class ChooseSystemDialog extends StatelessWidget {
  final Farm farm;
  final SystemDatastore systemDatastore;

  ChooseSystemDialog({
    super.key,
    required this.farm,
  }) : systemDatastore = farm.game.gameDatastore.systemDatastore;

  void _onSystemSelected(FarmSystem farmSystem) {}

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView.separated(
        padding: EdgeInsets.all(15.s),
        scrollDirection: Axis.horizontal,
        itemCount: systemDatastore.systems.length,
        itemBuilder: (_, int index) {
          final farmSystem = systemDatastore.systems[index];
          return ButtonAnimator(
            onPressed: () {
              _onSystemSelected(farmSystem);
            },
            child: SystemItemWidget(
              farm: farm,
              farmSystem: farmSystem,
            ),
          );
        },
        separatorBuilder: (_, __) => Gap(30.s),
      ),
    );
  }
}
