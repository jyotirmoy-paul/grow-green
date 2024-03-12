import '../../../../../../../../l10n/l10n.dart';
import '../../../../../../../../routes/routes.dart';
import '../../../components/farm/model/fertilizer/fertilizer_type.dart';

class FertilizerInfo {
  static String getFertilizerInfo(FertilizerType? fertilizerType) {
    final context = Navigation.navigationKey.currentContext;
    if (context == null || fertilizerType == null) return '';

    return switch (fertilizerType) {
      FertilizerType.organic => context.l10n.organicFertilizerInfo,
      FertilizerType.chemical => context.l10n.chemicalFertilizerInfo,
    };
  }
}
