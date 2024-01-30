import 'package:flutter/foundation.dart';

extension StringExtension on String? {
  bool get isEmptyOrNull => this == null || this!.isEmpty;

  T toEnum<T>(Iterable<T> values, T defaultValue) {
    for (final value in values) {
      if (describeEnum(value as Object) == this) {
        return value;
      }
    }

    return defaultValue;
  }
}
