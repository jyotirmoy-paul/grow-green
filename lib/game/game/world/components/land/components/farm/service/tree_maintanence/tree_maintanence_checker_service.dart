import 'dart:async';

import '../../../../../../../../../services/audio/audio_service.dart';
import '../../../../../../../../../services/log/log.dart';
import '../../../../../../../overlays/notification_overlay/service/notification_helper.dart';
import '../../../../../../../services/game_services/time/time_service.dart';
import '../../asset/tree_asset.dart';
import '../../components/hover_board/enum/hover_board_type.dart';
import '../../components/hover_board/hover_board_controller.dart';
import '../../components/hover_board/models/hover_board_model.dart';
import '../../components/tree/enums/tree_stage.dart';
import '../../model/tree_data.dart';
import '../farm_core_service.dart';

/// TODO: Language

class TreeMaintanenceCheckerService {
  /// constants
  /// tree maintanence is checked for every `treeMaintanenceCheckDuration` interval
  static const treeMaintanenceCheckDuration = Duration(days: 365);

  /// if trees stay unattended for `treeMaintanenceSpillLimit` duration, they will be removed due to lack of maintanence
  static const treeMaintanenceSpillLimit = Duration(days: 90);

  final String tag;
  final FarmCoreService farmCoreService;
  final HoverBoardController _hoverBoardController;

  late DateTime dateTime;

  bool _booted = false;
  bool _isInRecoverablePhase = false;
  bool _isInIrrecoverablePhase = false;
  bool _needsMaintanence = true;

  DateTime? _treeMaintanenceDueDate;
  StreamSubscription? _streamSubscription;

  TreeData get _treeData => farmCoreService.treeData;

  TreeMaintanenceCheckerService({
    required this.farmCoreService,
  })  : tag = 'TreeMaintanenceCheckerService[${farmCoreService.farm.farmId}]',
        _hoverBoardController = farmCoreService.farm.farmController.hoverBoard.hoverBoardController;

  void boot() {
    if (_booted) {
      throw Exception('$tag: boot() invoked on already booted up service');
    }
    _booted = true;
    _initiateBootupSequence();
  }

  /// reset internal variables whenever trees are removed
  void _reset() {
    _treeMaintanenceDueDate = null;
    _isInRecoverablePhase = false;
    _isInIrrecoverablePhase = false;
    _hoverBoardController.removeHoverBoard(HoverBoardType.treeMaintanenceWaiting);
    _needsMaintanence = true;
  }

  void _handleIrrecoverablePhase() {
    if (_isInIrrecoverablePhase) return;
    _isInIrrecoverablePhase = true;

    Log.i('$tag: _handleIrrecoverablePhase() invoked, all hopes are lost now, with heavy heart, we have to kill trees');

    /// play sorrow audio
    AudioService.treeDied();

    farmCoreService.expireTreeDueToMaintanenceMiss();

    /// notify users why trees were removed
    NotificationHelper.treeMaintenanceMiss();

    _reset();
  }

  void _removeTreeSupports() {
    farmCoreService.removeTreeSupport();
  }

  void _handleRecoverablePhase({
    required DateTime dueDate,
    required DateTime limitDate,
  }) {
    if (_isInRecoverablePhase) return;
    _isInRecoverablePhase = true;

    Log.i('$tag: _handleRecoverablePhase() invoked, let\'s notify user to attend the farm');

    /// remove tree supports (as they have expired)
    _removeTreeSupports();

    /// show a ticking hover
    _hoverBoardController.addHoverBoard(
      type: HoverBoardType.treeMaintanenceWaiting,
      model: HoverBoardModel.timer(
        text: 'Maintanence overdue',
        image: TreeAsset.of(_treeData.treeType).at(TreeStage.elder),
        startDateTime: dueDate,
        futureDateTime: limitDate,
        swapMinMaxColor: true,
      ),
      onTap: () {
        Log.d('$tag: waiting for tree\'s maintanence refill');
      },
    );
  }

  void _checkForMaintanence(DateTime dateTime) {
    final dueDate = _treeMaintanenceDueDate;
    if (dueDate == null || !_needsMaintanence) return;

    /// if tree is harvest ready & not currently in recoverable phase, we don't have to maintain it anymore it maintains itself!
    /// if tree is currently in recoverable phase, this would be the last maintanence
    if (_treeData.isHarvestReady && !_isInRecoverablePhase) {
      _needsMaintanence = false;
      return _reset();
    }

    /// figure out limit date
    final limitDate = dueDate.add(treeMaintanenceSpillLimit);

    if (_isInRecoverablePhase) {}

    /// already expired but within recoverable period
    if (dateTime.isAfter(dueDate) && dateTime.isBefore(limitDate)) {
      return _handleRecoverablePhase(
        dueDate: dueDate,
        limitDate: limitDate,
      );
    }

    /// went outside irrecoverable period, we have no choice but, sadly, to remove the trees!
    if (dateTime.isAfter(limitDate)) {
      return _handleIrrecoverablePhase();
    }
  }

  void _checkAfterRefillAlert() {
    final treeMaintanenceDueDate = _treeMaintanenceDueDate!;
    if (dateTime.isAfter(treeMaintanenceDueDate)) return;

    if (_isInRecoverablePhase) {
      /// if due date is no more valid, let's reset!
      _reset();
    }
  }

  void _onTreeMaintanenceRefilled(DateTime onDate) {
    Log.i('$tag: _onTreeMaintanenceRefilled($onDate) invoked, calculating due date');

    /// update the due date
    _treeMaintanenceDueDate = onDate.add(treeMaintanenceCheckDuration);

    /// check to see if current alert shown to user are still valid
    _checkAfterRefillAlert();
  }

  void _onTreeMaintenanceRefill(DateTime? on) {
    final onDate = on;
    if (onDate == null) {
      Log.i('$tag: _onTreeMaintenanceRefill($on) invoked with null date, resetting!');
      return _reset();
    }

    return _onTreeMaintanenceRefilled(onDate);
  }

  /// start listening
  void _initiateBootupSequence() {
    dateTime = TimeService().currentDateTime;
    _streamSubscription = farmCoreService.lastTreeMaintenanceRefillOnStream.listen(_onTreeMaintenanceRefill);
  }

  void shutdown() {
    _streamSubscription?.cancel();
  }

  void onTimeChange(DateTime dateTime) {
    this.dateTime = dateTime;
    _checkForMaintanence(dateTime);
  }
}
