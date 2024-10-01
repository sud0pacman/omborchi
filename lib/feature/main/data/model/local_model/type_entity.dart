import 'package:isar/isar.dart';
import 'package:omborchi/feature/main/domain/model/raw_material_type.dart';
part 'type_entity.g.dart';

@Collection()
class TypeEntity {
  Id id = Isar.autoIncrement;
  String name = '';

  @override
  String toString() => 'Type(id: $id, name: $name)';

  RawMaterialType toModel(DateTime lastUpdate) {
    return RawMaterialType(id: id, name: name, updatedAt: lastUpdate);
  }
}