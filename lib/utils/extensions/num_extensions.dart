import '../responsive.dart';

extension DoubleExtension on double {
  double get s => this * Responsive().scaleFactor;
}

extension IntExtension on int {
  double get s => this * Responsive().scaleFactor;
}
