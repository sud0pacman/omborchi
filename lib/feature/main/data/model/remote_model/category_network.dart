import 'package:omborchi/feature/main/data/model/local_model/category_entity.dart';
import 'package:omborchi/feature/main/domain/model/category_model.dart';

class CategoryNetwork {
  final int? id;
  final String name;
  final DateTime updatedAt;


  CategoryNetwork(
      {this.id,
      required this.name,
      required this.updatedAt,
      });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'updated_at': updatedAt.toUtc().toIso8601String(),
    };
  }

  factory CategoryNetwork.fromJson(Map<String, dynamic> json) {
    return CategoryNetwork(
      id: json['id'],
      name: json['name'],
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  CategoryModel toModel() {
    return CategoryModel(
      id: id,
      name: name,
      updatedAt: updatedAt,
    );
  }

  CategoryNetwork copyWith({
    int? id,
    String? name,
    DateTime? updatedAt,
  }) {
    return CategoryNetwork(
      id: id ?? this.id,
      name: name ?? this.name,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'CategoryNetwork{id: $id, name: $name, updatedAt: $updatedAt,}';
  }

  CategoryEntity toLocal() {
    final CategoryEntity entity = CategoryEntity();
    entity.id = id!;
    entity.name = name;

    return entity;
  }
}
