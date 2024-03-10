part of 'village_temperature_service.dart';

class _TemperatureCalculatorService {
  final double baselineTemperature;
  final double minimumTemperature;
  final double co2SequestrationSensitivity;
  final double maxPossibleReduction;

  _TemperatureCalculatorService({
    required this.baselineTemperature,
    this.minimumTemperature = 15.0,
    this.co2SequestrationSensitivity = 0.05,
  }) : maxPossibleReduction = baselineTemperature - minimumTemperature;

  double calculateTemperature(double totalCo2Sequestered) {
    /// calculate the initial temperature reduction without considering the minimum threshold
    final rawTemperatureReduction = totalCo2Sequestered * co2SequestrationSensitivity;

    /// apply exponential decay to the temperature reduction based on how close it is to the minimum temperature
    final effectiveTemperatureReduction =
        maxPossibleReduction * (1 - math.exp(-rawTemperatureReduction / maxPossibleReduction));

    /// calculate the final temperature
    final finalTemperature = baselineTemperature - effectiveTemperatureReduction;

    /// do not allow the temperature to fall below `minimumTemperature`
    return math.max(finalTemperature, minimumTemperature);
  }
}
