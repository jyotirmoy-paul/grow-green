import '../enums/agroforestry_type.dart';
import '../enums/farm_system_type.dart';
import '../world/components/land/components/farm/model/content.dart';

abstract interface class FarmSystem {
  FarmSystemType get farmSystemType;
  double get estimatedSetupCost;
}

class MonocultureSystem implements FarmSystem {
  final Content fertilizer;
  final Content crop;

  const MonocultureSystem({
    required this.fertilizer,
    required this.crop,
  });

  @override
  FarmSystemType get farmSystemType => FarmSystemType.monoculture;

  @override
  double get estimatedSetupCost {
    /// TODO: calculate estimated setup depending upon factors
    return 0.0;
  }

  MonocultureSystem copyWith({
    Content? fertilizer,
    Content? crop,
  }) {
    return MonocultureSystem(
      fertilizer: fertilizer ?? this.fertilizer,
      crop: crop ?? this.crop,
    );
  }
}

class AgroforestrySystem implements FarmSystem {
  final AgroforestryType agroforestryType;
  final List<Content> trees;
  final Content crop;

  const AgroforestrySystem({
    required this.agroforestryType,
    required this.trees,
    required this.crop,
  });

  @override
  FarmSystemType get farmSystemType => FarmSystemType.agroforestry;

  @override
  double get estimatedSetupCost {
    /// TODO: calculate estimated setup depending upon factors
    return 0.0;
  }

  AgroforestrySystem copyWith({
    AgroforestryType? agroforestryType,
    List<Content>? trees,
    Content? crop,
  }) {
    return AgroforestrySystem(
      agroforestryType: agroforestryType ?? this.agroforestryType,
      trees: trees ?? this.trees,
      crop: crop ?? this.crop,
    );
  }
}
