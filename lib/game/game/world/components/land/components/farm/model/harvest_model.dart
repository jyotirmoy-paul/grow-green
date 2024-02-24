import 'package:json_annotation/json_annotation.dart';

import '../../../../../../converters/growable_converter.dart';
import '../../../../../../services/game_services/monetary/models/money_model.dart';
import '../components/system/enum/growable.dart';

part 'harvest_model.g.dart';

enum HarvestType {
  recurring,
  oneTime,
}

@JsonSerializable(explicitToJson: true, includeIfNull: true)
class HarvestModel {
  final HarvestType harvestType;

  @GrowableConverter()
  final Growable growable;
  final DateTime dateOfHarvest;
  final int ageAtHarvest;
  final double yield;
  final MoneyModel money;

  HarvestModel({
    required this.harvestType,
    required this.yield,
    required this.money,
    required this.growable,
    required this.dateOfHarvest,
    required this.ageAtHarvest,
  });

  factory HarvestModel.fromJson(Map<String, dynamic> json) => _$HarvestModelFromJson(json);
  Map<String, dynamic> toJson() => _$HarvestModelToJson(this);
}
