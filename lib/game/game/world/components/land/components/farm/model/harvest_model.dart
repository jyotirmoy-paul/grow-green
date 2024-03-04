import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../../../../converters/growable_converter.dart';
import '../../../../../../services/game_services/monetary/models/money_model.dart';
import '../components/system/enum/growable.dart';

part 'harvest_model.g.dart';

enum HarvestType {
  recurring,
  oneTime,
}

enum HarvestState {
  ack,
  waitingAck,
}

class HarvestModelNonAckData {
  final String id;
  final MoneyModel money;

  HarvestModelNonAckData({
    required this.id,
    required this.money,
  });
}

@JsonSerializable(explicitToJson: true, includeIfNull: true)
class HarvestModel {
  final String id;
  final HarvestType harvestType;
  @GrowableConverter()
  final Growable growable;
  final DateTime dateOfHarvest;
  final int ageInDaysAtHarvest;
  final double yield;
  final MoneyModel revenue;
  final HarvestState harvestState;

  HarvestModel({
    String? id,
    required this.harvestType,
    required this.yield,
    required this.revenue,
    required this.growable,
    required this.dateOfHarvest,
    required this.ageInDaysAtHarvest,
    this.harvestState = HarvestState.waitingAck,
  }) : id = id ?? const Uuid().v1();

  bool isAck() {
    return harvestState == HarvestState.ack;
  }

  HarvestModel ackHarvestState() {
    return HarvestModel(
      id: id,
      harvestType: harvestType,
      yield: yield,
      revenue: revenue,
      growable: growable,
      dateOfHarvest: dateOfHarvest,
      ageInDaysAtHarvest: ageInDaysAtHarvest,
      harvestState: HarvestState.ack,
    );
  }

  factory HarvestModel.fromJson(Map<String, dynamic> json) => _$HarvestModelFromJson(json);
  Map<String, dynamic> toJson() => _$HarvestModelToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: true, createFactory: false)
class HarvestStateUpdateModel {
  @JsonKey(includeToJson: false)
  final String id;
  final HarvestState harvestState;

  HarvestStateUpdateModel({
    required this.id,
    required this.harvestState,
  });

  Map<String, dynamic> toJson() => _$HarvestStateUpdateModelToJson(this);
}
