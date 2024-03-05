import 'dart:async';

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

  final String tag;
  final HoverBoardController _hoverBoardController;

  HarvestReflector({
    required this.farmCoreService,
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

  void _onHoverBoardTap({
    required MoneyModel totalMoney,
    required List<String> ids,
  }) {
    Log.d('$tag: hoverboard was tap, moneyContents: $totalMoney');

    /// add the total money to user's balance
    unawaited(farmCoreService.farm.game.gameController.monetaryService.transact(
      transactionType: TransactionType.credit,
      value: totalMoney,
    ));

    /// notify farm core service to update harvest models to ack state
    farmCoreService.markHarvestsAckFor(ids: ids);
  }

  void _onHarvestModelsChange(List<HarvestModelNonAckData> nonAckHarvestModel) {
    if (nonAckHarvestModel.isEmpty) {
      Log.d('$tag: nothing to collect in the farm');
      return;
    }

    MoneyModel totalMoney = MoneyModel.zero();
    List<String> nonAckHarvestModelIds = [];

    for (final hm in nonAckHarvestModel) {
      totalMoney += hm.money;
      nonAckHarvestModelIds.add(hm.id);
    }

    Log.d('$tag: total money accumulated in the farm: ${totalMoney.formattedValue}');

    /// show a component
    _hoverBoardController.addHoverBoard(
      type: HoverBoardType.harvestOutcome,

      /// TODO: Replace asset & fix text
      model: HoverBoardModel.basic(
        text: '₹ ${totalMoney.formattedValue}',
        image: 'props/coin.png',
        animationPrefix: 'animations/coins',
      ),
      onTap: () {
        _onHoverBoardTap(totalMoney: totalMoney, ids: nonAckHarvestModelIds);
      },
    );
  }

  void _initiateBootupSequence() {
    _harvestModelsSubscription = farmCoreService.harvestNotAckDataStream.listen(
      (nonAckHarvestModel) {
        Log.i('$tag: received ${nonAckHarvestModel.length} harvest models which are not ack-ed');
        _onHarvestModelsChange(nonAckHarvestModel);
      },
    );
  }

  void shutdown() {
    /// a farm is never removed, but still didn't like the idea of a stream never getting a chance to cancel
    _harvestModelsSubscription?.cancel();
    _booted = false;
  }
}
