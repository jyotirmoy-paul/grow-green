// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupportConfig _$SupportConfigFromJson(Map<String, dynamic> json) =>
    SupportConfig(
      maintenanceConfig: MaintenanceQty.fromJson(
          json['maintenanceConfig'] as Map<String, dynamic>),
      fertilizerConfig:
          Content.fromJson(json['fertilizerConfig'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SupportConfigToJson(SupportConfig instance) =>
    <String, dynamic>{
      'maintenanceConfig': instance.maintenanceConfig.toJson(),
      'fertilizerConfig': instance.fertilizerConfig.toJson(),
    };
