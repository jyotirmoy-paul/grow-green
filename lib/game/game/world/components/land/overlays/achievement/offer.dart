import 'package:json_annotation/json_annotation.dart';

import '../../../../../services/game_services/monetary/models/money_model.dart';

part 'offer.g.dart';

@JsonSerializable(explicitToJson: true)
class Offer {
  const Offer();
  factory Offer.fromJson(Map<String, dynamic> json) => _$OfferFromJson(json);
  Map<String, dynamic> toJson() => _$OfferToJson(this);
}

@JsonSerializable(explicitToJson: true)
class MoneyOffer extends Offer {
  final MoneyModel money;
  MoneyOffer({required this.money});

  factory MoneyOffer.fromJson(Map<String, dynamic> json) => _$MoneyOfferFromJson(json);
  Map<String, dynamic> toJson() => _$MoneyOfferToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GwalletOffer extends Offer {
  // TODO : Add Gwallet model
  final String gwallet;
  GwalletOffer({required this.gwallet});

  factory GwalletOffer.fromJson(Map<String, dynamic> json) => _$GwalletOfferFromJson(json);
  Map<String, dynamic> toJson() => _$GwalletOfferToJson(this);
}
