import 'package:isar/isar.dart';
import 'package:omborchi/feature/main/data/model/local_model/type_entity.dart';
import 'package:omborchi/feature/main/domain/model/raw_material_type.dart';

class RawMaterialTypeNetwork {
  final int? id;
  final String name;
  final DateTime updatedAt;

  RawMaterialTypeNetwork(
      {this.id, required this.name, required this.updatedAt});

  RawMaterialTypeNetwork copyWith({
    int? id,
    String? name,
    DateTime? updatedAt,
  }) {
    return RawMaterialTypeNetwork(
      id: id ?? this.id,
      name: name ?? this.name,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'updated_at': updatedAt.toUtc().toIso8601String(),
    };
  }

  factory RawMaterialTypeNetwork.fromJson(Map<String, dynamic> json) {
    return RawMaterialTypeNetwork(
      id: json['id'],
      name: json['name'],
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  RawMaterialType toModel() {
    return RawMaterialType(
      id: id,
      name: name,
      updatedAt: updatedAt,
    );
  }

  @override
  String toString() {
    return 'RawMaterialTypeNetwork{id: $id, name: $name, updatedAt: $updatedAt}';
  }

  TypeEntity toEntity() {
    final Id isarId = id!;
    return TypeEntity()
      ..id = isarId
      ..name = name
    ;
  }
}
