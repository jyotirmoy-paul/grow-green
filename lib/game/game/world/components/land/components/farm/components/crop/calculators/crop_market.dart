import '../enums/crop_type.dart';

abstract class CropMarket {
  static final Map<CropType, int> _cropPrices = {
    CropType.maize: 29,
    CropType.bajra: 23,
    CropType.wheat: 21,
    CropType.groundnut: 55,
    CropType.pepper: 95,
    CropType.banana: 32,
  };

  static int pricePerKg(CropType cropType) {
    return _cropPrices[cropType] ?? 0; // Return 0 if not found
  }

  static void updatePrice(CropType cropType, int newPrice) {
    _cropPrices[cropType] = newPrice;
  }
}
