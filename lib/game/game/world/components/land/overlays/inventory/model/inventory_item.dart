import 'package:equatable/equatable.dart';

class InventoryItem extends Equatable {
  final int id;
  final String name;
  final String image;
  final int? quantity;

  const InventoryItem({
    required this.id,
    required this.name,
    required this.image,
    this.quantity,
  });

  bool get isEmpty => quantity == null || quantity == 0;

  InventoryItem copyWith({
    int? id,
    String? name,
    String? image,
    int? quantity,
  }) {
    return InventoryItem(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  String toString() {
    return 'InventoryItem($id, $name, $image, $quantity)';
  }

  @override
  List<Object?> get props => [
        id,
        name,
        image,
        quantity,
      ];
}
