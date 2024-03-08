// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'farm_content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FarmContent _$FarmContentFromJson(Map<String, dynamic> json) => FarmContent(
      systemType:
          const SystemTypeConverter().fromJson(json['systemType'] as String),
      crop: json['crop'] == null
          ? null
          : Content.fromJson(json['crop'] as Map<String, dynamic>),
      tree: json['tree'] == null
          ? null
          : Content.fromJson(json['tree'] as Map<String, dynamic>),
      treeSupportConfig: json['treeSupportConfig'] == null
          ? null
          : SupportConfig.fromJson(
              json['treeSupportConfig'] as Map<String, dynamic>),
      cropSupportConfig: json['cropSupportConfig'] == null
          ? null
          : SupportConfig.fromJson(
              json['cropSupportConfig'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FarmContentToJson(FarmContent instance) =>
    <String, dynamic>{
      'crop': instance.crop?.toJson(),
      'tree': instance.tree?.toJson(),
      'treeSupportConfig': instance.treeSupportConfig?.toJson(),
      'cropSupportConfig': instance.cropSupportConfig?.toJson(),
      'systemType': const SystemTypeConverter().toJson(instance.systemType),
    };
