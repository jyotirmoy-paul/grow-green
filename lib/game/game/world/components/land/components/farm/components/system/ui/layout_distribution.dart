import 'package:flame/game.dart';
import '../../../../../../../../enums/agroforestry_type.dart';
import '../../../../../../../../enums/farm_system_type.dart';
import '../../../../../../../../enums/system_type.dart';
import '../../crop/enums/crop_type.dart';
import '../../tree/enums/tree_type.dart';
import '../growable.dart';

typedef LayoutData = List<GrowablePosition>;

class LayoutDistribution {
  final SystemType systemType;
  final TreeType treeType;
  final CropType cropType;
  final double size;
  final double treeSize;
  final double cropSize;

  LayoutDistribution({
    required this.systemType,
    TreeType? tt,
    required this.cropType,
    required this.size,
    required this.treeSize,
    required this.cropSize,
  }) : treeType = tt ?? TreeType.cocounut;

  LayoutData getDistribution() {
    switch (systemType) {
      case AgroforestryType.alley:
        return _getAlleyDistribution(boundarySize: size);

      case AgroforestryType.block:
        return _getBlockDistribution(boundarySize: size);

      case AgroforestryType.boundary:
        return _getBoundaryDistribution(boundarySize: size);

      case FarmSystemType.monoculture:
        return _getMonocropDistribution();
    }

    throw Exception('Please specify agroforestry type using AgroforestryType enum!');
  }

  LayoutData _getAlleyDistribution({required double boundarySize}) {
    LayoutData result = List.empty(growable: true);

    final smallestSize = 4 * treeSize + 4 * 3 * cropSize;
    if (smallestSize > boundarySize) return List.empty();

    LayoutData firstColumnTrees = _fillColumn(growable: treeType, size: size, column: 0, numOfGrowables: 4);
    LayoutData firstColumnCrops = LayoutData.empty(growable: true);
    for (int i = 0; i < firstColumnTrees.length - 1; i++) {
      final startTree = firstColumnTrees[i];
      final endTree = firstColumnTrees[i + 1];

      final sizeAvailable = endTree.pos.y - startTree.pos.y - treeSize;
      final cropsFilled = _fillColumn(
        growable: cropType,
        size: sizeAvailable,
        column: 0,
        numOfGrowables: 4,
        spacingOutside: true,
      );

      final cropsStartPosition = startTree.pos + Position(0, treeSize);
      firstColumnCrops.addAll(cropsFilled.translateBy(cropsStartPosition));
    }

    final firstColumn = firstColumnTrees + firstColumnCrops;

    for (final gp in firstColumn) {
      final row = _fillRow(growable: gp.growable, size: size, row: gp.pos.y);
      result.addAll(row);
    }
    return result;
  }

  LayoutData _getBlockDistribution({required double boundarySize}) {
    LayoutData result = List.empty(growable: true);
    const treeRows = 7;
    const cropRowsPerGap = 1;
    const cropRows = (treeRows - 1) * cropRowsPerGap;
    final smallestSize = treeRows * treeSize + cropRows * cropSize;
    if (smallestSize > boundarySize) return List.empty();

    LayoutData firstColumnTrees = _fillColumn(growable: treeType, size: size, column: 0, numOfGrowables: treeRows);

    for (int i = 1; i < firstColumnTrees.length; i += 2) {
      final translation = Position(treeSize / 2, 0);
      final newPosition = firstColumnTrees[i].pos + translation;
      firstColumnTrees[i] = firstColumnTrees[i].copyWith(pos: newPosition);
    }

    LayoutData firstColumnCrops = LayoutData.empty(growable: true);
    for (int i = 0; i < firstColumnTrees.length - 1; i++) {
      final startTree = firstColumnTrees[i];
      final endTree = firstColumnTrees[i + 1];

      final sizeAvailable = endTree.pos.y - startTree.pos.y - treeSize;
      final cropsFilled = _fillColumn(
        growable: cropType,
        size: sizeAvailable,
        column: 0,
        numOfGrowables: cropRowsPerGap,
        spacingOutside: true,
      );

      final cropsStartPosition = Position(0, startTree.pos.y) + Position(0, treeSize);
      firstColumnCrops.addAll(cropsFilled.translateBy(cropsStartPosition));
    }

    final firstColumn = firstColumnTrees + firstColumnCrops;

    for (final gp in firstColumn) {
      var row = _fillRow(growable: gp.growable, size: size, row: gp.pos.y);
      if (gp.pos.x != 0) {
        final translation = Position(gp.pos.x, 0);
        row = row.translateBy(translation);
        row.removeLast();
      }
      result.addAll(row);
    }
    return result;
  }

