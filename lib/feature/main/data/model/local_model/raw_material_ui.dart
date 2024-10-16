import '../../../domain/model/raw_material.dart';
import '../../../domain/model/raw_material_type.dart';

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
class RawMaterialUpdate {
  final RawMaterial? rawMaterial;
  final RawMaterialType? rawMaterialType;
  final int? quantity;
  final int? costId;

  RawMaterialUpdate({
    required this.rawMaterial,
    required this.rawMaterialType,
    required this.quantity,
    this.costId
  });

  RawMaterialUpdate copyWith({
    RawMaterial? rawMaterial,
    RawMaterialType? rawMaterialType,
    int? quantity,
  }) {
    return RawMaterialUpdate(
      rawMaterial: rawMaterial ?? this.rawMaterial,
      rawMaterialType: rawMaterialType ?? this.rawMaterialType,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  String toString() {
    return 'RawMaterialUpdate{rawMaterial: $rawMaterial, rawMaterialType: $rawMaterialType, quantity: $quantity}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! RawMaterialUpdate) return false;

    return other.rawMaterial == rawMaterial &&
        other.rawMaterialType == rawMaterialType &&
        other.quantity == quantity;
  }

  @override
  int get hashCode => Object.hash(rawMaterial, rawMaterialType, quantity);
}

