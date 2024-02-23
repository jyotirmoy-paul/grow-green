import 'package:json_annotation/json_annotation.dart';

import '../../../../../../services/game_services/monetary/models/money_model.dart';
import '../../../overlays/system_selector_menu/enum/component_id.dart';

part 'harvest_model.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class HarvestModel {
  final double yield;
  final MoneyModel money;
  final ComponentId growable;

  HarvestModel({
    required this.yield,
    required this.money,
    required this.growable,
  });

  factory HarvestModel.fromJson(Map<String, dynamic> json) => _$HarvestModelFromJson(json);
  Map<String, dynamic> toJson() => _$HarvestModelToJson(this);
}
