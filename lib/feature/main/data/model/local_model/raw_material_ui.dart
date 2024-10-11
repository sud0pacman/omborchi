class RawMaterialUi {
  final String? name;
  final double? price;
  final int? quantity;

  RawMaterialUi(
      {required this.name,
      required this.price,
      required this.quantity});

  RawMaterialUi copyWith({
    String? name,
    double? price,
    int? quantity,
  }) {
    return RawMaterialUi(
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  String toString() {
    return 'RawMaterialUi{name: $name, price: $price, quantity: $quantity}';
  }
}
