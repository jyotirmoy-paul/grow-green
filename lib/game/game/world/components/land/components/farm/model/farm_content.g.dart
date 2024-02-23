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
      trees: (json['trees'] as List<dynamic>?)
          ?.map((e) => Content.fromJson(e as Map<String, dynamic>))
          .toList(),
      fertilizer: json['fertilizer'] == null
          ? null
          : Content.fromJson(json['fertilizer'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FarmContentToJson(FarmContent instance) =>
    <String, dynamic>{
      'crop': instance.crop?.toJson(),
      'trees': instance.trees?.map((e) => e.toJson()).toList(),
      'fertilizer': instance.fertilizer?.toJson(),
      'systemType': const SystemTypeConverter().toJson(instance.systemType),
    };
