import 'package:omborchi/feature/main/data/model/local_model/type_entity.dart';
import 'package:omborchi/feature/main/data/model/remote_model/raw_material_type_network.dart';

class RawMaterialType {
  final int? id;
  final String name;
  final DateTime? updatedAt;

  RawMaterialType({this.id, required this.name, this.updatedAt});

  RawMaterialType copyWith({
    int? id,
    String? name,
    DateTime? updatedAt,
  }) {
    return RawMaterialType(
      id: id ?? this.id,
      name: name ?? this.name,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  RawMaterialTypeNetwork toNetwork() {
    return RawMaterialTypeNetwork(
      id: id,
      name: name,
      updatedAt: updatedAt!,
    );
  }

  TypeEntity toEntity() {
    final entity = TypeEntity();
    entity.name = name;

    return entity;
  }

  @override
  String toString() {
    return 'RawMaterialType{id: $id, name: $name, updatedAt: $updatedAt}';
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is RawMaterialType && runtimeType == other.runtimeType && name == other.name;

  @override
  int get hashCode => name.hashCode;
}
