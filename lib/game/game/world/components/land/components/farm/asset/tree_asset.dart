import '../components/tree/enums/tree_stage.dart';
import '../components/tree/enums/tree_type.dart';

class TreeAsset {
  static const tag = 'TreeAsset';
  static const prefix = 'trees';

  final TreeType treeType;
  TreeAsset._(this.treeType);

  factory TreeAsset.of(TreeType treeType) {
    return TreeAsset._(treeType);
  }

  String at(TreeStage treeStage) {
    return '$prefix/${treeType.name}_${treeStage.name}.png';
  }
}
