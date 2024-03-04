import '../../../../../../../services/datastore/game_datastore.dart';
import '../../model/soil_health_model.dart';

class SoilHealthRecorder {
  final String farmId;
  final GameDatastore gameDatastore;

  SoilHealthRecorder({
    required this.farmId,
    required this.gameDatastore,
  });

  final _soilHealthModels = <SoilHealthModel>[];
  List<SoilHealthModel> get soilHealthModels => _soilHealthModels;

  /// populate initial soil health data
  Future<void> init() async {
    final soilHealthData = await gameDatastore.getSoilHealthModelFor(farmId);
    _soilHealthModels.addAll(soilHealthData);
  }

  Future<void> record(SoilHealthModel soilHealthModel) async {
    await gameDatastore.addSoilHealthModelFor(farmId, soilHealthModel: soilHealthModel);
    _soilHealthModels.add(soilHealthModel);
  }
}
