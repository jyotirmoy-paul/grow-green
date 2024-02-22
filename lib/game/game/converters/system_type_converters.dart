import 'package:json_annotation/json_annotation.dart';

import '../../../utils/extensions/string_extensions.dart';
import '../enums/agroforestry_type.dart';
import '../enums/farm_system_type.dart';
import '../enums/system_type.dart';

class SystemTypeConverter implements JsonConverter<SystemType, String> {
  static const tag = 'SystemTypeConverter';

  const SystemTypeConverter();

  @override
  SystemType fromJson(String name) {
    final agroforestryType = name.toEnum<AgroforestryType?>(AgroforestryType.values, null);
    final farmSystemType = name.toEnum<FarmSystemType?>(FarmSystemType.values, null);

    return agroforestryType ??
        farmSystemType ??
        (throw Exception('$tag: fromJson($name) failed to find enum from agroforestryType, farmSystemType'));
  }

  @override
  String toJson(SystemType object) {
    return object.name;
  }
}
