import 'package:omborchi/feature/main/data/model/local_model/raw_material_entity.dart';
import 'package:omborchi/feature/main/domain/model/raw_material.dart';

class RawMaterialNetwork {
  final int? id;
  final String? name;
  final double? price;
  final int typeId;
  final DateTime updatedAt;

  RawMaterialNetwork(
      {this.id,
      required this.name,
      required this.price,
      required this.typeId,
      required this.updatedAt});

  RawMaterialNetwork copyWith({
    int? id,
    String? name,
    double? price,
    int? typeId,
    DateTime? updatedAt,
  }) {
    return RawMaterialNetwork(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      typeId: typeId ?? this.typeId,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'type_id': typeId,
      'updated_at': updatedAt.toUtc().toIso8601String(),
    };
  }

  factory RawMaterialNetwork.fromJson(Map<String, dynamic> map) {
    return RawMaterialNetwork(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] != null ? map['name'] as String : null,
      price: map['price'] != null
          ? (map['price'] is int
              ? (map['price'] as int).toDouble()
              : map['price'] as double)
          : null,
      typeId: map['type_id'] != null ? map['type_id'] as int : -1,
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'])
          : DateTime.now(),
    );
  }

  RawMaterial toModel() {
    return RawMaterial(
      id: id,
      name: name,
      price: price,
      typeId: typeId,
      updatedAt: updatedAt,
    );
  }

  @override
  String toString() {
    return 'RawMaterialNetwork{id: $id, name: $name, price: $price, typeId: $typeId}';
  }

  RawMaterialEntity toEntity() {
    final RawMaterialEntity entity = RawMaterialEntity();
    entity.id = id!;
    entity.name = name!;
    entity.price = price!;
    entity.typeId = typeId;

    return entity;
  }
}
