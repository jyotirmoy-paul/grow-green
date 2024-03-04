import 'dart:async';

import '../../../../../../../services/datastore/game_datastore.dart';
import '../../model/harvest_model.dart';

class HarvestRecorder {
  final GameDatastore gameDatastore;
  final String farmId;

  HarvestRecorder({
    required this.farmId,
    required this.gameDatastore,
  });

  final Map<String, HarvestModel> _harvestModels = {};
  final _streamController = StreamController<List<HarvestModelNonAckData>>.broadcast();

  Stream<List<HarvestModelNonAckData>> get harvestNotAckDataStream => _streamController.stream;
  List<HarvestModel> get harvestModels {
    return List<HarvestModel>.from(_harvestModels.values)..sort((a, b) => a.dateOfHarvest.compareTo(b.dateOfHarvest));
  }

  void _notify() {
    final data = <HarvestModelNonAckData>[];

    for (final hm in _harvestModels.values) {
      if (!hm.isAck()) {
        data.add(HarvestModelNonAckData(id: hm.id, money: hm.revenue));
      }
    }

    _streamController.add(data);
  }

  /// fetches the initial harvest data
  Future<void> init() async {
    final harvestModels = await gameDatastore.getHarvestModelsFor(farmId);
    for (final hm in harvestModels) {
      _harvestModels[hm.id] = hm;
    }

    _notify();
  }

  ///  records harvest model
  void recordHarvest(HarvestModel harvestModel) {
    unawaited(gameDatastore.addHarvestModelFor(farmId, harvestModel: harvestModel));
    _harvestModels[harvestModel.id] = harvestModel;
    _notify();
  }

  void updateAckStatusFor(List<String> ids) {
    final stateUpdates = <HarvestStateUpdateModel>[];

    for (final id in ids) {
      stateUpdates.add(
        HarvestStateUpdateModel(id: id, harvestState: HarvestState.ack),
      );

      /// update the local map
      _harvestModels[id] = _harvestModels[id]!.ackHarvestState();
    }

    unawaited(gameDatastore.updateHarestModelsFor(farmId, stateUpdates: stateUpdates));
    _notify();
  }
}
