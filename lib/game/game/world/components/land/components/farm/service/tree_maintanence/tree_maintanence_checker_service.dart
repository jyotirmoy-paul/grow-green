import 'dart:async';

import '../../../../../../../../../services/log/log.dart';
import '../../../../../../../overlays/notification_overlay/service/notification_helper.dart';
import '../farm_core_service.dart';

class TreeMaintanenceCheckerService {
  /// constants
  /// tree maintanence is checked for every `treeMaintanenceCheckDuration` interval
  static const treeMaintanenceCheckDuration = Duration(days: 365);

  /// if trees stay unattended for `treeMaintanenceSpillLimit` duration, they will be removed due to lack of maintanence
  static const treeMaintanenceSpillLimit = Duration(days: 90);

  final String tag;
  final FarmCoreService farmCoreService;

  bool _booted = false;
  bool _isInRecoverablePhase = false;
  bool _isInIrrecoverablePhase = false;

  DateTime? _treeMaintanenceDueDate;
  StreamSubscription? _streamSubscription;

  TreeMaintanenceCheckerService({
    required this.farmCoreService,
  }) : tag = 'TreeMaintanenceCheckerService[${farmCoreService.farm.farmId}]';

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
  }

  void _handleIrrecoverablePhase() {
    if (_isInIrrecoverablePhase) return;
    _isInIrrecoverablePhase = true;

    Log.i('$tag: _handleIrrecoverablePhase() invoked, all hopes are lost now, with heavy heart, we have to kill trees');

    farmCoreService.expireTreeDueToMaintanenceMiss();

    /// notify users why trees were removed
    NotificationHelper.treeMaintenanceMiss();

    _reset();
  }

  void _removeTreeSupports() {
    farmCoreService.removeTreeSupport();
  }

  void _handleRecoverablePhase() {
    if (_isInRecoverablePhase) return;
    _isInRecoverablePhase = true;

    _removeTreeSupports();

    Log.i('$tag: _handleRecoverablePhase() invoked, let\'s notify user to attend the farm');
  }

  void _checkForMaintanence(DateTime dateTime) {
    final dueDate = _treeMaintanenceDueDate;
    if (dueDate == null) return;

    /// figure out limit date
    final limitDate = dueDate.add(treeMaintanenceSpillLimit);

    /// already expired but within recoverable period
    if (dateTime.isAfter(dueDate) && dateTime.isBefore(limitDate)) {
      return _handleRecoverablePhase();
    }

    /// went outside irrecoverable period, we have no choice but, sadly, to remove the trees!
    if (dateTime.isAfter(limitDate)) {
      return _handleIrrecoverablePhase();
    }
  }

  void _onTreeMaintanenceRefilled(DateTime onDate) {
    Log.i('$tag: _onTreeMaintanenceRefilled($onDate) invoked, calculating due date');

    /// update the due date
    _treeMaintanenceDueDate = onDate.add(treeMaintanenceCheckDuration);
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
    _streamSubscription = farmCoreService.lastTreeMaintenanceRefillOnStream.listen(_onTreeMaintenanceRefill);
  }

  void shutdown() {
    _streamSubscription?.cancel();
  }

  void onTimeChange(DateTime dateTime) {
    _checkForMaintanence(dateTime);
  }
}
