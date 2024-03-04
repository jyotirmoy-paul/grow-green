import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../../../../converters/system_type_converters.dart';
import '../../../../../../enums/system_type.dart';
import 'fertilizer/fertilizer_type.dart';

part 'soil_health_model.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: true)
class SoilHealthModel {
  final String id;
  final DateTime recordedOnDate;
  final double currentSoilHealth;
  @SystemTypeConverter()
  final SystemType systemType;
  final FertilizerType? fertilizerType;
  final bool areTreesPresent;

  SoilHealthModel({
    required this.recordedOnDate,
    required this.currentSoilHealth,
    required this.systemType,
    required this.fertilizerType,
    required this.areTreesPresent,
  }) : id = const Uuid().v1();

  factory SoilHealthModel.fromJson(Map<String, dynamic> json) => _$SoilHealthModelFromJson(json);
  Map<String, dynamic> toJson() => _$SoilHealthModelToJson(this);
}
