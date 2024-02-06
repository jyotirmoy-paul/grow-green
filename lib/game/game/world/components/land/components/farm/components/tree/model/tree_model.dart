import '../enums/tree_stage.dart';
import '../enums/tree_type.dart';

class TreeModel {
  /// immutable properties
  final int treeIndex;
  final TreeType treeType;

  /// mutable properties
  TreeStage treeStage;

  TreeModel({
    required this.treeIndex,
    required this.treeType,
    required this.treeStage,
  });

  @override
  String toString() {
    return 'Tree($treeIndex, $treeType, $treeStage)';
  }
}
