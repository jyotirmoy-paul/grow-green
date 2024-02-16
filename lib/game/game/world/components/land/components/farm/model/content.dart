import '../components/system/real_life/calculators/qty.dart';

/// quantity is in game units
class Content<T extends Enum> {
  final T type;
  final Qty qty;

  const Content({
    required this.type,
    required this.qty,
  });

  @override
  String toString() {
    return 'Content(${type.name}, $qty)';
  }

  factory Content.empty(T type) {
    return Content<T>(
      type: type,
      qty: const Qty(value: 0, scale: Scale.units),
    );
  }

  bool get isEmpty => qty.value == 0;
  bool get isNotEmpty => !isEmpty;
}
