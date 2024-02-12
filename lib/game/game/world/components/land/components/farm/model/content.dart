/// quantity is in game units
class Content<T extends Enum> {
  final T type;
  final int quantity;

  Content({
    required this.type,
    required this.quantity,
  });

  @override
  String toString() {
    return 'Content(${type.name}, $quantity)';
  }

  factory Content.empty(T type) {
    return Content<T>(
      type: type,
      quantity: 0,
    );
  }

  bool get isEmpty => quantity == 0;
  bool get isNotEmpty => !isEmpty;
}
