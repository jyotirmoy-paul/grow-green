import '../model/fertilizer/fertilizer_type.dart';

class FertilizerAsset {
  static String fromType(FertilizerType type, {bool withPlus = false}) {
    final no = withPlus ? 'no_' : '';
    switch (type) {
      case FertilizerType.organic:
        return 'assets/images/icons/${no}organic_fertilizer.png';
      case FertilizerType.chemical:
        return 'assets/images/icons/${no}fertilizer.png';
    }
  }
}