  LayoutData _getBoundaryDistribution({
    required double boundarySize,
  }) {
    LayoutData result = List.empty(growable: true);

    final numOfGrowables = boundarySize ~/ treeSize;

    if (numOfGrowables == 0) return List.empty();

    final topRow = _fillRow(growable: treeType, row: 0, size: boundarySize);
    final bottomRow = _fillRow(growable: treeType, row: boundarySize - treeSize, size: boundarySize);
    final leftColumn = _fillColumn(growable: treeType, column: 0, size: boundarySize);
    final rightColumn = _fillColumn(growable: treeType, column: boundarySize - treeSize, size: boundarySize);

    result.addAll([...topRow, ...bottomRow, ...leftColumn, ...rightColumn]);

    if (result.isEmpty) return List.empty();

    final spacing = boundarySize - numOfGrowables * treeSize;
    final spacingPerTree = numOfGrowables > 1 ? spacing / (numOfGrowables - 1) : 0;
    final treeTotalSize = spacingPerTree + treeSize;

    final cropArea = boundarySize - 2 * treeTotalSize;
    final startPosition = Position(treeTotalSize, treeTotalSize);

    var cropResult = _fillArea(growable: cropType, layoutSize: cropArea).translateBy(startPosition);
    result.addAll(cropResult);

    return result;
  }

  LayoutData _getMonocropDistribution() {
    return _fillArea(growable: cropType, layoutSize: size);
  }

  LayoutData _fillRow({
    required Growable growable,
    required double size,
    required double row, // Assuming this is the constant X-coordinate for all positions in the column
    int? numOfGrowables,
    bool spacingOutside = false,
  }) {
    return _fillLayout(
      growable: growable,
      size: size,
      direction: AxisDirection.horizontal,
      position: row,
      numOfGrowablesInput: numOfGrowables,
      spacingOutside: spacingOutside,
    );
  }

  LayoutData _fillColumn({
    required Growable growable,
    required double size,
    required double column, // Assuming this is the constant X-coordinate for all positions in the column
    int? numOfGrowables,
    bool spacingOutside = false,
  }) {
    return _fillLayout(
      growable: growable,
      size: size,
      direction: AxisDirection.vertical,
      position: column,
      numOfGrowablesInput: numOfGrowables,
      spacingOutside: spacingOutside,
    );
  }

  LayoutData _fillArea({
    required Growable growable,
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
    required Growable growable,
    required double position,
    required AxisDirection direction,
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
    double getX(int index) => direction == AxisDirection.horizontal ? index * growableTotalSize : position;
    double getY(int index) => direction == AxisDirection.vertical ? index * growableTotalSize : position;

    // Pre-calculate the positions and create GrowablePosition objects in one go.
    final positions = List.generate(numOfGrowables, (i) {
      return GrowablePosition(pos: Position(getX(i), getY(i)), growable: growable);
    });

    // If spacing is outside, shift the positions by half the spacing.
    if (spacingOutside) {
      double spacingShiftX() => direction == AxisDirection.horizontal ? spacing / 2 : 0;
      double spacingShiftY() => direction == AxisDirection.vertical ? spacing / 2 : 0;
      return positions.translateBy(Position(spacingShiftX(), spacingShiftY()));
    } else {
      return positions;
    }
  }

  double getGrowableSize(Growable growable) => growable.getGrowableType() == GrowableType.tree ? treeSize : cropSize;
}

class GrowablePosition {
  final Position pos;
  final Growable growable;

  GrowablePosition({required this.pos, required this.growable});

  @override
  String toString() {
    return 'GrowablePosition($pos, $growable)';
  }

  GrowablePosition copyWith({Position? pos, Growable? growable}) {
    return GrowablePosition(
      pos: pos ?? this.pos,
      growable: growable ?? this.growable,
    );
  }
}

class Position {
  final double x;
  final double y;

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

  static Position fromSize(double size) => Position(size, size);

  Vector2 toVector2() {
    return Vector2(x.toDouble(), y.toDouble());
  }

  @override
  String toString() {
    return 'Position($x, $y)';
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
    return Position(x / other.x, y / other.y);
  }

  // For scalar operations, you can define additional methods or extensions.
  Position multiplyByScalar(int scalar) {
    return Position(x * scalar, y * scalar);
  }

  Position divideByScalar(double scalar) {
    if (scalar == 0) {
      throw ArgumentError("Cannot divide by zero scalar");
    }
    return Position(x / scalar, y / scalar);
  }
}

enum AxisDirection {
  horizontal,
  vertical,
}

extension LayoutDataExtension on LayoutData {
  LayoutData translateBy(Position t) {
    return map((e) => GrowablePosition(pos: e.pos + t, growable: e.growable)).toList();
  }
}
