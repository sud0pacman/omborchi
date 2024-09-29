import 'package:omborchi/feature/main/data/model/local_model/category_entity.dart';
import 'package:omborchi/feature/main/data/model/remote_model/category_network.dart';

class CategoryModel {
  final int? id;
  final String name;
  final DateTime? updatedAt;

  CategoryModel({
    this.id,
    required this.name,
    this.updatedAt,
  });

  CategoryModel copyWith({
    int? id,
    String? name,
    DateTime? updatedAt,
    String? status,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  CategoryNetwork toNetwork() {
    return CategoryNetwork(
      id: id,
      name: name,
      updatedAt: updatedAt!,
    );
  }

  CategoryEntity toLocal() {
    final CategoryEntity entity = CategoryEntity();
    if (id != null) entity.id = id!;
    entity.name = name;

    return entity;
  }

  @override
  String toString() {
    return 'CategoryModel{id: $id, name: $name, updatedAt: $updatedAt,}';
  }
}
