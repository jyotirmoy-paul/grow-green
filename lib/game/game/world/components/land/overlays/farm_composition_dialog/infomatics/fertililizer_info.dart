import '../../../components/farm/model/fertilizer/fertilizer_type.dart';

class FertilizerInfo {
  static String getFertilizerInfo(FertilizerType? fertilizerType) {
    switch (fertilizerType) {
      case FertilizerType.chemical:
        return 'A synthetic fertilizer that provides essential nutrients to crops, increasing their yield and growth rate but can potentially harm the soil health';
      case FertilizerType.organic:
        return 'A natural fertilizer that enriches the soil with organic matter, improving its structure and fertility.';
      default:
        return '';
    }
  }
}
