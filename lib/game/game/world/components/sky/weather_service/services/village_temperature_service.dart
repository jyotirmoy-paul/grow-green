import 'dart:async';
import 'dart:math' as math;

import '../../../../../../../services/log/log.dart';
import '../../../../../../utils/game_utils.dart';
import '../../../../../services/game_services/time/time_service.dart';
import '../../../land/components/farm/components/tree/enums/tree_type.dart';
import '../../../land/components/farm/farm.dart';
import 'co2_absorption_calculator.dart';

part 'temperature_calculator_service.dart';

class VillageTemperatureService {
  static const tag = 'VillageTemperatureService';
  static const checkIntervalInDays = 365;

  final List<Farm> farms;
  final _TemperatureCalculatorService _temperatureCalculatorService;
  final _calculatorsCache = <TreeType, Co2AbsorptionCalculator>{};
  final _temperatureStreamController = StreamController<double>.broadcast();

  Stream<double> get temperatureStream => _temperatureStreamController.stream;

  VillageTemperatureService({
    required this.farms,
  }) : _temperatureCalculatorService = _TemperatureCalculatorService(
          baselineTemperature: GameUtils.maxVillageTemperature,
          minimumTemperature: GameUtils.minVillageTemperature,
          co2SequestrationSensitivity: 0.001,
        );

  StreamSubscription? _streamSubscription;
  bool _inited = false;

  Co2AbsorptionCalculator getCalculatorFor(TreeType treeType) {
    if (_calculatorsCache.containsKey(treeType)) {
      return _calculatorsCache[treeType]!;
    }

    return _calculatorsCache[treeType] = Co2AbsorptionCalculator(treeType: treeType);
  }

  void _onTimeTick(DateTime dateTime) {
    double totalAbsorbedCo2 = 0.0;

    for (final farm in farms) {
      if (farm.farmController.isTreeDataAvailable) {
        final treeData = farm.farmController.treeData;
        final co2AbsorptionByOneTree = getCalculatorFor(treeData.treeType).getTotalCo2SequestratedBy(
          treeType: treeData.treeType,
          treeAgeInDays: dateTime.difference(treeData.lifeStartedAt).inDays,
        );

        totalAbsorbedCo2 += co2AbsorptionByOneTree * treeData.noOfTrees;
      }
    }

    /// let's find out new temperature
    final co2Absorption = totalAbsorbedCo2 / checkIntervalInDays;
    final newTemperature = _temperatureCalculatorService.calculateTemperature(co2Absorption);

    Log.i('$tag: village temperature is updated to :$newTemperature for co2Absorption: $co2Absorption');

    /// notify listeners
    _temperatureStreamController.add(newTemperature);
  }

  void init() {
    if (_inited) {
      throw Exception('$tag: init() invoked again! This is a mistake.');
    }

    _inited = true;

    _streamSubscription = TimeService().dateTimeStream.listen(_onTimeTick);
  }

  void dispose() {
    _streamSubscription?.cancel();
  }
}
