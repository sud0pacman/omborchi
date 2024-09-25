import 'package:omborchi/feature/main/data/model/local_model/category_entity.dart';
import 'package:omborchi/feature/main/domain/model/category_model.dart';

class CategoryNetwork {
  final int? id;
  final String name;
  final DateTime updatedAt;
  final String status;


  CategoryNetwork(
      {this.id,
      required this.name,
      required this.updatedAt,
      required this.status
      });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'updated_at': updatedAt.toUtc().toIso8601String(),
      'status': status,
    };
  }

  factory CategoryNetwork.fromJson(Map<String, dynamic> json) {
    return CategoryNetwork(
      id: json['id'],
      name: json['name'],
      updatedAt: DateTime.parse(json['updated_at']),
      status: json['status'],
    );
  }

  CategoryModel toModel() {
    return CategoryModel(
      id: id,
      name: name,
      updatedAt: updatedAt,
      status: status,
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
      status: status,
    );
  }

  @override
  String toString() {
    return 'CategoryNetwork{id: $id, name: $name, updatedAt: $updatedAt, status: $status}';
  }

  CategoryEntity toLocal() {
    final CategoryEntity entity = CategoryEntity();
    entity.id = id!;
    entity.name = name;
    entity.updatedAt = updatedAt;
    entity.status = status;

    return entity;
  }
}
