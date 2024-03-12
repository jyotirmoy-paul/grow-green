import '../../../../../../../../l10n/l10n.dart';
import '../../../../../../../../routes/routes.dart';
import '../../../components/farm/components/tree/enums/tree_type.dart';

class TreeInfo {
  static String getTreeInfo(TreeType? treeType) {
    final context = Navigation.navigationKey.currentContext;
    if (context == null || treeType == null) return '';

    return switch (treeType) {
      TreeType.mahagony => context.l10n.mahagonyInfo,
      TreeType.neem => context.l10n.neemInfo,
      TreeType.rosewood => context.l10n.rosewoodInfo,
      TreeType.teakwood => context.l10n.teakwoodInfo,
      TreeType.coconut => context.l10n.coconutInfo,
      TreeType.jackfruit => context.l10n.jackfruitInfo,
      TreeType.mango => context.l10n.mangoInfo,
    };
  }
}
