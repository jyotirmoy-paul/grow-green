import 'package:flame/game.dart';

import '../../../../../../../../enums/agroforestry_type.dart';
import '../../../../../../../../enums/farm_system_type.dart';
import '../../../../../../../../enums/system_type.dart';
import '../../crop/enums/crop_type.dart';
import '../enum/growable.dart';

typedef LayoutData = List<GrowablePosition>;

class LayoutDistribution {
  static const padding = 30.0;
  static const tag = 'LayoutDistribution';

  final SystemType systemType;
  final double size;
  final double treeSize;
  final double cropSize;

  /// it's such a bad idea to have cropType here, but limited by assets!
  final CropType? cropType;

  final Vector2 treeSizeVector2;
  final Vector2 cropSizeVector2;

  LayoutDistribution({
    required double size,
    required this.systemType,
    required this.treeSize,
    required this.cropSize,
    this.cropType,
  })  : size = systemType == FarmSystemType.monoculture ? size : size - padding * 2,
        treeSizeVector2 = Vector2(treeSize * 1.6, treeSize),
        cropSizeVector2 = Vector2(cropSize * 1.6, cropSize);

  LayoutData _processDistribution(LayoutData data) {
    for (final d in data) {
      d.pos.translate(padding, padding);
    }
    return data;
  }

  LayoutData getDistribution() {
    switch (systemType) {
      case AgroforestryType.alley:
        return _processDistribution(_getAlleyDistribution());

      case AgroforestryType.block:
        return _processDistribution(_getBlockDistribution());

      case AgroforestryType.boundary:
        return _processDistribution(_getBoundaryDistribution());

      case FarmSystemType.monoculture:
        return _processDistribution(_getMonocropDistribution());
    }

    throw Exception('Please specify agroforestry type using AgroforestryType enum!');
  }

  LayoutData _getAlleyDistribution() {
    /// tree values
    const treeRows = 3;
    const treeCols = 8;

    /// crop values
    final cropOnEachLine = switch (cropType) {
      CropType.maize => 50,
      CropType.bajra => 50,
      CropType.wheat => 50,
      CropType.groundnut => 30,
      CropType.pepper => 30,
      CropType.banana => 10,
      null => 0,
    };

    final cropFiles = switch (cropType) {
      CropType.maize => 8,
      CropType.bajra => 8,
      CropType.wheat => 8,
      CropType.groundnut => 6,
      CropType.pepper => 6,
      CropType.banana => 5,
      null => 0,
    };

    final double gapBetweenCropFiles = switch (cropType) {
      CropType.maize => 2,
      CropType.bajra => 2,
      CropType.wheat => -1,
      CropType.groundnut => 13,
      CropType.pepper => 13,
      CropType.banana => 5,
      null => 0,
    };

    final result = <GrowablePosition>[];

    final smallestSize = 4 * treeSize + 4 * 3 * cropSize;
    if (smallestSize > size) {
      throw Exception(
        '$tag: _getAlleyDistribution(): The given tree and crop size is not possible to be shown within $size area!',
      );
    }

    LayoutData firstColumnTrees = _fillColumn(
      growable: GrowableType.tree,
      size: size,
      column: 0,
      numOfGrowables: treeRows,
    );

    LayoutData firstColumnCrops = LayoutData.empty(growable: true);
    for (int i = 0; i < firstColumnTrees.length - 1; i++) {
      final startTree = firstColumnTrees[i];
      final endTree = firstColumnTrees[i + 1];

      final sizeAvailable = endTree.pos.y - startTree.pos.y - treeSize;
      final cropsFilled = _fillColumn(
        growable: GrowableType.crop,
        size: sizeAvailable,
        column: 0,
        numOfGrowables: cropFiles,
        spacingOutside: true,
        gap: gapBetweenCropFiles,
      );

      final cropsStartPosition = startTree.pos + Vector2(0, treeSize);
      firstColumnCrops.addAll(cropsFilled.translateBy(cropsStartPosition));
    }

    final firstColumn = firstColumnTrees + firstColumnCrops;

    for (final gp in firstColumn) {
      final row = _fillRow(
        growable: gp.growable,
        size: size,
        row: gp.pos.y,
        numOfGrowables: gp.growable.isTree ? treeCols : cropOnEachLine,
      );
      result.addAll(row);
    }

    return result;
  }

