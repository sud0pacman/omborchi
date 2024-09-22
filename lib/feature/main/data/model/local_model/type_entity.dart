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
// class TypeEntity {
//   final int? id;
//   final String name;

//   TypeEntity({
//     this.id,
//     required this.name,
//   });

//   TypeEntity copyWith({
//     int? id,
//     String? name,
//   }) {
//     return TypeEntity(
//       id: id ?? this.id,
//       name: name ?? this.name,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'name': name,
//     };
//   }

//   factory TypeEntity.fromJson(Map<String, dynamic> json) {
//     return TypeEntity(
//       id: json['id'],
//       name: json['name'],
//     );
//   }

//   @override
//   String toString() {
//     return 'TypeEntity{id: $id, name: $name}';
//   }
// }