import 'package:omborchi/feature/main/data/model/local_model/category_entity.dart';
import 'package:omborchi/feature/main/data/model/remote_model/category_network.dart';

class CategoryModel {
  final int? id;
  final String name;
  final DateTime updatedAt;
  final String status;

  CategoryModel({
    this.id,
    required this.name,
    required this.updatedAt,
    required this.status,
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
      status: status ?? this.status,
    );
  }

  CategoryNetwork toNetwork() {
    return CategoryNetwork(
      id: id,
      name: name,
      updatedAt: updatedAt,
      status: status,
    );
  }

  CategoryEntity toLocal() {
    return CategoryEntity(
      id: id,
      name: name,
      updatedAt: updatedAt,
      status: status,
    );
  }

  @override
  String toString() {
    return 'CategoryModel{id: $id, name: $name, updatedAt: $updatedAt, status: $status}';
  }
}
