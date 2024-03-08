import '../../../../crop/enums/crop_type.dart';

abstract class CropMarket {
  // This represents the selling price of the crop per kg
  static final Map<CropType, int> _cropSellingPrices = {
    CropType.maize: 200,
    CropType.bajra: 23,
    CropType.wheat: 21,
    CropType.groundnut: 55,
    CropType.pepper: 450,
    CropType.banana: 32,
  };

  static final Map<CropType, int> _seedBuyingPrice = {
    CropType.maize: 200,
    CropType.bajra: 23,
    CropType.wheat: 21,
    CropType.groundnut: 55,
    CropType.pepper: 10,
    CropType.banana: 32,
  };

  static int sellingPricePerQty(CropType cropType) {
    return _cropSellingPrices[cropType] ?? 0; // Return 0 if not found
  }

  static int buyingPricePerQty(CropType cropType) {
    return _seedBuyingPrice[cropType] ?? 0; // Return 0 if not found
  }
}
