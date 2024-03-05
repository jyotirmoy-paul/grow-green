import '../components/crop/enums/crop_stage.dart';
import '../components/crop/enums/crop_type.dart';

class CropAsset {
  final CropType cropType;
  final String prefix;

  CropAsset._(this.cropType, this.prefix);

  factory CropAsset.of(CropType cropType) {
    return CropAsset._(cropType, 'crops');
  }

  factory CropAsset.raw(CropType cropType) {
    return CropAsset._(cropType, 'assets/images/crops');
  }

  String at(CropStage cropStage) {
    return '$prefix/${cropType.name}/${cropStage.assetName}';
  }

  String get menuImage {
    return '$prefix/${cropType.name}/4_with_land.png';
  }

  static String representativeOf(CropType cropType) {
    return CropAsset.raw(cropType).at(CropStage.ripe);
  }

  static String menuRepresentativeOf(CropType cropType) {
    return CropAsset.raw(cropType).menuImage;
  }
}