  LayoutData _getBlockDistribution() {
    /// tree values
    const treeRows = 5;
    const treeCols = 8;

    /// crop values
    final cropOnEachLine = switch (cropType) {
      CropType.maize => 50,
      CropType.bajra => 50,
      CropType.wheat => 50,
      CropType.groundnut => 30,
      CropType.pepper => 30,
      CropType.banana => 12,
      null => 0,
    };

    final cropFiles = switch (cropType) {
      CropType.maize => 3,
      CropType.bajra => 3,
      CropType.wheat => 3,
      CropType.groundnut => 2,
      CropType.pepper => 2,
      CropType.banana => 1,
      null => 0,
    };

    final double gapBetweenCropFiles = switch (cropType) {
      CropType.maize => 2,
      CropType.bajra => 2,
      CropType.wheat => -2,
      CropType.groundnut => 4,
      CropType.pepper => 6,
      CropType.banana => 0,
      null => 0,
    };

    final result = <GrowablePosition>[];

    LayoutData firstColumnTrees = _fillColumn(
      growable: GrowableType.tree,
      size: size,
      column: 0,
      numOfGrowables: treeRows,
    );

    for (int i = 1; i < firstColumnTrees.length; i += 2) {
      final translation = Vector2(treeSize / 2, 0);
      final newPosition = firstColumnTrees[i].pos + translation;
      firstColumnTrees[i] = firstColumnTrees[i].copyWith(pos: newPosition);
    }

    LayoutData firstColumnCrops = LayoutData.empty(growable: true);
    for (int i = 0; i < firstColumnTrees.length - 1; i++) {
      final startTree = firstColumnTrees[i];
      final endTree = firstColumnTrees[i + 1];

      final sizeAvailable = endTree.pos.y - startTree.pos.y - treeSize;
      final cropsFilled = _fillColumn(
        growable: GrowableType.crop,
        size: sizeAvailable,
        column: 0,
        numOfGrowables: cropFiles,
        spacingOutside: true,
        gap: gapBetweenCropFiles,
      );

      final cropsStartPosition = Vector2(0, startTree.pos.y) + Vector2(0, treeSize);
      firstColumnCrops.addAll(cropsFilled.translateBy(cropsStartPosition));
    }

    final firstColumn = firstColumnTrees + firstColumnCrops;

    for (final gp in firstColumn) {
      var row = _fillRow(
        growable: gp.growable,
        size: size,
        row: gp.pos.y,
        numOfGrowables: gp.growable.isTree ? treeCols : cropOnEachLine,
      );

      if (gp.pos.x != 0) {
        final translation = Vector2(gp.pos.x, 0);
        row = row.translateBy(translation);
        row.removeLast();
      }
      result.addAll(row);
    }
    return result;
  }

  LayoutData _getBoundaryDistribution() {
    const treeNos = 8;

    final result = <GrowablePosition>[];
    final numOfGrowables = size ~/ treeSize;
    if (numOfGrowables == 0) {
      throw Exception('$tag: _getBoundaryDistribution() invoked with impossible combination of tree size!');
    }

    const gtree = GrowableType.tree;
    final topRow = _fillRow(growable: gtree, row: 0, size: size, numOfGrowables: treeNos);
    final bottomRow = _fillRow(growable: gtree, row: size - treeSize, size: size, numOfGrowables: treeNos);
    final leftColumn = _fillColumn(growable: gtree, column: 0, size: size, numOfGrowables: treeNos);
    final rightColumn = _fillColumn(growable: gtree, column: size - treeSize, size: size, numOfGrowables: treeNos);

    result.addAll([...topRow, ...bottomRow, ...leftColumn, ...rightColumn]);

    if (result.isEmpty) return List.empty();

    final spacing = size - numOfGrowables * treeSize;
    final spacingPerTree = numOfGrowables > 1 ? spacing / (numOfGrowables - 1) : 0;
    final treeTotalSize = spacingPerTree + treeSize;

    final cropArea = size - 2 * treeTotalSize;
    final startPosition = Vector2(treeTotalSize, treeTotalSize);

    final cropOnEachLine = switch (cropType) {
      CropType.maize => 45,
      CropType.bajra => 40,
      CropType.wheat => 40,
      CropType.groundnut => 25,
      CropType.pepper => 28,
      CropType.banana => 13,
      null => 0,
    };

    final cropFiles = switch (cropType) {
      CropType.maize => 12,
      CropType.bajra => 11,
      CropType.wheat => 10,
      CropType.groundnut => 10,
      CropType.pepper => 11,
      CropType.banana => 6,
      null => 0,
    };

    final actualAreaForCrop = switch (cropType) {
      CropType.banana => cropArea - 3 * cropSize,
      CropType.groundnut => cropArea - 2 * cropSize,
      CropType.wheat => cropArea - 2 * cropSize,
      _ => cropArea,
    };

    final remainingArea = cropArea - actualAreaForCrop;

    var cropResult = _fillArea(
      growable: GrowableType.crop,
      layoutSize: actualAreaForCrop,
      columnNumOfGrowables: cropOnEachLine,
      rowNumOfGrowables: cropFiles,
    ).translateBy(startPosition + Vector2.all(remainingArea / 4));

    result.addAll(cropResult);

    return result;
  }

