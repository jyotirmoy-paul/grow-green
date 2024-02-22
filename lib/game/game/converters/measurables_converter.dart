import 'package:json_annotation/json_annotation.dart';

import '../../../utils/extensions/string_extensions.dart';
import '../world/components/land/components/farm/components/crop/enums/crop_type.dart';
import '../world/components/land/components/farm/components/tree/enums/tree_type.dart';
import '../world/components/land/components/farm/model/fertilizer/fertilizer_type.dart';
import '../enums/measurables.dart';

class MeasurablesConverter implements JsonConverter<Measurables, String> {
  static const tag = 'MeasurablesConverter';

  const MeasurablesConverter();

  @override
  Measurables fromJson(String name) {
    final crop = name.toEnum<CropType?>(CropType.values, null);
    final tree = name.toEnum<TreeType?>(TreeType.values, null);
    final fertilizer = name.toEnum<FertilizerType?>(FertilizerType.values, null);

    return crop ??
        tree ??
        fertilizer ??
        (throw Exception('$tag: fromJson($name) failed to find enum from crop, tree, fertilizer'));
  }

  @override
  String toJson(Measurables object) {
    return object.name;
  }
}
