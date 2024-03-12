import '../../../../../../../../l10n/l10n.dart';
import '../../../../../../../../routes/routes.dart';
import '../../../components/farm/components/crop/enums/crop_type.dart';

abstract class CropInfo {
  static String getCropInfo(CropType? cropType) {
    final context = Navigation.navigationKey.currentContext;
    if (context == null || cropType == null) return '';

    return switch (cropType) {
      CropType.maize => context.l10n.maizeInfo,
      CropType.bajra => context.l10n.bajraInfo,
      CropType.wheat => context.l10n.wheatInfo,
      CropType.groundnut => context.l10n.groundnutInfo,
      CropType.pepper => context.l10n.pepperInfo,
      CropType.banana => context.l10n.bananaInfo,
    };
  }
}
