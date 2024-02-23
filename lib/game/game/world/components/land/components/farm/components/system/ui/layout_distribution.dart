import 'package:flame/game.dart';
import '../../../../../../../../enums/agroforestry_type.dart';
import '../../../../../../../../enums/farm_system_type.dart';
import '../../../../../../../../enums/system_type.dart';
import '../enum/growable.dart';

typedef LayoutData = List<GrowablePosition>;

class LayoutDistribution {
  static const tag = 'LayoutDistribution';

  final SystemType systemType;
  final double size;
  final double treeSize;
  final double cropSize;

  Vector2 get treeSizeVector2 => Vector2(treeSize * 1.6, treeSize);
  Vector2 get cropSizeVector2 => Vector2(cropSize * 1.6, cropSize);

  LayoutDistribution({
    required this.systemType,
    required this.size,
    required this.treeSize,
    required this.cropSize,
  });

  LayoutData getDistribution() {
    switch (systemType) {
      case AgroforestryType.alley:
        return _getAlleyDistribution();

      case AgroforestryType.block:
        return _getBlockDistribution();

      case AgroforestryType.boundary:
        return _getBoundaryDistribution();

      case FarmSystemType.monoculture:
        return _getMonocropDistribution();
    }

    throw Exception('Please specify agroforestry type using AgroforestryType enum!');
  }

  LayoutData _getAlleyDistribution() {
    LayoutData result = List.empty(growable: true);

    final smallestSize = 4 * treeSize + 4 * 3 * cropSize;
    if (smallestSize > size) {
      throw Exception('$tag: The given tree and crop size is not possible to be shown within $size area!');
    }

    LayoutData firstColumnTrees = _fillColumn(growable: GrowableType.tree, size: size, column: 0, numOfGrowables: 4);
    LayoutData firstColumnCrops = LayoutData.empty(growable: true);
    for (int i = 0; i < firstColumnTrees.length - 1; i++) {
      final startTree = firstColumnTrees[i];
      final endTree = firstColumnTrees[i + 1];

      final sizeAvailable = endTree.pos.y - startTree.pos.y - treeSize;
      final cropsFilled = _fillColumn(
        growable: GrowableType.crop,
        size: sizeAvailable,
        column: 0,
        numOfGrowables: 4,
        spacingOutside: true,
      );

      final cropsStartPosition = startTree.pos + Vector2(0, treeSize);
      firstColumnCrops.addAll(cropsFilled.translateBy(cropsStartPosition));
    }

    final firstColumn = firstColumnTrees + firstColumnCrops;

    for (final gp in firstColumn) {
      final row = _fillRow(growable: gp.growable, size: size, row: gp.pos.y);
      result.addAll(row);
    }
    return result;
  }

  LayoutData _getBlockDistribution() {
    LayoutData result = List.empty(growable: true);
    const treeRows = 7;
    const cropRowsPerGap = 1;
    const cropRows = (treeRows - 1) * cropRowsPerGap;
    final smallestSize = treeRows * treeSize + cropRows * cropSize;
    if (smallestSize > size) return List.empty();

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
        numOfGrowables: cropRowsPerGap,
        spacingOutside: true,
      );

      final cropsStartPosition = Vector2(0, startTree.pos.y) + Vector2(0, treeSize);
      firstColumnCrops.addAll(cropsFilled.translateBy(cropsStartPosition));
    }

    final firstColumn = firstColumnTrees + firstColumnCrops;

    for (final gp in firstColumn) {
      var row = _fillRow(growable: gp.growable, size: size, row: gp.pos.y);
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
    LayoutData result = List.empty(growable: true);

    final numOfGrowables = size ~/ treeSize;

    if (numOfGrowables == 0) return List.empty();

    final topRow = _fillRow(growable: GrowableType.tree, row: 0, size: size);
    final bottomRow = _fillRow(growable: GrowableType.tree, row: size - treeSize, size: size);
    final leftColumn = _fillColumn(growable: GrowableType.tree, column: 0, size: size);
    final rightColumn = _fillColumn(growable: GrowableType.tree, column: size - treeSize, size: size);

    result.addAll([...topRow, ...bottomRow, ...leftColumn, ...rightColumn]);

    if (result.isEmpty) return List.empty();

    final spacing = size - numOfGrowables * treeSize;
    final spacingPerTree = numOfGrowables > 1 ? spacing / (numOfGrowables - 1) : 0;
    final treeTotalSize = spacingPerTree + treeSize;

    final cropArea = size - 2 * treeTotalSize;
    final startPosition = Vector2(treeTotalSize, treeTotalSize);

    var cropResult = _fillArea(growable: GrowableType.crop, layoutSize: cropArea).translateBy(startPosition);
    result.addAll(cropResult);

    return result;
  }

  LayoutData _getMonocropDistribution() {
    return _fillArea(growable: GrowableType.crop, layoutSize: size);
  }

  LayoutData _fillRow({
    required GrowableType growable,
    required double size,
    required double row, // Assuming this is the constant X-coordinate for all positions in the column
    int? numOfGrowables,
    bool spacingOutside = false,
  }) {
    return _fillLayout(
      growable: growable,
      size: size,
      direction: _AxisDirection.horizontal,
      position: row,
      numOfGrowablesInput: numOfGrowables,
      spacingOutside: spacingOutside,
    );
  }

  LayoutData _fillColumn({
    required GrowableType growable,
    required double size,
    required double column, // Assuming this is the constant X-coordinate for all positions in the column
    int? numOfGrowables,
    bool spacingOutside = false,
  }) {
    return _fillLayout(
      growable: growable,
      size: size,
      direction: _AxisDirection.vertical,
      position: column,
      numOfGrowablesInput: numOfGrowables,
      spacingOutside: spacingOutside,
    );
  }

  LayoutData _fillArea({
    required GrowableType growable,
    required double layoutSize,
  }) {
    List<GrowablePosition> result = List.empty(growable: true);
    final firstColumn = _fillColumn(growable: growable, size: layoutSize, column: 0);
    for (final gp in firstColumn) {
      final row = _fillRow(growable: growable, size: layoutSize, row: gp.pos.y);
      result.addAll(row);
    }

    return result;
  }

  LayoutData _fillLayout({
    required GrowableType growable,
    required double position,
    required _AxisDirection direction,
    required double size,
    int? numOfGrowablesInput,
    bool spacingOutside = false,
  }) {
    // Calculate the size based on the start and end parameters.
    final growableSize = getGrowableSize(growable);
    final numOfGrowables = numOfGrowablesInput ?? size ~/ growableSize;

    if (numOfGrowables == 0) return List.empty();
    final spacing = size - numOfGrowables * growableSize;

    final insideSpacing = numOfGrowables > 1 ? spacing / (numOfGrowables - 1) : 0;
    final growableInsideSpacing = spacingOutside ? 0 : insideSpacing;
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
      double spacingShiftX() => direction == _AxisDirection.horizontal ? spacing / 2 : 0;
      double spacingShiftY() => direction == _AxisDirection.vertical ? spacing / 2 : 0;
      return positions.translateBy(Vector2(spacingShiftX(), spacingShiftY()));
    } else {
      return positions;
    }
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
