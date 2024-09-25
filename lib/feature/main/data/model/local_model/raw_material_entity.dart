import 'package:isar/isar.dart';
import 'package:omborchi/feature/main/domain/model/raw_material.dart';
part 'raw_material_entity.g.dart';

@Collection()
class RawMaterialEntity {
  Id id = Isar.autoIncrement;
  late String name;
  late double price;
  late int typeId;

  @override
  String toString() {
    return "RawMaterialEntity(id: $id, name: $name, price: $price, typeId: $typeId)";
  }

  RawMaterial toModel(DateTime lastUpdate) {
    return RawMaterial(
      id: id,
      name: name,
      price: price,
      typeId: typeId,
      updatedAt: lastUpdate,
    );
  }
}