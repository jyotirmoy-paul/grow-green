// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Content _$ContentFromJson(Map<String, dynamic> json) => Content(
      type: const MeasurablesConverter().fromJson(json['type'] as String),
      qty: Qty.fromJson(json['qty'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ContentToJson(Content instance) => <String, dynamic>{
      'type': const MeasurablesConverter().toJson(instance.type),
      'qty': instance.qty.toJson(),
    };
