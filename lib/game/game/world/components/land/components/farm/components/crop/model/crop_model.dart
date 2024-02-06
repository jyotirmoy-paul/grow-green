import '../enums/crop_health.dart';
import '../enums/crop_stage.dart';
import '../enums/crop_type.dart';

class CropModel {
  /// immutable properties
  final CropType cropType;
  final int cropIndex;

  /// mutable properties
  CropStage cropStage;
  CropHealth cropHealth;

  CropModel({
    required this.cropIndex,
    required this.cropType,
    required this.cropStage,
    required this.cropHealth,
  });

  @override
  String toString() {
    return 'Crop($cropIndex, $cropType, $cropStage, $cropHealth)';
  }
}
