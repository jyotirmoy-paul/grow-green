import '../../../components/farm/components/crop/enums/crop_type.dart';

abstract class CropInfo {
  static String getCropInfo(CropType? cropType) {
    switch (cropType) {
      case CropType.maize:
        return 'A versatile cereal grain that serves as a staple food for humans and livestock, also used in biofuel production.';
      case CropType.bajra:
        return 'A drought-resistant crop known for its high energy content and ability to thrive in poor soil conditions.';
      case CropType.wheat:
        return 'A primary grain used worldwide, essential for making bread, pasta, and many other food products.';
      case CropType.groundnut:
        return 'A legume crop valued for its edible seeds, oil production, and nutritional benefits.';
      case CropType.pepper:
        return 'A spice derived from the berries of the plant Piper nigrum, known for its hot and pungent flavor.';
      case CropType.banana:
        return 'A tropical fruit crop, highly valued for its sweet, nutritious fruit and versatile usage in various culinary dishes.';
      default:
        return '';
    }
  }
}
