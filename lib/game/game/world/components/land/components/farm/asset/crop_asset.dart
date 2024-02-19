import '../components/crop/enums/crop_stage.dart';
import '../components/crop/enums/crop_type.dart';

class CropAsset {
  static const tag = 'CropAsset';
  static const prefix = 'crops';

  final CropType cropType;
  CropAsset._(this.cropType);

  factory CropAsset.of(CropType cropType) {
    return CropAsset._(cropType);
  }

  String at(CropStage cropStage) {
    return '$prefix/${cropType.name}_${cropStage.name}.png';
  }
}
