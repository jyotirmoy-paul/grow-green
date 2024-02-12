import '../enums/crop_type.dart';

abstract class CropYield {
  // Map to store yields (kg/m²)
  static const Map<CropType, double> _yields = {
    CropType.maize: 1.50,
    CropType.bajra: 0.40,
    CropType.wheat: 0.80,
    CropType.groundnut: 0.45,
    CropType.pepper: 0.20,
    CropType.banana: 8.00,
  };

  // Getter for yield
  static double getYieldKgPerCubicM(CropType cropType) {
    return _yields[cropType] ?? 0.0; // Return 0 for unknown crops
  }
}
