import 'package:omborchi/feature/main/domain/model/category_model.dart';

class CategoryNetwork {
  final int? id;
  final String name;
  final DateTime updatedAt;

  CategoryNetwork({
    this.id,
    required this.name,
    required this.updatedAt
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'updated_at': updatedAt.toUtc().toIso8601String(),
    };
  }

  factory CategoryNetwork.fromJson(Map<String, dynamic> json) {
    return CategoryNetwork(
      id: json['id'],
      name: json['name'],
      updatedAt: json['updated_at'],
    );
  }

  CategoryModel toModel() {
    return CategoryModel(
      id: id,
      name: name,
      updatedAt: updatedAt,
    );
  }

  @override
  String toString() {
    return 'CategoryNetwork{id: $id, name: $name, updatedAt: $updatedAt}';
  }
}