  LayoutData _getMonocropDistribution() {
    final cropOnEachLine = switch (cropType) {
      CropType.maize => 60,
      CropType.bajra => 50,
      CropType.wheat => 60,
      CropType.groundnut => 35,
      CropType.pepper => 38,
      CropType.banana => 17,
      null => 0,
    };

    final cropFiles = switch (cropType) {
      CropType.maize => 13,
      CropType.bajra => 11,
      CropType.wheat => 11,
      CropType.groundnut => 11,
      CropType.pepper => 12,
      CropType.banana => 8,
      null => 0,
    };

    final actualAreaForCrop = size - 2 * cropSize;

    return _fillArea(
      growable: GrowableType.crop,
      layoutSize: actualAreaForCrop,
      columnNumOfGrowables: cropOnEachLine,
      rowNumOfGrowables: cropFiles,
    );
  }

  LayoutData _fillRow({
    required GrowableType growable,
    required double size,
    required double row, // Assuming this is the constant X-coordinate for all positions in the column
    int? numOfGrowables,
    bool spacingOutside = false,
    double? gap,
  }) {
    return _fillLayout(
      growable: growable,
      size: size,
      direction: _AxisDirection.horizontal,
      position: row,
      numOfGrowablesInput: numOfGrowables,
      spacingOutside: spacingOutside,
      gap: gap,
    );
  }

  LayoutData _fillColumn({
    required GrowableType growable,
    required double size,
    required double column, // Assuming this is the constant X-coordinate for all positions in the column
    int? numOfGrowables,
    bool spacingOutside = false,
    double? gap,
  }) {
    return _fillLayout(
      growable: growable,
      size: size,
      direction: _AxisDirection.vertical,
      position: column,
      numOfGrowablesInput: numOfGrowables,
      spacingOutside: spacingOutside,
      gap: gap,
    );
  }

  LayoutData _fillArea({
    required GrowableType growable,
    required double layoutSize,
    int? columnNumOfGrowables,
    bool columnSpacingOutside = false,
    double? columnGap,
    int? rowNumOfGrowables,
    bool rowSpacingOutside = false,
    double? rowGap,
  }) {
    final result = <GrowablePosition>[];

    final firstColumn = _fillColumn(
      growable: growable,
      size: layoutSize,
      column: 0,
      numOfGrowables: columnNumOfGrowables,
      spacingOutside: columnSpacingOutside,
      gap: columnGap,
    );

    for (final gp in firstColumn) {
      final row = _fillRow(
        growable: growable,
        size: layoutSize,
        row: gp.pos.y,
        numOfGrowables: rowNumOfGrowables,
        spacingOutside: rowSpacingOutside,
        gap: rowGap,
      );

      result.addAll(row);
    }

    return result;
  }

  LayoutData _fillLayout({
    required GrowableType growable,
    required double position,
    required _AxisDirection direction,
    required double size,
    double? gap,
    int? numOfGrowablesInput,
    bool spacingOutside = false,
  }) {
    // Calculate the size based on the start and end parameters.
    final growableSize = getGrowableSize(growable);
    final numOfGrowables = numOfGrowablesInput ?? size ~/ growableSize;

    if (numOfGrowables == 0) return List.empty();
    final spacing = size - numOfGrowables * growableSize;

    final insideSpacing = numOfGrowables > 1 ? spacing / (numOfGrowables - 1) : 0;
    final growableInsideSpacing = spacingOutside ? (gap ?? 0) : insideSpacing;
    final growableTotalSize = growableInsideSpacing + growableSize;

    // Adjust getX and getY functions to include the start offset.
    double getX(int index) => direction == _AxisDirection.horizontal ? index * growableTotalSize : position;
    double getY(int index) => direction == _AxisDirection.vertical ? index * growableTotalSize : position;

    // Pre-calculate the positions and create GrowablePosition objects in one go.
    final positions = List.generate(numOfGrowables, (i) {
      return GrowablePosition(pos: Vector2(getX(i), getY(i)), growable: growable);
    });

    // If spacing is outside, shift the positions by half the spacing.
    if (spacingOutside) {
      final s = gap ?? 0;

      double spacingShiftX() => direction == _AxisDirection.horizontal ? (spacing / 2) - 2 * s : 0;
      double spacingShiftY() => direction == _AxisDirection.vertical ? (spacing / 2) - 2 * s : 0;

      return positions.translateBy(Vector2(spacingShiftX(), spacingShiftY()));
    }

    return positions;
  }

  double getGrowableSize(GrowableType growable) => growable == GrowableType.tree ? treeSize : cropSize;
}

class GrowablePosition {
  final Vector2 pos;
  final GrowableType growable;

  GrowablePosition({required this.pos, required this.growable});

  @override
  String toString() {
    return 'GrowablePosition($pos, $growable)';
  }

  GrowablePosition copyWith({Vector2? pos, GrowableType? growable}) {
    return GrowablePosition(
      pos: pos ?? this.pos,
      growable: growable ?? this.growable,
    );
  }
}

enum _AxisDirection {
  horizontal,
  vertical,
}

extension _LayoutDataExtension on LayoutData {
  LayoutData translateBy(Vector2 t) {
    return map((e) => GrowablePosition(pos: e.pos + t, growable: e.growable)).toList();
  }
}
