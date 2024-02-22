import '../../../../../../../../enums/measurables.dart';
import '../../system/enum/growable.dart';

enum CropType implements Growable, Measurables {
  maize,
  bajra,
  wheat,
  groundnut,
  pepper,
  banana;

  @override
  GrowableType getGrowableType() => GrowableType.crop;
}
