import 'package:flame/game.dart';

import '../../../../../../../../../../services/log/log.dart';
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
    required this.treeType,
    required this.cropType,
    required this.size,
    this.treeSize = 1,
    this.cropSize = 1,
  });

  LayoutData getDistribution() {
    switch (systemType) {
      case AgroforestryType.alley:
        return _getAlleyDistribution();

      case AgroforestryType.block:
        return _getBlockDistribution();

      case AgroforestryType.boundary:
        return _getBoundaryDistribution(growable: treeType, boundarySize: size, origin: 0);

      case FarmSystemType.monoculture:
        return _getMonocropDistribution();
    }

    throw Exception('Please specify agroforestry type using AgroforestryType enum!');
  }

  LayoutData _getAlleyDistribution() {
    throw Exception('Alley Distribution is not implemented yet!');
  }

  LayoutData _getBlockDistribution() {
    throw Exception('Block Distribution is not implemented yet!');
  }

  LayoutData _getBoundaryDistribution({
    required double boundarySize,
    required Growable growable,
    required double origin,
  }) {
    LayoutData result = List.empty(growable: true);
    double growableSize = getGrowableSize(growable);

    if (boundarySize ~/ growableSize == 0) return List.empty();
    final topRow = _fillRow(
      growable: growable,
      row: origin,
      size: boundarySize,
    );
    final bottomRow = _fillRow(
      growable: growable,
      row: boundarySize - growableSize,
      size: boundarySize,
    );
    final leftColumn = _fillColumn(
      growable: growable,
      column: origin,
      size: boundarySize,
    );
    final rightColumn = _fillColumn(
      growable: growable,
      column: boundarySize - growableSize,
      size: boundarySize,
    );

    result.addAll(topRow);
    result.addAll(bottomRow);
    result.addAll(leftColumn);
    result.addAll(rightColumn);

    if (result.isEmpty) return List.empty();

    final cropArea = boundarySize - 2 * growableSize;
    final startPosition = origin + getGrowableSize(growable);
    var cropResult = _getBoundaryDistribution(
      boundarySize: cropArea,
      growable: cropType,
      origin: 0,
    );

    cropResult = cropResult.map((e) {
      return GrowablePosition(
        pos: e.pos + Position(startPosition, startPosition),
        growable: e.growable,
      );
    }).toList();

    result.addAll(cropResult);

    return result;
  }

  LayoutData _getMonocropDistribution() {
    throw Exception('_getMonocropDistribution not implemented');
  }

  LayoutData _fillRow({
    required Growable growable,
    required double size,
    required double row, // Assuming this is the constant X-coordinate for all positions in the column
  }) {
    return _fillLayout(
      growable: growable,
      size: size,
      direction: AxisDirection.horizontal,
      position: row,
    );
  }

  LayoutData _fillColumn({
    required Growable growable,
    required double size,
    required double column, // Assuming this is the constant X-coordinate for all positions in the column
  }) {
    return _fillLayout(
      growable: growable,
      size: size,
      direction: AxisDirection.vertical,
      position: column,
    );
  }

  LayoutData _fillLayout({
    required Growable growable,
    required double position,
    required AxisDirection direction,
    required double size,
  }) {
    // Calculate the size based on the start and end parameters.
    final growableSize = getGrowableSize(growable);
    final numOfGrowables = size ~/ growableSize;

    if (numOfGrowables == 0) return List.empty();

    final spacing = size - numOfGrowables * growableSize;
    final spacingPerGrowable = numOfGrowables > 1 ? spacing / (numOfGrowables - 1) : 0;
    final growableTotalSize = spacingPerGrowable + growableSize;

    // Adjust getX and getY functions to include the start offset.
    double getX(int index) => direction == AxisDirection.horizontal ? index * growableTotalSize : position;
    double getY(int index) => direction == AxisDirection.vertical ? index * growableTotalSize : position;

    // Pre-calculate the positions and create GrowablePosition objects in one go.
    List<GrowablePosition> positions = List.generate(numOfGrowables, (i) {
      return GrowablePosition(pos: Position(getX(i), getY(i)), growable: growable);
    });

    Log.i("result $positions");
    return positions;
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
