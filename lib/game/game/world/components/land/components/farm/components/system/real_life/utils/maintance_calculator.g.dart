// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'maintance_calculator.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MaintenanceQty _$MaintenanceQtyFromJson(Map<String, dynamic> json) =>
    MaintenanceQty(
      waterQty: Qty.fromJson(json['waterQty'] as Map<String, dynamic>),
      laborQty: Qty.fromJson(json['laborQty'] as Map<String, dynamic>),
      miscQty: Qty.fromJson(json['miscQty'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MaintenanceQtyToJson(MaintenanceQty instance) =>
    <String, dynamic>{
      'waterQty': instance.waterQty.toJson(),
      'laborQty': instance.laborQty.toJson(),
      'miscQty': instance.miscQty.toJson(),
    };
