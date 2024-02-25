import 'dart:async';

import '../../../../../../../../../services/log/log.dart';
import '../../../../../../../../../utils/extensions/date_time_extensions.dart';
import '../../../../../../../services/game_services/time/time_service.dart';
import '../../asset/crop_asset.dart';
import '../../components/crop/enums/crop_stage.dart';
import '../../components/crop/enums/crop_type.dart';
import '../../components/hover_board/enum/hover_board_type.dart';
import '../../components/hover_board/hover_board_controller.dart';
import '../../components/hover_board/models/hover_board_model.dart';
import '../../components/system/real_life/calculators/crops/base_crop.dart';
import '../../enum/farm_state.dart';
import '../farm_core_service.dart';

class CropTimer {
  final FarmCoreService farmCoreService;

  final String tag;
  final HoverBoardController _hoverBoardController;

  CropTimer({
    required this.farmCoreService,
  })  : _hoverBoardController = farmCoreService.farm.farmController.hoverBoard.hoverBoardController,
        tag = 'CropTimer[${farmCoreService.farm.farmId}]';

  bool _booted = false;
  StreamSubscription? _farmStateSubscription;

  void boot() {
    if (_booted) {
      throw Exception('$tag: boot() invoked on already booted up service');
    }
    _booted = true;
    _initiateBootupSequence();
  }

  void _onNeedToWaitForCrop() {
    Log.i('$tag: need to wait for crop, show timer!');

    final crop = farmCoreService.farmContent?.crop;
    if (crop == null) {
      throw Exception('$tag: invoked _onNeedToWaitForCrop() without a valid crop');
    }

    final cropType = crop.type as CropType;
    final baseCropCalculator = BaseCropCalculator.fromCropType(cropType);

    final currentDateTime = TimeService().currentDateTime;
    if (baseCropCalculator.canSow(currentDateTime.gameMonth)) {
      Log.d('$tag: we don\'t have to show timer, current month is good enough for sowing!');
      return;
    }

    /// find periods and sort them
    final periods = baseCropCalculator.sowData();
    periods.sort((a, b) => (a.sowMonth.index - b.sowMonth.index)); // bajra - jun, nov

    final nextSowDate = baseCropCalculator.getNextSowDateFrom(currentDateTime);

    /// show a component
    _hoverBoardController.addHoverBoard(
      type: HoverBoardType.cropsWaiting,
      model: HoverBoardModel.timer(
        text: 'waiting for ${cropType.name}',
        image: CropAsset.of(cropType).at(CropStage.maturity),
        startDateTime: currentDateTime,
        futureDateTime: nextSowDate,
      ),
      onTap: () {
        Log.d('$tag: waiting for crop, no action to perform!');
      },
    );
  }

  void _initiateBootupSequence() {
    _farmStateSubscription = farmCoreService.farmStateStream.listen((farmState) {
      if (farmState == FarmState.onlyCropsWaiting || farmState == FarmState.treesAndCropsButCropsWaiting) {
        _onNeedToWaitForCrop();
      }
    });
  }

  void shutdown() {
    _farmStateSubscription?.cancel();
  }
}
