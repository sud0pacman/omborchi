import 'package:omborchi/feature/main/data/remote_data_source/model/category_network.dart';

class CategoryModel {
  final int? id;
  final String name;
  final DateTime updatedAt;

  CategoryModel({
    this.id,
    required this.name,
    required this.updatedAt
  });

  CategoryModel copyWith({
    int? id,
    String? name,
    DateTime? updatedAt,
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
      updatedAt: updatedAt,
    );
  }

  @override
  String toString() {
    return 'CategoryModel{id: $id, name: $name, updatedAt: $updatedAt}';
  }

}