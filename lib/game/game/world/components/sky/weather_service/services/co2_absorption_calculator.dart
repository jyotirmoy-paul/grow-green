import '../../../land/components/farm/components/tree/enums/tree_type.dart';
import '../models/co2_absorption_data.dart';

class Co2AbsorptionCalculator {
  final TreeType treeType;
  final Co2AbsorptionData data;

  Co2AbsorptionCalculator({
    required this.treeType,
  }) : data = Co2AbsorptionData.of(treeType);

  double getTotalCo2SequestratedBy({required final int treeAgeInDays}) {
    final age = treeAgeInDays / 365;

    if (age <= Co2AbsorptionData.youngThresholdAge) {
      return data.youngSequestrationRate * age;
    }

    if (age <= Co2AbsorptionData.matureThresholdAge) {
      return data.totalYoungSequestration + (age - Co2AbsorptionData.youngThresholdAge) * data.matureSequestrationRate;
    }

    return data.totalMatureSequestration + (age - Co2AbsorptionData.matureThresholdAge) * data.oldSequestrationRate;
  }
}
