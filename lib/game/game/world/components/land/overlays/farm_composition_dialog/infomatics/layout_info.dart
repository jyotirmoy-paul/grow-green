import 'package:flutter/material.dart';

import '../../../../../../../../l10n/l10n.dart';
import '../../../../../../enums/agroforestry_type.dart';
import '../../../../../../enums/system_type.dart';
import '../../../../../../models/farm_system.dart';

class LayoutInfo {
  final SystemType systemType;
  final String info;

  const LayoutInfo({
    required this.systemType,
    required this.info,
  });

  factory LayoutInfo.fromSystemType(FarmSystem system, BuildContext context) {
    if (system is MonocultureSystem) {
      return LayoutInfo(
        systemType: system.farmSystemType,
        info: context.l10n.monocultureInfo,
      );
    } else {
      final agrosystem = (system as AgroforestrySystem).agroforestryType;
      return LayoutInfo(
        systemType: agrosystem,
        info: _buildAgroforestryInfo(agrosystem, context),
      );
    }
  }

  static String _buildAgroforestryInfo(AgroforestryType agrosystem, BuildContext context) {
    return switch (agrosystem) {
      AgroforestryType.alley => context.l10n.alleyCropingInfo,
      AgroforestryType.boundary => context.l10n.boudaryPlantationInfo,
      AgroforestryType.block => context.l10n.blockPlantationInfo,
    };
  }
}
