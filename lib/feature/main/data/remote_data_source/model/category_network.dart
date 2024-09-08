import 'package:omborchi/feature/main/domain/model/category_model.dart';

class CategoryNetwork {
  final int? id;
  final String name;
  final DateTime updatedAt;
  final bool isVerfied;

  CategoryNetwork(
      {this.id,
      required this.name,
      required this.updatedAt,
      this.isVerfied = false});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'updated_at': updatedAt.toUtc().toIso8601String(),
      'is_verified': isVerfied,
    };
  }

  factory CategoryNetwork.fromJson(Map<String, dynamic> json) {
    return CategoryNetwork(
      id: json['id'],
      name: json['name'],
      updatedAt: json['updated_at'],
      isVerfied: json['is_verified'],
    );
  }

  CategoryModel toModel() {
    return CategoryModel(
      id: id,
      name: name,
      updatedAt: updatedAt,
      isVerfied: isVerfied,
    );
  }

  CategoryNetwork copyWith({
    int? id,
    String? name,
    DateTime? updatedAt,
    bool? isVerfied,
  }) {
    return CategoryNetwork(
      id: id ?? this.id,
      name: name ?? this.name,
      updatedAt: updatedAt ?? this.updatedAt,
      isVerfied: isVerfied ?? this.isVerfied,
    );
  }

  @override
  String toString() {
    return 'CategoryNetwork{id: $id, name: $name, updatedAt: $updatedAt, isVerfied: $isVerfied}';
  }
}
