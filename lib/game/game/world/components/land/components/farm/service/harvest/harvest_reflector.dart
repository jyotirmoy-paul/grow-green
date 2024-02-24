import 'dart:async';

import 'package:flame/components.dart';

import '../../../../../../../../../services/log/log.dart';
import '../../../../../../../services/game_services/monetary/enums/transaction_type.dart';
import '../../../../../../../services/game_services/monetary/models/money_model.dart';
import '../../components/hover_board/enum/hover_board_type.dart';
import '../../components/hover_board/hover_board_controller.dart';
import '../../components/hover_board/models/hover_board_model.dart';
import '../../model/harvest_model.dart';
import '../farm_core_service.dart';

/// Responsible for updating farm UI in case a harvest data is available
/// This class also oversees collection of money
class HarvestReflector {
  final FarmCoreService farmCoreService;
  final void Function(Component) add;
  final void Function(Component) remove;

  final String tag;
  final HoverBoardController _hoverBoardController;

  HarvestReflector({
    required this.farmCoreService,
    required this.add,
    required this.remove,
  })  : _hoverBoardController = farmCoreService.farm.farmController.hoverBoard.hoverBoardController,
        tag = 'HarvestReflector[${farmCoreService.farm.farmId}]';

  bool _booted = false;
  StreamSubscription? _harvestModelsSubscription;

  void boot() {
    if (_booted) {
      throw Exception('$tag: boot() invoked on already booted up service');
    }
    _booted = true;
    _initiateBootupSequence();
  }

  void _onHoverBoardTap(MoneyModel totalMoney) {
    Log.d('$tag: hoverboard was tap, moneyContents: $totalMoney');

    /// add the total money to user's balance
    unawaited(farmCoreService.farm.game.gameController.monetaryService.transact(
      transactionType: TransactionType.credit,
      value: totalMoney,
    ));

    /// notify farm core service to update harvest models to ack state
    farmCoreService.markAllHarvestsAck();
  }

  void _onHarvestModelsChange(List<HarvestModel> harvestModels) {
    MoneyModel totalMoney = MoneyModel.zero();
    for (final hm in harvestModels) {
      /// collect only the money whose acknowledgement is not done by the user
      if (hm.harvestState == HarvestState.waitingAck) {
        totalMoney += hm.money;
      }
    }

    if (totalMoney.isZero()) {
      Log.d('$tag: no money to collect in the farm');

      if (_hoverBoardController.isShowing) {
        Log.d('$tag: removing the active hover board');
        _hoverBoardController.removeHoverBoard(type: HoverBoardType.harvestOutcome);
      }

      return;
    }

    Log.d('$tag: total money accumulated in the farm: ${totalMoney.formattedRupees}');

    /// show a component
    _hoverBoardController.addHoverBoard(
      type: HoverBoardType.harvestOutcome,

      /// TODO: Replace asset & fix text
      model: HoverBoardModel.basic(text: '₹ ${totalMoney.formattedRupees}', image: 'props/coin.png'),
      onTap: () {
        _onHoverBoardTap(totalMoney);
      },
    );
  }

  void _initiateBootupSequence() {
    _harvestModelsSubscription = farmCoreService.harvestModelsStream.listen(
      (harvestModels) {
        Log.i('$tag: received ${harvestModels.length} harvest models');
        _onHarvestModelsChange(harvestModels);
      },
    );
  }

  void shutdown() {
    /// a farm is never removed, but still didn't like the idea of a stream never getting a chance to cancel
    _harvestModelsSubscription?.cancel();
    _booted = false;
  }
}
