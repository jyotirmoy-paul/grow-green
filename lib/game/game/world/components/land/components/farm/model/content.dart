/// quantity is in game units
class Content<T extends Enum> {
  final T type;
  final double quantity;

  Content({
    required this.type,
    required this.quantity,
  });

  @override
  String toString() {
    return 'GrowableContent(${type.name}, $quantity)';
  }
}
