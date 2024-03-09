import 'package:json_annotation/json_annotation.dart';

import '../../../../../../converters/system_type_converters.dart';
import '../../../../../../enums/system_type.dart';
import '../../../overlays/farm_composition_dialog/choose_maintenance/logic/support_config.dart';
import 'content.dart';

part 'farm_content.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: true)
class FarmContent {
  final Content? crop;
  final Content? tree;
  final SupportConfig? treeSupportConfig;
  final SupportConfig? cropSupportConfig;

  @SystemTypeConverter()
  final SystemType systemType;

  FarmContent({
    required this.systemType,
    this.crop,
    this.tree,
    this.treeSupportConfig,
    this.cropSupportConfig,
  });

  FarmContent removeCrop() {
    return FarmContent(
      crop: null,
      cropSupportConfig: null,
      tree: tree,
      treeSupportConfig: treeSupportConfig,
      systemType: systemType,
    );
  }

  FarmContent removeTreeSupport() {
    return FarmContent(
      crop: crop,
      cropSupportConfig: cropSupportConfig,
      tree: tree,
      treeSupportConfig: null,
      systemType: systemType,
    );
  }

  FarmContent removeTree() {
    return FarmContent(
      crop: crop,
      cropSupportConfig: cropSupportConfig,
      tree: null,
      treeSupportConfig: null,
      systemType: systemType,
    );
  }

  FarmContent copyWith({
    Content? crop,
    Content? tree,
    SystemType? systemType,
    SupportConfig? treeSupportConfig,
    SupportConfig? cropSupportConfig,
  }) {
    return FarmContent(
      crop: crop ?? this.crop,
      tree: tree ?? this.tree,
      systemType: systemType ?? this.systemType,
      treeSupportConfig: treeSupportConfig ?? this.treeSupportConfig,
      cropSupportConfig: cropSupportConfig ?? this.cropSupportConfig,
    );
  }

  bool get hasOnlyCrops => hasCrop && !hasTrees;

  bool get hasOnlyTrees => !hasOnlyCrops && hasTrees;

  bool get hasCrop => crop?.isNotEmpty == true;

  bool get hasTrees => tree != null;

  bool get hasTreeSupport => treeSupportConfig != null;
  bool get hasCropSupport => cropSupportConfig != null;

  bool get isEmpty =>
      (crop == null || crop!.isEmpty) && (tree == null) && (cropSupportConfig == null) && (treeSupportConfig == null);

  @override
  String toString() {
    return 'FarmContent(crop: $crop, trees: $tree, systemType: $systemType, cropSupportConfig: $cropSupportConfig, treeSupportConfig: $treeSupportConfig)';
  }

  factory FarmContent.fromJson(Map<String, dynamic> json) => _$FarmContentFromJson(json);
  Map<String, dynamic> toJson() => _$FarmContentToJson(this);
}
