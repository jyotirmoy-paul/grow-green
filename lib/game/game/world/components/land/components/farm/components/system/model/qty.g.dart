// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qty.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Qty _$QtyFromJson(Map<String, dynamic> json) => Qty(
      value: json['value'] as int,
      scale: $enumDecode(_$ScaleEnumMap, json['scale']),
    );

Map<String, dynamic> _$QtyToJson(Qty instance) => <String, dynamic>{
      'value': instance.value,
      'scale': _$ScaleEnumMap[instance.scale]!,
    };

const _$ScaleEnumMap = {
  Scale.kg: 'kg',
  Scale.units: 'units',
};
