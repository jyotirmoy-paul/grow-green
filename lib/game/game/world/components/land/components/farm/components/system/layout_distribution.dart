import 'dart:math';

import '../crop/enums/crop_type.dart';
import '../tree/enums/tree_type.dart';
import 'growable.dart';
import 'system_type.dart';

typedef LayoutData = List<GrowablePosition>;

class LayoutDistribution {
  final SystemType systemType;
  final TreeType treeType;
  final CropType cropType;
  final int size;
  final int treeSize;
  final int cropSize;
  final int treeSpacing;
  final int cropSpacing;

  LayoutDistribution({
    required this.systemType,
    required this.treeType,
    required this.cropType,
    required this.size,
    this.treeSize = 1,
    this.cropSize = 1,
    this.treeSpacing = 0,
    this.cropSpacing = 0,
  });

  LayoutData getDistribution() {
    switch (systemType) {
      case SystemType.alley:
        return _getAlleyDistribution();
      case SystemType.block:
        return _getBlockDistribution();
      case SystemType.boundary:
        return _getBoundaryDistribution();
      case SystemType.monocrop:
        return _getMonocropDistribution();
    }
  }

  LayoutData _getAlleyDistribution() {
    return null!;
  }

  LayoutData _getBlockDistribution() {
    return null!;
  }

  LayoutData _getBoundaryDistribution() {
    final totalTreeSize = _getTotalSize(treeType);
    final numOfTreesPerSide = size ~/ totalTreeSize;
    final modifiedSize = numOfTreesPerSide * totalTreeSize;
    LayoutData result = List.empty(growable: true);

    final topRow = _fillRow(growable: treeType, row: 0, endToX: modifiedSize - 1);
    final bottomRow = _fillRow(growable: treeType, row: modifiedSize - totalTreeSize, endToX: modifiedSize - 1);
    final leftColumn = _fillColumn(growable: treeType, column: 0, spacing: 0, n: numOfTreesPerSide);
    final rightColumn =
        _fillColumn(growable: treeType, column: modifiedSize - totalTreeSize, spacing: 0, n: numOfTreesPerSide);

    final cropLeftoverArea = Position.fromSize(modifiedSize) - Position.fromSize(2 * _getTotalSize(treeType));
    final cropArea = _fillArea(cropType, Position.fromSize(_getTotalSize(treeType)), cropLeftoverArea);

    result.addAll(topRow);
    result.addAll(bottomRow);
    result.addAll(leftColumn);
    result.addAll(rightColumn);
    result.addAll(cropArea);
    return result;
  }

  LayoutData _getMonocropDistribution() {
    return _fillArea(cropType, Position.zero, Position(size, size));
  }

  LayoutData _fillRow({
    required Growable growable,
    required int row,
    required int endToX,
    startFromX = 0,
  }) {
    final rowSize = endToX - startFromX + 1;
    final n = rowSize ~/ _getTotalSize(growable);
    var positions = List.generate(n, (i) => Position(i * _getTotalSize(growable), row));
    positions = positions.map((pos) => pos.translateXBy(startFromX)).toList();
    return positions.map((pos) => GrowablePosition(pos: pos, growable: growable)).toList();
  }

  LayoutData _fillColumn({required Growable growable, required int column, required int spacing, required int n}) {
    final totalSize = spacing + _getTotalSize(growable);
    final positions = List.generate(n, (i) => Position(column, i * totalSize));
    return positions.map((pos) => GrowablePosition(pos: pos, growable: growable)).toList();
  }

  LayoutData _fillArea(Growable growable, Position startPos, Position area) {
    LayoutData result = List.empty(growable: true);
    final growablesPerColumn = area.y ~/ _getTotalSize(growable);

    for (int j = 0; j < growablesPerColumn; j++) {
      final rowStartPos = startPos.translateYBy(j * _getTotalSize(growable));
      final row = _fillRow(
        growable: growable,
        row: rowStartPos.y,
        endToX: startPos.x + area.x - 1,
        startFromX: rowStartPos.x,
      );
      result.addAll(row);
    }
    return result;
  }

  int _getTotalSize(Growable growable) {
    final isTree = growable.getGrowableType() == GrowableType.tree;
    if (isTree) return treeSize + treeSpacing;
    return cropSize + cropSpacing;
  }
}

class GrowablePosition {
  final Position pos;
  final Growable growable;

  GrowablePosition({required this.pos, required this.growable});
}

class Position {
  final int x;
  final int y;

  const Position(this.x, this.y);

  Position translateXBy(int t) {
    return Position(t + x, y);
  }

  Position translateYBy(int t) {
    return Position(x, y + t);
  }

  Position transpose() {
    return Position(y, x);
  }

  factory Position.copy(Position p) {
    return Position(p.x, p.y);
  }

  static const zero = Position(0, 0);

  static Position fromSize(int size) => Position(size, size);

  @override
  String toString() {
    return "(${x},${y})";
  }
}

extension PositionMathOperators on Position {
  Position operator +(Position other) {
    return Position(x + other.x, y + other.y);
  }

  Position operator -(Position other) {
    return Position(x - other.x, y - other.y);
  }

  // Multiplication and division will interpret the other Position's x and y as factors or divisors for the respective coordinates.
  Position operator *(Position other) {
    return Position(x * other.x, y * other.y);
  }

  Position operator /(Position other) {
    if (other.x == 0 || other.y == 0) {
      throw ArgumentError("Cannot divide by zero in Position division");
    }
    return Position(x ~/ other.x, y ~/ other.y);
  }

  // For scalar operations, you can define additional methods or extensions.
  Position multiplyByScalar(int scalar) {
    return Position(x * scalar, y * scalar);
  }

  Position divideByScalar(int scalar) {
    if (scalar == 0) {
      throw ArgumentError("Cannot divide by zero scalar");
    }
    return Position(x ~/ scalar, y ~/ scalar);
  }
}
