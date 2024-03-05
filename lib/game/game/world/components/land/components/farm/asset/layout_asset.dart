import '../../../../../../enums/system_type.dart';

class LayoutAsset {
  final SystemType systemType;
  final String prefix;

  LayoutAsset._(this.systemType, this.prefix);

  factory LayoutAsset.of(SystemType cropType) {
    return LayoutAsset._(cropType, 'crops');
  }

  factory LayoutAsset.raw(SystemType systemType) {
    return LayoutAsset._(systemType, 'assets/images/layouts');
  }

  String get _path {
    return '$prefix/${systemType.name}.png';
  }

  static String representativeOf(SystemType systemType) {
    return LayoutAsset.raw(systemType)._path;
  }
}
