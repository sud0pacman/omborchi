import 'package:omborchi/feature/main/data/remote_data_source/model/raw_material_network.dart';

class RawMaterial {
  final int? id;
  final String? name;
  final double? price;
  final int typeId;
  final DateTime updatedAt;

  RawMaterial({
    this.id,
    required this.name,
    required this.price,
    required this.typeId,
    required this.updatedAt
  });

  RawMaterialNetwork toNetwork() {
    return RawMaterialNetwork(
      id: id,
      name: name,
      price: price,
      typeId: typeId,
      updatedAt: updatedAt,
    );
  }


  RawMaterial copyWith({
    int? id,
    String? name,
    double? price,
    int? typeId,
    DateTime? updatedAt,
  }) {
    return RawMaterial(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      typeId: typeId ?? this.typeId,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'RawMaterial{id: $id, name: $name, price: $price, typeId: $typeId}';
  }
}