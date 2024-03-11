// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Offer _$OfferFromJson(Map<String, dynamic> json) => Offer();

Map<String, dynamic> _$OfferToJson(Offer instance) => <String, dynamic>{};

MoneyOffer _$MoneyOfferFromJson(Map<String, dynamic> json) => MoneyOffer(
      money: MoneyModel.fromJson(json['money'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MoneyOfferToJson(MoneyOffer instance) =>
    <String, dynamic>{
      'money': instance.money.toJson(),
    };

GwalletOffer _$GwalletOfferFromJson(Map<String, dynamic> json) => GwalletOffer(
      gwallet: json['gwallet'] as String,
    );

Map<String, dynamic> _$GwalletOfferToJson(GwalletOffer instance) =>
    <String, dynamic>{
      'gwallet': instance.gwallet,
    };
