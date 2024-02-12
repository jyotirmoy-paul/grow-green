import '../../system/growable.dart';

enum CropType implements Growable {
  maize,
  bajra,
  wheat,
  groundnut,
  pepper,
  banana,
  none;

  @override
  GrowableType getGrowableType() => GrowableType.crop;
}
